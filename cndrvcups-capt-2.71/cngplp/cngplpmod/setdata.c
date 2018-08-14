/*
 *  Print Dialog for Canon LIPS/PS/LIPSLX/UFR2/CAPT Printer.
 *  Copyright CANON INC. 2004
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */


#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "cngplpmod.h"
#include "cupsoption.h"
#include "ppdoptions.h"
#include "execjob.h"
#include "ppdkeys.h"

typedef struct booklet_dlg_value_t{
	char *value;
	char *creep_val;
	char *correction_val;
	double gutter_shift_num_d;
}BookletDlgValue;

typedef struct gutter_dlg_value_t{
	int value;
	double value_d;
}GutterDlgValue;

typedef struct findetail_dlg_value_t{
	char *fix;
	char *smooth;
	char *rotate;
	char *back;
	char *detect;
	char *skip;
	char *correction;
	char *copy_start_num_val;
	char *trust_print_val;
	int start_num;
	JobNote *job_note;
	char *postcard;
	char *wrinkles;
}FinDetailDlgValue;

typedef struct boxid_dlg_value_t{
	int data_name;
	char enter_name[128];
#ifndef __APPLE__
	int box_num;
#else
	char box_num[512];
#endif
}BoxidDlgValue;

typedef struct secured_dlg_value_t{
	char doc[128];
	char usr[128];
	char pass[8];
}SecuredDlgValue;

typedef struct jobaccount_dlg_value_t{
	char id[12];
	char ps[8];
}JobAccountDlgValue;

typedef struct prof_dlg_value_t{
	CupsOptVal *ppd_opt;
}ProfDlgValue;

typedef struct frontbackcvr_dlg_value_t{
	CupsOptVal *ppd_opt;
}FrontBackCvrDlgValue;
typedef struct holdqueue_dlg_value_t{
	int data_name_type;
	char enter_name[128];
}HoldQueueDlgValue;

typedef struct advanced_settings_dlg_value_t{
	char *shift_position_val;
	int shift_front_long;
	int shift_front_short;
	int shift_back_long;
	int shift_back_short;
	double detail_shift_front_long;
	double detail_shift_front_short;
	double detail_shift_back_long;
	double detail_shift_back_short;
}AdvancedSettingsDlgValue;

typedef struct prop_dlg_value_t{
	CupsOptVal *common;
	CupsOptVal *image;
	CupsOptVal *text;
	CupsOptVal *hpgl;
	int img_reso_scale;
	int margin_on;
	int selectby;
	int gutter_value;
	double gutter_value_d;
	int startnum_value;
	int shift_upwards;
	int shift_right;
	int shift_front_long;
	int shift_front_short;
	int shift_back_long;
	int shift_back_short;
	double detail_shift_upwards;
	double detail_shift_right;
	double detail_shift_front_long;
	double detail_shift_front_short;
	double detail_shift_back_long;
	double detail_shift_back_short;
	SpecialFunc *special;
	CupsOptVal *ppd_opt;
	JobNote *job_note;
	char *cnmediabrand;
	char *cninsertmediabrand;
	char *cninterleafmediabrand;
	char *cnpbindcovermediabrand;
	int offset_num;
	double guttershiftnum_value_d;
	double tab_shift;
	double ins_tab_shift;
	double adjust_trim_num;
	double adjust_frtrim_num;
	double adjust_tbtrim_num;
	double pb_fin_fore_trim_num;
	double pb_fin_topbtm_trim_num;
	int stack_copies_num;
	int saddle_press_adjust;
	char multipunch[16];
}PropDlgValue;

enum{
	MAIN_WINDOW = 0,
	PROP_DLG,
	BOOKLET_DLG,
	GUTTER_DLG,
	FINDETAIL_DLG,
	BOXID_DLG,
	SECURED_DLG,
	JOBACCOUNT_DLG,
	PROFILE_DLG,
	FRONTBACKCVR_DLG,
	HOLDQUEUE_DLG,
	ADVANCEDSETTINGS_DLG,
};

struct save_data_t{
	int showdlg_flag;
	PropDlgValue *prop;
	BookletDlgValue *booklet;
	GutterDlgValue *gutter;
	FinDetailDlgValue *fin;
	BoxidDlgValue *boxid;
	SecuredDlgValue *secured;
	JobAccountDlgValue *job;
	ProfDlgValue *prof;
	FrontBackCvrDlgValue *ftbkcvr;
	HoldQueueDlgValue *holdqueue;
	AdvancedSettingsDlgValue *advsettings;
};

static void UpdateDuplex(cngplpData *data, int flag);
static void UpdateBindEdge(cngplpData *data, char *value);
static void UpdateCNSaddleSetting(cngplpData *data, char *value);
static void UpdateCNSpecID(cngplpData *data, char *value);
static void GetShiftStartPosLimit(cngplpData *data, int id, int *max, int *min);
#ifndef __APPLE__
static void UpdateCNFoldSetting(cngplpData *data, const char *value);
static void UpdateCNPrintStyle(cngplpData *data, const char *value);
static void UpdateCNFoldDetail(cngplpData *data, char *value);
#endif

char* SetDataCommon(cngplpData *data, int id, char *value)
{
	char *option = NULL;
	char *copies = NULL;
	int i = 0;
	int index;
	int ret = 0;

	switch(id){
	case ID_PRINTERNAME:
		if(value == NULL)
			break;
		if(strcmp(value, data->curr_printer) != 0){
			for(i = 0; i < data->printer_num; i++){
				if(strcmp(value, data->printer_names[i]) == 0){
					cngplpFreeOptions(data);
					data->curr_printer = data->printer_names[i];
					ret = cngplpInitOptions(data);
					if(ret < 0){
						fprintf(stderr, "Failed to get current printer info.\n");
						cngplpDestroy(data);
						exit(1);
					}
					AddUpdateOption(data, "PrinterName");
					break;
				}
			}
		}
		break;
	case ID_FILTER:
		if(value == NULL)
			break;
		for(i = 0; g_filter_options[i] != NULL; i++){
			if(strcmp(value, g_filter_options[i]) == 0){
				SetCupsOption(data, data->cups_opt->common->option, "Filter", g_filter_options[i]);
				AddUpdateOption(data, "Filter");
				break;
			}
		}
		break;
	case ID_NUMBER_UP:
		if(value == NULL)
			break;
		index = id - ID_COMMON_OPTION - 1;
		option = IDtoCommonOption(index);
		for(i = 0; NupTextValue_table[i].text != NULL; i++){
			if(strcmp(value, NupTextValue_table[i].text) == 0){
				if((data->ppd_opt->uiconf_flag & CNUICONF_FLG_NUMBER_UP)
				 ||(data->ppd_opt->uiconf_flag & CNUICONF_FLG_ORIENTATION_REQUESTED)){
					char *nup = NULL;
					nup = GetCupsValue(data->cups_opt->common->option, option);
					MarkDisable(data, option, nup, -1, 1);
					SetCupsOption(data, data->cups_opt->common->option, option, NupTextValue_table[i].value);
					MarkDisable(data, option, value, 1, 1);
					RemarkOptValue(data, option);
				}else{
					SetCupsOption(data, data->cups_opt->common->option, option, NupTextValue_table[i].value);
				}
				break;
			}
		}
		break;
	case ID_CNCOPIES:
		if(value == NULL)
			break;
		index = id - ID_COMMON_OPTION - 1;
		option = IDtoCommonOption(index);
		if(data->ppd_opt->uiconf_flag & CNUICONF_FLG_CNCOPIES_COLLATE){
			copies = GetCupsValue(data->cups_opt->common->option, option);
			MarkDisable(data, "CNCopies", copies, -1, 1);
			SetCupsOption(data, data->cups_opt->common->option, option, value);
			MarkDisable(data, "CNCopies", value, 1, 1);
			RemarkOptValue(data, "CNCopies");
		}else{
			SetCupsOption(data, data->cups_opt->common->option, option, value);
		}
		break;
	case ID_ORIENTATION_REQUESTED:
		if(value == NULL)
			break;
		index = id - ID_COMMON_OPTION - 1;
		option = IDtoCommonOption(index);
		if(data->ppd_opt->uiconf_flag & CNUICONF_FLG_ORIENTATION_REQUESTED){
			char *ori = NULL;
			ori = GetCupsValue(data->cups_opt->common->option, option);
			MarkDisable(data, option, ori, -1, 1);
			SetCupsOption(data, data->cups_opt->common->option, option, value);
			MarkDisable(data, option, value, 1, 1);
			RemarkOptValue(data, option);
		}else{
			SetCupsOption(data, data->cups_opt->common->option, option, value);
		}
		break;
	default:
		if(value == NULL)
			break;
		index = id - ID_COMMON_OPTION - 1;
		option = IDtoCommonOption(index);
		SetCupsOption(data, data->cups_opt->common->option, option, value);
		break;
	}
	return option;
}

char* SetDataImage(cngplpData *data, int id, char *value)
{
	char *option = NULL;
	int index;
	if(id == ID_RESO_SCALE){
		if(value == NULL)
			return NULL;
		data->cups_opt->image->img_reso_scale = atoi(value);
		AddUpdateOption(data, "Reso-Scale");
	}else{
		if(value == NULL)
			return NULL;
		index = id - ID_IMAGE_OPTION - 1;
		option = IDtoImageOption(index);
		SetCupsOption(data, data->cups_opt->image->option, option, value);
	}
	return option;
}

char* SetDataText(cngplpData *data, int id, char *value)
{
	char *option = NULL;
	int index;
	if(id == ID_MARGIN){
		if(value == NULL)
			return NULL;
		data->cups_opt->text->margin_on = atoi(value);
		AddUpdateOption(data, "Margin");
	}else if(id < ID_MARGIN){
		if(value == NULL)
			return NULL;
		index = id - ID_TEXT_OPTION - 1;
		option = IDtoTextOption(index);
		SetCupsOption(data, data->cups_opt->text->option, option, value);
	}
	return option;
}

char* SetDataHPGL(cngplpData *data, int id, char *value)
{
	char *option = NULL;
	int index;
	if(value == NULL)
		return NULL;
	index = id - ID_HPGL_OPTION - 1;
	option = IDtoHPGLOption(index);
	SetCupsOption(data, data->cups_opt->hpgl->option, option, value);
	return option;
}


int UpdatePageSize(cngplpData *data, char *value)
{
	UIItemsList *list = data->ppd_opt->items_list;
	char *fin, *pnc, *fld, *ins, *trm, *dpx, *src, *trc, *spd, *hrd, *etp;
	char *tbt;
	char *itr;
#ifndef __APPLE__
	char *prp;
	char *gp;
#endif
	char *usp;
	char *ecs = NULL;

	fin = FindCurrOpt(list, "CNFinisher");
	pnc = FindCurrOpt(list, "CNPuncher");
	fld = FindCurrOpt(list, "CNFolder");
	ins = FindCurrOpt(list, "CNInsertUnit");
	trm = FindCurrOpt(list, "CNTrimmer");
	tbt = FindCurrOpt(list, "CNTopBottomTrimmer");
	dpx = FindCurrOpt(list, "CNDuplexUnit");
	src = FindCurrOpt(list, "CNSrcOption");
	trc = FindCurrOpt(list, "CNTrayCSetting");
	spd = FindCurrOpt(list, "CNSidePaperDeck");
	hrd = FindCurrOpt(list, "CNHardDisk");
	etp = FindCurrOpt(list, "CNEnableTrustPrint");
	itr = FindCurrOpt(list, kPPD_Items_CNInnerTrimmer);
#ifndef __APPLE__
	prp = FindCurrOpt(list, "CNProPuncher");
	gp = FindCurrOpt(list, kPPD_Items_CNDeviceType);
#endif
	usp = FindCurrOpt(list, kPPD_Items_CNUseSecuredPrint);
	ecs = FindCurrOpt(list, kPPD_Items_CNEnableCMSSettings);

	if(SetCustomSize(data, value))
		return 1;

#ifndef _OPAL
	ResetUIDisable(data);
	InitUIDisable(data);
#endif
	UpdatePPDData(data, "PageSize", value);

#ifndef __APPLE__
	if(gp != NULL)
		UpdatePPDData(data, kPPD_Items_CNDeviceType, gp);
#endif
	if(fin != NULL)
		UpdatePPDData(data, "CNFinisher", fin);
	if(pnc != NULL)
		UpdatePPDData(data, "CNPuncher", pnc);
	if(fld != NULL)
		UpdatePPDData(data, "CNFolder", fld);
	if(ins != NULL)
		UpdatePPDData(data, "CNInsertUnit", ins);
	if(trm != NULL)
		UpdatePPDData(data, "CNTrimmer", trm);
	if(tbt != NULL)
		UpdatePPDData(data, "CNTopBottomTrimmer", tbt);
	if(dpx != NULL)
		UpdatePPDData(data, "CNDuplexUnit", dpx);
	if(src != NULL)
		UpdatePPDData(data, "CNSrcOption", src);
	if(trc != NULL)
		UpdatePPDData(data, "CNTrayCSetting", trc);
	if(spd != NULL)
		UpdatePPDData(data, "CNSidePaperDeck", spd);
	if(hrd != NULL)
		UpdatePPDData(data, "CNHardDisk", hrd);
	if(etp != NULL)
		UpdatePPDData(data,"CNEnableTrustPrint", etp);
	if(itr != NULL)
		UpdatePPDData(data, kPPD_Items_CNInnerTrimmer, itr);
#ifndef __APPLE__
	if(prp != NULL)
		UpdatePPDData(data, "CNProPuncher", prp);
#endif
	if(usp != NULL)
		UpdatePPDData(data, kPPD_Items_CNUseSecuredPrint, usp);

	if(ecs != NULL)
	{
		UpdatePPDData(data, kPPD_Items_CNEnableCMSSettings, ecs);
	}

#ifndef _OPAL
	ResetCupsOptions(data);
	data->ppd_opt->gutter_value = 0;
	data->ppd_opt->gutter_value_d = 0.0;
	data->ppd_opt->startnum_value = 1;
	data->ppd_opt->guttershiftnum_value_d = 0.0;
	data->ppd_opt->tab_shift = 12.7;
	data->ppd_opt->ins_tab_shift = 12.7;
	InitAdjustTrimm(data->ppd_opt);
	data->ppd_opt->stack_copies_num = 1;
	data->ppd_opt->saddle_press_adjust = 0;
	if(data->ppd_opt->selectby)
		data->ppd_opt->selectby = SELECTBY_INPUTSLOT;
#endif

	return 0;
}

