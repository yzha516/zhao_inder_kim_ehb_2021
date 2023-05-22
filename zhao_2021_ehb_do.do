
/* Spousal bereavement and the cognitive health of older adults in the US: New insights on channels, single Items, and subjective evidence */
/* Date: July 2021 */
/* Author of the do file: Yuejun Zhao */

sysdir set PLUS "XX"						// ado directory here					
cd "XX" 									// change working directory here
							
log using "Cognitive Health_Log File", replace text 

/********************************************************************/


/* EXPLANATION OF VARIABLES:

Note: `Identifies' for IDs, `Indicates' for dummy variables, `Categorises' for categorical variables, `Counts' for count variables, `Delineates' for continuous variables.


I. GENERAL VARIABLES: 
Note:  Collected from TRK2016TR_R.dta and pre-processed in widcog_02_trk.r.
1) hhid			: Identifies household; note: may not be unique if multiple persons are interviewed within a household 
2) pn			: Identifies persons within a household; note: not unique outside of a given household; combine with hhid to uniquely identify a person 
3) index		: Identifies a respondent uniquely
3) wave			: Categorises HRS wave informaion from wave 4 (1998) to wave 13 (2016); note: i.wave used as wave dummies
4) cohort		: Categorises study cohorts including HRS (=1), AHEAD (=11), HRS/AHEAD overlap in AHEAD (=12), HRS/AHEAD overlap not in AHEAD (=13), CODA Children of the Depression Age (=21), WB War Babies (=31), EBB Early Baby Boomers (=41), MBB Mid Baby Boomers (=51), LBB Late Baby Boomers (=61)
4) male			: Indicates gender including male (=1) and female (=0); note: participants with unkonwn gender were preliminarily removed 
5) hispanic		: Categorises a respondent's hispanicity type including hispanic mexican (=1), hispanic other (=2), hispanic unknown (=3), non-hispanic (=5); narule: not obtained (=.), 
6) race			: Categorises a respondent's ethnicity including white/caucasian (=1), black or african american (=2), other (=7); narule: not obtained (=.),
7) immgyear		: Delineates year the respondent immigrated to the U.S. (1905 - 2017); narule: immigration year unknown or born in the U.S. (=.)
8) usborn		: Indicates whether a respondent's country of birth is a foreign country (=0) or U.S. (=1); narule: unknown (=.)
9) degree		: Categorises a respondent's highest degree of education including no degree (=0), GED or general education developemnt (=1), high school diploma (=2), two year college degree (=3), four year college degree (=4), master degree (=5), professional degree PHD MD or JD (=6), or degree unknown or some college (=9)
10) schlyrs		: Delineates a respondent's number of years in school including no formal education (=0), grades (=1 to =11), high school (=12), some college (=13 to =15), college graduate (=16), post college with 17+ years (=17): narule: not ascertained (=.)
11) wgtr		: Delineates cross-sectional weights
12) weight		: Delineates within-averaged weights
13) alive		: Vital status including alive at the wave (=1), presumed alive as of the wav e(=2), death reported in the wave (=5) and death reported in a prior wave (=6); note: (=5) is used to tabulate attrition by death.  
14) insamp		: Sample status including in the sample (=1), HRS-AHEAD overlap (=4), complete exit by death (=5), permanently dropped from the sample per request of the sample person, his/her spouse/partner, or other gatekeeper (=6), deceased sample member for whom the field staff was unable to find an informant eligible to do an exit or post-exit interview at a previous wave (=7), and permanently dropped from the sample for any other reason (=8); note: (=6) and (=8) are used to calculate voluntary attrition (current wave count - previous wave count as they are cumulative).

II. OUTCOME VARIABLES: 
Note: Collected wave-by-wave from core files then merged with the track file. See wicog_01_loop.r and widcog_03_r.r.
Note: All outcomes are modelled with linear probability fixed effects. Hence, we do not distinguish binary, count and approximately continuous otucomes. 
Note: Auxiliary variables include del, slfm and pstm.
1) cogtot		: Index for total cognition score, which equals the sum of rec, del, cnta, mdyt, pct and msev; narule: if at least one item is NA (=.), the index is NA (=.)
2) mtst			: Index for mental status score, which equals the sum of cnta, mdyt, pct and msev; narule: if at least one item is NA (=.), the index is NA (=.)
3) fluid		: Index for fluid cognition score, which equals the sum of rec, del, pct and msev; narule: if at least one item is NA (=.), the index is NA (=.) 
4) cryst		: Index for crystallised cognition score, which equals the sum of mdyt and pct; narule: if at least one item is NA (=.), the index is NA (=.)
5) objm			: Index for objective memory, including memory-related disease before wave 10 and dementia starting from wave 10 (=1), no memory-related disease or without dementia (=0); narule: DK don't know, RF refused or INAP inapplicable (=.)
6) sbjm 		: Index for subjective memory, which equals the sum of self-rated memory at present (slfm: poor=0, fair=1, good=2, very good=3, excellent=4, DK RF INAP=.) and memory compared to two years ago (pstm: worse=0, about the same =1, better=2, DK RF INAP=.)
7) rec			: Item for immediate word free-recall test where scores range from 0 to 10; narule: respondents who are assigned INAP in the FIRST recall question is deemed to not have participated (=.), which is distinguished from respondents who participated but recalled 0 words (=0)
8) idel			: Item for the scoring difference between delayed recall (del) and immediate recall (rec); note: del is calculated the same way as rec; narule: NA (=.) can result from either del or rec; when indices are constructed, we use del rather than idel
9) cnta			: Item for backward count (10 integers from 20 or 19) test with performance ranging from incorrect at first or second attempt (=0), correct at the second attempt (=1), correct at the first attempt (=2); narule: NA refers to respondents who did not participate (=.), not ones who did not answer correctly at either attempt (=0) 
10) msev		: Item for serial sevens (subtract 7 from 100 5 times) where scores range from 0 to 5, one for each correct subtraction; note: steps are independent; narule: respondents who are assigned INAP in the FIRST subtraction is deemed to not have participated (=.), which is distinguished from respondents who participated but did not perform any subtraction correctly (=0) 
11) mdyt		: Item for date naming (month, day, year and day-of-week recall) where scores range from 0 to 4, 1 for each correct answer; narule: NA (=.) if any of the four element reports NA (=.); within-element Dk or RF is coded as incorrect (0)
12) pct			: Item for object naming (cactus, scissors, president, vice president) where scores range from 0 to 4, one for each correct answer; narule: NA (=.) if any of the four element reports NA (=.); within-element Dk or RF is coded as incorrect (0)


(III.) TREATMENT VARIABLES:
Note: Collected wave-by-wave from core files then merged with the track file. See wicog_01_loop.r and widcog_03_r.r.
Note: First spousal loss (x=a), second spousal loss (x=b), third spousal loss (x=c).
Note: For main results, we use four year transition to or from widowhood onset or an eight-year span (i = 1, 2). For sensitivity analysis, we examine 20-year span (i = 1 to 5) and 40-year span (i = 1 to 10). 
Note: Vectors 2) to 10) are all constructed from 1). 
1) wid_t			: Indicate whether a respondent is widowed at time t (=1); note: raw data from core files; narule: DK NA RF INAP partial interview (=.), if married or married with spouse absent in the last wave and widowed in this wave, but NA to this question (=0)
2) wid_p{x}			: Indicates whether a respondent has been widowed the xth time at or before time t (=1)
3) wid_{xxx}		: Counts the number of times a respondent has been widowed 
4) wid_trend{x}		: Delineates linear transition to and from the xth widowhood onset (=0) with increment 1
5) wid{x}_lemn{i}	: Indicates whether a respondent is less than or equal to i wave before the xth wiodowhood onset (=1)
6) wid{x}_mn{i}		: Indicates whether a respondent is i wave before the xth wiodowhood onset (=1)
7) wid{x}_att		: Indicates whether a respondent is widowed the xth time at time t (=1) 
8) wid{x}_pl{i}		: Indicates whether a respondent is i wave after the xth wiodowhood onset (=1)
9) wid{x}_gepl{i}	: Indicates whether a respondent is greater than or equal to i wave after the xth wiodowhood onset (=1)
10) widm_p{x}		: Indicates whether a MALE respondent has been widowed the xth time at or before time t(=1)
11) widma_{lemn{i}|mn{i}|att|pl{i}|gepl{i}}: Indicates whether a MALE respondent is a certain distance (see III.4 to III.8) from the first widowhood onset (=1) 



IV: CONTROL VARIABLES:
Note: newsp and age were from TRK2016TR_R.dta. See widcog_02_trk.r.
Note: All other controls were collected wave-by-wave from core files then merged with the track file. See wicog_01_loop.r and widcog_03_r.r.
Note: (d) for depression channel; (v) for social vulnerability channel; (s) for stress channel. 
Note: When wave is not mentioned, definition of a control is consistent across waves. 
Note: Full brackets denote unused control variables. 
1) dep				: (d) Indicates whether a respondent was feeling sad, blue or depressed for two weeks or more in a row during the last 12 months (=1); narule: DK RF INAP (=.), no prior emotional/psychiatric problem but NA to this question (=0)
2) emot				: (d) Indicates whether a respondent is now taking tranquilizers, antidepressants or pills for nerves (=1) before wave 12; starting from wave 12, it indicates whether a respondent is now getting psychiatric or psychological treatment for his/her problems (=1); narule: DK RF INAP (=.), no prior emotional/psychiatric problem but NA to this question (=0)
3) chn				: (v) Indicates whether a respondent has children living with or within 10 miles of him/her (=1) starting from wave 6; for wave 4 and 5, it indicates whether a respondent has children living with him/her (=1); narule: DK RF NA INAP (=.)
4) gch				: (v) Indicates whether a respondent or his/her (late) spouse/partner spends 100 or more hours in total taking care of grandchildren since the previous interview (=1); narule: DK NA RF INAP partial interview (=.)
5) div				: (v) Indicates whether a respondent got divorced， separated, or annulled since the previous interview (=1); narule: DK RF INAP (=.), if married or living with partner or never married or other in the last wave and divorced or separated in this wave, but NA to this question (=0) 
6) newsp			: (v) Indicates whether a respondent has a new spouse/partner (=1); narule: Blank or Not in the sample this wave (=.)
7) odec				: (v) Indicates whether a respondent's parent (wave 4 to 13), parent-in-law (wave 4 to 5), child (wave 4 to 12, from HarmonizedHRS.vB), sibling (wave 4 to 11) or sibling-in-law (wave 4 to 5) died in the past two years for wave 4 and 11 (=1); narule: DK RF (=.)
8) achl				: (s) Categorises the number of drinks a respondent has in a day including less than 1 drink a day (=0), 1 to 2 drink(s) a day (=1), 3 to 4 drinks a day (=2) and no less than 5 drinks a day (=3); narule: DK NA RF (=.), no alcohol history or don't ever drink but NA to this question (=0)  
9) smk				: (s) Categorises a respondent into a non-smoker with 0 cigarettes a day (=0), light smoker with no greater than 10 cigarettes a day (=1), moderate smoker with 10 to no greater than 20 cigarettes a day (=2) and heavy smoker with greater than 20 cigarettes a day (=3); note: cigarette only; respondent answer either in packs or cigarettes, one pack has 20 cigarettes; narule: DK NA RF INAP (=.)
10) hpt				: (s) Indicates whether a respondent is taking medication to lower blood pressure (=1); narule: DK NA RF INAP partial interview (=.), no prior high blood pressure but NA to this question (=0) 
11) exc				: Indicates whether a respondent takes part in sports or activities that are vigorous, such as running or jogging, swimming, cycling, aerobics or gym workout, tennis, or digging with a spade or shovel no less than once a week starting from wave 7 (=1); prior to wave 7, vigorous physical activity pertains to sports, heavy housework, or a job that involves physical labor three times a week or more (=.); narule: DK NA RF INAP parital interview (=.)
12) diab			: Indicates whether a respondent is using insulin shot or a pump to treat diabetes (=1); narule: DK NA RF INAP partial interview (=.), no prior diabetes record but NA to this question (=0)
13) heart			: Indicates whether a respondent has had a heart attack or myocardial infarction in the past two years (=1); narule: DK NA RF INAP (=.) no prior heart condition but NA to this question (=0)
14) nursp			: Indicates whether a respondent's spouse/partner is living in a nursing home or other health care facility (=1); comprises of spouse/partner as a main respondent in interview (filtered by xPN_SP and xA028) and one that's not in the interview (xA033); narule: DK NA RF INAP partial interview (=.) no spouse number and xA033 is NA (=.)
(15) age			: Delineates the age of the respondent; narule: not core interview this wave (=.)
(16) age_sq			: Delineates the age of the respondent squared; narule: not core interview this wave (=.) 
(17) srh			: Categorises a respondent's self-rated health level including poor (=0), fair (=1), good (=2), very good (=3) or excellent (=4); narule: DK NA RF INAP partial interview (=.)
(18) strk			: Indicates whether a respondent has had a stroke in the past two years (=1); narule: DK NA RF INAP partial interview (=.), no prior stroke but NA to this question (=0) 
(19) fclim			: Counts the number of functional limit (0 to 10) a respondent suffers from, which includes difficulties walking one or several blocks, jogging one mile, sitting for two hours, getting up from a chair after sitting for long periods, climbing one or several flights of stairs without resting, stopping kneeling or crouching, reaching or extending arms above shoulder level, pulling or pushing large objects, lifting or carrying weights over 10 pounds, or picking up a dime from a table; narule: NAs were removed during item sum for wave 4 and 5 (i.e., if a respondent is missing one question, his/her sum is NOT NA), wave 6 onward used checkpoint question (i.e.already summed) with NA (=.)
(20) ret			: Categorises whether a respondent is not retired at all or question not relevant to respondent as the respondent does not work for pay or is homemaker etc. (=0), partly retired (=1) or completely retired (=2); narule: DK NA RF INAP partial interview (=.)
(21) dfin			: Indicates whether a respondent's social security income, supplemental security income, veterans benefits and other retirement pensions or annuities has stopped after widowhood, or the respondent's work hours has started stopped or changed after widowhood (=1); narule: DK NA RF INAP partial interview (=0) NOT NA!
(22) home			: Indicates whether a respondent is residing in a retirement community, senior citizens' housing or other type of housing that offers services for older adults or someone with a disability (=1) starting from wave 6; for wave 4 and 5, it indicates senior housing, retirement centre or assisted living residence (=1); narule: DK NA RF INAP partial interview no financial respondent (=.)
(23) nursr			: Indicates whether a respondent is residing in a nursing home or other health care facility (=1); naulr: INAP partial interview (=.)	
(24) praceff_{item}	: Indicates whether a respondent is taking a test for the first time (=1); narule: if item is missing then praceff_{item} is missing (=.)
(25) lrneff			: Indicates whether a respondent is assigned the same set of words as the previous wave for word recall tests (rec and del); narule: if rec or idel is missing then lrneff is missing (=.)
(26) cancer			: Indicates whether a respondent is receiving treatment for cancer (=1); narule: DK NA RF INAP (=.) no cancer but NA to this question (=0)
(27) lung			: Indicates whether a respondent is taking medication or other treatment for lung condition (=1); narule: DK NA RF INAP (=.) no lung condition but NA to this question (=0)
(28) arth			: Indicates whether a respondent is taking any medication or other treatments for arthritis or rheumatism in waves 4 to 11 (=1); for waves 12 and 13, indicates whether arthritis has gotten worse since the previous interview (=1); narule: DK NA RF INAP (=.) no arthritis but NA to this question (=0) 			
(29) pain			: Indicates whether pain makes it difficult for the respondent to do usual activities such as household chores or work (=1); narule: DK NA RF INAP (=.) no trouble with pain but NA to this question (=0)
(30) inhos			: Delineates the number of nights a respondent spends in a hospital in the last two years; narule: DK NA RF INAP (=.) no overnight stay but NA to this question (=0)
(31) agep			: Delineates the age of the respondent's spouse or partner; narule: no spouse or partner (=0)

*/



