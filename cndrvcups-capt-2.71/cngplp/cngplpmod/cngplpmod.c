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

#include "cngplpdef.h"
#include "cngplpmod.h"
#include "cupsoption.h"
#include "ppdoptions.h"
#include "setdata.h"
#include "getdata.h"
#include "execjob.h"
#include "ppdkeys.h"

#include <stdarg.h>

#ifndef _OPAL
int GetPrinterInfo(cngplpData *data);
#else
int GetPrinterInfo_iOS(cngplpData *data, const char *ppdFilePath);
#endif
int CreatePPDOptions(cngplpData *data);
void DeletePPDOptions(cngplpData *data);
#ifndef _OPAL
void SetCupsStoreOption(cngplpData *data, cups_dest_t *curr_printer);
void SetPPDStoreOption(cngplpData *data, cups_dest_t *curr_dest);
#else
void SetPPDStoreOption_iOS(cngplpData *data);
#endif
char *GetKeyValue(cngplpData *data);
#ifndef _OPAL
void SetPPDStoreUIValue(cngplpData *data, cups_dest_t *curr_printer);
#endif
int CheckJobAccount(cngplpData *data);


#ifndef _OPAL
cngplpData* cngplpNew(char *file_name)
#else
cngplpData* cngplpNew(char *file_name, const char *ppdFilePath)
#endif
{
	cngplpData *data = NULL;

	if((data = (cngplpData *)malloc(sizeof(cngplpData))) == NULL)
		return NULL;
	memset(data, 0 , sizeof(cngplpData));

#ifndef _OPAL
	if(GetPrinterInfo(data) < 0)
#else
	if(GetPrinterInfo_iOS(data, ppdFilePath) < 0)
#endif
	{
		MemFree(data);
		return NULL;
	}

	if(cngplpInitOptions(data) < 0){
		MemFree(data);
		return NULL;
	}

	if(file_name){
		int num = strlen(file_name);
		data->file_name = (char *)malloc(num + 1);
		memset(data->file_name, 0, num + 1);
		strncpy(data->file_name, file_name, num);
	}

	return data;
}

void cngplpDestroy(cngplpData *data)
{
	int i;

	if(data == NULL)
		return;

	cngplpFreeOptions(data);

	if(data->printer_names != NULL){
		for(i = 0; i < data->printer_num; i++){
			MemFree(data->printer_names[i]);
		}
		free(data->printer_names);
	}
	MemFree(data->file_name);
	MemFree(data->update_options);
	data->update_options = NULL;
	free(data);
	return;
}

char* cngplpSetData(cngplpData *data, int id, char *value)
{
UI_DEBUG("-----------------------------------------------------\n");
UI_DEBUG("<-cngplpSetData id=[%d] value=[%s]\n", id, value);
	InitUpdateOption(data);
	if(id < ID_COMMON_OPTION){
		SetDataPPD(data, id, value);
	}else if(id < ID_IMAGE_OPTION){
		SetDataCommon(data, id, value);
	}else if(id < ID_TEXT_OPTION){
		SetDataImage(data, id, value);
	}else if(id < ID_HPGL_OPTION){
		SetDataText(data, id, value);
	}else if(id < ID_BOTTON_EVENT){
		SetDataHPGL(data, id, value);
	}else{
		BottomEvent(data, id, value);
	}
	return ExitUpdateOption(data);
}

char* cngplpGetData(cngplpData *data, int id)
{
	char *ret = NULL;
	if(id == ID_PPD_OPTION){
		ret = GetAllOptionID(data);
	}else if(id < ID_COMMON_OPTION){
		ret = GetDataPPDOption(data, id);
	}else if(id < ID_IMAGE_OPTION){
		ret = GetDataCommonOption(data, id);
	}else if(id < ID_TEXT_OPTION){
		ret = GetDataImageOption(data, id);
	}else if(id < ID_HPGL_OPTION){
		ret = GetDataTextOption(data, id);
	}else if(id < ID_BOTTON_EVENT){
		ret = GetDataHPGLOption(data, id);
	}else if(id == ID_KEY_VALUE){
		ret = GetKeyValue(data);
	}
	return ret;
}