int ChkChgOpt(UIItemsList *items_list, char *name, char *value)
{
	char *str = FindCurrOpt(items_list, name);
	if(str == NULL)
		return 0;

	return (strcasecmp(str, value) == 0) ? 1 : 0;
}

void ChkStapleLocation(cngplpData *data, UIItemsList *list)
{
	UIItemsList *tmp;
	char *collate;
	tmp = list;

	if(FindCurrOpt(tmp, "StapleLocation") == NULL)
		return;

	collate = FindCurrOpt(tmp, "Collate");
	if(collate != NULL){
		if((strcmp(collate, "Staple") != 0) && (strcmp(collate, "StapleCollate") != 0) && (strcmp(collate, "StapleGroup") != 0))
			UpdatePPDData(data, "StapleLocation", "None");
		else
			UpdateEnableData(data, "StapleLocation", 1);
		AddUpdateOption(data, "StapleLocation");
	}
}

int isCompareCurrentValue(cngplpData *data, int id, const char* value)
{
	int result = 0;
	char *pBuff = NULL;
	char *pTok = NULL;
	char *pSaveTok = NULL;

	if ( (NULL == data) || (NULL == value) ) {
		return result;
	}

	pBuff = cngplpGetData(data, id);
	if ( pBuff ) {
		if ( (pTok = strtok_r(pBuff, ",;:", &pSaveTok)) != NULL ) {
			if ( strcmp(pTok, value) == 0 ) {
				result = 1;
			}
		}
		else {
			if ( strcmp(pBuff, value) == 0 ) {
				result = 1;
			}
		}
		free( pBuff );
	}
	return result;
}

char* SetDataPPD(cngplpData *data, int id, char *value)
{
	UIItemsList *list = data->ppd_opt->items_list;
	int index = id - 1;
	char *option = IDtoPPDOption(index);
	char *punch = NULL;
	int selectby = 0;
	int active = 0;
	int size = 0;

	if(option != NULL && index <= PPD_OPTION_NUM){
		if(value == NULL)
			return NULL;
		if(ChkChgOpt(list, option, value))
			return "NoChange";
	}

	switch(id){
	case ID_PAGESIZE:
		if(value == NULL)
			break;
		if(UpdatePageSize(data, value))
			return NULL;
		AddUpdateOption(data, "PageSize");
		break;
	case ID_MEDIATYPE:
		if(option == NULL || value == NULL)
			break;
		UpdatePPDData(data, option, value);
		AddUpdateOption(data, "CNOHPPrintMode");
        UpdateMediaBrandWithCurrMediaType(data, 0);

		break;
	case ID_SIDED1PRINT:
		if(value == NULL)
			break;
		if(strcasecmp(value, "true") == 0){
			UpdateDuplex(data, 0);
			UpdatePPDData(data, "Booklet", "None");
		}
		break;
	case ID_DUPLEX:
		if(value == NULL)
			break;
#ifdef __APPLE__
		UpdatePPDData_Priority(data, "Duplex", value);
#else
		if(strcasecmp(value, "true") == 0){
			UpdateDuplex(data, 1);
			UpdatePPDData(data, "Booklet", "None");
		}else{
			UpdateDuplex(data, 0);
		}
#endif
		break;
	case ID_BOOKLET:
		if(option == NULL || value == NULL)
			break;
#ifdef	__APPLE__
		if(data->ppd_opt->printer_type != PRINTER_TYPE_CAPT){
			UpdatePPDData(data, option, value);
			break;
		}
#endif
		if(strcasecmp(value, "true") == 0){
			char *cur = FindCurrOpt(list, option);
			if(strcmp(cur, "None") == 0)
				UpdatePPDData(data, "Booklet", "Left");
			else
				UpdatePPDData(data, "Booklet", cur);
			UpdateDuplex(data, 0);
		}else{
			UpdatePPDData(data, "CNTrimming", "False");
			UpdatePPDData(data, "CNSaddleStitch", "False");
			UpdatePPDData(data, "CNCreep", "False");
			UpdatePPDData(data, "CNVfolding", "False");
#if !defined(__APPLE__) && !defined(_OPAL)
			UpdatePPDData(data, "CNVfoldingTrimming", "False");
#endif
			UpdatePPDData(data, "Booklet", "None");
		}
		break;
	case ID_BOOKLET_DLG:
		if(value == NULL)
			break;
		UpdatePPDData(data, "Booklet", value);
		break;
	case ID_BINDEDGE:
		if(option == NULL || value == NULL)
			break;
#ifndef __APPLE__
		char *multipunch = NULL;
		const UIItemsList *const multi_list = FindItemsList(list, kPPD_Items_CNMultiPunch);
		int disable = 0;
		if(multi_list != NULL){
			multipunch = multi_list->default_option;
			disable = GetOptionDisableCount(data->ppd_opt, "CNMultiPunch", "BindEdge", value);
		}
		if(0 < disable){
			punch = FindCurrOpt(list, "CNPunch");
			if(punch != NULL){
				UpdatePPDData(data, "CNPunch", "None");
				ChkStapleLocation(data, list);
				if(multipunch != NULL){
					if((data != NULL) && (data->ppd_opt != NULL) && (data->ppd_opt->multipunch != NULL)){
						memset(data->ppd_opt->multipunch, '\0', 16);
						memcpy(data->ppd_opt->multipunch, multipunch, strlen(multipunch));
						UpdatePPDData(data, "CNMultiPunch", "Off");
					}
				}
				AddUpdateOption(data, "CNPunch");
			}
			UpdateBindEdge(data, value);
			break;
		}
#endif
		UpdateBindEdge(data, value);
		punch = FindCurrOpt(list, "CNPunch");
		if(punch != NULL){
			UpdatePPDData(data, "CNPunch", "None");
			ChkStapleLocation(data, list);
			if(strcasecmp(punch, "None") != 0){
				int disable;

				disable = GetDisableOpt(list, "CNPunch", value);
				if(disable == 0){
					UpdatePPDData(data, "CNPunch", value);
				}else{
					UpdatePPDData(data, "CNPunch", "None");
				}
			}
			AddUpdateOption(data, "CNPunch");
		}
		break;
	case ID_GUTTER:
		if(value == NULL)
			break;
		data->ppd_opt->gutter_value = atoi(value);
		data->ppd_opt->gutter_value_d = atof(value);
#ifdef __APPLE__
		if(data->ppd_opt->gutter_value > data->ppd_opt->max_gutter_value){
			data->ppd_opt->gutter_value = data->ppd_opt->max_gutter_value;
		}
		if(data->ppd_opt->gutter_value_d > data->ppd_opt->max_gutter_value_d){
			data->ppd_opt->gutter_value_d = data->ppd_opt->max_gutter_value_d;
		}
#endif
		break;
	case ID_COLLATE:
		if(option == NULL || value == NULL)
			break;
		UpdatePPDData(data, option, value);
		ChkStapleLocation(data, list);
		break;
	case ID_CNPUNCH:
		if(value == NULL)
			break;
		if(strcasecmp(value, "true") == 0){
			char *bind;
			bind = FindCurrOpt(list, "BindEdge");
			if(bind != NULL){
				UpdatePPDData(data, "CNPunch", bind);
			}
#ifndef __APPLE__
			if(strlen(data->ppd_opt->multipunch)){
				UpdatePPDData(data, "CNMultiPunch", data->ppd_opt->multipunch);
			}
#endif
		}else{
			UpdatePPDData(data, "CNPunch", "None");
#ifndef __APPLE__
			char *multipunch = FindCurrOpt(list, "CNMultiPunch");
			if(multipunch != NULL){
				memset(data->ppd_opt->multipunch, '\0', 16);
				memcpy(data->ppd_opt->multipunch, multipunch, strlen(multipunch));
				UpdatePPDData(data, "CNMultiPunch", "Off");
			}
#endif
		}
		AddUpdateOption(data, "CNPunch");
		break;
	case ID_SELECTBY:
		if(value == NULL)
			break;
		selectby = atoi(value);
		if(selectby == SELECTBY_INPUTSLOT){
			UpdatePPDData(data, "CNInterleafPrint", "False");
			UpdatePPDData(data, "CNInterleafMediaType", NULL);
			UpdatePPDData(data, "CNInterleafSheet", "False");

			data->ppd_opt->selectby = selectby;
			UpdatePPDData(data, "MediaType", NULL);
		}else if(selectby == SELECTBY_MEDIATYPE){
			data->ppd_opt->selectby = selectby;
			UpdatePPDData(data, "InputSlot", NULL);
		}
		AddUpdateOption(data, "SelectBy");
		AddUpdateOption(data, "CNInterleafSheet");
		AddUpdateOption(data, "CNOHPPrintMode");
		break;
	case ID_JOBACCOUNT:
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
			active = (strcasecmp(value, "true") == 0) ? 1 : 0;
			data->ppd_opt->special->job_account = active;
			AddUpdateOption(data, "JobAccount");
		}
		break;
	case ID_DATANAME:
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
			data->ppd_opt->special->data_name = atoi(value);
			AddUpdateOption(data, "DataName");
		}
		break;
	case ID_ENTERNAME:
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
#ifndef _OPAL
			memset(data->ppd_opt->special->enter_name, 0 , 128);
			strncpy(data->ppd_opt->special->enter_name, value, 127);
#else
			if(data->ppd_opt->special->enter_name != NULL){
				free(data->ppd_opt->special->enter_name);
				data->ppd_opt->special->enter_name = NULL;
			}
			data->ppd_opt->special->enter_name = strdup(value);
#endif
		}
		break;
	case ID_BOXIDNUM:
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
#ifndef __APPLE__
			data->ppd_opt->special->box_num = atoi(value);
#else
			strncpy(data->ppd_opt->special->box_num, value, 511);
#endif
		}
		break;
	case ID_SECURED_DOCNAME:
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
#ifndef _OPAL
			size = sizeof(data->ppd_opt->special->doc_name);
			memset(data->ppd_opt->special->doc_name, 0, size);
			strncpy(data->ppd_opt->special->doc_name, value, 127);
#else
			if(data->ppd_opt->special->doc_name != NULL){
				free(data->ppd_opt->special->doc_name);
				data->ppd_opt->special->doc_name = NULL;
			}
			data->ppd_opt->special->doc_name = strdup(value);
#endif
		}
		break;
	case ID_SECURED_USRNAME:
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
			size = sizeof(data->ppd_opt->special->usr_name);
			memset(data->ppd_opt->special->usr_name, 0, size);
			strncpy(data->ppd_opt->special->usr_name, value, 127);
		}
		break;
	case ID_SECURED_PASSWD:
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
			size = sizeof(data->ppd_opt->special->passwd_array);
			memset(data->ppd_opt->special->passwd_array, 0, size);
			strncpy(data->ppd_opt->special->passwd_array, value, 7);
		}
		break;
	case ID_JOBACCOUNT_ID:
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
			size = sizeof(data->ppd_opt->special->job_account_id);
			memset(data->ppd_opt->special->job_account_id, 0, size);
			strncpy(data->ppd_opt->special->job_account_id, value, 9);
		}
		break;
	case ID_JOBACCOUNT_PASSWD:
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
			size = sizeof(data->ppd_opt->special->job_account_passwd);
			memset(data->ppd_opt->special->job_account_passwd, 0, size);
			strncpy(data->ppd_opt->special->job_account_passwd, value, 7);
		}
		break;
	case ID_CNUSRPASSWORD:
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
			size = sizeof(data->ppd_opt->special->usr_passwd);
			memset(data->ppd_opt->special->usr_passwd, 0, size);
			strncpy(data->ppd_opt->special->usr_passwd, value, size-1);
		}
		break;
	case ID_CNCOPYSETNUMBERING:
		if(value == NULL)
			break;
		AddUpdateOption(data, option);
		UpdatePPDData(data, option, value);
		break;
	case ID_STARTNUM:
		if(value == NULL)
			break;
		data->ppd_opt->startnum_value = atoi(value);
		break;
	case ID_CNINTERLEAFSHEET:
		if(value == NULL)
			break;
		AddUpdateOption(data, option);
		UpdatePPDData(data, option, value);
		break;
	case ID_CNCOLORMODE:
		if(option == NULL || value == NULL)
			break;
		UpdatePPDData(data, option, value);
		AddUpdateOption(data, option);