/********************************************************************/


//************ preamble ************//

use "hl_fe_ehb.dta", clear
xtset index wave

foreach var of varlist *{
di "`var'" _col(20) "`: var l `var''" _col(50)  "`: val l `var''"
}

set more off

global ylist cogtot mtst fluid cryst objm sbjm rec idel cnta msev mdyt pct
global ylista cogtot mtst fluid cryst objm sbjm															
global ylisti rec idel cnta msev mdyt pct

global xlist l2dep l2emot l2chn l2gch l2odec l2achl l2smk l2hpt 							///
l2exc l2diab l2heart l2cancer l2lung l2arth l2pain l2inhos l2agep l2nursp   								// 	w/ depression, social contact and stress

global widalist2 wida_mn2 wida_mn1 wida_att wida_pl1 wida_gepl2												// 8-year span, (-4 to 4) years, (-2 to 2) waves
global widalist5 wida_mn5 wida_mn4 wida_mn3 wida_mn2 wida_mn1 wida_att  					///
wida_pl1 wida_pl2 wida_pl3 wida_pl4 wida_gepl5																// 20-year span, (-10 to 10) years, (-5 to 5) waves

global widlist_mtp wida_mn2 wida_mn1 wida_att wida_pl1 wida_gepl2 widb_mn2 					///
widb_mn1 widb_att widb_pl1 widb_gepl2 																		// 8-year span, (-4 to 4) years, (-2 to 2) waves, three spousal lossess
global widlist_trend wid_trenda wid_trendb 																	// linear trend