int cngplpInitOptions(cngplpData *data)
{
#ifndef _OPAL
	cups_dest_t *all_dests;
	cups_dest_t *curr_dest;
	int num;

	num = cupsGetDests(&all_dests);
	if(num <= 0){
		return -1;
	}
#endif

	if(data->curr_printer == NULL)
		return -1;

#ifndef _OPAL
	curr_dest = cupsGetDest(data->curr_printer, NULL, num, all_dests);
	if(curr_dest == NULL)
		return -1;
#endif

	data->cups_opt = (CupsOptions *)malloc(sizeof(CupsOptions));
	if(data->cups_opt == NULL)
		return -1;

	if(CreateCupsOptions(data) < 0){
		MemFree(data->cups_opt);
		return -1;
	}

#ifndef _OPAL
	SetCupsStoreOption(data, curr_dest);
#endif

	data->ppd_opt = (PPDOptions *)malloc(sizeof(PPDOptions));
	if(data->ppd_opt == NULL){
		DeleteCupsOptions(data->cups_opt);
		return -1;
	}

	if(CreatePPDOptions(data) < 0){
		DeleteCupsOptions(data->cups_opt);
		DeletePPDOptions(data);
		return -1;
	}

#ifndef _OPAL
	if(data->ppdfile){
		SetPPDStoreOption(data, curr_dest);
	}

	if(data->ppd_opt->uivalue != NULL){
		SetPPDStoreUIValue(data, curr_dest);
	}
#else
	if(data->ppdfile){
		SetPPDStoreOption_iOS(data);
	}
#endif

	if(CreateSaveOptions(data) < 0){
		DeleteCupsOptions(data->cups_opt);
		DeletePPDOptions(data);
		return -1;
	}

#ifndef _OPAL
	cupsFreeDests(num, all_dests);
#endif
	return 0;
}

void cngplpFreeOptions(cngplpData *data)
{
	if(data) {
		DeleteSaveOptions(data);
		DeleteCupsOptions(data->cups_opt);
		DeletePPDOptions(data);
		data->cups_opt = NULL;
		data->ppd_opt = NULL;
	}
}

#ifndef _OPAL
int GetPrinterInfo(cngplpData *data)
{
	cups_dest_t *all_dests;
	cups_dest_t *curr_dest;
	int num, i;

	num = cupsGetDests(&all_dests);
	if(num == 0)
		return -1;

	data->printer_num = num;
	data->printer_names = (char **)malloc(sizeof(char *) * num);
	if(data->printer_names == NULL)
		return -1;

	curr_dest = all_dests;
	for(i = 0; i < num; i++){
		if(curr_dest->name != NULL)
			data->printer_names[i] = strdup(curr_dest->name);
		else
			data->printer_names[i] = NULL;
		curr_dest++;
	}

	data->curr_printer = data->printer_names[0];
	curr_dest = all_dests;
	for(i = 0; i < num; i++){
		if(curr_dest->is_default){
			data->curr_printer = data->printer_names[i];
			break;
		}
		curr_dest++;
	}

	cupsFreeDests(num, all_dests);
	return 0;
}
#else
int GetPrinterInfo_iOS(cngplpData *data, const char *ppdFilePath)
{
	data->printer_num = 1;
	data->printer_names = (char **)malloc(sizeof(char *));
	if(data->printer_names == NULL)
		return -1;

	data->printer_names[0] = strdup(ppdFilePath);
	if(data->printer_names[0] == NULL)
		return -1;

	data->curr_printer = data->printer_names[0];

	return 0;
}
#endif

#ifndef __APPLE__

char *comma_chg_opt_name[] =
{
	"CNBindEdgeShift",
	"CNShiftFrShortEdge",
	"CNShiftFrLongEdge",
	"CNShiftBkShortEdge",
	"CNShiftBkLongEdge",
	"CNGutterShiftNum",
	"CNAdjustTrimNum",
};


int is_comma_chg_opt_name(char *name)
{
	int num = sizeof(comma_chg_opt_name) / sizeof(char *);
	int i;

	for( i = 0; i < num; i++ )
	{
		if( strcmp(name, comma_chg_opt_name[i]) == 0 )
		{
			return 1;
		}
	}
	return 0;
}


int get_comma_chg_env()
{
	double num = 0.11;
	char * tmp = NULL;
	int ret = 0;
	char * value = (char *)malloc(8);
	snprintf(value, 8, "%.2f", num);

	if( (tmp = strchr(value, ',') ) != NULL)
	{
      ret = 1;
	}
	else if( (tmp = strchr(value, '.') ) != NULL)
	{
		ret = 2;
	}
	free(value);

	return ret;
}


