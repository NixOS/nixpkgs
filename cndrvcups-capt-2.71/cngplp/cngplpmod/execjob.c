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
#include <sys/types.h>
#include <sys/wait.h>

#include "cngplpmod.h"
#include "cupsoption.h"
#include "ppdoptions.h"
#include "ppdkeys.h"

#define EXEC_PATH	"/usr/bin"
#define	EXEC_FILE_LPR	"lpr"
#define	EXEC_FILE_LPOPTIONS	"lpoptions"

#if !defined(__APPLE__) && !defined(_OPAL)
#define MAX_BUFSIZE     512

#define PRINTER_NAME_FORMAT_START "<%s>"
#define PRINTER_NAME_FORMAT_END "</%s>"
#define PRINTER_NAME_FORMAT_STARTEND "<%s>%s</%s>"
#define ACCOUNT_ON "ON"
#define ACCOUNT_OFF "OFF"

static int check_printer_name(char * const printer_name, const char * const t_line, const char * const format);
static int check_account_printer_name(char * const printer_name, char * const t_line);
static int get_account_status(char * const printer_name, char * const t_line);
#endif

char* MakeCustomValue(cngplpData *data, char *uival_w, char *uival_h);
int SaveJobAccount(cngplpData *data);
void get_param_len(char *opt_name_arg, char *str, int *len);
int add_param_array(char **ptr_param, char *opt_name_arg, char *opt_val_arg);

#if !defined(__APPLE__) && !defined(_OPAL)
static int check_printer_name(char * const printer_name, const char * const t_line, const char * const format)
{
	int n_diff_size = 1;
	char str_printer_name[MAX_BUFSIZE];

	if( (printer_name == NULL) || (t_line == NULL) || (format == NULL) ) {
		return n_diff_size;
	}

	memset( str_printer_name, 0x00, MAX_BUFSIZE );

	snprintf( str_printer_name, MAX_BUFSIZE - 1, format, printer_name );
	n_diff_size = strcmp( t_line, str_printer_name );

	return n_diff_size;
}

static int check_account_printer_name(char * const printer_name, char * const t_line)
{
	int n_diff_size = 1;
	int status = 0;
	char *useAccountStr = NULL;
	char str_printer_name[MAX_BUFSIZE];

	if( (printer_name == NULL) || (t_line == NULL) ) {
		return n_diff_size;
	}

	memset( str_printer_name, 0x00, MAX_BUFSIZE );

	status = get_account_status( printer_name, t_line );
	if( status == 1 ) {
		useAccountStr = ACCOUNT_ON;
	}
	else {
		useAccountStr = ACCOUNT_OFF;
	}

	snprintf( str_printer_name, MAX_BUFSIZE - 1, PRINTER_NAME_FORMAT_STARTEND, printer_name, useAccountStr, printer_name );
	n_diff_size = strcmp( t_line, str_printer_name );

	return n_diff_size;
}
#endif

int add_param_char(char **ptr_param, char *name, char *value)
{
	char tmp_value[1024];
	char **ptr;
	ptr = ptr_param;
	*ptr = strdup("-o");
	ptr++;

	if(value != NULL){
		if(strstr(value, " ") != NULL)
			snprintf(tmp_value, (sizeof(tmp_value)-1), "%s=\"%s\"", name, value);
		else
			snprintf(tmp_value, (sizeof(tmp_value)-1), "%s=%s", name, value);
		*ptr = strdup(tmp_value);
	}else{
		*ptr = strdup(name);
	}
	ptr++;
	ptr_param = ptr;
	return 2;
}

int add_param_double(char **ptr_param, char *name, double value)
{
	char tmp_value[128];
	char **ptr;

	ptr = ptr_param;
	*ptr = strdup("-o");
	ptr++;
	snprintf(tmp_value, 127, "%s=%f", name, value);
	*ptr = strdup(tmp_value);
	ptr++;

	ptr_param = ptr;
	return 2;
}

int add_param_int(char **ptr_param, char *name, int value)
{
	char tmp_value[128];
	char **ptr;

	ptr = ptr_param;
	*ptr = strdup("-o");
	ptr++;
	snprintf(tmp_value, 127, "%s=%d", name, value);
	*ptr = strdup(tmp_value);
	ptr++;

	ptr_param = ptr;
	return 2;
}