********** summary statistics **********
** sumstat_all


********** channels, w/ controls **********
** regdvs_ta: regn_ta, regd_ta, regv_ta, regs_ta stacked
	* (1): simple widowhood onset
	* (2): time to spousal loss
		* A. regn_ta: index (Aggregated), w/o depression, social vulnerability or stress, total
		* B. regd_ta: index, w/ Depression, total
		* C. regv_ta: index, w/ social Vulnerability, total
		* D. regs_ta: index, w/ Stress, total
	
** reg_ta: index, w/ depression, social vulnerability and stress
	* A: simple widowhood onset
	* B: time to spousal loss

********** items, w/ controls and channels **********
** reg_ti: items, w/ channels
	* A: simple widowhood onset
	* B: time to spousal loss 

********** gender, w/ controls and channels **********
** reg_mfai: reg_mfa, reg_mfi stacked
	* (1). reg_mfa: index, w/ channels, by gender 
		* A: simple widowhood onset
		* B: time to spousal loss
	* (2). reg_mfi: item, w/ channels, by gender 
		* A: simple widowhood onset
		* B: time to spousal loss


********** robustness, w/ controls and channels **********

** rbalt_tai: rbpool_tai, rbbt_tai, rbre_tai, hausman_fe_re stacked
	* rbpool_tai: pooled, index & item total
	* rbbt_tai: between, index & item total
	* rbre_tai: re clustered, index & item total
	* hausman_fe_re: hausman test, index & item total