#if !defined(__APPLE__) && !defined(_OPAL)
void ConvertDecimalPoint(char *value)
{
	int tmp_env = get_comma_chg_env();
	char *p_tmp = NULL;

	if( (tmp_env == 1) && ((p_tmp = strchr(value, '.') ) != NULL) )
	{
		*p_tmp = ',';
	}
	else if( (tmp_env == 2) && ((p_tmp = strchr(value, ',') ) != NULL) )
	{
		*p_tmp = '.';
	}
}
#endif

#endif
void SetDocName(PPDOptions* ppd_opt, int jobmode, char* value)
{
	if(jobmode == 1){
#ifndef _OPAL
		strncpy(ppd_opt->special->enter_name, value, 127);
#else
		if(ppd_opt->special->enter_name != NULL){
			free(ppd_opt->special->enter_name);
			ppd_opt->special->enter_name = NULL;
		}
		ppd_opt->special->enter_name = strdup(value);
#endif
	}
	else if(jobmode == 2){
#ifndef _OPAL
		strncpy(ppd_opt->special->doc_name, value, 127);
#else
		if(ppd_opt->special->doc_name != NULL){
			free(ppd_opt->special->doc_name);
			ppd_opt->special->doc_name = NULL;
		}
		ppd_opt->special->doc_name = strdup(value);
#endif
	}
	else if(jobmode == 3)
		strncpy(ppd_opt->special->hold_name, value, 127);
}