int make_ppd_param(cngplpData *data, char **param_list, int lpr_type)
{
	PPDOptions *ppd_opt = data->ppd_opt;
	char **ptr_param;
	UIItemsList *tmp;
	int num = 0;
	int list_num = 0;
	int enable_jobnote = 1;

	ptr_param = param_list;
	tmp = ppd_opt->items_list;

	switch(ppd_opt->selectby){
	case SELECTBY_INPUTSLOT:
		num = add_param_char(ptr_param, "CNInputSelect", "InputSlot");
		ptr_param += num;
		list_num += num;
		break;
	case SELECTBY_MEDIATYPE:
		num = add_param_char(ptr_param, "CNInputSelect", "MediaType");
		ptr_param += num;
		list_num += num;
		break;
	default:
		break;
	}

	while(1){
		if(strcmp(tmp->name, "Duplex") == 0){
			char *value;
			if(ppd_opt->duplex_valtype == DUPLEX_VALTYPE_TRUE){
				if(strcasecmp(tmp->current_option->name, "None") == 0)
					value = strdup("False");
				else
					value = strdup(tmp->current_option->name);
			}else{
				value = strdup(tmp->current_option->name);
			}
			num = add_param_char(ptr_param, tmp->name, value);
			ptr_param += num;
			list_num += num;
			free(value);
		}else if(strcmp(tmp->name, "Booklet") == 0){
			char *value;
			if(strcasecmp(tmp->current_option->name, "None") == 0)
				value = strdup("False");
			else
				value = strdup(tmp->current_option->name);
			num = add_param_char(ptr_param, tmp->name, value);
			ptr_param += num;
			list_num += num;
			free(value);
		}else if(strcmp(tmp->name, "BindEdge") == 0){
			if(GetActiveBooklet(ppd_opt) != 1){
				char str[32];
				memset(str, 0, 32);
				if(strcmp(tmp->current_option->name, "None") == 0){
					strncpy(str, tmp->current_option->name, 31);
					num = add_param_char(ptr_param, tmp->name, str);
					ptr_param += num;
					list_num += num;
				}else{
					num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
					ptr_param += num;
					list_num += num;
					if(ppd_opt->us_type)
						num = add_param_double(ptr_param, "CNBindEdgeShift", ppd_opt->gutter_value_d);
					else
						num = add_param_int(ptr_param, "CNBindEdgeShift", ppd_opt->gutter_value);
					ptr_param += num;
					list_num += num;
				}
			}
		}else if(strcmp(tmp->name, "CNJobExecMode") == 0){
			if(strcmp(tmp->current_option->name, "secured") == 0){
				num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
				ptr_param += num;
				list_num += num;
#ifndef _OPAL
				if(strlen(ppd_opt->special->doc_name) != 0){
					num = add_param_char(ptr_param, "CNDocName", ppd_opt->special->doc_name);
					ptr_param += num;
					list_num += num;
				}
#else
				if((ppd_opt->special->doc_name != NULL) && (strlen(ppd_opt->special->doc_name) != 0)){
					num = add_param_char(ptr_param, "CNDocName", ppd_opt->special->doc_name);
					ptr_param += num;
					list_num += num;
				}
#endif
				num = add_param_char(ptr_param, "CNUsrName", ppd_opt->special->usr_name);
				ptr_param += num;
				list_num += num;
				num = add_param_char(ptr_param, "CNSecuredPrint", ppd_opt->special->passwd_array);
				ptr_param += num;
				list_num += num;
			}else if(strcmp(tmp->current_option->name, "store") == 0){
				enable_jobnote = 0;
				num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
				ptr_param += num;
				list_num += num;
				if(ppd_opt->special->data_name == 1){
					if(data->file_name != NULL){
						num = add_param_char(ptr_param, "CNDocName", data->file_name);
						ptr_param += num;
						list_num += num;
					}
				}else{
#ifndef _OPAL
					if(strlen(ppd_opt->special->enter_name) != 0){
						num = add_param_char(ptr_param, "CNDocName", ppd_opt->special->enter_name);
						ptr_param += num;
						list_num += num;
					}
#else
					if((ppd_opt->special->enter_name != NULL) && (strlen(ppd_opt->special->enter_name) != 0)){
						num = add_param_char(ptr_param, "CNDocName", ppd_opt->special->enter_name);
						ptr_param += num;
						list_num += num;
					}
#endif
				}
#ifndef __APPLE__
				num = add_param_int(ptr_param, "CNMailBox", ppd_opt->special->box_num);
				ptr_param += num;
				list_num += num;
#else
				if(strlen(ppd_opt->special->box_num) != 0){
					num = add_param_array(ptr_param,"CNMailBox",ppd_opt->special->box_num);
					ptr_param += num;
					list_num += num;
				}
#endif
			}else if(strcasecmp(tmp->current_option->name, "Hold") == 0){
#ifndef __APPLE__
				enable_jobnote = 0;
#endif
				num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
				ptr_param += num;
				list_num += num;
				if(ppd_opt->special->holddata_name == 1){
#ifndef __APPLE__
					if(data->file_name != NULL){
						num = add_param_char(ptr_param, "CNDocName", data->file_name);
						ptr_param += num;
						list_num += num;
					}
#else
					num = add_param_char(ptr_param, "CNDocName", data->file_name);
					ptr_param += num;
					list_num += num;
#endif
				}else{
#ifndef __APPLE__
					if(strlen(ppd_opt->special->hold_name) != 0){
						num = add_param_char(ptr_param, "CNDocName", ppd_opt->special->hold_name);
						ptr_param += num;
						list_num += num;
					}
#else
					num = add_param_char(ptr_param, "CNDocName", ppd_opt->special->hold_name);
					ptr_param += num;
					list_num += num;
#endif
				}
			}else{
				num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
				ptr_param += num;
				list_num += num;
			}
		}else if(strcmp(tmp->name, "CNCopySetNumbering") == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if(strcmp(tmp->current_option->name, "True") == 0){
				num = add_param_int(ptr_param, "CNStartingNumber", ppd_opt->startnum_value);
				ptr_param += num;
				list_num += num;
			}
		}else if(strcmp(tmp->name, "PageSize") == 0){
			if(strcmp(tmp->current_option->name, "Custom") == 0){
				char *custom = NULL;
				custom = MakeCustomValue(data, "CNPaperWidth", "CNPaperHeight");
				num = add_param_char(ptr_param, tmp->name, custom);
				ptr_param += num;
				list_num += num;
				free(custom);
			}else{
				num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
				ptr_param += num;
				list_num += num;
			}
#ifdef __APPLE__
		}else if(strcmp(tmp->name, kPPD_Items_CNColorMode) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if(ppd_opt->printer_type == PRINTER_TYPE_PS){
				if(strcmp(tmp->current_option->name, "mono") == 0)
					num = add_param_char(ptr_param, "ColorModel", "Gray");
				else
					num = add_param_char(ptr_param, "ColorModel", "RGB");
				ptr_param += num;
				list_num += num;
			}
#endif
		}else if(strcmp(tmp->name, kPPD_Items_CNShiftStartPrintPosition) == 0){
			char *val;
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if(strcmp(tmp->current_option->name, "True") == 0){
				if((val = GetUIValue(data, "CNEnableDetailShiftPosition")) != NULL){
					if(strcasecmp(val,"True") == 0){
						if(ppd_opt->shift_pos_type == 1){
							num = add_param_double(ptr_param, kPPD_Items_Device_CNShiftFrLongEdge, ppd_opt->detail_shift_front_long);
							ptr_param += num;
							list_num += num;
							num = add_param_double(ptr_param, kPPD_Items_Device_CNShiftFrShortEdge, ppd_opt->detail_shift_front_short);
							ptr_param += num;
							list_num += num;
							num = add_param_double(ptr_param, kPPD_Items_Device_CNShiftBkLongEdge, ppd_opt->detail_shift_back_long);
							ptr_param += num;
							list_num += num;
							num = add_param_double(ptr_param, kPPD_Items_Device_CNShiftBkShortEdge, ppd_opt->detail_shift_back_short);
							ptr_param += num;
							list_num += num;
						}else if(ppd_opt->shift_pos_type == 2){
							num = add_param_double(ptr_param, kPPD_Items_Device_CNShiftUpwards, ppd_opt->detail_shift_upwards);
							ptr_param += num;
							list_num += num;
							num = add_param_double(ptr_param, kPPD_Items_Device_CNShiftRight, ppd_opt->detail_shift_right);
							ptr_param += num;
							list_num += num;
						}
					}
				}
				if((val == NULL) || (strcasecmp(val,"False") == 0)){
					if(ppd_opt->shift_pos_type == 1){
						num = add_param_int(ptr_param, kPPD_Items_Device_CNShiftFrLongEdge, ppd_opt->shift_front_long);
						ptr_param += num;
						list_num += num;
						num = add_param_int(ptr_param, kPPD_Items_Device_CNShiftFrShortEdge, ppd_opt->shift_front_short);
						ptr_param += num;
						list_num += num;
						num = add_param_int(ptr_param, kPPD_Items_Device_CNShiftBkLongEdge, ppd_opt->shift_back_long);
						ptr_param += num;
						list_num += num;
						num = add_param_int(ptr_param, kPPD_Items_Device_CNShiftBkShortEdge, ppd_opt->shift_back_short);
						ptr_param += num;
						list_num += num;
					}else if(ppd_opt->shift_pos_type == 2){
						num = add_param_int(ptr_param, kPPD_Items_Device_CNShiftUpwards, ppd_opt->shift_upwards);
						ptr_param += num;
						list_num += num;
						num = add_param_int(ptr_param, kPPD_Items_Device_CNShiftRight, ppd_opt->shift_right);
						ptr_param += num;
						list_num += num;
					}
				}
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNOutputPartition) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if(strcmp(tmp->current_option->name, "offset") == 0){
				char *val;
				if((val = GetUIValue(data, "EnableCNOffsetNum")) != NULL){
					if(strcasecmp(val,"True") == 0){
						num = add_param_int(ptr_param, kPPD_Items_Device_CNOffsetNum, ppd_opt->offset_num);
						ptr_param += num;
						list_num += num;
					}
				}
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNDisplacementCorrection) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if(strcasecmp(tmp->current_option->name, "Manual") == 0){
				num = add_param_double(ptr_param, kPPD_Items_CNGutterShiftNum, ppd_opt->guttershiftnum_value_d);
				ptr_param += num;
				list_num += num;
			}
		}else if(strcmp(tmp->name, kPPD_Items_MediaType) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			{
				char *val;
				if((val = GetUIValue(data, "CNEnableMediaBrand")) != NULL){
					if(strcasecmp(val,"True") == 0){
						if((ppd_opt->media_brand != NULL) && (ppd_opt->media_brand->cur_item != NULL)){
							num = add_param_int(ptr_param, kPPD_Items_Device_CNMediaLibraryID, ppd_opt->media_brand->cur_item->id);
							ptr_param += num;
							list_num += num;
							num = add_param_int(ptr_param, kPPD_Items_Device_CNMediaShape, ppd_opt->media_brand->cur_item->shape);
							ptr_param += num;
							list_num += num;
						}
					}
				}
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNSheetForInsertion) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			{
				char *val;
				if((val = GetUIValue(data, "CNEnableMediaBrand")) != NULL){
					if(strcasecmp(val,"True") == 0){
						if((strstr(tmp->current_option->name, "TAB") != NULL)
						&& (ppd_opt->media_brand != NULL)
						&& (ppd_opt->media_brand->cur_ins_item != NULL)){
							num = add_param_int(ptr_param, kPPD_Items_Device_CNInsertMediaLibraryID, ppd_opt->media_brand->cur_ins_item->id);
							ptr_param += num;
							list_num += num;
						}
					}
				}
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNInterleafMediaType) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			{
				char *val;
				if((val = GetUIValue(data, "CNEnableMediaBrand")) != NULL){
					if(strcasecmp(val,"True") == 0){
						if((ppd_opt->media_brand != NULL) && (ppd_opt->media_brand->cur_interleaf_item != NULL)){
							num = add_param_int(ptr_param, kPPD_Items_Device_CNInterleafMediaLibraryID, ppd_opt->media_brand->cur_interleaf_item->id);
							ptr_param += num;
							list_num += num;
						}
					}
				}
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNPBindCoverMediaType) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			{
				char *val;
				if((val = GetUIValue(data, "CNEnableMediaBrand")) != NULL){
					if(strcasecmp(val,"True") == 0){
						if((ppd_opt->media_brand != NULL) && (ppd_opt->media_brand->cur_pb_cover_item != NULL)){
							num = add_param_int(ptr_param, kPPD_Items_Device_CNPBindCoverMediaLibraryID, ppd_opt->media_brand->cur_pb_cover_item->id);
							ptr_param += num;
							list_num += num;
						}
					}
				}
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNInsertSheet) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if(strcmp(tmp->current_option->name, "True") == 0){
				if(ppd_opt->ins_pos != NULL){
					num = add_param_array(ptr_param, kPPD_Items_Device_CNInsertPos, ppd_opt->ins_pos);
					ptr_param += num;
					list_num += num;
				}
				if(ppd_opt->ins_pos_papersource != NULL){
					num = add_param_array(ptr_param, kPPD_Items_Device_CNInsertPosPaperSource, ppd_opt->ins_pos_papersource);
					ptr_param += num;
					list_num += num;
				}
				if(ppd_opt->ins_pos_printon != NULL){
					num = add_param_array(ptr_param, kPPD_Items_Device_CNInsertPosPrinton, ppd_opt->ins_pos_printon);
					ptr_param += num;
					list_num += num;
				}
				if(ppd_opt->tab_ins_pos != NULL){
					num = add_param_array(ptr_param, kPPD_Items_Device_CNTabInsertPos, ppd_opt->tab_ins_pos);
					ptr_param += num;
					list_num += num;
				}
				if(ppd_opt->tab_ins_pos_papersource != NULL){
					num = add_param_array(ptr_param, kPPD_Items_Device_CNTabInsertPosPaperSource, ppd_opt->tab_ins_pos_papersource);
					ptr_param += num;
					list_num += num;
				}
				if(ppd_opt->tab_ins_pos_printon != NULL){
					num = add_param_array(ptr_param, kPPD_Items_Device_CNTabInsertPosPrinton, ppd_opt->tab_ins_pos_printon);
					ptr_param += num;
					list_num += num;
				}
				char *val;
				if((val = GetUIValue(data, "CNMultiPaperSourceInsertTab")) != NULL){
					if(strcasecmp(val,"True") == 0){
						num = add_param_int(ptr_param, kPPD_Items_Device_CNTabInsertMultiNumber, ppd_opt->tab_ins_multi_number);
						ptr_param += num;
						list_num += num;
						if(ppd_opt->tab_ins_multi_papersource != NULL){
							num = add_param_array(ptr_param, kPPD_Items_Device_CNTabInsertMultiPaperSource, ppd_opt->tab_ins_multi_papersource);
							ptr_param += num;
							list_num += num;
						}
						if(ppd_opt->tab_ins_multi_papertype != NULL){
							num = add_param_array(ptr_param, kPPD_Items_Device_CNTabInsertMultiPaperType, ppd_opt->tab_ins_multi_papertype);
							ptr_param += num;
							list_num += num;
						}
					}
				}
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNOverlay) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if((strcmp(tmp->current_option->name, "UseOverlay") == 0)
			|| (strcmp(tmp->current_option->name, "ClearCoatingForm") == 0)){
				num = add_param_char(ptr_param, kPPD_Items_Device_CNFormHandle, data->ppd_opt->special->form_handle);
				ptr_param += num;
				list_num += num;
			}
			else if(strcmp(tmp->current_option->name, "CreatFormFile") == 0){
				num = add_param_char(ptr_param, kPPD_Items_Device_CNOverlayFileName, data->ppd_opt->special->form_name);
				ptr_param += num;
				list_num += num;
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNAdjustTrim) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if((strcmp(tmp->current_option->name, "Manual") == 0)||(strcmp(tmp->current_option->name, "ForeOnly") == 0)){
				char *val;
				if(((val = FindCurrOpt(ppd_opt->items_list, kPPD_Items_CNTopBottomTrimmer)) != NULL) && (strcasecmp(val, "None") != 0)){
					num = add_param_double(ptr_param, kPPD_Items_Device_CNAdjustForeTrimNum, data->ppd_opt->adjust_frtrim_num);
					ptr_param += num;
					list_num += num;
					num = add_param_double(ptr_param, kPPD_Items_Device_CNAdjustTopBottomTrimNum, data->ppd_opt->adjust_tbtrim_num);
					ptr_param += num;
					list_num += num;
				}else{
					num = add_param_double(ptr_param, kPPD_Items_Device_CNAdjustTrimNum, data->ppd_opt->adjust_trim_num);
					ptr_param += num;
					list_num += num;
				}
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNSendTime) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if(strcmp(tmp->current_option->name, "True") == 0){
				num = add_param_char(ptr_param, kPPD_Items_Device_CNSendTimeNum, data->ppd_opt->fax_setting->send_time);
				ptr_param += num;
				list_num += num;
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNUseOutsideLineNum) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if(strcmp(tmp->current_option->name, "True") == 0){
				num = add_param_char(ptr_param, kPPD_Items_Device_CNOutsideLineNumber, data->ppd_opt->fax_setting->outside_line_number);
				ptr_param += num;
				list_num += num;
				num = add_param_char(ptr_param, kPPD_Items_Device_CNOutsideLineNumberIntra, data->ppd_opt->fax_setting->outside_line_number_intra);
				ptr_param += num;
				list_num += num;
				num = add_param_char(ptr_param, kPPD_Items_Device_CNOutsideLineNumberNgn, data->ppd_opt->fax_setting->outside_line_number_ngn);
				ptr_param += num;
				list_num += num;
				num = add_param_char(ptr_param, kPPD_Items_Device_CNOutsideLineNumberNgnMyNumber, data->ppd_opt->fax_setting->outside_line_number_ngnmynum);
				ptr_param += num;
				list_num += num;
				num = add_param_char(ptr_param, kPPD_Items_Device_CNOutsideLineNumberVoip, data->ppd_opt->fax_setting->outside_line_number_voip);
				ptr_param += num;
				list_num += num;
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNPBindCoversheet) == 0){
			if(strcmp(tmp->current_option->name, "Custom") == 0){
				char *custom = NULL;
				custom = MakeCustomValue(data, "CNBindCoverPaperWidth", "CNBindCoverPaperHeight");
				num = add_param_char(ptr_param, tmp->name, custom);
				ptr_param += num;
				list_num += num;
				free(custom);
			}else{
				num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
				ptr_param += num;
				list_num += num;
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNPBindMainPaper) == 0){
			if(strcmp(tmp->current_option->name, "Custom") == 0){
				char *custom = NULL;
				custom = MakeCustomValue(data, "CNBindMainPaperWidth", "CNBindMainPaperHeight");
				num = add_param_char(ptr_param, tmp->name, custom);
				ptr_param += num;
				list_num += num;
				free(custom);
			}else{
				num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
				ptr_param += num;
				list_num += num;
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNPBindFinishing) == 0){
			if(strcmp(tmp->current_option->name, "Custom") == 0){
				char *custom = NULL;
				custom = MakeCustomValue(data, "CNBindFinPaperWidth", "CNBindFinPaperHeight");
				num = add_param_char(ptr_param, tmp->name, custom);
				ptr_param += num;
				list_num += num;
				free(custom);
			}else{
				num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
				ptr_param += num;
				list_num += num;
			}
		}else if(strcmp(tmp->name, kPPD_Items_InputSlot) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if(strcmp(tmp->current_option->name, "PaperName") == 0){
				if(ppd_opt->feed_paper_name != NULL){
					num = add_param_char(ptr_param, kPPD_Items_Device_CNFeedPaperName, ppd_opt->feed_paper_name);
					ptr_param += num;
					list_num += num;
				}
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNPBindSpecifyFinishingBy) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if(strcmp(tmp->current_option->name, "TrimWidth") == 0){
				num = add_param_double(ptr_param, kPPD_Items_Device_CNPBindFinishForeTrimNum, data->ppd_opt->pb_fin_fore_trim_num);
				ptr_param += num;
				list_num += num;
				num = add_param_double(ptr_param, kPPD_Items_Device_CNPBindFinishTopBottomTrimNum, data->ppd_opt->pb_fin_topbtm_trim_num);
				ptr_param += num;
				list_num += num;
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNSpecifyNumOfCopiesStack) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if(strcmp(tmp->current_option->name, "True") == 0){
				num = add_param_int(ptr_param, kPPD_Items_Device_CNStackCopiesNum, ppd_opt->stack_copies_num);
				ptr_param += num;
				list_num += num;
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNSorterFinish) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if(strcmp(tmp->current_option->name, "UserSeparateDynamic") == 0){
				if(ppd_opt->bin_name != NULL){
					num = add_param_char(ptr_param, kPPD_Items_Device_CNBinName, ppd_opt->bin_name);
					ptr_param += num;
					list_num += num;
				}
			}
			if(strcmp(tmp->current_option->name, "UserSeparateStatic") == 0){
				if(ppd_opt->bin_name_array != NULL){
					num = add_param_array(ptr_param, kPPD_Items_Device_CNBinNameArray, ppd_opt->bin_name_array);
					ptr_param += num;
					list_num += num;
				}
			}
		}else if(strcmp(tmp->name, kPPD_Items_CNSaddlePress) == 0){
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
			if(strcasecmp(tmp->current_option->name, "True") == 0){
				num = add_param_int(ptr_param, kPPD_Items_Device_CNSaddlePressAdjustment, ppd_opt->saddle_press_adjust);
				ptr_param += num;
				list_num += num;
			}
		}else{
			num = add_param_char(ptr_param, tmp->name, tmp->current_option->name);
			ptr_param += num;
			list_num += num;
		}
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
		if(tmp->current_option == NULL){
			if(tmp->next == NULL)
				break;
			tmp = tmp->next;
		}
	}
	{
		char *val;
		if((val = GetUIValue(data, "EnableCNTabShift")) != NULL){
			if(strcasecmp(val,"True") == 0){
				num = add_param_double(ptr_param, kPPD_Items_Device_CNTabShift, ppd_opt->tab_shift);
				ptr_param += num;
				list_num += num;
			}
		}
		if((val = GetUIValue(data, "EnableCNInsertTabShift")) != NULL){
			if(strcasecmp(val,"True") == 0){
				num = add_param_double(ptr_param, kPPD_Items_Device_CNInsertTabShift, ppd_opt->ins_tab_shift);
				ptr_param += num;
				list_num += num;
			}
		}
		if((val = GetUIValue(data, "EnableCNSender")) != NULL){
			if(strcasecmp(val,"True") == 0){
				num = add_param_char(ptr_param, kPPD_Items_Device_CNSender, data->ppd_opt->fax_setting->sender_name);
				ptr_param += num;
				list_num += num;
			}
		}
	}
	if(ppd_opt->special != NULL){
		if(isUseJobAccount(ppd_opt)){
#ifdef	__APPLE__
			char tmp[32];
			if(strlen(ppd_opt->special->job_account_id) && strlen(ppd_opt->special->job_account_passwd)){
				snprintf(tmp, 31, "%s_%s", ppd_opt->special->job_account_id, ppd_opt->special->job_account_passwd);
				num = add_param_char(ptr_param, "CNJobAccount", tmp);
				ptr_param += num;
				list_num += num;
			}
			else if(strlen(ppd_opt->special->job_account_id) && !strlen(ppd_opt->special->job_account_passwd)){
				snprintf(tmp, 31, "%s_", ppd_opt->special->job_account_id);
				num = add_param_char(ptr_param, "CNJobAccount", tmp);
				ptr_param += num;
				list_num += num;
			}
#endif
			if(ppd_opt->special->show_disable_job_account_bw == 1){
				char tmp_job[32];

				if(ppd_opt->special->disable_job_account_bw == 1){
					snprintf(tmp_job, 31, "%s", "True");
				}else{
					snprintf(tmp_job, 31, "%s", "False");
				}
				num = add_param_char(ptr_param, "CNDisableJobAccountingBW", tmp_job);
				ptr_param += num;
				list_num += num;
			}
		}
		if(isUseUserManagement(ppd_opt)){
			char *val;
			val = FindCurrOpt(ppd_opt->items_list, kPPD_Items_CNJobExecMode);
			if((val == NULL) || (strcasecmp(val, "secured") != 0)) {
				num = add_param_char(ptr_param, kPPD_Items_Device_CNUsrName, ppd_opt->special->usr_name);
				ptr_param += num;
				list_num += num;
			}
			num = add_param_char(ptr_param, kPPD_Items_Device_CNUsrPassword, ppd_opt->special->usr_passwd);
			ptr_param += num;
			list_num += num;
		}
	}
	if((ppd_opt->job_note != NULL) && (enable_jobnote == 1)){
#ifndef __APPLE__
		if(strlen(ppd_opt->job_note->note) != 0){
#endif
			num = add_param_char(ptr_param, kPPD_Items_Device_CNJobNote, ppd_opt->job_note->note);
			ptr_param += num;
			list_num += num;
#ifndef __APPLE__
		}
		if(strlen(ppd_opt->job_note->details) != 0){
#endif
			num = add_param_char(ptr_param, kPPD_Items_Device_CNJobDetails, ppd_opt->job_note->details);
			ptr_param += num;
			list_num += num;
#ifndef __APPLE__
		}
#endif
	}
	if(ppd_opt->uivalue != NULL){
		UIValueList *val_tmp = ppd_opt->uivalue;
		while(1){
			if(val_tmp->opt_flag){
				num = add_param_char(ptr_param, val_tmp->key, val_tmp->value);
				ptr_param += num;
				list_num += num;
			}
			if(val_tmp->next == NULL)
				break;
			val_tmp = val_tmp->next;
		}
	}
	return list_num;
}