#ifndef __APPLE__
		UIItemsList *matching_method = FindItemsList(list, kPPD_Items_CNMatchingMethod);
		UIItemsList *monitor_profile = FindItemsList(list, kPPD_Items_CNMonitorProfile);
		if(strcasecmp(value, "mono") == 0){
			if(matching_method)
				UpdatePPDData(data, kPPD_Items_CNMatchingMethod, "None");
			if(monitor_profile)
				UpdatePPDData(data, kPPD_Items_CNMonitorProfile, "None");
		}
		else{
			if(matching_method)
				UpdatePPDData(data, kPPD_Items_CNMatchingMethod, matching_method->default_option);
			if(monitor_profile)
				UpdatePPDData(data, kPPD_Items_CNMonitorProfile, monitor_profile->default_option);
		}
#if !defined(__APPLE__) && !defined(_OPAL)
		UIItemsList *number_of_colors = FindItemsList(list, kPPD_Items_CNNumberOfColors);
		if( number_of_colors != NULL ) {
			AddUpdateOption(data, kPPD_Items_CNNumberOfColors);
		}
#endif
#endif
		break;
	case ID_DISABLE_JOBACCOUNT_BW:
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
			active = (strcasecmp(value, "true") == 0) ? 1 : 0;
			data->ppd_opt->special->disable_job_account_bw = active;
		}
		break;
	case ID_CNPUREBLACKTEXT:
		if(option == NULL || value == NULL)
			break;
		UpdatePPDData(data, option, value);
		AddUpdateOption(data, option);
		{
			int disable;
			char *cur;
			cur = FindCurrOpt(list, IDtoPPDOption(ID_CNBLACKOVERPRINT-1));
			if(cur != NULL){
				disable = GetDisableOpt(list, IDtoPPDOption(ID_CNBLACKOVERPRINT-1), cur);
				if(disable != 0){
					UpdatePPDData(data, IDtoPPDOption(ID_CNBLACKOVERPRINT-1), NULL);
				}
			}
		}
		break;
	case ID_CNSET_FRONT_COVER:
	case ID_CNSET_BACK_COVER:
		if(option == NULL || value == NULL)
			break;
		AddUpdateOption(data, option);
		UpdatePPDData(data, option, value);
		break;
	case ID_CNSHIFTUPWARDS:
		if(value == NULL)
			break;
		{
			int	max_val, min_val, new_val;
			double new_val_double;
			GetShiftStartPosLimit(data, ID_CNSHIFTUPWARDS, &max_val, &min_val);
			new_val = atoi(value);
			new_val_double = atof(value);
			if((double)min_val > new_val_double){
				data->ppd_opt->shift_upwards = min_val;
				data->ppd_opt->detail_shift_upwards = (double)min_val;
			}else if((double)max_val < new_val_double){
				data->ppd_opt->shift_upwards = max_val;
				data->ppd_opt->detail_shift_upwards = (double)max_val;
			}else{
				data->ppd_opt->shift_upwards = new_val;
				data->ppd_opt->detail_shift_upwards = new_val_double;
			}
		}
		break;
	case ID_CNSHIFTRIGHT:
		if(value == NULL)
			break;
		{
			int	max_val, min_val, new_val;
			double new_val_double;
			GetShiftStartPosLimit(data, ID_CNSHIFTRIGHT, &max_val, &min_val);
			new_val = atoi(value);
			new_val_double = atof(value);
			if((double)min_val > new_val_double){
				data->ppd_opt->shift_right = min_val;
				data->ppd_opt->detail_shift_right = (double)min_val;
			}else if((double)max_val < new_val_double){
				data->ppd_opt->shift_right = max_val;
				data->ppd_opt->detail_shift_right = (double)max_val;
			}else{
				data->ppd_opt->shift_right = new_val;
				data->ppd_opt->detail_shift_right = new_val_double;
			}
		}
		break;
	case ID_CNSHIFTFRLONGEDGE:
		if(value == NULL)
			break;
		{
			int	max_val, min_val, new_val;
			double new_val_double;
			GetShiftStartPosLimit(data, ID_CNSHIFTFRLONGEDGE, &max_val, &min_val);
			new_val = atoi(value);
			new_val_double = atof(value);
			if((double)min_val > new_val_double){
				data->ppd_opt->shift_front_long = min_val;
				data->ppd_opt->detail_shift_front_long = (double)min_val;
			}else if((double)max_val < new_val_double){
				data->ppd_opt->shift_front_long = max_val;
				data->ppd_opt->detail_shift_front_long = (double)max_val;
			}else{
				data->ppd_opt->shift_front_long = new_val;
				data->ppd_opt->detail_shift_front_long = new_val_double;
			}
		}
		break;
	case ID_CNSHIFTFRSHORTEDGE:
		if(value == NULL)
			break;
		{
			int	max_val, min_val, new_val;
			double new_val_double;
			GetShiftStartPosLimit(data, ID_CNSHIFTFRSHORTEDGE, &max_val, &min_val);
			new_val = atoi(value);
			new_val_double = atof(value);
			if((double)min_val > new_val_double){
				data->ppd_opt->shift_front_short = min_val;
				data->ppd_opt->detail_shift_front_short = (double)min_val;
			}else if((double)max_val < new_val_double){
				data->ppd_opt->shift_front_short = max_val;
				data->ppd_opt->detail_shift_front_short = (double)max_val;
			}else{
				data->ppd_opt->shift_front_short = new_val;
				data->ppd_opt->detail_shift_front_short = new_val_double;
			}
		}
		break;
	case ID_CNSHIFTBKLONGEDGE:
		if(value == NULL)
			break;
		{
			int	max_val, min_val, new_val;
			double new_val_double;
			GetShiftStartPosLimit(data, ID_CNSHIFTBKLONGEDGE, &max_val, &min_val);
			new_val = atoi(value);
			new_val_double = atof(value);
			if((double)min_val > new_val_double){
				data->ppd_opt->shift_back_long = min_val;
				data->ppd_opt->detail_shift_back_long = (double)min_val;
			}else if((double)max_val < new_val_double){
				data->ppd_opt->shift_back_long = max_val;
				data->ppd_opt->detail_shift_back_long = (double)max_val;
			}else{
				data->ppd_opt->shift_back_long = new_val;
				data->ppd_opt->detail_shift_back_long = new_val_double;
			}
		}
		break;
	case ID_CNSHIFTBKSHORTEDGE:
		if(value == NULL)
			break;
		{
			int	max_val, min_val, new_val;
			double new_val_double;
			GetShiftStartPosLimit(data, ID_CNSHIFTBKSHORTEDGE, &max_val, &min_val);
			new_val = atoi(value);
			new_val_double = atof(value);
			if((double)min_val > new_val_double){
				data->ppd_opt->shift_back_short = min_val;
				data->ppd_opt->detail_shift_back_short = (double)min_val;
			}else if((double)max_val < new_val_double){
				data->ppd_opt->shift_back_short = max_val;
				data->ppd_opt->detail_shift_back_short = (double)max_val;
			}else{
				data->ppd_opt->shift_back_short = new_val;
				data->ppd_opt->detail_shift_back_short = new_val_double;
			}
		}
		break;
	case ID_CNJOBNOTE:
		if(value == NULL)
			break;
		if(data->ppd_opt->job_note){
			size = sizeof(data->ppd_opt->job_note->note);
			memset(data->ppd_opt->job_note->note, 0, size);
			strncpy(data->ppd_opt->job_note->note, value, size);
		}
		break;
	case ID_CNJOBDETAILS:
		if(value == NULL)
			break;
		if(data->ppd_opt->job_note){
			size = sizeof(data->ppd_opt->job_note->details);
			memset(data->ppd_opt->job_note->details, 0, size);
			strncpy(data->ppd_opt->job_note->details, value, size);
		}
		break;
	case ID_CNOFFSETNUM:
		if(value == NULL)
			break;
#ifdef __APPLE__
		if(GetOffsetNumConflict(data) && !IsConflictBetweenFunctions(data, kPPD_Items_CNStaple, "True", kPPD_Items_CNOutputPartition, "offset")){
			break;
		}
#endif
		data->ppd_opt->offset_num = atoi(value);
		break;
	case ID_CNGUTTERSHIFTNUM:
		{
		double max_value;
		char *maxptr;

		if(value == NULL)
			break;
		data->ppd_opt->guttershiftnum_value_d = atof(value);
		maxptr = cngplpGetData(data,ID_MAX_GUTTER_SHIFT_NUM);
		if(maxptr != NULL){
			max_value = atof(maxptr);

			if(max_value < data->ppd_opt->guttershiftnum_value_d){
				data->ppd_opt->guttershiftnum_value_d = max_value;
			}
			free(maxptr);
		}
		break;
		}
	case ID_CNTABSHIFT:
		if(value == NULL)
			break;
		data->ppd_opt->tab_shift = atof(value);
		break;
	case ID_CNMEDIABRANDLIST:
		RemakeMediaBrandList(data->ppd_opt, value);
		break;
	case ID_CNMEDIABRAND:
		if(value == NULL)
			break;
		UpdateMediaBrand(data, value);
		break;
	case ID_CNINSERTMEDIABRAND:
		if(value == NULL)
			break;
		UpdateInsertMediaBrand(data, value);
		break;
	case ID_CNINTERLEAFMEDIABRAND:
		if(value == NULL)
			break;
		UpdateInterleafMediaBrand(data, value);
		break;
	case ID_CNPBINDCOVERMEDIABRAND:
		if(value == NULL)
			break;
		UpdatePBindCoverMediaBrand(data, value);
		break;
	case ID_CNMONITORPROFILELIST:
		if(value == NULL)
			break;
		UpdateMonitorProfileList(data, value);
		break;
	case ID_CNRGBSOURCEPROFILELIST:
		UpdateDeviceProfileList(data, IDtoPPDOption(ID_CNRGBSOURCEPROFILE-1), value);
		break;
	case ID_CNRGBDEVICELINKPROFILELIST:
		UpdateDeviceProfileList(data, IDtoPPDOption(ID_CNRGBINPUTLIGHTCLRSPACE-1), value);
		break;
	case ID_CNCMYKDEVICELINKPROFILELIST:
		UpdateDeviceProfileList(data, IDtoPPDOption(ID_CNCMYKINPUTLIGHTCLRSPACE-1), value);
		break;
	case ID_CNCMYKSIMULATIONPROFILELIST:
		UpdateDeviceProfileList(data, IDtoPPDOption(ID_CNCMYKSIMULATIONPROFILE-1), value);
		break;
	case ID_CNOUTPUTPROFILELIST:
		UpdateDeviceProfileList(data, IDtoPPDOption(ID_CNOUTPUTPROFILE-1), value);
		break;
	case ID_CNINSERTTABSHIFT:
		if(value == NULL)
			break;
		data->ppd_opt->ins_tab_shift = atof(value);
		break;
	case ID_CNINSERTPOS:
		if(data->ppd_opt->ins_pos != NULL){
			free(data->ppd_opt->ins_pos);
			data->ppd_opt->ins_pos = NULL;
		}
		if(value != NULL)
			data->ppd_opt->ins_pos = strdup(value);
		break;
	case ID_CNINSERTPOSPAPERSOURCE:
		if(data->ppd_opt->ins_pos_papersource != NULL){
			free(data->ppd_opt->ins_pos_papersource);
			data->ppd_opt->ins_pos_papersource = NULL;
		}
		if(value != NULL)
			data->ppd_opt->ins_pos_papersource = strdup(value);
		break;
	case ID_CNINSERTPOSPRINTON:
		if(data->ppd_opt->ins_pos_printon != NULL){
			free(data->ppd_opt->ins_pos_printon);
			data->ppd_opt->ins_pos_printon = NULL;
		}
		if(value != NULL)
			data->ppd_opt->ins_pos_printon = strdup(value);
		break;
	case ID_CNTABINSERTPOS:
		if(data->ppd_opt->tab_ins_pos != NULL){
			free(data->ppd_opt->tab_ins_pos);
			data->ppd_opt->tab_ins_pos = NULL;
		}
		if(value != NULL)
			data->ppd_opt->tab_ins_pos = strdup(value);
		break;
	case ID_CNTABINSERTPOSPAPERSOURCE:
		if(data->ppd_opt->tab_ins_pos_papersource != NULL){
			free(data->ppd_opt->tab_ins_pos_papersource);
			data->ppd_opt->tab_ins_pos_papersource = NULL;
		}
		if(value != NULL)
			data->ppd_opt->tab_ins_pos_papersource = strdup(value);
		break;
	case ID_CNTABINSERTPOSPRINTON:
		if(data->ppd_opt->tab_ins_pos_printon != NULL){
			free(data->ppd_opt->tab_ins_pos_printon);
			data->ppd_opt->tab_ins_pos_printon = NULL;
		}
		if(value != NULL)
			data->ppd_opt->tab_ins_pos_printon = strdup(value);
		break;
	case ID_CNTABINSERTMULTIPAPERNUMBER:
		if(value == NULL)
			break;
		data->ppd_opt->tab_ins_multi_number = atoi(value);
		break;
	case ID_CNTABINSERTMULTIPAPERSOURCE:
		if(data->ppd_opt->tab_ins_multi_papersource != NULL){
			free(data->ppd_opt->tab_ins_multi_papersource);
			data->ppd_opt->tab_ins_multi_papersource = NULL;
		}
		if(value != NULL)
			data->ppd_opt->tab_ins_multi_papersource = strdup(value);
		break;
	case ID_CNTABINSERTMULTIPAPERTYPE:
		if(data->ppd_opt->tab_ins_multi_papertype != NULL){
			free(data->ppd_opt->tab_ins_multi_papertype);
			data->ppd_opt->tab_ins_multi_papertype = NULL;
		}
		if(value != NULL)
			data->ppd_opt->tab_ins_multi_papertype = strdup(value);
		break;
	case ID_CNFORMHANDLE:
#ifdef __APPLE__
		UpdateFormHandle(data, value);
#else
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
			size = sizeof(data->ppd_opt->special->form_handle);
			memset(data->ppd_opt->special->form_handle, 0, size);
			strncpy(data->ppd_opt->special->form_handle, value, size-1);
		}
#endif
		break;
	case ID_CNFORMLIST:
		UpdateFormList(data, value);
		break;
	case ID_CNOVERLAYFILENAME:
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
			size = sizeof(data->ppd_opt->special->form_name);
			memset(data->ppd_opt->special->form_name, 0, size);
			strncpy(data->ppd_opt->special->form_name, value, size-1);
		}
		break;
	case ID_CNADJUSTTRIMNUM:
		if(value == NULL)
			break;
		data->ppd_opt->adjust_trim_num = atof(value);
		break;
	case ID_CNADJUSTFORETRIMNUM:
		if(value == NULL)
			break;
		data->ppd_opt->adjust_frtrim_num = atof(value);
		break;
	case ID_CNADJUSTTOPBOTTOMTRIMNUM:
		if(value == NULL)
			break;
		data->ppd_opt->adjust_tbtrim_num = atof(value);
		break;
	case ID_CNPBINDFINISHFORETRIMNUM:
		if(value == NULL)
			break;
		data->ppd_opt->pb_fin_fore_trim_num = atof(value);
		break;
	case ID_CNPBINDFINISHTOPBOTTOMTRIMNUM:
		if(value == NULL)
			break;
		data->ppd_opt->pb_fin_topbtm_trim_num = atof(value);
		break;
	case ID_CNSENDTIMENUM:
		if((value == NULL) || (data->ppd_opt->fax_setting == NULL))
			break;
		memset(data->ppd_opt->fax_setting->send_time, 0 , 6);
		strncpy(data->ppd_opt->fax_setting->send_time, value, 5);
		break;
	case ID_CNOUTSIDELINENUMBER:
		if((value == NULL) || (data->ppd_opt->fax_setting == NULL))
			break;
		memset(data->ppd_opt->fax_setting->outside_line_number, 0 , 6);
		strncpy(data->ppd_opt->fax_setting->outside_line_number, value, 5);
		break;
	case ID_CNOUTSIDELINENUMINTRA:
		if((value == NULL) || (data->ppd_opt->fax_setting == NULL))
			break;
		memset(data->ppd_opt->fax_setting->outside_line_number_intra, 0 , 6);
        if( 0 != isCompareCurrentValue(data, ID_CNFAXIPFAXINTRA, "True") ){
			strncpy(data->ppd_opt->fax_setting->outside_line_number_intra, value, 5);
        }
		break;
	case ID_CNOUTSIDELINENUMNGN:
		if((value == NULL) || (data->ppd_opt->fax_setting == NULL))
			break;
		memset(data->ppd_opt->fax_setting->outside_line_number_ngn, 0 , 6);
        if( 0 != isCompareCurrentValue(data, ID_CNFAXIPFAXNGN, "True") ){
			strncpy(data->ppd_opt->fax_setting->outside_line_number_ngn, value, 5);
        }
		break;
	case ID_CNOUTSIDELINENUMMYNUMBERNGN:
		if((value == NULL) || (data->ppd_opt->fax_setting == NULL))
			break;
		memset(data->ppd_opt->fax_setting->outside_line_number_ngnmynum, 0 , 6);
        if( 0 != isCompareCurrentValue(data, ID_CNFAXIPFAXMYNUMBERNGN, "True") ){
			strncpy(data->ppd_opt->fax_setting->outside_line_number_ngnmynum, value, 5);
        }
		break;
	case ID_CNOUTSIDELINENUMVOIP:
		if((value == NULL) || (data->ppd_opt->fax_setting == NULL))
			break;
		memset(data->ppd_opt->fax_setting->outside_line_number_voip, 0 , 6);
        if( 0 != isCompareCurrentValue(data, ID_CNFAXIPFAXVOIP, "True") ){
			strncpy(data->ppd_opt->fax_setting->outside_line_number_voip, value, 5);
        }
		break;
	case ID_CNSENDER:
		if((value == NULL) || (data->ppd_opt->fax_setting == NULL))
			break;
		memset(data->ppd_opt->fax_setting->sender_name, 0 , 100);
		strncpy(data->ppd_opt->fax_setting->sender_name, value, 99);
		break;
	case ID_CNPBINDCOVERSHEET:
		if(value == NULL)
			break;
		UpdateBindCover(data, IDtoPPDOption(ID_CNPBINDCOVERSHEET-1), value);
		break;
	case ID_CNPBINDMAINPAPER:
		if(value == NULL)
			break;
		UpdateBindCover(data, IDtoPPDOption(ID_CNPBINDMAINPAPER-1), value);
		break;
	case ID_CNPBINDFINISHING:
		if(value == NULL)
			break;
		UpdateBindCover(data, IDtoPPDOption(ID_CNPBINDFINISHING-1), value);
		break;
	case ID_HOLD_NAME:
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
			size = sizeof(data->ppd_opt->special->hold_name);
			memset(data->ppd_opt->special->hold_name, 0, size);
			strncpy(data->ppd_opt->special->hold_name, value, size-1);
		}
		break;
	case ID_HOLDQUEUE_DATANAME:
		if(value == NULL)
			break;
		if(data->ppd_opt->special){
			data->ppd_opt->special->holddata_name = atoi(value);
			AddUpdateOption(data, "HoldDataName");
		}
		break;
	case ID_CNFEEDPAPERNAME:
		if(data->ppd_opt->feed_paper_name != NULL){
			free(data->ppd_opt->feed_paper_name);
			data->ppd_opt->feed_paper_name = NULL;
		}
		if(value != NULL)
			data->ppd_opt->feed_paper_name = strdup(value);
		break;
	case ID_CNSADDLESETTING:
		if(value == NULL)
			break;
		UpdateCNSaddleSetting(data, value);
		break;
	case ID_CNSTACKCOPIESNUM:
		if(value == NULL)
			break;
		data->ppd_opt->stack_copies_num = atoi(value);
		break;
	case ID_CNBINNAME:
		if(data->ppd_opt->bin_name != NULL){
			free(data->ppd_opt->bin_name);
			data->ppd_opt->bin_name = NULL;
		}
		if(value != NULL)
			data->ppd_opt->bin_name = strdup(value);
		break;
	case ID_CNBINNAME_ARRAY:
		if(data->ppd_opt->bin_name_array != NULL){
			free(data->ppd_opt->bin_name_array);
			data->ppd_opt->bin_name_array = NULL;
		}
		if(value != NULL)
			data->ppd_opt->bin_name_array = strdup(value);
		break;
	case ID_CNSADDLEPRESSADJUSTMENT:
		if(value == NULL)
			break;
		data->ppd_opt->saddle_press_adjust = atoi(value);
		break;
	case ID_CNSPECID:
		if(value == NULL)
			break;
		UpdateCNSpecID(data, value);
		break;
#if defined(__APPLE__) && !defined(_OPAL)
	case ID_CNDUPUNIT:
		if(value == NULL) {
			break;
		}
		UpdatePPDData(data, option, value);
		if(FindItemsList(list, kPPD_Items_CNDupUnit) != NULL) {
			UpdatePPDData(data, kPPD_Items_CNDuplex, NULL);
		}
		break;
#endif
#ifndef __APPLE__
	case ID_CNFOLDSETTING:
		if(value == NULL){
			break;
		}
		UpdateCNFoldSetting(data, value);
		break;
	case ID_CNPRINTSTYLE:
		if(value == NULL){
			break;
		}
		UpdateCNPrintStyle(data, value);
		break;
	case ID_CNFOLDDETAIL:
		if(value == NULL){
			break;
		}
		UpdateCNFoldDetail(data, value);
		break;
#endif
	default:
		if(id == ID_CNJOBEXECMODE || id == ID_CNOUTPUTPARTITION ||
		   id == ID_CNSHIFTSTARTPRINTPOSITION ||
		   id == ID_CNCREEP ||
		   id == ID_CNDISPLACEMENTCORRECTION ||
		   id == ID_CNADJUSTTRIM ||
		   id == ID_CNUSESHARPNESS || id == ID_CNSHARPNESS ||
		   id == ID_CNTRIMMING ||
		   id == ID_CNSORTERFINISH ||
		   id == ID_CNUSECOLORANTDENSITY || id == ID_CNCOLORANTDENSITY ||
		   id == ID_CNCFOLDING ||
		   id == ID_CNHALFFOLDING ||
		   id == ID_CNACCORDIONZFOLDING ||
#if !defined(__APPLE__) && !defined(_OPAL)
		   id == ID_CNNUMBEROFCOLORS ||
#endif
		   id == ID_CNDOUBLEPARALLELFOLDING)
			AddUpdateOption(data, option);
		if(option == NULL || value == NULL)
			break;
#ifndef __APPLE__
		if(id == ID_CNCFOLDING ||
                   id == ID_CNHALFFOLDING ||
                   id == ID_CNACCORDIONZFOLDING ||
                   id == ID_CNDOUBLEPARALLELFOLDING ||
                   id == ID_CNZFOLDING){
                        if(!strcasecmp(value, "false"))
                                value = "None";
                }
#endif
		UpdatePPDData(data, option, value);
		break;
	}

	return NULL;
}


int CreateSaveOptions(cngplpData *data)
{
	data->save_data = (SaveOptions *)malloc(sizeof(SaveOptions));
	if(data->save_data == NULL)
		return -1;
	memset(data->save_data, 0, sizeof(SaveOptions));
	return 0;
}

void DeleteSaveOptions(cngplpData *data)
{
	if(data != NULL){
		if(data->save_data != NULL){
			free(data->save_data);
			data->save_data = NULL;
		}
	}
}

int SaveCupsOptions(cngplpData *data)
{
	CupsOptions *cups_opt = data->cups_opt;
	PropDlgValue *prop = data->save_data->prop;
	CupsOptVal *src;

	src = cups_opt->common->option;
	prop->common = (CupsOptVal *)malloc(sizeof(CupsOptVal));
	if(prop->common == NULL)
		goto err;

	memset(prop->common, 0, sizeof(CupsOptVal));
	while(1){
		AddCupsOption(prop->common, src->option, src->value);
		if(src->next == NULL)
			break;
		src = src->next;
	}

	src = cups_opt->image->option;
	prop->image = (CupsOptVal *)malloc(sizeof(CupsOptVal));
	if(prop->image == NULL)
		goto err;

	memset(prop->image, 0, sizeof(CupsOptVal));
	while(1){
		AddCupsOption(prop->image, src->option, src->value);
		if(src->next == NULL)
			break;
		src = src->next;
	}
	prop->img_reso_scale = cups_opt->image->img_reso_scale;

	src = cups_opt->text->option;
	prop->text = (CupsOptVal *)malloc(sizeof(CupsOptVal));
	if(prop->text == NULL)
		goto err;

	memset(prop->text, 0, sizeof(CupsOptVal));
	while(1){
		AddCupsOption(prop->text, src->option, src->value);
		if(src->next == NULL)
			break;
		src = src->next;
	}
	prop->margin_on = data->cups_opt->text->margin_on;

	src = cups_opt->hpgl->option;
	prop->hpgl = (CupsOptVal *)malloc(sizeof(CupsOptVal));
	if(prop->hpgl == NULL)
		goto err;

	memset(prop->hpgl, 0, sizeof(CupsOptVal));
	while(1){
		AddCupsOption(prop->hpgl, src->option, src->value);
		if(src->next == NULL)
			break;
		src = src->next;
	}
	return 0;

err:
	MemFree(prop->common);
	MemFree(prop->image);
	MemFree(prop->text);
	MemFree(prop->hpgl);
	return -1;
}