#ifndef _OPAL
void SetPPDStoreOption(cngplpData *data, cups_dest_t *curr_printer)
{
	int i;
	PPDOptions *ppd_opt = data->ppd_opt;
	cups_option_t *opt;
	UIItemsList *items_list;
	int jobmode = 0;
	int cnt = 0;
	char *slot = NULL;
	char *media = NULL;
	int usr_select = 0;
	int inputselect = 0;
#ifndef __APPLE__
  	int tmp_env = 0;
  	char *p_tmp = NULL;
	tmp_env = get_comma_chg_env();
	char *value = NULL;
#endif


	opt = curr_printer->options;
	for(i = 0; i < curr_printer->num_options; i++){
		items_list = ppd_opt->items_list;
#ifndef __APPLE__
      if( is_comma_chg_opt_name(opt->name) == 1 )
      {
        if( tmp_env == 1 && (p_tmp = strchr(opt->value, '.') ) != NULL)
        {
          *p_tmp = ',';
        }
		else if( tmp_env == 2 && (p_tmp = strchr(opt->value, ',') ) != NULL)
        {
          *p_tmp = '.';
        }
      }
#endif
		while(1){
			if(strcmp(opt->name, items_list->name) == 0){
				if(strcmp(items_list->name, "InputSlot") == 0){
					if(ppd_opt->selectby != SELECTBY_NONE){
						slot = strdup(opt->value);
						usr_select = SELECTBY_INPUTSLOT;
					}
				}else if(strcmp(items_list->name, "MediaType") == 0){
					if(ppd_opt->selectby != SELECTBY_NONE){
						media = strdup(opt->value);
						usr_select = SELECTBY_MEDIATYPE;
					}
				}else if(strcmp(items_list->name, "CNJobExecMode") == 0){
					if(strcmp(opt->value, "store") == 0)
						jobmode = 1;
					else if(strcmp(opt->value, "secured") == 0)
						jobmode = 2;
					else if(strcasecmp(opt->value, "Hold") == 0)
						jobmode = 3;
				}

				if(strcmp(items_list->name, "PageSize") == 0){
					if(strstr(opt->value, "Custom") != NULL){
						char *tmp_value = strdup(opt->value);
						SetCustomSize(data, tmp_value);
						items_list->new_option = strdup(tmp_value);
						free(tmp_value);
					}else{
						items_list->new_option = strdup(opt->value);
					}
				}else{
					items_list->new_option = strdup(opt->value);
				}

				if(items_list->current_option != NULL){
					ResetUIConst(data, items_list->name, items_list->current_option->name);
					MarkDisable(data, items_list->name, items_list->current_option->name, -1, 0);
					cnt++;
				}
				UpdateCurrOption(items_list);
			}
			if(items_list->next == NULL)
				break;
			items_list = items_list->next;
		}
		if(strcmp(opt->name, "CNBindEdgeShift") == 0){
			ppd_opt->gutter_value = atoi(opt->value);
			ppd_opt->gutter_value_d = atof(opt->value);
		}else if(strcmp(opt->name, "CNStartingNumber") == 0){
			ppd_opt->startnum_value = atoi(opt->value);
		}else if(strcmp(opt->name, "CNUsrName") == 0){
			strncpy(ppd_opt->special->usr_name, opt->value, 127);
		}else if(strcmp(opt->name, "CNDocName") == 0){
#ifndef __APPLE__
			value = strdup(opt->value);
#else
			if(jobmode == 1)
				strncpy(ppd_opt->special->enter_name, opt->value, 127);
			else if(jobmode == 2)
				strncpy(ppd_opt->special->doc_name, opt->value, 127);
			else if(jobmode == 3)
				strncpy(ppd_opt->special->hold_name, opt->value, 127);
#endif
		}else if(strcmp(opt->name, "CNSecuredPrint") == 0){
			strncpy(ppd_opt->special->passwd_array, opt->value, 7);
		}else if(strcmp(opt->name, "CNMailBox") == 0){
#ifndef __APPLE__
			ppd_opt->special->box_num = atoi(opt->value);
#else
			strncpy(ppd_opt->special->box_num, opt->value,511);
#endif
		}else if(strcmp(opt->name, "CNDisableJobAccountingBW") == 0){
			int job_account_bw;
			job_account_bw = (strcmp(opt->value, "True") == 0) ? 1 : 0;
			ppd_opt->special->disable_job_account_bw = job_account_bw;
		}else if(strcmp(opt->name, kPPD_Items_Device_CNShiftUpwards) == 0){
			ppd_opt->shift_upwards = atoi(opt->value);
			ppd_opt->detail_shift_upwards = atof(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNShiftRight) == 0){
			ppd_opt->shift_right = atoi(opt->value);
			ppd_opt->detail_shift_right = atof(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNShiftFrLongEdge) == 0){
			ppd_opt->shift_front_long = atoi(opt->value);
			ppd_opt->detail_shift_front_long = atof(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNShiftFrShortEdge) == 0){
			ppd_opt->shift_front_short = atoi(opt->value);
			ppd_opt->detail_shift_front_short = atof(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNShiftBkLongEdge) == 0){
			ppd_opt->shift_back_long = atoi(opt->value);
			ppd_opt->detail_shift_back_long = atof(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNShiftBkShortEdge) == 0){
			ppd_opt->shift_back_short = atoi(opt->value);
			ppd_opt->detail_shift_back_short = atof(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNJobNote) == 0){
			if(ppd_opt->job_note != NULL)
				strncpy(ppd_opt->job_note->note, opt->value, sizeof(ppd_opt->job_note->note));
		}else if(strcmp(opt->name, kPPD_Items_Device_CNJobDetails) == 0){
			if(ppd_opt->job_note != NULL)
				strncpy(ppd_opt->job_note->details, opt->value, sizeof(ppd_opt->job_note->details));
		}else if(strcmp(opt->name, kPPD_Items_Device_CNOffsetNum) == 0){
			ppd_opt->offset_num = atoi(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNInputSelect) == 0){
			if(strcmp(opt->value, kPPD_Items_InputSlot) == 0)
				inputselect = SELECTBY_INPUTSLOT;
			else if(strcmp(opt->value, kPPD_Items_MediaType) == 0)
				inputselect = SELECTBY_MEDIATYPE;
		}else if(strcmp(opt->name, kPPD_Items_CNGutterShiftNum) == 0){
			double max_value;
			char *maxptr;

			ppd_opt->guttershiftnum_value_d = atof(opt->value);

			maxptr = cngplpGetData(data,ID_MAX_GUTTER_SHIFT_NUM);
			if(maxptr != NULL){
				max_value = atof(maxptr);

				if(max_value < ppd_opt->guttershiftnum_value_d){
					ppd_opt->guttershiftnum_value_d = max_value;
				}
				free(maxptr);
			}
		}else if(strcmp(opt->name, kPPD_Items_Device_CNTabShift) == 0){
			ppd_opt->tab_shift = atof(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNInsertTabShift) == 0){
			ppd_opt->ins_tab_shift = atof(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNFormHandle) == 0){
				strncpy(ppd_opt->special->form_handle, opt->value, 127);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNOverlayFileName) == 0){
				strncpy(ppd_opt->special->form_name, opt->value, 127);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNAdjustTrimNum) == 0){
			ppd_opt->adjust_trim_num = atof(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNAdjustForeTrimNum) == 0){
			ppd_opt->adjust_frtrim_num = atof(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNAdjustTopBottomTrimNum) == 0){
			ppd_opt->adjust_tbtrim_num = atof(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNPBindFinishForeTrimNum) == 0){
			ppd_opt->pb_fin_fore_trim_num = atof(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNPBindFinishTopBottomTrimNum) == 0){
			ppd_opt->pb_fin_topbtm_trim_num = atof(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNStackCopiesNum) == 0){
			ppd_opt->stack_copies_num = atoi(opt->value);
		}else if(strcmp(opt->name, kPPD_Items_Device_CNSaddlePressAdjustment) == 0){
			ppd_opt->saddle_press_adjust = atoi(opt->value);
		}
		opt++;
	}