int make_cups_param(cngplpData *data, char **param_list, int color_mode, int lpr_type)
{
	CupsOptions *cups_opt = data->cups_opt;
	char **ptr_param;
	int num = 0, i;
	int list_num = 0;
#ifndef	__APPLE__
	char str[128], *start, *end;
#endif
	CupsOptVal *tmp;

	ptr_param = param_list;
	tmp = cups_opt->common->option;
	while(1){
#ifndef	__APPLE__
		if(strcmp("page-set", tmp->option) == 0){
			num = add_param_char(ptr_param, tmp->option, tmp->value);
			ptr_param += num;
			list_num += num;
		}else if(strcmp("page-ranges", tmp->option) == 0){
			if(strcmp(tmp->value, "-") == 0){
				num = add_param_char(ptr_param, tmp->option, "1-");
				ptr_param += num;
				list_num += num;
			}else{
				num = add_param_char(ptr_param, tmp->option, tmp->value);
				ptr_param += num;
				list_num += num;
			}
#else
		if(strcmp("page-set", tmp->option) == 0){
			if(strcmp("odd", tmp->value) == 0 || strcmp("even", tmp->value) == 0){
				num = add_param_char(ptr_param, tmp->option, tmp->value);
				ptr_param += num;
				list_num += num;
			}
		}else if(strcmp("page-ranges", tmp->option) == 0){
			CupsOptVal *range;
			range = GetCupsOptVal(cups_opt->common->option, "page-set");
			if(strcmp(range->value, "range") == 0 && strlen(tmp->value)){
				num = add_param_char(ptr_param, tmp->option, tmp->value);
				ptr_param += num;
				list_num += num;
			}
#endif
		}else if(strcmp("outputorder", tmp->option) == 0){
			if(lpr_type || strcmp("reverse", tmp->value) == 0){
				num = add_param_char(ptr_param, tmp->option, tmp->value);
				ptr_param += num;
				list_num += num;
			}
		}else if(strstr(tmp->option, "job-sheets-") == NULL){
			num = add_param_char(ptr_param, tmp->option, tmp->value);
			ptr_param += num;
			list_num += num;
		}
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
	}
#ifndef	__APPLE__
	memset(str, 0,128);
	tmp = GetCupsOptVal(cups_opt->common->option, "job-sheets-start");
	start = tmp ? tmp->value : "none";
	tmp = GetCupsOptVal(cups_opt->common->option, "job-sheets-end");
	end = tmp ? tmp->value : "none";
	snprintf(str, 127, "%s,%s", start, end);
	num = add_param_char(ptr_param, "job-sheets", str);
	ptr_param += num;
	list_num += num;
#endif

	tmp = NULL;
	tmp = GetCupsOptVal(cups_opt->common->option, "Filter");
	for(i = 0; g_filter_options[i] != NULL; i++){
		if(tmp == NULL)
			break;
		if(strcmp(tmp->value, g_filter_options[i]) == 0)
			break;
	}

	switch(i){
	case FILTER_IMAGE:
		tmp = cups_opt->image->option;
		if(tmp != NULL){
			while(1){
				if(strcmp("hue", tmp->option) == 0
				|| strcmp("saturation", tmp->option) == 0){
					if(color_mode){
						num = add_param_char(ptr_param, tmp->option, tmp->value);
						ptr_param += num;
						list_num += num;
					}
				}else if(strcmp("ppi", tmp->option) != 0
				&& strcmp("scaling", tmp->option) != 0
				&& strcmp("natural-scaling", tmp->option) != 0){
					num = add_param_char(ptr_param, tmp->option, tmp->value);
					ptr_param += num;
					list_num += num;
				}
				if(tmp->next == NULL)
					break;
				tmp = tmp->next;
			}
		}
		switch(cups_opt->image->img_reso_scale){
		case 0:
			tmp = GetCupsOptVal(cups_opt->image->option, "ppi");
			break;
		case 1:
			tmp = GetCupsOptVal(cups_opt->image->option, "scaling");
			break;
		case 2:
			tmp = GetCupsOptVal(cups_opt->image->option, "natural-scaling");
			break;
		}
		if(tmp != NULL){
			num = add_param_char(ptr_param, tmp->option, tmp->value);
			ptr_param += num;
			list_num += num;
		}
		break;
	case FILTER_TEXT:
		tmp = cups_opt->text->option;
		if(tmp != NULL){
			while(1){
				if(strstr(tmp->option, "page-") != NULL){
					if(cups_opt->text->margin_on){
						num = add_param_char(ptr_param, tmp->option, tmp->value);
						ptr_param += num;
						list_num += num;
					}
				}else if(strcmp("prettyprint", tmp->option) == 0){
					num = add_param_char(ptr_param, tmp->option, tmp->value);
					ptr_param += num;
					list_num += num;
				}else{
					num = add_param_char(ptr_param, tmp->option, tmp->value);
					ptr_param += num;
					list_num += num;
				}
				if(tmp->next == NULL)
					break;
				tmp = tmp->next;
			}
		}
		break;
	case FILTER_HPGL:
		tmp = GetCupsOptVal(cups_opt->hpgl->option, "blackplot");
		if(tmp != NULL && color_mode){
			if(strcmp(tmp->value, "true") == 0){
				num = add_param_char(ptr_param, tmp->option, tmp->value);
				ptr_param += num;
				list_num += num;
			}
		}
		tmp = GetCupsOptVal(cups_opt->hpgl->option, "fitplot");
		if(tmp != NULL){
			if(strcmp(tmp->value, "true") == 0){
				num = add_param_char(ptr_param, tmp->option, tmp->value);
				ptr_param += num;
				list_num += num;
			}
		}
		tmp = GetCupsOptVal(cups_opt->hpgl->option, "penwidth");
		if(tmp != NULL){
			num = add_param_char(ptr_param, tmp->option, tmp->value);
			ptr_param += num;
			list_num += num;
		}
		break;
	default:
		break;
	}

	return list_num;
}

int make_lpr_param(cngplpData *data, char **param_list, int lpr_type)
{
	char **ptr_param;
	int num = 0, type = 0;
	ptr_param = param_list;

	if(lpr_type){
		*ptr_param = strdup("lpr");
		ptr_param++;
		num++;
		*ptr_param = strdup("-P");
		ptr_param++;
		num++;
		type = 0;
	}else{
		*ptr_param = strdup("lpoptions");
		ptr_param++;
		num++;
		*ptr_param = strdup("-p");
		ptr_param++;
		num++;
		type = 1;
	}

	*ptr_param = strdup(data->curr_printer);
	ptr_param++;
	num++;
	num += make_cups_param(data, ptr_param, data->ppd_opt->color_mode, type);
	ptr_param += num - 3;

	num += make_ppd_param(data, ptr_param, type);

	if(lpr_type){
		param_list[num++] = strdup(data->file_name);
		param_list[num++] = NULL;
	}else{
		param_list[num] = NULL;
		num++;
	}
	return num;
}

void exec_remove_option(cngplpData *data)
{
#ifndef _OPAL
	char **param_list;
	int num = 0, printer_num = 0;
	cups_dest_t *dests;
	cups_dest_t *curr_printer;
	cups_option_t *opt;

	printer_num = cupsGetDests(&dests);
	curr_printer = cupsGetDest(data->curr_printer, NULL, printer_num, dests);

	if(!curr_printer){
		fprintf(stderr, "Failed to get current printer info.\n");
		if(dests)
			cupsFreeDests(printer_num, dests);
		return;
	}

	opt = curr_printer->options;

	param_list = (char **)malloc(sizeof(char *) * 256);
	if(param_list != NULL){
		int pid = 0, i;

		param_list[num++] = strdup("lpoptions");
		param_list[num++] = strdup("-p");
		param_list[num++] = strdup(data->curr_printer);
		for(i = 0; i < curr_printer->num_options; i++){
			param_list[num++] = strdup("-r");
			param_list[num++] = strdup(opt->name);
			opt++;
		}

		param_list[num] = NULL;

		if((pid = fork()) != -1){
			if(pid == 0){
				char path[128];
				memset(path, 0, 128);
				strncpy(path, EXEC_PATH, 127);
				strncat(path, "/", 127 - strlen(path));
				strncat(path, EXEC_FILE_LPOPTIONS, 127 - strlen(path));
				execv(path, param_list);
			}else{
				waitpid(pid, NULL, 0);
			}
		}

		for(i = 0; i < num; i++){
			MemFree(param_list[i]);
		}
		MemFree(param_list);
	}

	cupsFreeDests(printer_num, dests);
#endif
}

void exec_lpr(cngplpData *data, int lpr_type)
{
	char **param_list;

	if(!lpr_type)
		exec_remove_option(data);

#ifndef __APPLE__
	SaveJobAccount(data);
#endif

	param_list = (char **)malloc(sizeof(char *) * 256);
	if(param_list != NULL){
		int pid, num = 0, i;
		num = make_lpr_param(data, param_list, lpr_type);

		pid = fork();

		if(pid == -1)
			return;

		if(pid == 0){
			char path[128];
			memset(path, 0, 128);
			strncpy(path, EXEC_PATH, 127);
			strncat(path, "/", 127 - strlen(path));
			if(lpr_type){
				strncat(path, EXEC_FILE_LPR, 127 - strlen(path));
				execv(path, param_list);
			}else{
				strncat(path, EXEC_FILE_LPOPTIONS, 127 - strlen(path));
				execv(path, param_list);
			}
		}else{
			waitpid(pid, NULL, 0);
		}

		for(i = 0; param_list[i] != NULL; i++){
			UI_DEBUG("[%2d]:[%s]\n", i, param_list[i]);
		}
		for(i = 0; i < num; i++){
			MemFree(param_list[i]);
		}
		MemFree(param_list);
	}
}

void exec_set_def_printer(cngplpData *data)
{
	char **param_list;

	param_list = (char **)malloc(sizeof(char *) * 4);
	if(param_list != NULL){
		int pid = 0, i;

		param_list[0] = strdup("lpoptions");
		param_list[1] = strdup("-d");
		param_list[2] = strdup(data->curr_printer);
		param_list[3] = NULL;
		if((pid = fork()) != -1){
			if(pid == 0){
				char path[128];
				memset(path, 0, 128);
				strncpy(path, EXEC_PATH, 127);
				strncat(path, "/", 127 - strlen(path));
				strncat(path, EXEC_FILE_LPOPTIONS, 127 - strlen(path));
				execv(path, param_list);
			}else{
				waitpid(pid, NULL, 0);
			}
		}
		for(i = 0; i < 4; i++){
			MemFree(param_list[i]);
		}
		MemFree(param_list);
	}
}

char* AddKeyValue(char *plist, char *str)
{
	char *tmp = NULL;

	if(plist == NULL){
		tmp = strdup(str);
	}else{
		int size = strlen(plist) + strlen(str) + 2;
		tmp = (char *)malloc(size);
		memset(tmp, 0, size);
		cngplp_util_strcpy(tmp, plist);
		cngplp_util_strcat(tmp, str);
		MemFree(plist);
	}
	return tmp;
}

char *GetKeyValue(cngplpData *data)
{
	char **plist, **tmp;
	char *str = NULL;
	int num = 0, i;
	int colormode = data->ppd_opt->color_mode;

	plist = (char **)malloc(sizeof(char *) * 1024);
	if(plist != NULL){
		tmp = plist;
#ifndef _OPAL
		*tmp = strdup("CUPS:");
		tmp++;
		num++;
#endif
		num += make_cups_param(data, tmp, colormode, 0);
#ifndef _OPAL
		tmp += num - 1;
		*tmp = strdup(";PPD:");
		tmp++;
		num++;
#else
		tmp += num;
#endif
		num += make_ppd_param(data, tmp, 0);
		tmp[num++] = NULL;
	}

	for(i = 0; i < num - 1; i++){
		if(strcmp(plist[i], "-o") != 0){
			str = AddKeyValue(str, plist[i]);
		}else{
#ifndef _OPAL
			if(i != 1  && strcmp(plist[i - 1], ";PPD:") != 0)
				str = AddKeyValue(str, ";");
#else
			if(i != 0)
				str = AddKeyValue(str, " ");
#endif
		}
	}

	for(i = 0; i < num - 1; i++){
		MemFree(plist[i]);
	}
	MemFree(plist);

	return str;
}

char* MakeCustomValue(cngplpData *data, char *uival_w, char *uival_h)
{
	char *value;
	char *width = NULL, *height = NULL;
	int len = 0;

	if(data->ppd_opt->custom_size == 0)
		return "Custom.595x842";

	if((width = GetUIValue(data, uival_w)) == NULL)
		width = "595";
	if((height = GetUIValue(data, uival_h)) == NULL)
		height = "842";

	len = 8 + strlen(width) + strlen(height);
	if((value = (char *)malloc(sizeof(char) * (len + 1))) == NULL)
		return "Custom.595x842";
	memset(value, 0, len + 1);
	snprintf(value, len + 1, "Custom.%sx%s", width, height);

	return value;
}

#ifndef __APPLE__

#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

#define	ACCOUNT_PATH "/etc/cngplp/account"
#define	ACCOUNT_FILE_TYPE_STATUS_READ 1
#define	ACCOUNT_FILE_TYPE_STATUS_WRITE 2
#define	ACCOUNT_FILE_TYPE_CONF_READ 3
#define	ACCOUNT_FILE_TYPE_CONF_WRITE 4

#define	ACCOUNT_FILE_STATUS "status"
#define	ACCOUNT_FILE_CONF ".conf"

#define	ACCOUNT_FILE_STATUS_NEW "status.new"
#define	ACCOUNT_FILE_CONF_NEW ".conf.new"

#define	MAX_BUFSIZE	512

#define	ACCOUNT_STATUS_FORMAT "<%s>%s</%s>\n"
#define	ACCOUNT_CONF_FORMAT_START "<%s>\n"
#define	ACCOUNT_CONF_FORMAT_ID "id=%s\n"
#define	ACCOUNT_CONF_FORMAT_PSWD "password=%s\n"
#define	ACCOUNT_CONF_FORMAT_END "</%s>\n"



static int file_write(int fd, char *line, int line_size)
{
	int w_bytes = 0;
	int offset = 0;

	fsync(fd);
	do{
		w_bytes = write(fd, line + offset, line_size - offset);
		if(w_bytes + offset == line_size)
			break;
		offset += w_bytes;
	}while(w_bytes + offset < line_size);
	sync();

	return 0;
}

static int get_line_from_buffer(char **line, char *buff, int offset, int max)
{
	int i;
	char *tmp = buff + offset;
	char *l_tmp = NULL;

	if(*line == NULL){
		l_tmp = (char *)calloc(max + 1, 1);
		if(l_tmp == NULL)
			return -2;
	}else{
		int len = strlen(*line) + max + 1;
		l_tmp = (char *)calloc(len , 1);
		if(l_tmp == NULL)
			return -2;
		strncpy(l_tmp, *line, strlen(*line));
		free(*line);
	}

	for(i = 0; offset + i < max; i++){
		if(*tmp == '\n' || *tmp == '\r' || *tmp == EOF){
			strncat(l_tmp, buff + offset, i);
			*line = l_tmp;
			if(*(tmp + 1) == '\n' || *(tmp + 1) == '\r' || *tmp == EOF)
				i++;
			return (i + 1);
		}
		tmp++;
	}

	strncat(l_tmp, buff + offset, max);
	*line = l_tmp;

	return -1;
}

int exist_file(char *file_name)
{
	struct stat info;
	int ret = 0;

	if(file_name != NULL){
		ret = stat(file_name, &info);
	}
	return (ret == 0) ? 0 : 1;
}

char* make_file_path(int type, char *user, char *filename)
{
	char path[256];

	memset(path, 0, 256);
	switch(type){
	case ACCOUNT_FILE_TYPE_STATUS_READ:
		strncpy(path, ACCOUNT_PATH, 255);
		strncat(path, "/", 255 - strlen(path));
		strncat(path, filename, 255 - strlen(path));
		if(exist_file(path))
			return NULL;
		break;
	case ACCOUNT_FILE_TYPE_STATUS_WRITE:
		strncpy(path, ACCOUNT_PATH, 255);
		strncat(path, "/", 255 - strlen(path));
		strncat(path, filename, 255 - strlen(path));
		break;
	case ACCOUNT_FILE_TYPE_CONF_READ:
		strncpy(path, ACCOUNT_PATH, 255);
		strncat(path, "/", 255 - strlen(path));
		if(user == NULL)
		{
			strncat(path, "root", 255 - strlen(path));
		}else{
			strncat(path, user, 255);
		}
		strncat(path, filename, 255 - strlen(path));
		if(exist_file(path))
			return NULL;
		break;
	case ACCOUNT_FILE_TYPE_CONF_WRITE:
		strncpy(path, ACCOUNT_PATH, 255);
		strncat(path, "/", 255 - strlen(path));
		if(user == NULL)
		{
			strncat(path, "root", 255 - strlen(path));
		}else{
			strncat(path, user, 255);
		}
		strncat(path, filename, 255 - strlen(path));
		break;
	default:
		break;
	}
	return strdup(path);
}

#if !defined(__APPLE__) && !defined(_OPAL)
static int get_account_status(char * const printer_name, char * const t_line)
{
	int n_ret = 0;
	unsigned int un_print_name_size = 0;
	char *buf_str = NULL;
	char str_printer_name[MAX_BUFSIZE];

	if( (printer_name == NULL) || (t_line == NULL) ) {
		return n_ret;
	}

	memset( str_printer_name, 0x00, MAX_BUFSIZE );

	snprintf( str_printer_name, MAX_BUFSIZE - 1, PRINTER_NAME_FORMAT_START, printer_name );
	un_print_name_size = strlen( str_printer_name );
	buf_str = t_line;
	buf_str += un_print_name_size;

	if( strncasecmp( buf_str, ACCOUNT_ON, strlen(ACCOUNT_ON) ) == 0 ) {
		n_ret = 1;
	}
	else {
		n_ret = 0;
	}
	return n_ret;
}
#else
int get_account_status(char *buff, int buf_size)
{
	char *ptr = NULL;
	char status[32], *p_sts = NULL;

	ptr = buff;
	while(1){
		if(*ptr == '\n' || *ptr == '\0')
			return 0;
		if(ptr - buff == buf_size - 1)
			return 0;
		if(*ptr == '>'){
			ptr++;
			break;
		}
		ptr++;
	}

	memset(status, 0, 32);
	p_sts = status;
	while(1){
		if(*ptr == '\n' || *ptr == '\0')
			break;
		if(p_sts - status == 31)
			break;
		if(*ptr == '<')
			break;
		*p_sts = *ptr;
		p_sts++;
		ptr++;
	}
	*p_sts = '\0';

	if(*status != '\0'){
		if(strcasecmp(status, "ON") == 0)
			return 1;
		else
			return 0;
	}

	return 0;
}
#endif

int check_account_status(char *printer)
{
	int fd;
	char *file = NULL;
	int status = 0;
	int offset = 0, l_bytes = 0, r_bytes = 0;
	char t_buf[MAX_BUFSIZE + 1];
	char *t_line = NULL;

	if(printer == NULL)
		return 0;

	memset(t_buf, 0, sizeof(t_buf));

	if((file = make_file_path(ACCOUNT_FILE_TYPE_STATUS_READ, NULL,
				ACCOUNT_FILE_STATUS)) == NULL)
		return 0;

	if((fd = open(file, O_RDONLY)) < 0)
		goto err;

	while((r_bytes = read(fd, t_buf, MAX_BUFSIZE))){
		if(r_bytes == -1){
			if(errno == EINTR)
				continue;
			else
				break;
		}

		offset = 0;

		while(r_bytes > offset){
			l_bytes = get_line_from_buffer(&t_line, t_buf, offset, MAX_BUFSIZE);
			if(l_bytes < 0){
				break;
			}

#if !defined(__APPLE__) && !defined(_OPAL)
			if((t_line[0] == '<') &&
			   (check_account_printer_name(printer, &t_line[0]) == 0))
			{
				status = get_account_status(printer, &t_line[0]);
#else
			if((t_line[0] == '<')
			&& strncmp(t_line + 1, printer, strlen(printer)) == 0)
			{
				status = get_account_status(t_line, MAX_BUFSIZE);
#endif
				free(t_line);
				close(fd);
				free(file);
				return status;
			}
			offset += l_bytes;
			if(t_line != NULL){
				free(t_line);
				t_line = NULL;
			}
		}
		memset(t_buf, 0, sizeof(t_buf));
	}

	if(t_line)
		free(t_line);
	close(fd);
err:
	free(file);
	return 0;
}

int get_account_conf(char *printer, char *user, char *id, char *ps, int size)
{
	int fd;
	char *file = NULL;
	int is_curr = 0;
	int offset = 0, l_bytes = 0, r_bytes = 0;
	char t_buf[MAX_BUFSIZE + 1];
	char *t_line = NULL;

	memset(t_buf, 0, sizeof(t_buf));

	if(printer == NULL)
		return 0;

	if((file = make_file_path(ACCOUNT_FILE_TYPE_CONF_READ, user,
				ACCOUNT_FILE_CONF)) == NULL)
		return 0;

	if((fd = open(file, O_RDONLY)) < 0)
		goto err;

	while((r_bytes = read(fd, t_buf, MAX_BUFSIZE))){
		if(r_bytes == -1){
			if(errno == EINTR)
				continue;
			else
				break;
		}

		offset = 0;

		while(r_bytes > offset){
			char *ptr = NULL;
			char *tmp = NULL;
			l_bytes = get_line_from_buffer(&t_line, t_buf, offset, MAX_BUFSIZE);
			if(l_bytes < 0){
				break;
			}

#if !defined(__APPLE__) && !defined(_OPAL)
			if((t_line[0] == '<') &&
			   (check_printer_name(printer, &t_line[0], PRINTER_NAME_FORMAT_START) == 0))
#else
			if((t_line[0] == '<')
			&& strncmp(t_line + 1, printer, strlen(printer)) == 0)
#endif
			{
				is_curr = 1;
			}
#if !defined(__APPLE__) && !defined(_OPAL)
			else if((t_line[0] == '<') && (t_line[1] == '/') &&
			        (check_printer_name(printer, &t_line[0], PRINTER_NAME_FORMAT_END) == 0))
#else
			else if(t_line[0] == '<' && t_line[1] == '/'
			&& strncmp(t_line + 2, printer, strlen(printer)) == 0)
#endif
			{
				if(is_curr == 1){
					close(fd);
					free(file);
					free(t_line);
					return is_curr;
				}
				is_curr = 0;
			}
#if !defined(__APPLE__) && !defined(_OPAL)
			else if((is_curr == 1) &&
			        (strncmp(t_line, "id=", strlen("id=")) == 0))
			{
				ptr = t_line;
#else
			else if(is_curr == 1
			&& (ptr = strstr(t_line, "id=")) != NULL)
			{
#endif
				while(1){
					if(*ptr == '\0' || *ptr == '\n')
						break;
					if(*ptr == '='){
						ptr++;
						break;
					}
					ptr++;
				}

				tmp = id;
				while(1){
					if(*ptr == '\0' || *ptr == '\n')
						break;
					if(tmp - id == size - 1)
						break;
					*tmp = *ptr;
					tmp++;
					ptr++;
				}
				*tmp = '\0';
			}
#if !defined(__APPLE__) && !defined(_OPAL)
			else if((is_curr == 1) &&
			   	    (strncmp(t_line, "password=", strlen("password=")) == 0))
			{
				ptr = t_line;
#else
			else if(is_curr == 1
			&& (ptr = strstr(t_line, "password=")) != NULL)
			{
#endif
				while(1){
					if(*ptr == '\0' || *ptr == '\n')
						break;
					if(*ptr == '='){
						ptr++;
						break;
					}
					ptr++;
				}

				tmp = ps;
				while(1){
					if(*ptr == '\0' || *ptr == '\n')
						break;
					if(tmp - ps == size - 1)
						break;
					*tmp = *ptr;
					tmp++;
					ptr++;
				}
				*tmp = '\0';
			}
			offset += l_bytes;
			if(t_line != NULL){
				free(t_line);
				t_line = NULL;
			}
		}
		memset(t_buf, 0, sizeof(t_buf));
	}

	if(t_line)
		free(t_line);

	close(fd);
	free(file);

	return is_curr;
err:
	free(file);
	return 0;
}

int
check_job_account(char *printer, char *user, char *id, char *ps, int buf_size)
{
	int ret = 0;

	if(printer == NULL)
		return 0;

	if((ret = check_account_status(printer)))
	{
		get_account_conf(printer, user, id, ps, buf_size);
	}
	return ret;
}


int save_account_status(char *printer, int useAccount)
{
	int fd_new, fd_org;
	char *file_new = NULL, *file_org = NULL;
	char *useAccountStr = NULL;
	char *t_line = NULL;

	if(printer == NULL)
		return 1;

	if((file_org = make_file_path(ACCOUNT_FILE_TYPE_STATUS_WRITE, NULL,
				ACCOUNT_FILE_STATUS)) == NULL)
		return 1;

	if((file_new = make_file_path(ACCOUNT_FILE_TYPE_STATUS_WRITE, NULL,
				ACCOUNT_FILE_STATUS_NEW)) == NULL)
		goto err;

	if((fd_new = open(file_new, O_RDWR|O_CREAT|O_EXCL, 0644)) < 0)
		goto err;

	useAccountStr = useAccount ? "ON" : "OFF";

	if((fd_org = open(file_org, O_RDONLY)) < 0){
		t_line = (char *)calloc(MAX_BUFSIZE + 1, 1);
		if(t_line == NULL)
			goto err;
		snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_STATUS_FORMAT,
			printer, useAccountStr, printer);
		file_write(fd_new, t_line, strlen(t_line));
	}else{
		int is_curr = 0;
		int offset = 0, l_bytes = 0, r_bytes = 0;
		char t_buf[MAX_BUFSIZE + 1];
		memset(t_buf, 0, sizeof(t_buf));
		while((r_bytes = read(fd_org, t_buf, MAX_BUFSIZE))){
			if(r_bytes == -1){
				if(errno == EINTR){
					continue;
				}else{
					break;
				}
			}
			offset = 0;
			while(r_bytes > offset){
				char new_line[MAX_BUFSIZE];
				memset(new_line, 0, MAX_BUFSIZE);
				l_bytes = get_line_from_buffer(&t_line, t_buf, offset, MAX_BUFSIZE);
				if(l_bytes < 0){
					break;
				}

#if !defined(__APPLE__) && !defined(_OPAL)
				if((t_line[0] == '<') &&
				   (check_account_printer_name(printer, &t_line[0]) == 0))
				{
#else
				if(t_line[0] == '<'
				&& strncmp(t_line + 1, printer, strlen(printer)) == 0){
#endif
					snprintf(new_line, MAX_BUFSIZE - 1,
						ACCOUNT_STATUS_FORMAT, printer,
						useAccountStr, printer);
					file_write(fd_new, new_line, strlen(new_line));
					is_curr = 1;
				}else{
					char *tmp = NULL;
					int len = strlen(t_line) + 1;
					tmp = (char *)calloc(len + 1, 1);
					if(tmp != NULL){
						snprintf(tmp, len + 1, "%s\n", t_line);
						file_write(fd_new, tmp, strlen(tmp));
						free(tmp);
					}
				}
				offset += l_bytes;
				if(t_line != NULL){
					free(t_line);
					t_line = NULL;
				}
			}
			memset(t_buf, 0, sizeof(t_buf));
		}
		if(is_curr == 0){
			if(t_line != NULL)
				free(t_line);
			t_line = (char *)calloc(MAX_BUFSIZE + 1, 1);
			if(t_line != NULL){
				snprintf(t_line, MAX_BUFSIZE - 1,
					ACCOUNT_STATUS_FORMAT, printer,
					 useAccountStr, printer);
				file_write(fd_new, t_line, strlen(t_line));
			}
		}
	}

	if(fd_new > 0)
		close(fd_new);
	if(fd_org > 0)
		close(fd_org);

	unlink(file_org);
	rename(file_new, file_org);

	if(t_line != NULL)
		free(t_line);
	if(file_new != NULL)
		free(file_new);
	if(file_org != NULL)
		free(file_org);
	return 0;

err:
	if(file_new != NULL)
		free(file_new);
	if(file_org != NULL)
		free(file_org);

	return 1;
}

int save_account_conf(char *printer, char *user, char *id, char *ps, int del)
{
	int fd_new, fd_org;
	char *file_new = NULL, *file_org = NULL;
	char *t_line = NULL;

	if(printer == NULL)
		return 1;

	if((file_org = make_file_path(ACCOUNT_FILE_TYPE_CONF_WRITE, user,
				ACCOUNT_FILE_CONF)) == NULL)
		return 1;

	if((file_new = make_file_path(ACCOUNT_FILE_TYPE_CONF_WRITE, user,
				ACCOUNT_FILE_CONF_NEW)) == NULL)
		goto err;

	if((fd_new = open(file_new, O_RDWR|O_CREAT|O_EXCL, 0600)) < 0)
		goto err;

	if((fd_org = open(file_org, O_RDONLY)) < 0){
		if(del){
			close(fd_new);
			unlink(file_new);
			goto err;
		}
		t_line = (char *)calloc(MAX_BUFSIZE + 1, 1);
		if(t_line == NULL)
			goto err;
		snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_START, printer);
		file_write(fd_new, t_line, strlen(t_line));
		memset(t_line, 0, MAX_BUFSIZE + 1);
		snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_ID, id);
		file_write(fd_new, t_line, strlen(t_line));
		memset(t_line, 0, MAX_BUFSIZE + 1);
		snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_PSWD, ps);
		file_write(fd_new, t_line, strlen(t_line));
		memset(t_line, 0, MAX_BUFSIZE + 1);
		snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_END, printer);
		file_write(fd_new, t_line, strlen(t_line));
	}else{
		int is_curr = 0;
		int offset = 0, l_bytes = 0, r_bytes = 0;
		char t_buf[MAX_BUFSIZE + 1];
		memset(t_buf, 0, sizeof(t_buf));
		while((r_bytes = read(fd_org, t_buf, MAX_BUFSIZE))){
			if(r_bytes == -1){
				if(errno == EINTR)
					continue;
				else
					break;
			}
			offset = 0;

			while(r_bytes > offset){
				char new_line[MAX_BUFSIZE];

				memset(new_line, 0, sizeof(new_line));
				l_bytes = get_line_from_buffer(&t_line, t_buf, offset, MAX_BUFSIZE);

				if(l_bytes < 0){
					break;
				}

#if !defined(__APPLE__) && !defined(_OPAL)
				if((t_line[0] == '<') &&
				   (check_printer_name(printer, &t_line[0], PRINTER_NAME_FORMAT_START) == 0))
				{
#else
				if(t_line[0] == '<'
				&& strncmp(t_line + 1, printer, strlen(printer)) == 0){
#endif
					is_curr = 1;
					if(del)
						goto skip;
					snprintf(new_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_START, printer);
					file_write(fd_new, new_line, strlen(new_line));
#if !defined(__APPLE__) && !defined(_OPAL)
				}
				else if((t_line[0] == '<') && (t_line[1] == '/') &&
				        (check_printer_name(printer, &t_line[0], PRINTER_NAME_FORMAT_END) == 0))
				{
#else
				}else if(t_line[0] == '<' && t_line[1] == '/'
				&& strncmp(t_line + 2, printer, strlen(printer)) == 0){
#endif
					is_curr = 2;
					if(del)
						goto skip;
					snprintf(new_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_END, printer);
					file_write(fd_new, new_line, strlen(new_line));
#if !defined(__APPLE__) && !defined(_OPAL)
				}
				else if((is_curr == 1) &&
				        (strncmp(t_line, "id=", strlen("id=")) == 0))
				{
#else
				}else if(is_curr == 1
				&& strstr(t_line, "id=") != NULL){
#endif
					if(del)
						goto skip;
					snprintf(new_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_ID, id);
					file_write(fd_new, new_line, strlen(new_line));
#if !defined(__APPLE__) && !defined(_OPAL)
				}
				else if((is_curr == 1) &&
			     	    (strncmp(t_line, "password=", strlen("password=")) == 0))
				{
#else
				}else if(is_curr == 1
				&& strstr(t_line, "password=") != NULL){
#endif
					if(del)
						goto skip;
					snprintf(new_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_PSWD, ps);
					file_write(fd_new, new_line, strlen(new_line));
				}else{
					char *tmp = NULL;
					int len = strlen(t_line) + 1;
					tmp = (char *)calloc(len + 1, 1);
					if(tmp != NULL){
						snprintf(tmp, len + 1, "%s\n", t_line);
						file_write(fd_new, tmp, strlen(tmp));
						free(tmp);
					}
				}
skip:
				offset += l_bytes;
				if(t_line != NULL){
					free(t_line);
					t_line = NULL;
				}
			}
			memset(t_buf, 0, sizeof(t_buf));
		}
		if(is_curr == 0 && del == 0){
			if(t_line != NULL)
				free(t_line);
			t_line = (char *)calloc(MAX_BUFSIZE + 1, 1);
			if(t_line != NULL){
				memset(t_line, 0, MAX_BUFSIZE);
				snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_START, printer);
				file_write(fd_new, t_line, strlen(t_line));
				memset(t_line, 0, MAX_BUFSIZE);
				snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_ID, id);
				file_write(fd_new, t_line, strlen(t_line));
				memset(t_line, 0, MAX_BUFSIZE);
				snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_PSWD, ps);
				file_write(fd_new, t_line, strlen(t_line));
				memset(t_line, 0, MAX_BUFSIZE);
				snprintf(t_line, MAX_BUFSIZE - 1, ACCOUNT_CONF_FORMAT_END, printer);
				file_write(fd_new, t_line, strlen(t_line));
			}
		}
	}

	if(fd_new > 0)
		close(fd_new);
	if(fd_org > 0)
		close(fd_new);

	unlink(file_org);
	rename(file_new, file_org);

	if(t_line != NULL)
		free(t_line);
	if(file_new != NULL)
		free(file_new);
	if(file_org != NULL)
		free(file_org);
	return 0;