** rbtrd_mfai: rbtrd_mfa, rbtrd_mfi stacked
	* A. rbtrd_mfa: linear change instead of dummies, index by gender
	* B. rbtrd_mfi: linear change instead of dummies, item by gender
		
** rbmtp_mfai: rbmtp_mfa, rbmtp_mfi stacked
	* A. rbmtp_mfa: multiple spousal losses, time to spousal loss, index by gender
	* B. rbmtp_mfi: multiple spousal losses, time to spousal loss, item by gender

** rbpsm_mfai: rbpsm_mfa, rbpsm_mfi stacked
	* (1). rbpsm_mfa: index, w/ channels, by gender 
		* A: simple widowhood onset
		* B: time to spousal loss
	* (2). rbpsm_mfi: item, w/ channels, by gender 
		* A: simple widowhood onset
		* B: time to spousal loss
		
** rbcoh_tq: rbcoh_mtst, rbcoh_objm stacked
	* A. rbcoh_mtst: mental status, by age quartiles
	* B. rbcoh_objm: objective memory, by age quartiles

** (reserve) medeff: acme estimates
** (reserve) rbprac_mfi: practice & learning effects, item by gender
** (reserve) rb10yr_mfi: (-10,10), item by gender
 
 		 


/***** Table 3: Summary statistics for measures conditional on widowhood status (sumstat_all) *****/

qui xtreg msev $widalist2 $xlist i.wave [pw=weight], fe cluster(index)
gen sumsmpl = e(sample)

eststo clear
foreach i in 1 0 {
	* cognitive measures (aggregated indices and single item scales)
	estpost tabstat cogtot mtst fluid cryst objm sbjm rec idel cnta msev mdyt pct if wid_pa == `i' & sumsmpl == 1, statistics(mean sd) columns(statistics) 
	eststo wid_pa_ai`i'
	* channels of widowhood effects
	estpost tabstat l2dep l2emot l2chn l2gch l2odec l2achl l2smk l2hpt if wid_pa == `i' & sumsmpl == 1, statistics(mean sd) columns(statistics) 
	eststo wid_pa_m`i'
	* covariates
	estpost tabstat l2exc l2diab l2heart l2cancer l2lung l2arth l2pain l2inhos l2age l2agep l2nursp if wid_pa == `i' & sumsmpl == 1, statistics(mean sd) columns(statistics) 
	eststo wid_pa_x`i'
	* time-invariant characteristics
	estpost tabstat male usborn schlyrs if wid_pa == `i' & sumsmpl == 1, statistics(mean sd) columns(statistics) 
	eststo wid_pa_ti`i'
}
tab wid_pa if sumsmpl == 1
sum age if wave == 4 		
egen ltd = rowtotal(l2diab l2heart l2cancer l2lung l2arth l2pain)
replace ltd = 1 if ltd > 1
tab ltd if sumsmpl == 1