#ifndef __APPLE__
	if((ppd_opt != NULL) && (value != NULL)){
		SetDocName(ppd_opt, jobmode, value);
		MemFree(value);
	}
#endif

	if(cnt != 0){
	  	ResetUIDisable(data);
		AllUpdatePPDData(data);
	}

	if(inputselect == SELECTBY_INPUTSLOT){
		ppd_opt->selectby = inputselect;
		UpdatePPDData(data, "MediaType", NULL);
		UpdatePPDData(data, "InputSlot", slot);
	}else if(inputselect == SELECTBY_MEDIATYPE){
		ppd_opt->selectby = inputselect;
		UpdatePPDData(data, "InputSlot", NULL);
		UpdatePPDData(data, "MediaType", media);
	}else{
		if(usr_select == SELECTBY_INPUTSLOT){
			ppd_opt->selectby = usr_select;
			UpdatePPDData(data, "MediaType", NULL);
			UpdatePPDData(data, "InputSlot", slot);
		}else if(usr_select == SELECTBY_MEDIATYPE){
			ppd_opt->selectby = usr_select;
			UpdatePPDData(data, "InputSlot", NULL);
			UpdatePPDData(data, "MediaType", media);
		}
	}

	if(slot)	free(slot);
	if(media)	free(media);

#ifndef	__APPLE__
	CheckJobAccount(data);
#endif
}
#else
void SetPPDStoreOption_iOS(cngplpData *data)
{
	PPDOptions *ppd_opt = data->ppd_opt;

	ResetUIDisable(data);
	AllUpdatePPDData(data);
}
#endif