err:
	if(file_new != NULL)
		free(file_new);
	if(file_org != NULL)
		free(file_org);

	return 1;
}

int ChangedJobAccount(char *id, char *ps, char *org_id, char *org_ps)
{
	if(strlen(id) == strlen(org_id)){
		if(strcmp(id, org_id) == 0){
			if(strlen(ps) == strlen(org_ps)){
				if(strcmp(ps, org_ps) == 0)
					return 0;
			}
		}
	}
	return 1;
}

int SaveJobAccount(cngplpData *data)
{
	int useAccount = 0;
	char *printer = NULL;
	char *user = NULL;

	if(data == NULL)
		return 0;

	if(data->curr_printer == NULL)
		return 0;

	if(data->ppd_opt == NULL)
		return 0;

	if(data->ppd_opt->special == NULL)
		return 0;

	useAccount = data->ppd_opt->special->job_account;
	printer = (char *)data->curr_printer;

	if(getuid() == 0){
		user = NULL;
		if(useAccount != data->ppd_opt->special->org_job_account){
			if(save_account_status(printer, useAccount))
				return 0;
		}
	}else{
		if((user = getenv("USER")) == NULL)
			return 0;
	}

	if(useAccount){
		char *id = NULL, *ps = NULL;
		char *org_id = NULL, *org_ps = NULL;
		id = data->ppd_opt->special->job_account_id;
		ps = data->ppd_opt->special->job_account_passwd;
		org_id = data->ppd_opt->special->org_job_account_id;
		org_ps = data->ppd_opt->special->org_job_account_passwd;
		if(ChangedJobAccount(id, ps, org_id, org_ps))
			save_account_conf(printer, user, id, ps, 0);
	}

	return 1;
}