* add daggers to binary variables
foreach var in l2dep l2emot l2chn l2gch l2odec l2exc l2diab l2heart l2cancer l2lung l2arth l2pain l2nursp male usborn {
	local lbl : variable label `var'
	la var `var' "`lbl'$^\dagger$"
}

cap erase "sumstat_all.tex" 
estout wid_pa_ai1 wid_pa_ai0 using "sumstat_all.tex", cell("mean(fmt(2)) sd(par(( )))") mlabels("Bereaved 2,846 (9.31\%)" "Non-bereaved 27,732 (90.69\%)") collabels("Mean" "(Sd)") style(tex) posthead(\multicolumn{5}{l}{\textit{Cognitive measures}}\\) label append 
estout wid_pa_m1 wid_pa_m0 using "sumstat_all.tex", cell("mean(fmt(2)) sd(par(( )))") mlabels(none) collabels(none) style(tex) posthead(\midrule \multicolumn{5}{l}{\textit{Channels of widowhood effects (lagged by two periods)}}\\) label append 
estout wid_pa_x1 wid_pa_x0 using "sumstat_all.tex", cell("mean(fmt(2)) sd(par(( )))") mlabels(none) collabels(none) style(tex) posthead(\midrule \multicolumn{5}{l}{\textit{Covariates (lagged by two periods)}}\\) label append 
estout wid_pa_ti1 wid_pa_ti0 using "sumstat_all.tex", cell("mean(fmt(2)) sd(par(( )))") mlabels(none) collabels(none) style(tex) posthead(\midrule \multicolumn{5}{l}{\textit{Time-invariant characteristics}}\\) label append 		

* remove daggers from labels
foreach var in l2dep l2emot l2chn l2gch l2odec l2exc l2diab l2heart l2cancer l2lung l2arth l2pain l2nursp {
	local ovar = substr("`var'",3,.)
	local lbl : variable label `ovar'
	la var `var' "`lbl'"
}
la var male "Male"
la var usborn "Born in the US"
drop sumsmpl



//************ Channels: depression, social vulnerability, and stress ************//


/***** Table 4: Estimates for aggregated indices with different channels specified (regdvs_ta) *****/
* A. total, aggregated, w/o dep, contact or stress		(regn_ta) 
* B. total, aggregated, w/ dep 						(regd_ta) 
* C. total, aggregated, w/ social vulnerability 		(regv_ta) 
* D. total, aggregated, w/ stress						(regs_ta) 