#ifndef _OPAL
void SetCupsStoreOption(cngplpData *data, cups_dest_t *curr_printer)
{
	CupsOptions *cups_opt = data->cups_opt;
	int i;
	cups_option_t *opt;

	opt = curr_printer->options;
	for(i = 0; i < curr_printer->num_options; i++){
		if(strcmp(opt->name, "page-set") == 0){
			SetCupsOption(data, cups_opt->common->option, opt->name, opt->value);
		}else if(strcmp(opt->name, "page-ranges") == 0){
			SetCupsOption(data, cups_opt->common->option, opt->name, opt->value);
#ifndef __APPLE__
#else
			SetCupsOption(data, cups_opt->common->option, "page-set", "range");
#endif
		}else if(strcmp(opt->name, "job-sheets") == 0){
			char start[32], end[32];
			char *ptr, *sp, *ep;
			ptr = opt->value;
			sp = start;
			ep = end;

			while(1){
				if(*ptr == '\0'){
					break;
				}
				if(*ptr == ','){
					ptr++;
					break;
				}
				if(sp - start == 31)
					break;
				*sp = *ptr;
				ptr++;
				sp++;
			}
			*sp = '\0';
			SetCupsOption(data, cups_opt->common->option, "job-sheets-start", start);

			while(1){
				if(*ptr == '\0'){
					break;
				}
				if(ep - end == 31)
					break;
				*ep = *ptr;
				ptr++;
				ep++;
			}
			*ep = '\0';
			SetCupsOption(data, cups_opt->common->option, "job-sheets-end", end);
		}else if(strcmp(opt->name, "ppi") == 0){
			SetCupsOption(data, cups_opt->image->option, opt->name, opt->value);
			cups_opt->image->img_reso_scale = 0;
			SetCupsOption(data, cups_opt->common->option, "Filter", g_filter_options[FILTER_IMAGE]);
		}else if(strcmp(opt->name, "scaling") == 0){
			SetCupsOption(data, cups_opt->image->option, opt->name, opt->value);
			cups_opt->image->img_reso_scale = 1;
			SetCupsOption(data, cups_opt->common->option, "Filter", g_filter_options[FILTER_IMAGE]);
		}else if(strcmp(opt->name, "natural-scaling") == 0){
			SetCupsOption(data, cups_opt->image->option, opt->name, opt->value);
			cups_opt->image->img_reso_scale = 2;
			SetCupsOption(data, cups_opt->common->option, "Filter", g_filter_options[FILTER_IMAGE]);
		}else if(strcmp(opt->name, "page-left") == 0){
			SetCupsOption(data, cups_opt->text->option, opt->name, opt->value);
			cups_opt->text->margin_on = 1;
			SetCupsOption(data, cups_opt->common->option, "Filter", g_filter_options[FILTER_TEXT]);
		}else if(strcmp(opt->name, "page-top") == 0){
			SetCupsOption(data, cups_opt->text->option, opt->name, opt->value);
			cups_opt->text->margin_on = 1;
			SetCupsOption(data, cups_opt->common->option, "Filter", g_filter_options[FILTER_TEXT]);
		}else if(strcmp(opt->name, "page-right") == 0){
			SetCupsOption(data, cups_opt->text->option, opt->name, opt->value);
			cups_opt->text->margin_on = 1;
			SetCupsOption(data, cups_opt->common->option, "Filter", g_filter_options[FILTER_TEXT]);
		}else if(strcmp(opt->name, "page-bottom") == 0){
			SetCupsOption(data, cups_opt->text->option, opt->name, opt->value);
			cups_opt->text->margin_on = 1;
			SetCupsOption(data, cups_opt->common->option, "Filter", g_filter_options[FILTER_TEXT]);
		}else if(strcmp(opt->name, "cpi") == 0){
			SetCupsOption(data, cups_opt->text->option, opt->name, opt->value);
			SetCupsOption(data, cups_opt->common->option, "Filter", g_filter_options[FILTER_TEXT]);
		}else if(strcmp(opt->name, "penwidth") == 0){
			SetCupsOption(data, cups_opt->hpgl->option, opt->name, opt->value);
			SetCupsOption(data, cups_opt->common->option, "Filter", g_filter_options[FILTER_HPGL]);
		}else{
			if(!SetCupsOption(data, cups_opt->common->option, opt->name, opt->value)){
				if(SetCupsOption(data, cups_opt->image->option, opt->name, opt->value))
					SetCupsOption(data, cups_opt->common->option, "Filter", g_filter_options[FILTER_IMAGE]);
				else if(SetCupsOption(data, cups_opt->text->option, opt->name, opt->value))
					SetCupsOption(data, cups_opt->common->option, "Filter", g_filter_options[FILTER_TEXT]);
				else if(SetCupsOption(data, cups_opt->hpgl->option, opt->name, opt->value))
					SetCupsOption(data, cups_opt->common->option, "Filter", g_filter_options[FILTER_HPGL]);
			}
		}
		opt++;
	}
}
#endif