int SavePPDOptions(cngplpData *data)
{
	PPDOptions *ppd_opt = data->ppd_opt;
	PropDlgValue *prop = data->save_data->prop;
	UIItemsList *tmp;

	prop->selectby = ppd_opt->selectby;
	prop->gutter_value = ppd_opt->gutter_value;
	prop->startnum_value = ppd_opt->startnum_value;
	prop->shift_upwards = ppd_opt->shift_upwards;
	prop->shift_right = ppd_opt->shift_right;
	prop->shift_front_long = ppd_opt->shift_front_long;
	prop->shift_front_short = ppd_opt->shift_front_short;
	prop->shift_back_long = ppd_opt->shift_back_long;
	prop->shift_back_short = ppd_opt->shift_back_short;
	prop->detail_shift_upwards = ppd_opt->detail_shift_upwards;
	prop->detail_shift_right = ppd_opt->detail_shift_right;
	prop->detail_shift_front_long = ppd_opt->detail_shift_front_long;
	prop->detail_shift_front_short = ppd_opt->detail_shift_front_short;
	prop->detail_shift_back_long = ppd_opt->detail_shift_back_long;
	prop->detail_shift_back_short = ppd_opt->detail_shift_back_short;
	prop->offset_num = ppd_opt->offset_num;
	prop->guttershiftnum_value_d = ppd_opt->guttershiftnum_value_d;
	prop->tab_shift = ppd_opt->tab_shift;
	prop->ins_tab_shift = ppd_opt->ins_tab_shift;
	prop->adjust_trim_num = ppd_opt->adjust_trim_num;
	prop->adjust_frtrim_num = ppd_opt->adjust_frtrim_num;
	prop->adjust_tbtrim_num = ppd_opt->adjust_tbtrim_num;
	prop->pb_fin_fore_trim_num = ppd_opt->pb_fin_fore_trim_num;
	prop->pb_fin_topbtm_trim_num = ppd_opt->pb_fin_topbtm_trim_num;
	prop->stack_copies_num = ppd_opt->stack_copies_num;
	prop->saddle_press_adjust = ppd_opt->saddle_press_adjust;

	if(ppd_opt->special != NULL){
		prop->special = (SpecialFunc *)malloc(sizeof(SpecialFunc));
		memset(prop->special, 0, sizeof(SpecialFunc));
		memcpy(prop->special, ppd_opt->special, sizeof(SpecialFunc));
	}

	if(ppd_opt->job_note != NULL){
		prop->job_note = (JobNote *)malloc(sizeof(JobNote));
		memset(prop->job_note, 0, sizeof(JobNote));
		memcpy(prop->job_note, ppd_opt->job_note, sizeof(JobNote));
	}

	prop->cnmediabrand = cngplpGetData(data, ID_CNMEDIABRAND);
	prop->cninsertmediabrand = cngplpGetData(data, ID_CNINSERTMEDIABRAND);
	prop->cninterleafmediabrand = cngplpGetData(data, ID_CNINTERLEAFMEDIABRAND);
	prop->cnpbindcovermediabrand = cngplpGetData(data, ID_CNPBINDCOVERMEDIABRAND);

	prop->ppd_opt = (CupsOptVal *)malloc(sizeof(CupsOptVal));
	if(prop->ppd_opt == NULL){
		MemFree(prop->ppd_opt);
		return -1;
	}

	memset(prop->ppd_opt, 0, sizeof(CupsOptVal));
	tmp = ppd_opt->items_list;
	while(1){
		if(tmp->current_option != NULL){
			AddCupsOption(prop->ppd_opt, tmp->name, tmp->current_option->name);
		}
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
	}

	return 0;
}

void RestoreCupsOptions(cngplpData *data)
{
	CupsOptions *cups_opt = data->cups_opt;
	PropDlgValue *prop = data->save_data->prop;
	CupsOptVal *src, *dest;

	dest = cups_opt->common->option;
	src = prop->common;
	while(1){
		SetCupsOption(data, dest, src->option, src->value);
		if(src->next == NULL)
			break;
		src = src->next;
	}

	dest = cups_opt->image->option;
	src = prop->image;
	while(1){
		SetCupsOption(data, dest, src->option, src->value);
		if(src->next == NULL)
			break;
		src = src->next;
	}
	cups_opt->image->img_reso_scale = prop->img_reso_scale;

	dest = cups_opt->text->option;
	src = prop->text;
	while(1){
		SetCupsOption(data, dest, src->option, src->value);
		if(src->next == NULL)
			break;
		src = src->next;
	}
	cups_opt->text->margin_on = prop->margin_on;

	dest = cups_opt->hpgl->option;
	src = prop->hpgl;
	while(1){
		SetCupsOption(data, dest, src->option, src->value);
		if(src->next == NULL)
			break;
		src = src->next;
	}
}

void RestorePPDOptions(cngplpData *data)
{
	PPDOptions *ppd_opt = data->ppd_opt;
	PropDlgValue *prop = data->save_data->prop;
	CupsOptVal *src = prop->ppd_opt ;

	ppd_opt->selectby = prop->selectby;
	ppd_opt->gutter_value = prop->gutter_value;
	ppd_opt->startnum_value = prop->startnum_value;
	ppd_opt->shift_upwards = prop->shift_upwards;
	ppd_opt->shift_right = prop->shift_right;
	ppd_opt->shift_front_long = prop->shift_front_long;
	ppd_opt->shift_front_short = prop->shift_front_short;
	ppd_opt->shift_back_long = prop->shift_back_long;
	ppd_opt->shift_back_short = prop->shift_back_short;
	ppd_opt->detail_shift_upwards = prop->detail_shift_upwards;
	ppd_opt->detail_shift_right = prop->detail_shift_right;
	ppd_opt->detail_shift_front_long = prop->detail_shift_front_long;
	ppd_opt->detail_shift_front_short = prop->detail_shift_front_short;
	ppd_opt->detail_shift_back_long = prop->detail_shift_back_long;
	ppd_opt->detail_shift_back_short = prop->detail_shift_back_short;
	ppd_opt->offset_num = prop->offset_num;
	ppd_opt->guttershiftnum_value_d = prop->guttershiftnum_value_d;
	ppd_opt->tab_shift = prop->tab_shift;
	ppd_opt->ins_tab_shift = prop->ins_tab_shift;
	ppd_opt->adjust_trim_num = prop->adjust_trim_num;
	ppd_opt->adjust_frtrim_num = prop->adjust_frtrim_num;
	ppd_opt->adjust_tbtrim_num = prop->adjust_tbtrim_num;
	ppd_opt->pb_fin_fore_trim_num = prop->pb_fin_fore_trim_num;
	ppd_opt->pb_fin_topbtm_trim_num = prop->pb_fin_topbtm_trim_num;
	ppd_opt->stack_copies_num = prop->stack_copies_num;
	ppd_opt->saddle_press_adjust = prop->saddle_press_adjust;

	if(ppd_opt->special != NULL)
		memcpy(ppd_opt->special, prop->special, sizeof(SpecialFunc));

	if(ppd_opt->job_note != NULL)
		memcpy(ppd_opt->job_note, prop->job_note, sizeof(JobNote));

	if(prop->cnmediabrand != NULL)
		SetDataPPD(data, ID_CNMEDIABRAND, prop->cnmediabrand);
	if(prop->cninsertmediabrand != NULL)
		SetDataPPD(data, ID_CNINSERTMEDIABRAND, prop->cninsertmediabrand);
	if(prop->cninterleafmediabrand != NULL)
		SetDataPPD(data, ID_CNINTERLEAFMEDIABRAND, prop->cninterleafmediabrand);
	if(prop->cnpbindcovermediabrand != NULL)
		SetDataPPD(data, ID_CNPBINDCOVERMEDIABRAND, prop->cnpbindcovermediabrand);

	while(1){
		UpdatePPDDataForCancel(data, src->option, src->value);
		if(src->next == NULL)
			break;
		src = src->next;
	}
	RemarkOptValue(data, "BindEdge");
	RemarkOptValue(data, "");
}

void FreePropSaveData(cngplpData *data)
{
	if(data->save_data->prop != NULL){
		FreeCupsOptVal(data->save_data->prop->ppd_opt);
		data->save_data->prop->ppd_opt = NULL;
		FreeCupsOptVal(data->save_data->prop->common);
		data->save_data->prop->common = NULL;
		FreeCupsOptVal(data->save_data->prop->text);
		data->save_data->prop->text = NULL;
		FreeCupsOptVal(data->save_data->prop->image);
		data->save_data->prop->image = NULL;
		FreeCupsOptVal(data->save_data->prop->hpgl);
		data->save_data->prop->hpgl = NULL;
		MemFree(data->save_data->prop->special);
		data->save_data->prop->special = NULL;
		MemFree(data->save_data->prop->job_note);
		data->save_data->prop->job_note = NULL;
		MemFree(data->save_data->prop->cnmediabrand);
		data->save_data->prop->cnmediabrand = NULL;
		MemFree(data->save_data->prop->cninsertmediabrand);
		data->save_data->prop->cninsertmediabrand = NULL;
		MemFree(data->save_data->prop->cninterleafmediabrand);
		data->save_data->prop->cninterleafmediabrand = NULL;
		MemFree(data->save_data->prop->cnpbindcovermediabrand);
		data->save_data->prop->cnpbindcovermediabrand = NULL;
		MemFree(data->save_data->prop);
		data->save_data->prop = NULL;
		memset(data->save_data, 0, sizeof(SaveOptions));
	}
}

void SavePropData(cngplpData *data)
{
	data->save_data->prop = (PropDlgValue *)malloc(sizeof(PropDlgValue));
	if(data->save_data->prop == NULL)
		return;

	memset(data->save_data->prop, 0, sizeof(PropDlgValue));

	SaveCupsOptions(data);
	SavePPDOptions(data);

	data->save_data->showdlg_flag = PROP_DLG;
}

void RestorePropData(cngplpData *data)
{
	if(data->save_data->prop != NULL){
		RestoreCupsOptions(data);
		RestorePPDOptions(data);
		FreePropSaveData(data);
	}
}

void RestoreDefaultData(cngplpData *data)
{
	PropDlgValue *prop = data->save_data->prop;
	CupsOptVal *src = prop->ppd_opt;

	data->ppd_opt->gutter_value = 0;
	data->ppd_opt->gutter_value_d = 0.0;
	data->ppd_opt->startnum_value = 1;

	data->ppd_opt->guttershiftnum_value_d = 0.0;
	data->ppd_opt->tab_shift = 12.7;
	data->ppd_opt->ins_tab_shift = 12.7;
	InitAdjustTrimm(data->ppd_opt);
	data->ppd_opt->stack_copies_num = 1;
	data->ppd_opt->shift_right = 0;
	data->ppd_opt->detail_shift_right = 0.0;
	data->ppd_opt->shift_upwards = 0;
	data->ppd_opt->detail_shift_upwards = 0.0;
	data->ppd_opt->shift_front_long = 0;
	data->ppd_opt->shift_front_short = 0;
	data->ppd_opt->shift_back_long = 0;
	data->ppd_opt->shift_back_short = 0;
	data->ppd_opt->detail_shift_front_long = 0.0;
	data->ppd_opt->detail_shift_front_short = 0.0;
	data->ppd_opt->detail_shift_back_long = 0.0;
	data->ppd_opt->detail_shift_back_short = 0.0;
	data->ppd_opt->offset_num = 1;

	while(1){
		UpdatePPDDataForDefault(data, src->option);
		if(src->next == NULL)
			break;
		src = src->next;
	}

	ResetCupsOptions(data);
	RemarkOptValue(data, "BindEdge");
	RemarkOptValue(data, "");
	if(data->ppd_opt->selectby)
		data->ppd_opt->selectby = SELECTBY_INPUTSLOT;

}

void FreeBookletSaveData(cngplpData *data)
{
	if(data->save_data->booklet != NULL){
		data->save_data->showdlg_flag = PROP_DLG;
		MemFree(data->save_data->booklet->value);
		data->save_data->booklet->value = NULL;
		MemFree(data->save_data->booklet->creep_val);
		data->save_data->booklet->creep_val = NULL;
		MemFree(data->save_data->booklet->correction_val);
		data->save_data->booklet->correction_val = NULL;
		MemFree(data->save_data->booklet);
		data->save_data->booklet = NULL;
	}
}

void SaveBookletData(cngplpData *data)
{
	char *value;
	char *creep_val;
	char *correction_val;

	value = FindCurrOpt(data->ppd_opt->items_list, "Booklet");
	if(value != NULL){
		data->save_data->booklet = (BookletDlgValue *)malloc(sizeof(BookletDlgValue));
		if(data->save_data->booklet == NULL)
			return;

		memset(data->save_data->booklet, 0, sizeof(BookletDlgValue));
		data->save_data->showdlg_flag = BOOKLET_DLG;
		data->save_data->booklet->value = strdup(value);
		data->save_data->booklet->gutter_shift_num_d = data->ppd_opt->guttershiftnum_value_d;
		creep_val = FindCurrOpt(data->ppd_opt->items_list, "CNCreep");
		correction_val = FindCurrOpt(data->ppd_opt->items_list, "CNDisplacementCorrection");
		if(creep_val != NULL && correction_val != NULL){
			data->save_data->booklet->creep_val = strdup(creep_val);
			data->save_data->booklet->correction_val = strdup(correction_val);
		}
	}
}