#else
int
check_job_account(char *printer, char *user, char *id, char *ps, int buf_size)
{
	return 0;
}
#endif

int add_param_array(char **ptr_param, char *opt_name_arg, char *opt_val_arg)
{
	int cnmailbox_cnt = 0;
	int len = 0;
	int total_len = 0;
	int num = 0;
	int total_num = 0;
	char *box_num_ptr = NULL;
	char *cnmaibox_ptr = NULL;
	box_num_ptr = opt_val_arg;
	for(; total_len < strlen(opt_val_arg);){
		get_param_len(opt_name_arg, box_num_ptr, &len);
		cnmaibox_ptr = (char *)malloc(len + 1);
		strncpy(cnmaibox_ptr, box_num_ptr, len);
		*(cnmaibox_ptr + len) = 0;
		if(cnmailbox_cnt == 0){
			num = add_param_char(ptr_param, opt_name_arg, cnmaibox_ptr);
			cnmailbox_cnt ++;
		}else{
			char optname_ptr[256];
			snprintf(optname_ptr, (sizeof(optname_ptr)-1), "%s_%d", opt_name_arg,cnmailbox_cnt);
			num = add_param_char(ptr_param, optname_ptr, cnmaibox_ptr);
			cnmailbox_cnt ++;
		}
		free(cnmaibox_ptr);
		total_len = total_len +len + 1;
		box_num_ptr = box_num_ptr + len ;
		box_num_ptr ++;
		ptr_param += num;
		total_num += num;
	}
	return total_num;
}

void  get_param_len(char *opt_name_arg, char *str, int *len)
{
	int	max_len = 127;
	int i = 0;

	*len = 0;
	max_len = max_len - (strlen(opt_name_arg) + 5);
	i = 0;
	while(1){
		if(i+1 >= max_len){
			break;
		}
		if(str[i] == '\0'){
			*len = i;
			break;
		}
		if(str[i] == '_'){
			*len = i;
		}
		i++;
	}
	return;
}