int CreatePPDOptions(cngplpData *data)
{
#ifndef _OPAL
	char *pWorkPPD = (char *)cupsGetPPD(data->curr_printer);
	if(pWorkPPD) {
		data->ppdfile = strdup(pWorkPPD);
		if (!data->ppdfile) {
			unlink(pWorkPPD);
			return -1;
		}
	}
#else
	data->ppdfile = strdup(data->curr_printer);
	if(data->ppdfile == NULL)
		return -1;
#endif

	memset(data->ppd_opt, 0, sizeof(PPDOptions));

	data->ppd_opt->startnum_value = 1;
	data->ppd_opt->dpicon_pictid = -1;
	data->ppd_opt->enable_finishflag = -1;
	data->ppd_opt->enable_inputflag = -1;
	data->ppd_opt->enable_qualitytype = -1;
	data->ppd_opt->offset_num = 1;
	data->ppd_opt->tab_shift = 12.7;
	data->ppd_opt->ins_tab_shift = 12.7;
	data->ppd_opt->adjust_trim_num = 0.0;
	data->ppd_opt->adjust_frtrim_num = 0.0;
	data->ppd_opt->adjust_tbtrim_num = 0.0;
	data->ppd_opt->pb_fin_fore_trim_num = 0.0;
	data->ppd_opt->pb_fin_topbtm_trim_num = 0.0;
	data->ppd_opt->stack_copies_num = 1;
	data->ppd_opt->saddle_press_adjust = 0;

	data->ppd_opt->items_list = (UIItemsList *)malloc(sizeof(UIItemsList));
	if(data->ppd_opt->items_list == NULL)
		return -1;

	memset(data->ppd_opt->items_list, 0, sizeof(UIItemsList));

	if((ParsePPD(data->ppd_opt, data->ppdfile)) < 0){
		return -1;
	}
	char *max_val = GetUIValue(data, kPPD_Items_CNUITrimValMax);
	char *min_val = GetUIValue(data, kPPD_Items_CNUITrimValMin);
	char *def_val = GetUIValue(data, kPPD_Items_CNUIAdjustTrimNumDefault);
	if(def_val == NULL || max_val == NULL || min_val == NULL){
		if(max_val != NULL)
			UpdateUIValue(data, kPPD_Items_CNUITrimValMax, "10.2");
		else
			AddUIValueList(data->ppd_opt, kPPD_Items_CNUITrimValMax, "10.2", 0);
		if(min_val != NULL)
			UpdateUIValue(data, kPPD_Items_CNUITrimValMin, "2.0");
		else
			AddUIValueList(data->ppd_opt, kPPD_Items_CNUITrimValMin, "2.0", 0);
		data->ppd_opt->adjust_trim_num = 2.0;
		data->ppd_opt->adjust_frtrim_num = 2.0;
}
	char *ptbValMax = GetUIValue(data,kPPD_Items_CNUITopBottomTrimValMax);
	char *ptbValMin = GetUIValue(data,kPPD_Items_CNUITopBottomTrimValMin);
	char *ptbValDef = GetUIValue(data,kPPD_Items_CNUIAdjustTopBottomTrimNumDefault);
	if(ptbValDef == NULL || ptbValMax ==NULL || ptbValMin ==NULL){
		if(ptbValMax != NULL)
			UpdateUIValue(data,kPPD_Items_CNUITopBottomTrimValMax,"15.0");
		else
			AddUIValueList(data->ppd_opt,kPPD_Items_CNUITopBottomTrimValMax,"15.0",0);
		if(ptbValMin != NULL)
			UpdateUIValue(data,kPPD_Items_CNUITopBottomTrimValMin,"2.0");
		else
			AddUIValueList(data->ppd_opt,kPPD_Items_CNUITopBottomTrimValMin,"2.0",0);
		data->ppd_opt->adjust_tbtrim_num = 2.0;
	}

	if(data->ppdfile)
		InitUIDisable(data);

	if(data->ppdfile)
		SetDefaultOptIfAllOptConflict(data);

	return 0;
}


void DeletePPDOptions(cngplpData *data)
{
	FreePPDOptions(data->ppd_opt);
	if(data->ppdfile) {
#ifndef _OPAL
		unlink(data->ppdfile);
#endif
		MemFree(data->ppdfile);
		data->ppdfile = NULL;
	}
}


#if _UI_DEBUG
void DebugDisable(cngplpData *data, int id)
{
	PPDOptions *ppd_opt = data->ppd_opt;
	int i = 0;
	UIItemsList *list;
	UIOptionList *opt;
	char *except = IDtoPPDOption(id - 1);
if(except == NULL)
return;
UI_DEBUG("[%s]:%d\n", except, id);
	list = ppd_opt->items_list;
	while(1){
		opt = list->opt_lists;
		while(1){
			i++;
if(except != NULL && strcmp(except, list->name) == 0)
UI_DEBUG("[%3d] item:[%18s] opt:[%10s] disable[%d] def:[%3s]\n", i, except, opt->name, opt->disable, (strcmp(list->current_option->name, opt->name) == 0) ? "Yes" : "NO");
			if(opt->next == NULL)
				break;
			opt = opt->next;
		}

		if(list->next == NULL)
			break;
		list = list->next;
	}
UI_DEBUG("\n");
}
#endif

#ifndef _OPAL
void SetPPDStoreUIValue(cngplpData *data, cups_dest_t *curr_printer)
{
	int i;
	cups_option_t *opt = curr_printer->options;

	for(i = 0; i < curr_printer->num_options; i++){
		UpdateUIValue(data, opt->name, opt->value);
		opt++;
	}
}
#endif