void RestoreBookletData(cngplpData *data)
{
	if(data->save_data->booklet && data->save_data->booklet->value){
		UpdatePPDDataForCancel(data, "Booklet", data->save_data->booklet->value);
		if(data->save_data->booklet->creep_val != NULL && data->save_data->booklet->correction_val != NULL){
			UpdatePPDDataForCancel(data, "CNCreep", data->save_data->booklet->creep_val);
			UpdatePPDDataForCancel(data, "CNDisplacementCorrection", data->save_data->booklet->correction_val);
		}
		RemarkOptValue(data, "");
	}
    if(data->save_data->booklet != NULL){
        data->ppd_opt->guttershiftnum_value_d = data->save_data->booklet->gutter_shift_num_d;
    }
	FreeBookletSaveData(data);
}

void FreeGutterSaveData(cngplpData *data)
{
	if(data->save_data->gutter != NULL){
		data->save_data->showdlg_flag = PROP_DLG;
		MemFree(data->save_data->gutter);
		data->save_data->gutter = NULL;
	}
}

void SaveGutterData(cngplpData *data)
{
	data->save_data->gutter = (GutterDlgValue *)malloc(sizeof(GutterDlgValue));
	if(data->save_data->gutter == NULL)
		return;

	data->save_data->gutter->value = data->ppd_opt->gutter_value;
	data->save_data->gutter->value_d = data->ppd_opt->gutter_value_d;
	data->save_data->showdlg_flag = GUTTER_DLG;
}

void RestoreGutterData(cngplpData *data)
{
	if(data->save_data->gutter != NULL){
		data->ppd_opt->gutter_value = data->save_data->gutter->value;
		data->ppd_opt->gutter_value_d = data->save_data->gutter->value_d;
	}
	FreeGutterSaveData(data);
}

void FreeFinDetailSaveData(cngplpData *data)
{
	if(data->save_data->fin != NULL){
		MemFree(data->save_data->fin->fix);
		data->save_data->fin->fix = NULL;
		MemFree(data->save_data->fin->correction);
		data->save_data->fin->correction = NULL;
		MemFree(data->save_data->fin->smooth);
		data->save_data->fin->smooth = NULL;
		MemFree(data->save_data->fin->back);
		data->save_data->fin->back = NULL;
		MemFree(data->save_data->fin->rotate);
		data->save_data->fin->rotate = NULL;
		MemFree(data->save_data->fin->detect);
		data->save_data->fin->detect = NULL;
		MemFree(data->save_data->fin->skip);
		data->save_data->fin->skip = NULL;
		MemFree(data->save_data->fin->job_note);
		data->save_data->fin->job_note = NULL;
		MemFree(data->save_data->fin->copy_start_num_val);
		data->save_data->fin->copy_start_num_val = NULL;
		MemFree(data->save_data->fin->trust_print_val);
		data->save_data->fin->trust_print_val = NULL;
		MemFree(data->save_data->fin->postcard);
		data->save_data->fin->postcard = NULL;
		MemFree(data->save_data->fin->wrinkles);
		data->save_data->fin->wrinkles = NULL;

		MemFree(data->save_data->fin);
		data->save_data->fin = NULL;
		data->save_data->showdlg_flag = PROP_DLG;
	}
}

void SaveFinDetailData(cngplpData *data)
{
	char *value;

	data->save_data->fin = (FinDetailDlgValue *)malloc(sizeof(FinDetailDlgValue));
	if(data->save_data->fin == NULL)
		return;

	memset(data->save_data->fin, 0, sizeof(FinDetailDlgValue));

	value = FindCurrOpt(data->ppd_opt->items_list, "CNFixingMode");
	if(value != NULL)
		data->save_data->fin->fix = strdup(value);

	value = FindCurrOpt(data->ppd_opt->items_list, "CNCurlCorrection");
	if(value != NULL)
		data->save_data->fin->correction = strdup(value);

	value = FindCurrOpt(data->ppd_opt->items_list, "CNSuperSmooth");
	if(value != NULL)
		data->save_data->fin->smooth = strdup(value);

	value = FindCurrOpt(data->ppd_opt->items_list, "CNBackPaperPrint");
	if(value != NULL)
		data->save_data->fin->back = strdup(value);

	value = FindCurrOpt(data->ppd_opt->items_list, "CNRotatePrint");
	if(value != NULL)
		data->save_data->fin->rotate = strdup(value);

	value = FindCurrOpt(data->ppd_opt->items_list, "CNSkipBlank");
	if(value != NULL)
		data->save_data->fin->skip = strdup(value);

	value = FindCurrOpt(data->ppd_opt->items_list, "CNDetectPaperSize");
	if(value != NULL)
		data->save_data->fin->detect = strdup(value);
	if(data->ppd_opt->job_note != NULL){
		data->save_data->fin->job_note = (JobNote *)malloc(sizeof(JobNote));
		memset(data->save_data->fin->job_note, 0, sizeof(JobNote));
		memcpy(data->save_data->fin->job_note, data->ppd_opt->job_note, sizeof(JobNote));
	}
	value = FindCurrOpt(data->ppd_opt->items_list, "CNCopySetNumbering");
	if(value != NULL)
		data->save_data->fin->copy_start_num_val = strdup(value);
	data->save_data->fin->start_num = data->ppd_opt->startnum_value;
	value = FindCurrOpt(data->ppd_opt->items_list, "CNTrustPrint");
	if(value != NULL)
		data->save_data->fin->trust_print_val = strdup(value);
	data->save_data->showdlg_flag = FINDETAIL_DLG;
	value = FindCurrOpt(data->ppd_opt->items_list, "CNRevicePostcard");
	if(value != NULL)
		data->save_data->fin->postcard = strdup(value);
	value = FindCurrOpt(data->ppd_opt->items_list, kPPD_Items_CNWrinklesCorrectionOutput);
	if(value != NULL)
		data->save_data->fin->wrinkles = strdup(value);
}

void RestoreFinDetailData(cngplpData *data)
{
	if(data->save_data->fin != NULL){
		char *value;
		value = data->save_data->fin->fix;
		if(value != NULL)
			UpdatePPDDataForCancel(data, "CNFixingMode", value);

		value = data->save_data->fin->correction;
		if(value != NULL)
			UpdatePPDDataForCancel(data, "CNCurlCorrection", value);

		value = data->save_data->fin->smooth;
		if(value != NULL)
			UpdatePPDDataForCancel(data, "CNSuperSmooth", value);

		value = data->save_data->fin->back;
		if(value != NULL)
			UpdatePPDDataForCancel(data, "CNBackPaperPrint", value);

		value = data->save_data->fin->rotate;
		if(value != NULL)
			UpdatePPDDataForCancel(data, "CNRotatePrint", value);

		value = data->save_data->fin->skip;
		if(value != NULL)
			UpdatePPDDataForCancel(data, "CNSkipBlank", value);

		value = data->save_data->fin->detect;
		if(value != NULL)
			UpdatePPDDataForCancel(data, "CNDetectPaperSize", value);
		if(data->save_data->fin->job_note != NULL)
			memcpy(data->ppd_opt->job_note, data->save_data->fin->job_note, sizeof(JobNote));
		data->ppd_opt->startnum_value = data->save_data->fin->start_num;
		value = data->save_data->fin->copy_start_num_val;
		if(value != NULL)
			UpdatePPDDataForCancel(data, "CNCopySetNumbering", value);
		value = data->save_data->fin->trust_print_val;
		if(value != NULL)
			UpdatePPDDataForCancel(data, "CNTrustPrint", value);
		value = data->save_data->fin->postcard;
		if(value != NULL)
			UpdatePPDData(data, "CNRevicePostcard", value);
		value = data->save_data->fin->wrinkles;
		if(value != NULL){
			UpdatePPDData(data, kPPD_Items_CNWrinklesCorrectionOutput, value);
		}

		RemarkOptValue(data, "");
	}
	FreeFinDetailSaveData(data);
}

void FreeSecuredSaveData(cngplpData *data)
{
	if(data->save_data->secured != NULL){
		MemFree(data->save_data->secured);
		data->save_data->secured = NULL;
		data->save_data->showdlg_flag = PROP_DLG;
	}
}

void SaveSecuredData(cngplpData *data)
{
	SpecialFunc *special = data->ppd_opt->special;

	if(special == NULL)
		return;

	data->save_data->secured = (SecuredDlgValue *)malloc(sizeof(SecuredDlgValue));
	if(data->save_data->secured == NULL)
		return;

	memset(data->save_data->secured, 0, sizeof(SecuredDlgValue));

	strncpy(data->save_data->secured->doc, special->doc_name, 127);
	strncpy(data->save_data->secured->usr, special->usr_name, 127);
	strncpy(data->save_data->secured->pass, special->passwd_array, 7);

	data->save_data->showdlg_flag = SECURED_DLG;
}

void RestoreSecuredData(cngplpData *data)
{
	SecuredDlgValue *secured = data->save_data->secured;
	SpecialFunc *special = data->ppd_opt->special;
	if(secured == NULL || special == NULL)
		return;

	memset(special->doc_name, 0, 128);
	memset(special->usr_name, 0, 128);
	memset(special->passwd_array, 0, 8);

	strncpy(special->doc_name, secured->doc, 127);
	strncpy(special->usr_name, secured->usr, 127);
	strncpy(special->passwd_array, secured->pass, 7);

	FreeSecuredSaveData(data);
}

void FreeJobAccountSaveData(cngplpData *data)
{
	if(data->save_data->job != NULL){
		MemFree(data->save_data->job);
		data->save_data->job = NULL;
		data->save_data->showdlg_flag = PROP_DLG;
	}
}

void SaveJobAccountData(cngplpData *data)
{
	SpecialFunc *special = data->ppd_opt->special;

	if(special == NULL)
		return;

	data->save_data->job = (JobAccountDlgValue *)malloc(sizeof(JobAccountDlgValue));
	if(data->save_data->job == NULL)
		return;

	memset(data->save_data->job, 0, sizeof(JobAccountDlgValue));

	strncpy(data->save_data->job->id, special->job_account_id, 9);
	strncpy(data->save_data->job->ps, special->job_account_passwd, 7);

	data->save_data->showdlg_flag = JOBACCOUNT_DLG;
}

void RestoreJobAccountData(cngplpData *data)
{
	JobAccountDlgValue *job = data->save_data->job;
	SpecialFunc *special = data->ppd_opt->special;
	if(job == NULL || special == NULL)
		return;

	memset(special->job_account_id, 0, 12);
	memset(special->job_account_passwd, 0, 8);

	strncpy(special->job_account_id, job->id, 9);
	strncpy(special->job_account_passwd, job->ps, 7);

	FreeJobAccountSaveData(data);
}

void FreeBoxidSaveData(cngplpData *data)
{
	if(data->save_data->boxid != NULL){
		MemFree(data->save_data->boxid);
		data->save_data->boxid = NULL;
		data->save_data->showdlg_flag = PROP_DLG;
	}
}

void SaveBoxidData(cngplpData *data)
{
	SpecialFunc *special = data->ppd_opt->special;

	if(special == NULL)
		return;

	data->save_data->boxid = (BoxidDlgValue *)malloc(sizeof(BoxidDlgValue));
	if(data->save_data->boxid == NULL)
		return;

	memset(data->save_data->boxid, 0, sizeof(BoxidDlgValue));

	strncpy(data->save_data->boxid->enter_name, special->enter_name, 127);
	data->save_data->boxid->data_name = special->data_name;
#ifndef __APPLE__
	data->save_data->boxid->box_num = special->box_num;
#else
	strncpy(data->save_data->boxid->box_num, special->box_num, 511);
#endif

	data->save_data->showdlg_flag = BOXID_DLG;
}

void RestoreBoxidData(cngplpData *data)
{
	BoxidDlgValue *boxid = data->save_data->boxid;
	SpecialFunc *special = data->ppd_opt->special;
	if(boxid == NULL || special == NULL)
		return;

	memset(special->enter_name, 0, 128);
	strncpy(special->enter_name, boxid->enter_name, 127);
	special->data_name = boxid->data_name;
#ifndef __APPLE__
	special->box_num = boxid->box_num;
#else
	strncpy(special->box_num, boxid->box_num, 511);
#endif

	FreeBoxidSaveData(data);
}

void FreeProfileSaveData(cngplpData *data)
{
	if(data->save_data->prof != NULL){
		FreeCupsOptVal(data->save_data->prof->ppd_opt);
		data->save_data->prof->ppd_opt = NULL;
		MemFree(data->save_data->prof);
		data->save_data->prof = NULL;
		data->save_data->showdlg_flag = PROP_DLG;
	}
}