* (1) 4.A to D: Simple widowhood onset 
foreach suf in n d v s { 
if "`suf'" == "n" {
	global varlist l2exc l2diab l2heart l2cancer l2lung l2arth l2pain l2inhos l2agep l2nursp
}
else if "`suf'" == "d" {
	global varlist l2dep l2emot l2exc l2diab l2heart l2cancer l2lung l2arth l2pain l2inhos l2agep l2nursp
}
else if "`suf'" == "v" {
	global varlist l2chn l2gch l2odec l2exc l2diab l2heart l2cancer l2lung l2arth l2pain l2inhos l2agep l2nursp
}
else {
	global varlist l2achl l2smk l2hpt l2exc l2diab l2heart l2cancer l2lung l2arth l2pain l2inhos l2agep l2nursp
}
foreach y in $ylista {
	xtreg `y' wid_pa $varlist i.wave [pw=weight], fe cluster(index)
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	testparm wid_pa
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "cogtot" {
	outreg2 using reg`suf'_ta_tex_pa, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 				///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex replace label	
}
else {
	outreg2 using reg`suf'_ta_tex_pa, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 				///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex append label	
}
}
} 



* (2) 4.A to D: Time to spousal loss
foreach suf in n d v s { 
if "`suf'" == "n" {
	global varlist l2exc l2diab l2heart l2cancer l2lung l2arth l2pain l2inhos l2agep l2nursp
}
else if "`suf'" == "d" {
	global varlist l2dep l2emot l2exc l2diab l2heart l2cancer l2lung l2arth l2pain l2inhos l2agep l2nursp
}
else if "`suf'" == "v" {
	global varlist l2chn l2gch l2odec l2exc l2diab l2heart l2cancer l2lung l2arth l2pain l2inhos l2agep l2nursp
}
else {
	global varlist l2achl l2smk l2hpt l2exc l2diab l2heart l2cancer l2lung l2arth l2pain l2inhos l2agep l2nursp
}
foreach y in $ylista {
	xtreg `y' $widalist2 $varlist i.wave [pw=weight], fe cluster(index)
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	testparm $widalist2
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "cogtot" {	
	outreg2 using reg`suf'_ta_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex replace label	
}
else {
	outreg2 using reg`suf'_ta_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex append label	
}
}
} 




/***** Table 5: Estimates for agregated indices including depression, social vulnerability, and stress *****/
* total, aggregated, w/ dep, vulnerability and stress		(reg_ta) 

* 5.A: Simple widowhood onset
foreach y in $ylista {
	xtreg `y' wid_pa $xlist i.wave [pw=weight], fe cluster(index)
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	testparm wid_pa
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "cogtot" {
	outreg2 using reg_ta_tex_pa, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex replace label	
}
else {
	outreg2 using reg_ta_tex_pa, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex append label	
}
}

* 5.B: Time to spousal loss
foreach y in $ylista {
	xtreg `y' $widalist2 $xlist i.wave [pw=weight], fe cluster(index)  
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	lincom wida_mn2 + wida_mn1 + wida_att + wida_pl1 + wida_gepl2
	scalar te = r(estimate)
	scalar tese = r(se)
	scalar tep = r(p)
	testparm $widalist2
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "cogtot" {	
	outreg2 using reg_ta_tex, ctitle("`var label `y''") stats(coef se) paren(se) 		///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F overall, foval, p overall, foval_p, F widowhood, fwid, 		///
	p widowhood, fwid_p) tex replace label	
}
else {
	outreg2 using reg_ta_tex, ctitle("`var label `y''") stats(coef se) paren(se) 		///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F overall, foval, p overall, foval_p, F widowhood, fwid, 		///
	p widowhood, fwid_p) tex append label	
}
}



//************************ Single item scales ************************//

/***** Table 6: Estimates for single item scales *****/
* total, items, w/ all channels 			(reg_ti) 

* 6.A: Simple widowhood onset
foreach y in $ylisti {
	xtreg `y' wid_pa $xlist i.wave [pw=weight], fe vce(robust) 
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	testparm wid_pa
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "rec" {
	outreg2 using reg_ti_tex_pa, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex replace label	
} 
else {
	outreg2 using reg_ti_tex_pa, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex append label	
} 
}

* 6.B: Time to spousal loss
foreach y in $ylisti {
	xtreg `y' $widalist2 $xlist i.wave [pw=weight], fe vce(robust)  
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	lincom wida_mn2 + wida_mn1 + wida_att + wida_pl1 + wida_gepl2
	scalar te = r(estimate)
	scalar tese = r(se)
	scalar tep = r(p)
	testparm $widalist2
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "rec" {	
	outreg2 using reg_ti_tex, ctitle("`var label `y''") stats(coef se) paren(se) 		///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F overall, foval, p overall, foval_p, F widowhood, fwid, 		///
	p widowhood, fwid_p) tex replace label
} 
else {
	outreg2 using reg_ti_tex, ctitle("`var label `y''") stats(coef se) paren(se) 		///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F overall, foval, p overall, foval_p, F widowhood, fwid, 		///
	p widowhood, fwid_p) tex append label
} 
}





//***************** Gender heterogeneity *****************//

/***** Table 7: Estimates for aggregated indices and single item scales by gender (reg_mfai)*****/


** (1) male & female, indices, w/ all channels 			(reg_mfa) 

* (1) 7.A: Simple widowhood onset, aggregated indices
foreach y in $ylista {
foreach i in 1 0 {
	xtreg `y' wid_pa $xlist i.wave [pw=weight] if male == `i', fe cluster(index)
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	testparm wid_pa
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "cogtot" & `i' == 1{
	outreg2 using reg_mfa_tex_pa, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex replace label	
} 
else {
	outreg2 using reg_mfa_tex_pa, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex append label	
}
}
}

* (1) 7.B: Time to spousal loss, aggregated indices
foreach y in $ylista {
foreach i in 1 0 {
	xtreg `y' $widalist2 $xlist i.wave [pw=weight] if male == `i', fe cluster(index)
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	lincom wida_mn2 + wida_mn1 + wida_att + wida_pl1 + wida_gepl2
	scalar te = r(estimate)
	scalar tese = r(se)
	scalar tep = r(p)	
	testparm $widalist2
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "cogtot" & `i' == 1{
	outreg2 using reg_mfa_tex, ctitle("`var label `y''") stats(coef se) paren(se) 		///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F overall, foval, p overall, foval_p, F widowhood, fwid, 		///
	p widowhood, fwid_p) tex replace label
} 
else {
	outreg2 using reg_mfa_tex, ctitle("`var label `y''") stats(coef se) paren(se) 		///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F overall, foval, p overall, foval_p, F widowhood, fwid, 		///
	p widowhood, fwid_p) tex append label
}
}
}


** (2) male & female, items, w/ all channels 		(reg_mfi)

* (2) 7.A: Simple widowhood onset, single item scales
foreach y in $ylisti {
foreach i in 1 0 {
	xtreg `y' wid_pa $xlist i.wave [pw=weight] if male == `i', fe cluster(index)
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	testparm wid_pa
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "rec" & `i' == 1 {
	outreg2 using reg_mfi_tex_pa, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex replace label	
} 
else {
	outreg2 using reg_mfi_tex_pa, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex append label	
}
}
}


* (2) 7.B: Time to spousal loss, single item scales
foreach y in $ylisti {
foreach i in 1 0 {
	xtreg `y' $widalist2 $xlist i.wave [pw=weight] if male == `i', fe cluster(index)
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	lincom wida_mn2 + wida_mn1 + wida_att + wida_pl1 + wida_gepl2
	scalar te = r(estimate)
	scalar tese = r(se)
	scalar tep = r(p)
	testparm $widalist2
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "rec" & `i' == 1 {
	outreg2 using reg_mfi_tex, ctitle("`var label `y''") stats(coef se) paren(se) 		///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F overall, foval, p overall, foval_p, F widowhood, fwid, 		///
	p widowhood, fwid_p) tex replace label	
} 
else {
	outreg2 using reg_mfi_tex, ctitle("`var label `y''") stats(coef se) paren(se) 		///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F overall, foval, p overall, foval_p, F widowhood, fwid, 		///
	p widowhood, fwid_p) tex append label
}
}
}



//********************** Robustness Checks  **********************//


/***** Table 9: pooled, between and random effects estimates for aggregated indices and single item scales (app:alt) *****/
* (a) pooled: total, indices and items 				(rbpool_tai) 
* (b) between: total, indices and items 			(rbbt_tai) 
* (c) random effects: total, indices and items 		(rbre_ta) 

foreach m in pool bt re {
foreach y in $ylist {
if "`m'" == "pool" {
	regress `y' $widalist2 $xlist i.wave [pw=weight], cluster(index)
} 	
else if "`m'" == "bt" {
	xtreg `y' $widalist2 $xlist, be vce(bootstrap)
}	
else {
	xtreg `y' $widalist2 $xlist i.wave, re cluster(index)
}
	
if "`y'" == "cogtot" { 
	outreg2 using rb`m'_tai_tex, ctitle("`var label `y''") stats(coef se)  				///
	paren(se) bdec(3) dec(2) tex replace label
}
else {
	outreg2 using rb`m'_tai_tex, ctitle("`var label `y''") stats(coef se)  				///
	paren(se) bdec(3) dec(2) tex append label
}
}
}