char* cngplpGetValue(cngplpData *data, char *key)
{
	if(data == NULL)
		return NULL;

	if(key == NULL)
		return GetAllUIValue(data);
	else
		return ToChar(GetUIValue(data, key));
}

char* cngplpSetValue(cngplpData *data, char *key, char *value)
{
	if(data == NULL)
		return NULL;

	InitUpdateOption(data);
	UpdateUIValue(data, key, value);
	return ExitUpdateOption(data);
}


char* cngplpIDtoKey(int id)
{
	char *ret = NULL;

	if(id < ID_DEVICE_INFO){
		ret = ToChar(IDtoPPDOption(id - 1));
	}else if(id < ID_COMMON_OPTION){
		ret = ToChar(IDtoDevOption(id));
	}else if(id < ID_IMAGE_OPTION){
		ret = ToChar(IDtoCommonOption(id - ID_COMMON_OPTION - 1));
	}else if(id < ID_TEXT_OPTION){
		ret = ToChar(IDtoImageOption(id - ID_IMAGE_OPTION - 1));
	}else if(id < ID_HPGL_OPTION){
		ret = ToChar(IDtoTextOption(id - ID_TEXT_OPTION - 1));
	}else if(id < ID_BOTTON_EVENT){
		ret = ToChar(IDtoHPGLOption(id - ID_HPGL_OPTION - 1));
	}
	return ret;
}

int CheckJobAccount(cngplpData *data)
{
	char id[32], ps[32];
	char *user = NULL;
	int job_account = 0;
	char *curr = strdup(data->curr_printer);

	if(curr && data->ppd_opt->special != NULL){
		memset(id, 0, sizeof(id));
		memset(ps, 0, sizeof(ps));
		if(getuid() != 0)
			user = getenv("USER");

		job_account = check_job_account(curr, user, id, ps, 32);
		data->ppd_opt->special->job_account = job_account;
		memcpy(data->ppd_opt->special->job_account_id, id, 12);
		memcpy(data->ppd_opt->special->job_account_passwd, ps, 8);
		data->ppd_opt->special->org_job_account = job_account;
		memcpy(data->ppd_opt->special->org_job_account_id, id, 12);
		memcpy(data->ppd_opt->special->org_job_account_passwd, ps, 8);
		free(curr);
	}
	return 0;
}


char* cngplpGetDevOptionConflict(cngplpData *data, int id)
{
	char *ret = NULL;

	if(id < ID_DEVICE_INFO){
		ret = GetPPDDevOptionConflict(data, id);
	}else if(id < ID_COMMON_OPTION){
		ret = GetPPDDevOptionConflict_DeviceInfo(data, id);
	}

	return ret;
}

char* cngplpGetFuncVerConflict(cngplpData *data, int id)
{
	char *ret = NULL;

	if(id < ID_DEVICE_INFO){
		ret = GetPPDFuncVerConflict(data, id);
	}

	return ret;
}

char* cngplp_util_strcpy( char* dst, const char* src )
{
	if( (NULL != dst) && (NULL != src) ){
		memmove( dst, src, strlen(src)+1 );
	}
	return dst;
}

char* cngplp_util_strcat( char* dst, const char* src )
{
	char* newDst = NULL;

	if( (NULL != dst) && (NULL != src) ){
		newDst = dst + strlen( dst );
		memmove( newDst, src, strlen(src)+1 );
	}

	return dst;
}

int cngplp_util_sprintf( char* dst, const char* fmt, ... )
{
	int		cpysize		= 0;
	int		dummysize	= 128;
	char*	dummystring = NULL;
	char*	restring = NULL;
	va_list	valist;

	if( NULL == dst ){
		return -1;
	}

	dummystring = calloc(dummysize, 1);

	if( NULL == dummystring ){
		return -1;
	}

	while(1){
		va_start(valist, fmt);
		cpysize = vsnprintf(dummystring, dummysize, fmt, valist);
		va_end(valist);

		if( cpysize > -1 && cpysize < dummysize ){
			memmove(dst, dummystring, cpysize+1);
			free(dummystring);
			break;
		}
		if( cpysize > -1 ){
			dummysize *= 2;
		}
		restring = realloc(dummystring, dummysize);
		if( NULL == restring ){
			free(dummystring);
			cpysize = -1;
			break;
		} else {
			dummystring = restring;
		}
	}
	return cpysize;
}