void SaveProfileData(cngplpData *data)
{
	ProfDlgValue *prof;
	PPDOptions *ppd_opt = data->ppd_opt;
	UIItemsList *tmp;

	data->save_data->prof = (ProfDlgValue *)malloc(sizeof(ProfDlgValue));
	if(data->save_data->prof == NULL)
		return;

	memset(data->save_data->prof, 0, sizeof(ProfDlgValue));

	prof = data->save_data->prof;
	prof->ppd_opt = (CupsOptVal *)malloc(sizeof(CupsOptVal));
	if(prof->ppd_opt == NULL){
		MemFree(prof->ppd_opt);
		return;
	}

	memset(prof->ppd_opt, 0, sizeof(CupsOptVal));
	tmp = ppd_opt->items_list;
	while(1){
		if(tmp->current_option != NULL){
			AddCupsOption(prof->ppd_opt, tmp->name, tmp->current_option->name);
		}
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
	}

	data->save_data->showdlg_flag = PROFILE_DLG;
}

void RestoreProfileData(cngplpData *data)
{
	CupsOptVal *src = NULL;

	if(data->save_data->prof == NULL)
		return;

	src = data->save_data->prof->ppd_opt ;
	while(1){
		UpdatePPDDataForCancel(data, src->option, src->value);
		if(src->next == NULL)
			break;
		src = src->next;
	}
	RemarkOptValue(data, "");

	FreeProfileSaveData(data);
}

void FreeFrontBackCvrSaveData(cngplpData *data)
{
	if(data->save_data->ftbkcvr != NULL){
		FreeCupsOptVal(data->save_data->ftbkcvr->ppd_opt);
		data->save_data->ftbkcvr->ppd_opt = NULL;
		MemFree(data->save_data->ftbkcvr);
		data->save_data->ftbkcvr = NULL;
		data->save_data->showdlg_flag = PROP_DLG;
	}
}

void SaveFrontBackCvrData(cngplpData *data)
{
	FrontBackCvrDlgValue *ftbkcvr;
	PPDOptions *ppd_opt = data->ppd_opt;
	UIItemsList *tmp;

	data->save_data->ftbkcvr = (FrontBackCvrDlgValue *)malloc(sizeof(FrontBackCvrDlgValue));
	if(data->save_data->ftbkcvr == NULL)
		return;

	memset(data->save_data->ftbkcvr, 0, sizeof(FrontBackCvrDlgValue));

	ftbkcvr = data->save_data->ftbkcvr;
	ftbkcvr->ppd_opt = (CupsOptVal *)malloc(sizeof(CupsOptVal));
	if(ftbkcvr->ppd_opt == NULL){
		MemFree(ftbkcvr->ppd_opt);
		return;
	}

	memset(ftbkcvr->ppd_opt, 0, sizeof(CupsOptVal));
	tmp = ppd_opt->items_list;
	while(1){
		if(tmp->current_option != NULL){
			AddCupsOption(ftbkcvr->ppd_opt, tmp->name, tmp->current_option->name);
		}
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
	}

	data->save_data->showdlg_flag = FRONTBACKCVR_DLG;
}

void RestoreFrontBackCvrData(cngplpData *data)
{
	CupsOptVal *src = NULL;

	if(data->save_data->ftbkcvr == NULL)
		return;

	src = data->save_data->ftbkcvr->ppd_opt ;
	while(1){
		UpdatePPDDataForCancel(data, src->option, src->value);
		if(src->next == NULL)
			break;
		src = src->next;
	}
	RemarkOptValue(data, "");

	FreeFrontBackCvrSaveData(data);
}
void FreeHoldQueueSaveData(cngplpData *data)
{
	if(data->save_data->holdqueue != NULL){
		MemFree(data->save_data->holdqueue);
		data->save_data->holdqueue = NULL;
		data->save_data->showdlg_flag = PROP_DLG;
	}
}
void SaveHoldQueueData(cngplpData *data)
{
	SpecialFunc *special_func = data->ppd_opt->special;

	if(special_func == NULL)
		return;

	data->save_data->holdqueue = (HoldQueueDlgValue*)malloc(sizeof(HoldQueueDlgValue));
	if(data->save_data->holdqueue == NULL)
		return;

	memset(data->save_data->holdqueue, 0, sizeof(HoldQueueDlgValue));
	strncpy(data->save_data->holdqueue->enter_name, special_func->hold_name, 127);
	data->save_data->holdqueue->data_name_type = special_func->holddata_name;
	data->save_data->showdlg_flag = HOLDQUEUE_DLG;
}

void RestoreHoldQueueData(cngplpData *data)
{
	HoldQueueDlgValue *hold_queue = data->save_data->holdqueue;
	SpecialFunc *special_func = data->ppd_opt->special;
	if(hold_queue == NULL || special_func  == NULL)
		return;

	memset(special_func->hold_name, 0, 128);
	strncpy(special_func->hold_name, hold_queue->enter_name, 127);
	special_func->holddata_name = hold_queue->data_name_type;

	FreeHoldQueueSaveData(data);
}

void FreeAdvancedSettingsSaveData(cngplpData *data)
{
	if(data->save_data->advsettings != NULL){
		MemFree(data->save_data->advsettings->shift_position_val);
		data->save_data->advsettings->shift_position_val = NULL;
		MemFree(data->save_data->advsettings);
		data->save_data->advsettings = NULL;
		data->save_data->showdlg_flag = PROP_DLG;
	}
}

void SaveAdvancedSettingsData(cngplpData *data)
{
	char *shift_position_val = NULL;

	shift_position_val = FindCurrOpt(data->ppd_opt->items_list, "CNShiftStartPrintPosition");
	if(shift_position_val != NULL){
		data->save_data->advsettings = (AdvancedSettingsDlgValue *)malloc(sizeof(AdvancedSettingsDlgValue));
		if(data->save_data->advsettings == NULL)
			return;
		memset(data->save_data->advsettings, 0, sizeof(AdvancedSettingsDlgValue));
		data->save_data->advsettings->shift_position_val = strdup(shift_position_val);
		data->save_data->advsettings->shift_front_long = data->ppd_opt->shift_front_long;
		data->save_data->advsettings->shift_front_short = data->ppd_opt->shift_front_short;
		data->save_data->advsettings->shift_back_long = data->ppd_opt->shift_back_long;
		data->save_data->advsettings->shift_back_short = data->ppd_opt->shift_back_short;
		data->save_data->advsettings->detail_shift_front_long = data->ppd_opt->detail_shift_front_long;
		data->save_data->advsettings->detail_shift_front_short = data->ppd_opt->detail_shift_front_short;
		data->save_data->advsettings->detail_shift_back_long = data->ppd_opt->detail_shift_back_long;
		data->save_data->advsettings->detail_shift_back_short = data->ppd_opt->detail_shift_back_short;

		data->save_data->showdlg_flag = ADVANCEDSETTINGS_DLG;
	}
}

void RestoreAdvancedSettingsData(cngplpData *data)
{
	if(data->save_data->advsettings != NULL && data->save_data->advsettings->shift_position_val != NULL){
		UpdatePPDDataForCancel(data, "CNShiftStartPrintPosition", data->save_data->advsettings->shift_position_val);
		data->ppd_opt->shift_front_long = data->save_data->advsettings->shift_front_long;

		data->ppd_opt->shift_front_short = data->save_data->advsettings->shift_front_short;
		data->ppd_opt->shift_back_long = data->save_data->advsettings->shift_back_long;
		data->ppd_opt->shift_back_short = data->save_data->advsettings->shift_back_short;
		data->ppd_opt->detail_shift_front_long = data->save_data->advsettings->detail_shift_front_long;
		data->ppd_opt->detail_shift_front_short = data->save_data->advsettings->detail_shift_front_short;
		data->ppd_opt->detail_shift_back_long = data->save_data->advsettings->detail_shift_back_long;
		data->ppd_opt->detail_shift_back_short = data->save_data->advsettings->detail_shift_back_short;
		RemarkOptValue(data, "");
	}
	FreeAdvancedSettingsSaveData(data);
}
void BottomEvent(cngplpData *data, int id, char *value)
{

	switch(id){
	case ID_SETDEFAULT:
		exec_set_def_printer(data);
		break;
	case ID_EXECLPR:
		if(value == NULL)
			break;
		if(strcasecmp(value, "Print") == 0)
			exec_lpr(data, 1);
		else if(strcmp(value, "Save") == 0)
			exec_lpr(data, 0);
		break;
	case ID_SHOWDLG:
		if(value == NULL)
			break;
		if(strcasecmp(value, "Prop") == 0)
			SavePropData(data);
		else if(strcasecmp(value, "Booklet") == 0)
			SaveBookletData(data);
		else if(strcasecmp(value, "Gutter")  == 0)
			SaveGutterData(data);
		else if(strcasecmp(value, "FinDetail") == 0)
			SaveFinDetailData(data);
		else if(strcasecmp(value, "Secured") == 0)
			SaveSecuredData(data);
		else if(strcasecmp(value, "JobAccount") == 0)
			SaveJobAccountData(data);
		else if(strcasecmp(value, "Boxid") == 0)
			SaveBoxidData(data);
		else if(strcasecmp(value, "Profile") == 0)
			SaveProfileData(data);
		else if(strcasecmp(value, "FrontBackCvr") == 0)
			SaveFrontBackCvrData(data);
		else if(strcasecmp(value, "HoldQueue") ==  0)
			SaveHoldQueueData(data);
		else if(strcasecmp(value,"Settings") == 0)
			SaveAdvancedSettingsData(data);
		break;
	case ID_OK:
		if(value == NULL)
			break;
		if(strcasecmp(value, "Prop") == 0)
			FreePropSaveData(data);
		else if(strcasecmp(value, "Booklet") == 0)
			FreeBookletSaveData(data);
		else if(strcasecmp(value, "Gutter")  == 0)
			FreeGutterSaveData(data);
		else if(strcasecmp(value, "FinDetail") == 0)
			FreeFinDetailSaveData(data);
		else if(strcasecmp(value, "JobAccount") == 0)
			FreeJobAccountSaveData(data);
		else if(strcasecmp(value, "Secured") == 0)
			FreeSecuredSaveData(data);
		else if(strcasecmp(value, "Boxid") == 0)
			FreeBoxidSaveData(data);
		else if(strcasecmp(value, "Profile") == 0)
			FreeProfileSaveData(data);
		else if(strcasecmp(value, "FrontBackCvr") == 0)
			FreeFrontBackCvrSaveData(data);
		else if(strcasecmp(value, "HoldQueue") == 0)
			FreeHoldQueueSaveData(data);
		else if(strcasecmp(value,"Settings") == 0)
			FreeAdvancedSettingsSaveData(data);
		break;
	case ID_CANCEL:
		if(value == NULL)
			break;
		if(strcasecmp(value, "Prop") == 0)
			RestorePropData(data);
		else if(strcasecmp(value, "Booklet") == 0)
			RestoreBookletData(data);
		else if(strcasecmp(value, "Gutter")  == 0)
			RestoreGutterData(data);
		else if(strcasecmp(value, "FinDetail") == 0)
			RestoreFinDetailData(data);
		else if(strcasecmp(value, "Secured") == 0)
			RestoreSecuredData(data);
		else if(strcasecmp(value, "JobAccount") == 0)
			RestoreJobAccountData(data);
		else if(strcasecmp(value, "Boxid") == 0)
			RestoreBoxidData(data);
		else if(strcasecmp(value, "Profile") == 0)
			RestoreProfileData(data);
		else if(strcasecmp(value, "FrontBackCvr") == 0)
			RestoreFrontBackCvrData(data);
		else if(strcasecmp(value, "HoldQueue") == 0)
			RestoreHoldQueueData(data);
		else if(strcasecmp(value,"Settings") == 0)
			RestoreAdvancedSettingsData(data);
		break;
	case ID_RESTOREDEFAULT:
		RestoreDefaultData(data);
		break;
	case ID_PRINTERINFO:
		break;
	}
}



static void UpdateDuplex(cngplpData *data, int flag)
{
	int type = data->ppd_opt->duplex_valtype;

	switch(type){
	case DUPLEX_VALTYPE_TRUE:
	default:
		if(flag){
			UpdatePPDData(data, "Duplex", "True");
		}else{
			UpdatePPDData(data, "Duplex", "False");
		}
		break;
	case DUPLEX_VALTYPE_TUMBLE:
		if(flag){
			UIItemsList *list = data->ppd_opt->items_list;
			char *bind = NULL;
			if((bind = FindCurrOpt(list, "BindEdge")) != NULL){
				if(strncmp(bind, "Top", strlen(bind)) == 0
				|| strncmp(bind, "Bottom", strlen(bind)) == 0){
					UpdatePPDData(data, "Duplex", "DuplexTumble");
				}else{
					UpdatePPDData(data, "Duplex", "DuplexNoTumble");
				}
			}
		}else{
			UpdatePPDData(data, "Duplex", "None");
		}
		break;
	}
}