* (d) hausman test: total, indices and items 		(haus_fe_re)

foreach y in $ylist {
foreach m in reh feh {
if "`m'" == "reh" {
	xtreg `y' $widalist2 $xlist i.wave, re 
	est store `y'_t_re
}
else {
	xtreg `y' $widalist2 $xlist i.wave, fe 
	est store `y'_t_fe
}
}
	hausman `y'_t_fe `y'_t_re, sigmamore
	scalar `y'_t = r(chi2)
	scalar `y'_tp = r(p)
}

mat haus = cogtot_t, mtst_t, fluid_t, cryst_t, objm_t, sbjm_t, rec_t, idel_t, cnta_t, msev_t, mdyt_t, pct_t
mat hausp = cogtot_tp, mtst_tp, fluid_tp, cryst_tp, objm_tp, sbjm_tp, rec_tp, idel_tp, cnta_tp, msev_tp, mdyt_tp, pct_tp
mat haus = haus\hausp

putexcel set haus_fe_re, replace
putexcel A1=matrix(haus) 
outtable using haus_fe_re, mat(haus) replace 

drop *_t_fe
drop *_t_re



/***** Table 10: Estimates for aggregated indices and single item scales with a linear transition to widowhood (rbtrd_mfai) *****/


* 10.A: Linear transition to spousal loss, male & female, aggregated indices (rbtrd_mfa)
foreach y in $ylista {
foreach i in 1 0 {
	xtreg `y' wid_trenda $xlist i.wave [pw=weight] if male == `i', fe cluster(index)
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	testparm wid_trenda
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "cogtot" & `i' == 1 { 
	outreg2 using rbtrd_mfa_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex replace label	
}
else {
	outreg2 using rbtrd_mfa_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex append label	
}
}
}



* 10.B Linear transition to spousal loss, male & female, single item scales (rbtrd_mfi)
foreach y in $ylisti {
foreach i in 1 0 {
	xtreg `y' wid_trenda $xlist i.wave [pw=weight] if male == `i', fe cluster(index)
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	testparm wid_trenda
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "rec" & `i' == 1 { 	
	outreg2 using rbtrd_mfi_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex replace label	
}
else {
	outreg2 using rbtrd_mfi_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex append label	
}
}
}



/***** Table 11: Estimates of multiple spousal losses across aggregated indices and Single Item Scales by gender (rbmtp_mfai) *****/

* number of older adults widowed twice
tab wid_pb if wave == 13
	

* 11.A: Time to multiple spousal loss, male & female, aggregated indices (rbmtp_mfa) 
foreach y in $ylista {
foreach i in 1 0 {
	xtreg `y' $widlist_mtp $xlist i.wave [pw=weight] if male == `i', fe cluster(index)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	lincom wida_mn2 + wida_mn1 + wida_att + wida_pl1 + wida_gepl2
	scalar te = r(estimate)
	scalar tese = r(se)
	scalar tep = r(p)	
	testparm $widalist2
	scalar fwid1 = r(F)
	scalar fwid_p1 = r(p)
	testparm widb_mn2 widb_mn1 widb_att widb_pl1 widb_gepl2
	scalar fwid2 = r(F)
	scalar fwid_p2 = r(p)
if "`y'" == "cogtot" & `i' == 1 {
	outreg2 using rbmtp_mfa_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F first loss, fwid1, p first loss, fwid_p1, F second loss, 		///
	fwid2, p second loss, fwid_p2) tex replace label	
} 
else {
	outreg2 using rbmtp_mfa_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F first loss, fwid1, p first loss, fwid_p1, F second loss, 		///
	fwid2, p second loss, fwid_p2) tex append label	
}
}
}
 


* 11.B: Time to multiple spousal loss, male & female, single item scales (rbmtp_mfi)
foreach y in $ylisti {
foreach i in 1 0 {
	xtreg `y' $widlist_mtp $xlist i.wave [pw=weight] if male == `i', fe cluster(index)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	lincom wida_mn2 + wida_mn1 + wida_att + wida_pl1 + wida_gepl2
	scalar te = r(estimate)
	scalar tese = r(se)
	scalar tep = r(p)	
	testparm $widalist2
	scalar fwid1 = r(F)
	scalar fwid_p1 = r(p)
	testparm widb_mn2 widb_mn1 widb_att widb_pl1 widb_gepl2
	scalar fwid2 = r(F)
	scalar fwid_p2 = r(p)
if "`y'" == "rec" & `i' == 1 {
	outreg2 using rbmtp_mfi_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F first loss, fwid1, p first loss, fwid_p1, F second loss, 		///
	fwid2, p second loss, fwid_p2) tex replace label		
} 
else {
	outreg2 using rbmtp_mfi_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F first loss, fwid1, p first loss, fwid_p1, F second loss, 		///
	fwid2, p second loss, fwid_p2) tex append label		
}
}
}



/***** Table 12: Estimates for aggregated indices and single item scales by gender using propensity score matching (reg_psm)*****/

** (1) male & female, indices, w/ all channels 		(rbpsm_mfa)	 

* (1) 12.A: Simple widowhood onset, aggregated indices		
foreach y in $ylista {
foreach i in 1 0 {
	xtreg `y' wid_pa $xlist i.wave [pw=wpsker] if male == `i', fe cluster(index)
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	testparm wid_pa
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "cogtot" & `i' == 1{
	outreg2 using rbpsm_mfa_tex_pa, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex replace label	
} 
else {
	outreg2 using rbpsm_mfa_tex_pa, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex append label	
}
}
}

* (1) 12.B: Time to spousal loss, aggregated indices	
foreach y in $ylista {
foreach i in 1 0 {
	xtreg `y' $widalist2 $xlist i.wave [pw=wpsker] if male == `i', fe cluster(index)
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	lincom wida_mn2 + wida_mn1 + wida_att + wida_pl1 + wida_gepl2
	scalar te = r(estimate)
	scalar tese = r(se)
	scalar tep = r(p)	
	testparm $widalist2
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "cogtot" & `i' == 1{
	outreg2 using rbpsm_mfa_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F overall, foval, p overall, foval_p, F widowhood, fwid, 		///
	p widowhood, fwid_p) tex replace label
} 
else {
	outreg2 using rbpsm_mfa_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F overall, foval, p overall, foval_p, F widowhood, fwid, 		///
	p widowhood, fwid_p) tex append label
}
}
}


** (2) male & female, items, w/ all channels 		(rbpsm_mfi)

* (2) 12.A: Simple widowhood onset, single item scales	
foreach y in $ylisti {
foreach i in 1 0 {
	xtreg `y' wid_pa $xlist i.wave [pw=wpsker] if male == `i', fe cluster(index)
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	testparm wid_pa
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "rec" & `i' == 1 {
	outreg2 using rbpsm_mfi_tex_pa, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex replace label	
} 
else {
	outreg2 using rbpsm_mfi_tex_pa, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(AIC, aic, BIC, bic, F overall, foval, p overall, 			///
	foval_p, F widowhood, fwid, p widowhood, fwid_p) tex append label	
}
}
}


* (2) 12.B: Time to spousal loss, single item scales	
foreach y in $ylisti {
foreach i in 1 0 {
	xtreg `y' $widalist2 $xlist i.wave [pw=wpsker] if male == `i', fe cluster(index)
	scalar foval = e(F)
	scalar foval_p = e(p)
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	lincom wida_mn2 + wida_mn1 + wida_att + wida_pl1 + wida_gepl2
	scalar te = r(estimate)
	scalar tese = r(se)
	scalar tep = r(p)
	testparm $widalist2
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if "`y'" == "rec" & `i' == 1 {
	outreg2 using rbpsm_mfi_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F overall, foval, p overall, foval_p, F widowhood, fwid, 		///
	p widowhood, fwid_p) tex replace label	
} 
else {
	outreg2 using rbpsm_mfi_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F overall, foval, p overall, foval_p, F widowhood, fwid, 		///
	p widowhood, fwid_p) tex append label
}
}
}




/***** Table 13: Estimates for single item scales for different age cohorts *****/
* male & female, single item scales										(rbcoh_tq)

* oldest old: born before 1924
* children of the depression: 1924 - 1930
* hrs original cohort: 1931 - 1941 
* war babies: 1942 - 1947

 
* 13.A. Time to spousal loss, mental status (rbcoh_mtst)
foreach y in mtst {
forvalues coh = 1 / 4 {
	xtreg `y' $widalist2 $xlist i.wave [pw=weight] if coh`coh'_mtst == 1, fe cluster(index)	
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	lincom wida_mn2 + wida_mn1 + wida_att + wida_pl1 + wida_gepl2
	scalar te = r(estimate)
	scalar tese = r(se)
	scalar tep = r(p)	
	testparm $widalist2
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if `coh' == 1 {
	outreg2 using rbcoh_mtst_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F widowhood, fwid, p widowhood, fwid_p) tex replace label	
} 
else {
	outreg2 using rbcoh_mtst_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F widowhood, fwid, p widowhood, fwid_p) tex append label	
}
}
}



* 13.B. Time to spousal loss, objective memory (rbcoh_objm)
foreach y in objm {
forvalues coh = 1 / 4 {
	xtreg `y' $widalist2 $xlist i.wave [pw=weight] if coh`coh'_objm == 1, fe cluster(index)	
	estat ic
	mat ic = r(S)
	scalar aic = ic[1,5]
	scalar bic = ic[1,6]
	lincom wida_mn2 + wida_mn1 + wida_att + wida_pl1 + wida_gepl2
	scalar te = r(estimate)
	scalar tese = r(se)
	scalar tep = r(p)	
	testparm $widalist2
	scalar fwid = r(F)
	scalar fwid_p = r(p)
if `coh' == 1 {
	outreg2 using rbcoh_objm_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F widowhood, fwid, p widowhood, fwid_p) tex replace label	
} 
else {
	outreg2 using rbcoh_objm_tex, ctitle("`var label `y''") stats(coef se) paren(se) 	///
	bdec(3) dec(2) addstat(Total effect, te, Total se, tese, Total p, tep, 				///
	AIC, aic, BIC, bic, F widowhood, fwid, p widowhood, fwid_p) tex append label	
}
}
}




log close