static void UpdateBindEdge(cngplpData *data, char *value)
{
	int type = data->ppd_opt->duplex_valtype;

	switch(type){
	case DUPLEX_VALTYPE_TRUE:
	default:
		UpdatePPDData(data, "BindEdge", value);
		break;
	case DUPLEX_VALTYPE_TUMBLE:
		{
			UIItemsList *list = data->ppd_opt->items_list;
			char *dplx = NULL;
			char *stpl = NULL;
			dplx = FindCurrOpt(list, "Duplex");
			stpl = FindCurrOpt(list, "StapleLocation");
			UpdatePPDData(data, "StapleLocation", "None");
			UpdatePPDData(data, "BindEdge", value);

			if(stpl != NULL
			&& strncmp(stpl, "None", strlen(stpl)) != 0){
				UpdateEnableData(data, "StapleLocation", 1);
			}

			if(dplx != NULL
			&& strncmp(dplx, "None", strlen(dplx)) != 0){
				if(strncmp(value, "Top", strlen(value)) == 0
				|| strncmp(value, "Bottom", strlen(value)) == 0){
					UpdatePPDData(data, "Duplex", "DuplexTumble");
				}else if(strncmp(value, "Left", strlen(value)) == 0
				|| strncmp(value, "Right", strlen(value)) == 0){
					UpdatePPDData(data, "Duplex", "DuplexNoTumble");
				}
			}
		}
		break;
	}
}

#ifndef __APPLE__
static void UpdateCNSaddleSetting(cngplpData *data, char *value)
{
	if(strcasecmp(value, "Fold Only") == 0){
		UpdatePPDData(data, kPPD_Items_CNVfolding, "True");
		UpdatePPDData(data, kPPD_Items_CNSaddleStitch, "False");
#if !defined(__APPLE__) && !defined(_OPAL)
		UpdatePPDData(data, kPPD_Items_CNVfoldingTrimming, "False");
#endif
		UpdatePPDData(data, kPPD_Items_CNTrimming, "False");
	}else if(strcasecmp(value, "Fold + Saddle Stitch") == 0){
		UpdatePPDData(data, kPPD_Items_CNVfolding, "True");
		UpdatePPDData(data, kPPD_Items_CNSaddleStitch, "True");
#if !defined(__APPLE__) && !defined(_OPAL)
		UpdatePPDData(data, kPPD_Items_CNVfoldingTrimming, "False");
#endif
		UpdatePPDData(data, kPPD_Items_CNTrimming, "False");
#if !defined(__APPLE__) && !defined(_OPAL)
	}else if(strcasecmp(value, "Fold + Trim") == 0){
		UpdatePPDData(data, kPPD_Items_CNVfolding, "True");
		UpdatePPDData(data, kPPD_Items_CNSaddleStitch, "False");
		UpdatePPDData(data, kPPD_Items_CNVfoldingTrimming, "True");
		UpdatePPDData(data, kPPD_Items_CNTrimming, "True");
#endif
	}else if(strcasecmp(value, "Fold + Saddle Stitch + Trim") == 0){
		UpdatePPDData(data, kPPD_Items_CNVfolding, "True");
		UpdatePPDData(data, kPPD_Items_CNSaddleStitch, "True");
#if !defined(__APPLE__) && !defined(_OPAL)
		UpdatePPDData(data, kPPD_Items_CNVfoldingTrimming, "False");
#endif
		UpdatePPDData(data, kPPD_Items_CNTrimming, "True");
	}else if(strcasecmp(value, "Saddle Stitch") == 0){
		UpdatePPDData(data, kPPD_Items_CNSaddleStitch, "True");
		UpdatePPDData(data, kPPD_Items_CNTrimming, "False");
	}else if(strcasecmp(value, "Saddle Stitch + Trim") == 0){
		UpdatePPDData(data, kPPD_Items_CNSaddleStitch, "True");
		UpdatePPDData(data, kPPD_Items_CNTrimming, "True");
	}else{
		UpdatePPDData(data, kPPD_Items_CNVfolding, "False");
		UpdatePPDData(data, kPPD_Items_CNSaddleStitch, "False");
#if !defined(__APPLE__) && !defined(_OPAL)
		UpdatePPDData(data, kPPD_Items_CNVfoldingTrimming, "False");
#endif
		UpdatePPDData(data, kPPD_Items_CNTrimming, "False");
	}
}
#else
static void UpdateCNSaddleSetting(cngplpData *data, char *value)
{
	if(strcasecmp(value, "VFolding") == 0){
		UpdatePPDData(data, kPPD_Items_CNVfolding, "True");
		UpdatePPDData(data, kPPD_Items_CNSaddleStitch, "False");
		UpdatePPDData(data, kPPD_Items_CNVfoldingTrimming, "False");
		UpdatePPDData(data, kPPD_Items_CNTrimming, "False");
	}else if(strcasecmp(value, "SaddleStitch") == 0){
		UpdatePPDData(data, kPPD_Items_CNVfolding, "True");
		UpdatePPDData(data, kPPD_Items_CNSaddleStitch, "True");
		UpdatePPDData(data, kPPD_Items_CNVfoldingTrimming, "False");
		UpdatePPDData(data, kPPD_Items_CNTrimming, "False");
	}else if(strcasecmp(value, "VFoldingTrimming") == 0){
		UpdatePPDData(data, kPPD_Items_CNVfolding, "True");
		UpdatePPDData(data, kPPD_Items_CNSaddleStitch, "False");
		UpdatePPDData(data, kPPD_Items_CNVfoldingTrimming, "True");
		UpdatePPDData(data, kPPD_Items_CNTrimming, "True");
	}else if(strcasecmp(value, "Trimming") == 0){
		UpdatePPDData(data, kPPD_Items_CNVfolding, "True");
		UpdatePPDData(data, kPPD_Items_CNSaddleStitch, "True");
		UpdatePPDData(data, kPPD_Items_CNVfoldingTrimming, "False");
		UpdatePPDData(data, kPPD_Items_CNTrimming, "True");
	}else{
		UpdatePPDData(data, kPPD_Items_CNVfolding, "False");
		UpdatePPDData(data, kPPD_Items_CNSaddleStitch, "False");
		UpdatePPDData(data, kPPD_Items_CNVfoldingTrimming, "False");
		UpdatePPDData(data, kPPD_Items_CNTrimming, "False");
	}
}
#endif
static void UpdateCNSpecID(cngplpData *data, char *value)
{
	UIOptionList *opt;

	opt = FindOptionList(data->ppd_opt->items_list, kPPD_Items_CNSpecID, value);
	if(opt != NULL){
		UpdatePPDData(data, kPPD_Items_CNSpecID, value);
	}
	else{
		UIItemsList *item;
		item = FindItemsList(data->ppd_opt->items_list, kPPD_Items_CNSpecID);
		if(item){
			unsigned long lsetval;
			unsigned long ltmpval;
			unsigned long loptval = 0;
			lsetval = strtoul(value, NULL, 16);
			opt = item->opt_lists;
			while(opt != NULL){
				ltmpval = strtoul(opt->name, NULL, 16);
				if((lsetval > ltmpval) && (ltmpval > loptval)){
					loptval = ltmpval;
				}
				opt = opt->next;
			}
			if(loptval == 0){
				opt = item->opt_lists;
				while(opt != NULL){
					ltmpval = strtoul(opt->name, NULL, 16);
					if((loptval == 0) || (ltmpval < loptval)){
						loptval = ltmpval;
					}
					opt = opt->next;
				}
			}
			if(loptval > 0){
				char specid[128];
				snprintf(specid, sizeof(specid)-1, "%04X", loptval);
				UpdatePPDData(data, kPPD_Items_CNSpecID, specid);
			}
		}
	}
}


static void GetShiftStartPosLimit(cngplpData *data, int id, int *max, int *min)
{
	char	*max_str = NULL;
	char	*min_str = NULL;

	*max = 30;
	*min = -30;

	switch(id){
	case ID_CNSHIFTUPWARDS:
	case ID_CNSHIFTRIGHT:
		*max = 30;
		*min = -30;
		break;
	case ID_CNSHIFTFRLONGEDGE:
	case ID_CNSHIFTFRSHORTEDGE:
	case ID_CNSHIFTBKLONGEDGE:
	case ID_CNSHIFTBKSHORTEDGE:
		*max = 50;
		*min = -50;
		break;
	}

	max_str = GetUIValue(data, "CNShiftPositionMax");
	if(max_str != NULL){
		*max = atoi(max_str);
	}

	min_str = GetUIValue(data, "CNShiftPositionMin");
	if(min_str != NULL){
		*min = atoi(min_str);
	}
}

#ifndef __APPLE__
static void UpdateCNFoldSetting(cngplpData *data, const char *value)
{
	if(strcasecmp(value, "Z-fold") == 0){
		UpdatePPDData(data, kPPD_Items_CNZfolding, "True");
		UpdatePPDData(data, kPPD_Items_CNCfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNHalfFolding, "None");
		UpdatePPDData(data, kPPD_Items_CNAccordionZfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNDoubleParallelFolding, "None");
	}else if(strcasecmp(value, "C-fold") == 0){
		UpdatePPDData(data, kPPD_Items_CNZfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNCfolding, "True");
		UpdatePPDData(data, kPPD_Items_CNHalfFolding, "None");
		UpdatePPDData(data, kPPD_Items_CNAccordionZfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNDoubleParallelFolding, "None");
	}else if(strcasecmp(value, "Half Fold") == 0){
		UpdatePPDData(data, kPPD_Items_CNZfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNCfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNHalfFolding, "True");
		UpdatePPDData(data, kPPD_Items_CNAccordionZfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNDoubleParallelFolding, "None");
	}else if(strcasecmp(value, "Accordion Z-fold") == 0){
		UpdatePPDData(data, kPPD_Items_CNZfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNCfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNHalfFolding, "None");
		UpdatePPDData(data, kPPD_Items_CNAccordionZfolding, "True");
		UpdatePPDData(data, kPPD_Items_CNDoubleParallelFolding, "None");
        }else if(strcasecmp(value, "Double Parallel Fold") == 0){
		UpdatePPDData(data, kPPD_Items_CNZfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNCfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNHalfFolding, "None");
		UpdatePPDData(data, kPPD_Items_CNAccordionZfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNDoubleParallelFolding, "True");
        }else{
		UpdatePPDData(data, kPPD_Items_CNZfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNCfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNHalfFolding, "None");
		UpdatePPDData(data, kPPD_Items_CNAccordionZfolding, "None");
		UpdatePPDData(data, kPPD_Items_CNDoubleParallelFolding, "None");
	}
	AddUpdateOption(data, "CNFoldDetail");
}


static void UpdateCNPrintStyle(cngplpData *data, const char *value)
{
	UIItemsList *list = data->ppd_opt->items_list;

	if(strcasecmp(value, "2-sided Printing") == 0){
		UpdateDuplex(data, 1);
		UpdatePPDData(data, kPPD_Items_Booklet, "None");
#if !defined(__APPLE__) && !defined(_OPAL)
	}else if( ( strcasecmp(value, "Booklet Printing") == 0 ) ||
	          ( strcasecmp(value, "Booklet Printing + Offset") == 0 ) ) {
#else
	}else if(strcasecmp(value, "Booklet Printing") == 0){
#endif
		char *cur = FindCurrOpt(list, "Booklet");
		if(strcmp(cur, "None") == 0){
			UpdatePPDData(data, kPPD_Items_Booklet, "Left");
		}else{
			UpdatePPDData(data, kPPD_Items_Booklet, cur);
		}
		UpdateDuplex(data, 0);
	}else{
		UpdatePPDData(data, kPPD_Items_CNTrimming, "False");
		UpdatePPDData(data, kPPD_Items_CNSaddleStitch, "False");
		UpdatePPDData(data, kPPD_Items_CNCreep, "False");
		UpdatePPDData(data, kPPD_Items_CNVfolding, "False");
#if !defined(__APPLE__) && !defined(_OPAL)
		UpdatePPDData(data, kPPD_Items_CNVfoldingTrimming, "False");
#endif
		UpdateDuplex(data, 0);
		UpdatePPDData(data, kPPD_Items_Booklet, "None");
	}
}

static void UpdateCNFoldDetail(cngplpData *data, char *value)
{
	UIItemsList *list = data->ppd_opt->items_list;
	char *cur = NULL;

	cur = FindCurrOpt(list, kPPD_Items_CNCfolding);
	if(cur != NULL){
		if(strcmp(cur, "True") == 0){
			UpdatePPDData(data, kPPD_Items_CNCfoldSetting, value);
		}
	}
	cur = FindCurrOpt(list, kPPD_Items_CNHalfFolding);
	if(cur != NULL){
		if(strcmp(cur, "True") == 0){
			UpdatePPDData(data, kPPD_Items_CNHalfFoldSetting, value);
		}
	}
	cur = FindCurrOpt(list, kPPD_Items_CNAccordionZfolding);
	if(cur != NULL){
		if(strcmp(cur, "True") == 0){
			UpdatePPDData(data, kPPD_Items_CNAccordionZfoldSetting, value);
		}
	}
	cur = FindCurrOpt(list, kPPD_Items_CNDoubleParallelFolding);
	if(cur != NULL){
		if(strcmp(cur, "True") == 0){
			UpdatePPDData(data, kPPD_Items_CNDoubleParallelFoldSetting, value);
		}
	}
}
#endif

