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
#include "ppdkeys.h"
#ifndef __APPLE__
#include <locale.h>
#endif

char *MakeDuplexBoolList(PPDOptions *ppd_opt);
#ifndef __APPLE__
extern int GetCurrDisable(const int id, const char *in);
#endif

char* AddList(char *list, char *add)
{
	char *tmp;

	if(list == NULL){
		tmp = strdup(add);
		if(tmp == NULL)
			return NULL;
	}else{
		int size;
		size = strlen(list) + strlen(add) + 4;
		tmp = (char *)malloc(size);
		memset(tmp, 0, size);
		cngplp_util_strcpy(tmp, list);
		cngplp_util_strcat(tmp, ",");
		cngplp_util_strcat(tmp, add);
		MemFree(list);
	}
	return tmp;
}

char* MakePPDOptionList(PPDOptions *ppd_opt, char *item_name)
{
	char *glist = NULL;
	char curr[256];
	int flag = 1;
	UIItemsList *item;
	UIOptionList *tmp_opt_list;

	item = FindItemsList(ppd_opt->items_list, item_name);
	if(item == NULL)
		return NULL;

	memset(curr, 0, 256);
	if(item->current_option && item->current_option->name)
		snprintf(curr, 255, "%s:", item->current_option->name);
	else
		snprintf(curr, 255, "%s:", item->opt_lists->name);

	tmp_opt_list = item->opt_lists;
	while(1){
		char tmp[256];
		memset(tmp, 0, 256);
		if(strcmp(item_name, "StapleLocation") == 0
		|| strcmp(item_name, "Booklet") == 0
#ifndef __APPLE__
		|| strcmp(item_name, kPPD_Items_CNMatchingMethod) == 0
		|| strcmp(item_name, kPPD_Items_CNMonitorProfile) == 0
#endif
		){
			if(strcmp(tmp_opt_list->name, "None") == 0){
				if(tmp_opt_list->next == NULL)
					break;
				tmp_opt_list = tmp_opt_list->next;
			}
		}
		if(flag){
#ifndef __APPLE__

			if(strcmp(item_name, "BindEdge") == 0){
				snprintf(tmp, 255, "%s%s<%d>", curr, tmp_opt_list->name, 0);
			}else{
				int disable = 0;
				if(strcmp(tmp_opt_list->name, item->current_option->name) == 0)
					disable = 0;
				else
					disable = tmp_opt_list->disable;
				snprintf(tmp, 255, "%s%s<%d>", curr, tmp_opt_list->name, disable);
			}
#else
			if(strcmp(item_name, "PageSize") == 0
			|| strcmp(item_name, "BindEdge") == 0){
				snprintf(tmp, 255, "%s%s<%d>", curr, tmp_opt_list->name, 0);
			}else{
                if(item->current_option != NULL){
                    int disable = 0;
                    if(strcmp(tmp_opt_list->name, item->current_option->name) == 0)
                        disable = 0;
                    else
                        disable = tmp_opt_list->disable;
                    snprintf(tmp, 255, "%s%s<%d>", curr, tmp_opt_list->name, disable);
                }
			}
#endif
			glist = AddList(glist, tmp);
			flag = 0;
		}else{
			if(strcmp(item_name, "PageSize") == 0){
                if(item->current_option != NULL){
                    int disable = 0;
                    if(strcmp(tmp_opt_list->name, "Custom") == 0
                       && strcmp(item->current_option->name, "Custom"))
                        disable = 1;
                    else
#ifndef __APPLE__

                        disable = tmp_opt_list->disable;
#else
                        disable = 0;
#endif
                    snprintf(tmp, 255, "%s<%d>", tmp_opt_list->name, disable);
                }
			}else if(strcmp(item_name, "BindEdge") == 0){
				snprintf(tmp, 255, "%s<%d>", tmp_opt_list->name, 0);
			}else{
                if(item->current_option != NULL){
                    int disable = 0;
                    if(strcmp(tmp_opt_list->name, item->current_option->name) == 0)
                        disable = 0;
                    else
                        disable = tmp_opt_list->disable;
                    snprintf(tmp, 255, "%s<%d>", tmp_opt_list->name, disable);
                }
			}
			glist = AddList(glist, tmp);
		}
		if(tmp_opt_list->next == NULL)
			break;
		tmp_opt_list = tmp_opt_list->next;
	}
	return glist;
}

char *MakeCNPunchBoolList(PPDOptions *ppd_opt, char *item_name)
{
	char *glist = NULL;
	char curr[256];
	char *punch;
	UIItemsList *item;

	item = FindItemsList(ppd_opt->items_list, item_name);
	if(item == NULL)
		return NULL;

	memset(curr, 0, 256);
	punch = FindCurrOpt(ppd_opt->items_list, item_name);
	if(punch != NULL){
		if(strcmp(punch, "Left") == 0
		|| strcmp(punch, "Right") == 0
		|| strcmp(punch, "Top") == 0
		|| strcmp(punch, "Bottom") == 0){
			cngplp_util_strcpy(curr, "True:True<0>,False<0>");
		}else{
			char *bind;
			int dis = 1;
			bind = FindCurrOpt(ppd_opt->items_list, "BindEdge");
			if(bind != NULL){
				dis = GetDisableOpt(ppd_opt->items_list, item_name, bind);
			}
			if(dis == 0)
				cngplp_util_strcpy(curr, "False:True<0>,False<0>");
			else
				cngplp_util_strcpy(curr, "False:True<4>,False<0>");
		}
	}
	return glist = strdup(curr);
}

char *MakePPDBoolList(PPDOptions *ppd_opt, char *item_name)
{
	char *glist = NULL;
	char curr[256];
	int disable;
	UIItemsList *item;

	item = FindItemsList(ppd_opt->items_list, item_name);
	if(item == NULL)
		return NULL;

	disable = GetDisable(ppd_opt->items_list, item_name);

	memset(curr, 0, 256);
	if(item->current_option && item->current_option->name){
		if(strcmp(item->current_option->name, "False") == 0
		|| strcmp(item->current_option->name, "None") == 0)
			snprintf(curr, 255, "False:True<%d>,False<0>",disable);
		else
			snprintf(curr, 255, "True:True<%d>,False<0>", disable);
	}else{
		if(strcmp(item->opt_lists->name, "False") == 0
		|| strcmp(item->opt_lists->name, "None") == 0)
			snprintf(curr, 255, "False:True<%d>,False<0>", disable);
		else
			snprintf(curr, 255, "True:True<%d>,False<0>", disable);
	}

	return glist = strdup(curr);
}
#ifndef __APPLE__
char *MakeCNSaddleSettingList(PPDOptions *ppd_opt, char *item_name)
{
	char *glist = NULL;
	char *tmp_glist = NULL;
	char curr[256];
	int disable;
	UIItemsList *item;
	char tmp[256];
	UIItemsList *list = NULL;

	memset(curr, 0, 256);

	list = FindItemsList(ppd_opt->items_list, kPPD_Items_CNVfolding);
	if(list != NULL){
		disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNVfolding, "True");
		snprintf(tmp, 255, "%s<%d>", "Fold Only", disable);
		tmp_glist = AddList(tmp_glist, tmp);
		if(strcasecmp(list->current_option->name, "True") == 0){
#if !defined(__APPLE__) && !defined(_OPAL)
			cngplp_util_strcpy(curr, "Fold Only");
#else
			strcpy(curr, "Fold Only");
#endif
		}
	}

	item = FindItemsList(ppd_opt->items_list, kPPD_Items_CNSaddleStitch);
	if(item != NULL){
		disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNSaddleStitch, "True");
		if(list != NULL){
			snprintf(tmp, 255, "%s<%d>", "Fold + Saddle Stitch", disable);
		}else{
			snprintf(tmp, 255, "%s<%d>", "Saddle Stitch", disable);
		}
		tmp_glist = AddList(tmp_glist, tmp);
		if(strcasecmp(item->current_option->name, "True") == 0){
			if(list != NULL){
#if !defined(__APPLE__) && !defined(_OPAL)
				cngplp_util_strcpy(curr, "Fold + Saddle Stitch");
#else
				strcpy(curr, "Fold + Saddle Stitch");
#endif
			}else{
#if !defined(__APPLE__) && !defined(_OPAL)
				cngplp_util_strcpy(curr, "Saddle Stitch");
#else
				strcpy(curr, "Saddle Stitch");
#endif
			}
		}
	}

#if !defined(__APPLE__) && !defined(_OPAL)
	item = FindItemsList(ppd_opt->items_list, kPPD_Items_CNVfoldingTrimming);
	if(item != NULL){
		disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNVfoldingTrimming, "True");
		snprintf(tmp, 255, "%s<%d>", "Fold + Trim", disable);
		tmp_glist = AddList(tmp_glist, tmp);
		if(strcasecmp(item->current_option->name, "True") == 0){
			cngplp_util_strcpy(curr, "Fold + Trim");
		}
	}
#endif

	item = FindItemsList(ppd_opt->items_list, kPPD_Items_CNTrimming);
	if(item != NULL){
		disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNTrimming, "True");
		disable -= GetOptionDisableCount(ppd_opt, kPPD_Items_CNSaddleStitch, kPPD_Items_CNTrimming, "True");
		disable += GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNSaddleStitch, "True");
		if(list != NULL){
			snprintf(tmp, 255, "%s<%d>", "Fold + Saddle Stitch + Trim", disable);
		}else{
			snprintf(tmp, 255, "%s<%d>", "Saddle Stitch + Trim", disable);
		}
		tmp_glist = AddList(tmp_glist, tmp);
		if(strcasecmp(item->current_option->name, "True") == 0){
#if !defined(__APPLE__) && !defined(_OPAL)
			if(strstr(curr, "Fold + Trim") == NULL){
				if(list != NULL){
					cngplp_util_strcpy(curr, "Fold + Saddle Stitch + Trim");
				}else{
					cngplp_util_strcpy(curr, "Saddle Stitch + Trim");
				}
			}
#else
			if(list != NULL){
				strcpy(curr, "Fold + Saddle Stitch + Trim");
			}else{
				strcpy(curr, "Saddle Stitch + Trim");
			}
#endif
		}
	}

	if(tmp_glist){
		if(strlen(curr) <= 0){
#if !defined(__APPLE__) && !defined(_OPAL)
			cngplp_util_strcpy(curr, "None");
#else
			strcpy(curr, "None");
#endif
		}
		snprintf(tmp, 255, "%s:None<0>", curr);
		glist = AddList(glist, tmp);
		glist = AddList(glist, tmp_glist);
	}

	MemFree(tmp_glist);

	return glist;
}
#else
char *MakeCNSaddleSettingList(PPDOptions *ppd_opt, char *item_name)
{
	char *glist = NULL;
	char *tmp_glist = NULL;
	char curr[256];
	int disable;
	UIItemsList *item;
	char tmp[256];

	memset(curr, 0, 256);

	item = FindItemsList(ppd_opt->items_list, kPPD_Items_CNVfolding);
	if(item != NULL){
		disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNVfolding, "True");
		snprintf(tmp, 255, "%s<%d>", "VFolding", disable);
		tmp_glist = AddList(tmp_glist, tmp);
		if(strcasecmp(item->current_option->name, "True") == 0){
			cngplp_util_strcpy(curr, "VFolding");
		}
	}

	item = FindItemsList(ppd_opt->items_list, kPPD_Items_CNSaddleStitch);
	if(item != NULL){
		disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNSaddleStitch, "True");
		snprintf(tmp, 255, "%s<%d>", "SaddleStitch", disable);
		tmp_glist = AddList(tmp_glist, tmp);
		if(strcasecmp(item->current_option->name, "True") == 0){
			cngplp_util_strcpy(curr, "SaddleStitch");
		}
	}

	item = FindItemsList(ppd_opt->items_list, kPPD_Items_CNVfoldingTrimming);
	if(item != NULL){
		disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNVfoldingTrimming, "True");
		snprintf(tmp, 255, "%s<%d>", "VFoldingTrimming", disable);
		tmp_glist = AddList(tmp_glist, tmp);
		if(strcasecmp(item->current_option->name, "True") == 0){
			cngplp_util_strcpy(curr, "VFoldingTrimming");
		}
	}

	item = FindItemsList(ppd_opt->items_list, kPPD_Items_CNTrimming);
	if(item != NULL){
		disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNTrimming, "True");
		disable -= GetOptionDisableCount(ppd_opt, kPPD_Items_CNSaddleStitch, kPPD_Items_CNTrimming, "True");
		disable += GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNSaddleStitch, "True");
		snprintf(tmp, 255, "%s<%d>", "Trimming", disable);
		tmp_glist = AddList(tmp_glist, tmp);
		if(strcasecmp(item->current_option->name, "True") == 0){
			if(strstr(curr, "VFoldingTrimming") == NULL){
				cngplp_util_strcpy(curr, "Trimming");
			}
		}
	}

	if(tmp_glist){
		if(strlen(curr) <= 0){
			cngplp_util_strcpy(curr, "Off");
		}
		snprintf(tmp, 255, "%s:Off<0>", curr);
		glist = AddList(glist, tmp);
		glist = AddList(glist, tmp_glist);
	}

	MemFree(tmp_glist);

	return glist;
}
#endif

#ifndef __APPLE__
char *MakeCNFoldSettingList(PPDOptions *ppd_opt, char *item_name)
{
	char *glist = NULL;
	char *tmp_glist = NULL;
	char curr[256];
	int disable;
	UIItemsList *item;
	char tmp[256];

	memset(curr, 0, 256);

	item = FindItemsList(ppd_opt->items_list, kPPD_Items_CNZfolding);
	if(item != NULL){
		disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNZfolding, "True");
		snprintf(tmp, 255, "%s<%d>", "Z-fold", disable);
		tmp_glist = AddList(tmp_glist, tmp);
		if(strcasecmp(item->current_option->name, "True") == 0){
#if !defined(__APPLE__) && !defined(_OPAL)
			cngplp_util_strcpy(curr, "Z-fold");
#else
			strcpy(curr, "Z-fold");
#endif
		}
	}

	item = FindItemsList(ppd_opt->items_list, kPPD_Items_CNCfolding);
	if(item != NULL){
		disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNCfolding, "True");
		snprintf(tmp, 255, "%s<%d>", "C-fold", disable);
		tmp_glist = AddList(tmp_glist, tmp);
		if(strcasecmp(item->current_option->name, "True") == 0){
#if !defined(__APPLE__) && !defined(_OPAL)
			cngplp_util_strcpy(curr, "C-fold");
#else
			strcpy(curr, "C-fold");
#endif
		}
	}

	item = FindItemsList(ppd_opt->items_list, kPPD_Items_CNHalfFolding);
	if(item != NULL){
		disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNHalfFolding, "True");
		snprintf(tmp, 255, "%s<%d>", "Half Fold", disable);
		tmp_glist = AddList(tmp_glist, tmp);
		if(strcasecmp(item->current_option->name, "True") == 0){
#if !defined(__APPLE__) && !defined(_OPAL)
			cngplp_util_strcpy(curr, "Half Fold");
#else
			strcpy(curr, "Half Fold");
#endif
		}
	}

	item = FindItemsList(ppd_opt->items_list, kPPD_Items_CNAccordionZfolding);
	if(item != NULL){
		disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNAccordionZfolding, "True");
		snprintf(tmp, 255, "%s<%d>", "Accordion Z-fold", disable);
		tmp_glist = AddList(tmp_glist, tmp);
		if(strcasecmp(item->current_option->name, "True") == 0){
#if !defined(__APPLE__) && !defined(_OPAL)
			cngplp_util_strcpy(curr, "Accordion Z-fold");
#else
			strcpy(curr, "Accordion Z-fold");
#endif
		}
	}

	item = FindItemsList(ppd_opt->items_list, kPPD_Items_CNDoubleParallelFolding);
	if(item != NULL){
		disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_CNDoubleParallelFolding, "True");
		snprintf(tmp, 255, "%s<%d>", "Double Parallel Fold", disable);
		tmp_glist = AddList(tmp_glist, tmp);
		if(strcasecmp(item->current_option->name, "True") == 0){
#if !defined(__APPLE__) && !defined(_OPAL)
			cngplp_util_strcpy(curr, "Double Parallel Fold");
#else
			strcpy(curr, "Double Parallel Fold");
#endif
		}
	}

	if(tmp_glist){
		if(strlen(curr) <= 0){
#if !defined(__APPLE__) && !defined(_OPAL)
			cngplp_util_strcpy(curr, "None");
#else
			strcpy(curr, "None");
#endif
		}
		snprintf(tmp, 255, "%s:None<0>", curr);
		glist = AddList(glist, tmp);
		glist = AddList(glist, tmp_glist);
	}

	MemFree(tmp_glist);

	return glist;
}

char *MakeCNPrintStyleList(PPDOptions *ppd_opt, char *item_name)
{
	char *glist = NULL;
	char *tmp_glist = NULL;
	char curr[256];
	int disable;
	UIItemsList *item;
	char tmp[256];
	int type = ppd_opt->duplex_valtype;

	memset(curr, 0, 256);

	item = FindItemsList(ppd_opt->items_list, kPPD_Items_Duplex);
	if(item != NULL){
		if(DUPLEX_VALTYPE_TRUE == type){
			disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_Duplex, "True");
			snprintf(tmp, 255, "%s<%d>", "2-sided Printing", disable);
			tmp_glist = AddList(tmp_glist, tmp);
			if(strcasecmp(item->current_option->name, "True") == 0){
#if !defined(__APPLE__) && !defined(_OPAL)
				cngplp_util_strcpy(curr, "2-sided Printing");
#else
				strcpy(curr, "2-sided Printing");
#endif
			}
		}else if(DUPLEX_VALTYPE_TUMBLE == type){
			disable = GetCurrDisable(ID_DUPLEX, NULL);
			snprintf(tmp, 255, "%s<%d>", "2-sided Printing", disable);
			tmp_glist = AddList(tmp_glist, tmp);
			if(strcasecmp(item->current_option->name, "DuplexNoTumble") == 0 || strcasecmp(item->current_option->name, "DuplexTumble") == 0){
#if !defined(__APPLE__) && !defined(_OPAL)
				cngplp_util_strcpy(curr, "2-sided Printing");
#else
				strcpy(curr, "2-sided Printing");
#endif
			}
		}
	}

	item = FindItemsList(ppd_opt->items_list, kPPD_Items_Booklet);
	if(item != NULL){
		disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_Booklet, "Left");
		snprintf(tmp, 255, "%s<%d>", "Booklet Printing", disable);
		tmp_glist = AddList(tmp_glist, tmp);
		if(strcasecmp(item->current_option->name, "Left") == 0 || strcasecmp(item->current_option->name, "Right") == 0){
#if !defined(__APPLE__) && !defined(_OPAL)
			if( ppd_opt->booklet_offset != 0 ) {
				cngplp_util_strcpy(curr, "Booklet Printing + Offset");
			}
			else {
				cngplp_util_strcpy(curr, "Booklet Printing");
			}
#else
			strcpy(curr, "Booklet Printing");
#endif
		}
	}

	if(strlen(curr) <= 0){
#if !defined(__APPLE__) && !defined(_OPAL)
		cngplp_util_strcpy(curr, "1-sided Printing");
#else
		strcpy(curr, "1-sided Printing");
#endif
	}
	snprintf(tmp, 255, "%s:1-sided Printing<0>", curr);
	glist = AddList(glist, tmp);
	if(tmp_glist){
		glist = AddList(glist, tmp_glist);
	}

	MemFree(tmp_glist);

	return glist;
}
#endif

char* MakeEnableInsertPosPaperSource(cngplpData *data, int is_tabpaper)
{
	PPDOptions *ppd_opt = data->ppd_opt;
	UIItemsList *item = NULL;
	char *ret_list = NULL;
	char *conf_options = NULL;
	char *tok = NULL;
	char *tmp = NULL;
	char *list = NULL;
	char *def = NULL;

	item = FindItemsList(ppd_opt->items_list, kPPD_Items_CNInsertInputSlot);
	if(item != NULL){
		conf_options = GetPPDDevOptionConflict(data, ID_CNINSERTINPUTSLOT);
		if(conf_options) {
			for(tok = strtok_r(conf_options, ",", &tmp); tok != NULL; tok = strtok_r(NULL, ",", &tmp)) {
				char *opt = strchr(tok, '<');
				if(opt){
					*opt = '\0';
					if(atoi(opt+1) == 0){
						if( (is_tabpaper == 0)
						 || !IsConflictBetweenFunctions(data, kPPD_Items_CNSheetForInsertion, "TAB1", kPPD_Items_CNInsertInputSlot, tok)){
							list = AddList(list, tok);
							if(def == NULL){
								def = tok;
							}
							else if(strcmp(item->default_option, tok) == 0){
								def = tok;
							}
						}
					}
				}
			}

			if(def && list){
				size_t mem_size = strlen(def) + strlen(list) + 2;
				ret_list = calloc(1, mem_size);
				if(ret_list){
					snprintf(ret_list, mem_size, "%s:%s", def, list);
				}
			}

			free(conf_options);
			conf_options = NULL;
		}
	}

	if(list){
		free(list);
		list = NULL;
	}

	return ret_list;
}

#ifndef __APPLE__

char* DoubleToChar(double value)
{
	char *num;
	num = (char *)malloc(256);
	memset(num, 0, 256);
    setlocale (LC_NUMERIC, "C");
	snprintf(num, 255, "%f", value);
    setlocale (LC_NUMERIC, "");
	return num;
}
char* DoubleToChar2(double value)
{
	char *num;
	num = (char *)malloc(256);
	memset(num, 0, 256);
        setlocale (LC_NUMERIC, "C");
	snprintf(num, 255, "%.2f", value);
        setlocale (LC_NUMERIC, "");
	return num;
}

#else
char* DoubleToChar(double value)
{
	char *num;
	num = (char *)malloc(256);
	memset(num, 0, 256);
	snprintf(num, 255, "%f", value);
	return num;
}
char* DoubleToChar2(double value)
{
	char *num;
	num = (char *)malloc(256);
	memset(num, 0, 256);
	snprintf(num, 255, "%.2f", value);
	return num;
}
#endif


char* IntToChar(int value)
{
	char *num;
	num = (char *)malloc(256);
	memset(num, 0, 256);
	snprintf(num, 255, "%d", value);
	return num;
}

char* ToChar(char *value)
{
	char *ret = NULL;
	int size = 0;
	if(value != NULL){
		size = strlen(value) + 1;
		ret = (char *)malloc(size);
		if(ret == NULL)
			return NULL;

		memset(ret, 0, size);
		strncpy(ret, value, size - 1);
	}
	return ret;
}

char* GetDataCommonOption(cngplpData *data, int id)
{
	char *list = NULL;
	int i;
	char curr[256];
	char *option = NULL;
	int index = id - ID_COMMON_OPTION - 1;
	option = IDtoCommonOption(index);

	memset(curr, 0, 255);

	switch(id){
	case ID_PRINTERNAME:
		snprintf(curr, 255, "%s:%s<0>", data->curr_printer, data->printer_names[0]);
		list = AddList(list, curr);
		for(i = 1; i < data->printer_num; i++){
			char tmp[256];
			memset(tmp, 0, 255);
			snprintf(tmp, 255, "%s<0>", data->printer_names[i]);
			list = AddList(list, tmp);
		}
		break;
	case ID_NUMBER_UP:
		snprintf(curr, 255, "%s:%s<0>", GetCupsValue(data->cups_opt->common->option, "number-up"), NupTextValue_table[0].text);
		list = AddList(list, curr);
		for(i = 1; NupTextValue_table[i].text != NULL; i++){
			char tmp[256];
			memset(tmp, 0, 255);
			snprintf(tmp, 255, "%s<0>", NupTextValue_table[i].text);
			list = AddList(list, tmp);
		}
		break;
	case ID_FILTER:
		snprintf(curr, 255, "%s:%s<0>", GetCupsValue(data->cups_opt->common->option, "Filter"), g_filter_options[0]);
		list = AddList(list, curr);
		for(i = 1; g_filter_options[i] != NULL; i++){
			char tmp[256];
			memset(tmp, 0, 255);
			snprintf(tmp, 255, "%s<0>", g_filter_options[i]);
			list = AddList(list, tmp);
		}
		break;
	case ID_JOB_SHEETS_START:
		snprintf(curr, 255, "%s:%s<0>", GetCupsValue(data->cups_opt->common->option, "job-sheets-start"), g_banner_option[0]);
		list = AddList(list, curr);
		for(i = 1; g_banner_option[i] != NULL; i++){
			char tmp[256];
			memset(tmp, 0, 255);
			snprintf(tmp, 255, "%s<0>", g_banner_option[i]);
			list = AddList(list, tmp);
		}
		break;
	case ID_JOB_SHEETS_END:
		snprintf(curr, 255, "%s:%s<0>", GetCupsValue(data->cups_opt->common->option, "job-sheets-end"), g_banner_option[0]);
		list = AddList(list, curr);
		for(i = 1; g_banner_option[i] != NULL; i++){
			char tmp[256];
			memset(tmp, 0, 255);
			snprintf(tmp, 255, "%s<0>", g_banner_option[i]);
			list = AddList(list, tmp);
		}
		break;
	default:
		if(option != NULL)
			return ToChar(GetCupsValue(data->cups_opt->common->option, option));
		break;
	}
	return list;
}

char* GetDataPPDOption(cngplpData *data, int id)
{
	char *option = NULL;

	switch(id){
	case ID_SELECTBY:
		return IntToChar(data->ppd_opt->selectby);
	case ID_JOBACCOUNT:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else{
#ifndef	__APPLE__
			return IntToChar(data->ppd_opt->special->job_account);
#else
			return ToChar(data->ppd_opt->special->job_account == 0 ? "False" : "True");
#endif
		}
	case ID_JOBACCOUNT_ID:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->special->job_account_id);
	case ID_JOBACCOUNT_PASSWD:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->special->job_account_passwd);
	case ID_CNUSRPASSWORD:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->special->usr_passwd);
	case ID_DATANAME:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
		return IntToChar(data->ppd_opt->special->data_name);
	case ID_ENTERNAME:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
#ifndef _OPAL
		return ToChar(data->ppd_opt->special->enter_name);
#else
		if(data->ppd_opt->special->enter_name == NULL){
			return ToChar("");
		}else {
			return ToChar(data->ppd_opt->special->enter_name);
		}
#endif
	case ID_BOXIDNUM:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
#ifndef __APPLE__
		return IntToChar(data->ppd_opt->special->box_num);
#else
		return ToChar(data->ppd_opt->special->box_num);
#endif
	case ID_MAX_BOXIDNUM:
		return IntToChar(data->ppd_opt->max_box_num);
	case ID_GUTTER:
		if(data->ppd_opt->summary_flag & CNSUMMARY_FLG_GUTTER)
			return NULL;
                if(data->ppd_opt->us_type)
                        return DoubleToChar(data->ppd_opt->gutter_value_d);
                else
                        return IntToChar(data->ppd_opt->gutter_value);
	case ID_MAX_GUTTER:
                if(data->ppd_opt->us_type)
                        return DoubleToChar(data->ppd_opt->max_gutter_value_d);
                else
                        return IntToChar(data->ppd_opt->max_gutter_value);
        case ID_USTYPE:
                return ToChar(data->ppd_opt->us_type == 0 ? "False" : "True");
	case ID_LIST_MEDIATYPE:
		return IntToChar(data->ppd_opt->list_mediatype_value);
  case ID_LIST_PAGESIZE:
      return IntToChar(data->ppd_opt->list_pagesize_value);
	case ID_SECURED_DOCNAME:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
#ifndef _OPAL
		return ToChar(data->ppd_opt->special->doc_name);
#else
		if(data->ppd_opt->special->doc_name == NULL){
			return ToChar("");
		}else {
			return ToChar(data->ppd_opt->special->doc_name);
		}
#endif
	case ID_SECURED_USRNAME:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->special->usr_name);
	case ID_SECURED_PASSWD:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->special->passwd_array);
	case ID_COLOR_MODE:
		return IntToChar(data->ppd_opt->color_mode);
	case ID_PRINTERTYPE:
		return IntToChar(data->ppd_opt->printer_type);
	case ID_MAX_COPIES:
		return IntToChar(data->ppd_opt->max_copy_num);
	case ID_SPECIAL_FUNC:
		return ToChar(data->ppd_opt->special != NULL ? "1" : "0");
	case ID_DOC_LENGTH:
		return IntToChar(data->ppd_opt->max_doc_length);
	case ID_DUPLEX:
		option = IDtoPPDOption(id - 1);
		if(option == NULL)
			return NULL;
#ifdef	__APPLE__
			return MakePPDOptionList(data->ppd_opt, "Duplex");
#else
			return MakeDuplexBoolList(data->ppd_opt);
#endif
	case ID_BOOKLET:
	case ID_CNSADDLESTITCH:
	case ID_CNTRIMMING:
	case ID_CNZFOLDING:
	case ID_CNINSERTER:
	case ID_CNPUREBLACKPROCESS:
	case ID_CNPUNCHER:
	case ID_CNFOLDER:
	case ID_CNINSERTUNIT:
	case ID_CNTRIMMER:
	case ID_CNDUPLEXUNIT:
	case ID_CNSUPERSMOOTH:
	case ID_CNBACKPAPERPRINT:
	case ID_CNROTATEPRINT:
	case ID_CNCOPYSETNUMBERING:
	case ID_CNINTERLEAFSHEET:
	case ID_CNINTERLEAFPRINT:
	case ID_CNSKIPBLANK:
	case ID_CNDETECTPAPERSIZE:
	case ID_CNRGBPUREBLACKPROCESS:
	case ID_CNUSEGRAYSCALEPROFILE:
	case ID_CNLASTPAGEPRINTMODE:
	case ID_CNSET_FRONT_COVER:
	case ID_CNSET_BACK_COVER:
	case ID_CNSPECIFYNUMOFCOPIESSTACK:
	case ID_CNVFOLDING:
	case ID_CNPROPUNCHER:
		option = IDtoPPDOption(id - 1);
		if(option == NULL)
			return NULL;
#ifdef	__APPLE__
		if(data->ppd_opt->printer_type != PRINTER_TYPE_CAPT)
		{
			switch(id){
			case ID_CNPUNCHER:
			case ID_BOOKLET:
			case ID_CNFOLDER:
			case ID_CNTRIMMER:
			case ID_CNINSERTUNIT:
			case ID_CNLASTPAGEPRINTMODE:
			case ID_CNPROPUNCHER:
				return MakePPDOptionList(data->ppd_opt, option);
			default:
				return MakePPDBoolList(data->ppd_opt, option);
			}
		}
		else {
			switch(id){
			case ID_CNSUPERSMOOTH:
				return MakePPDOptionList(data->ppd_opt, option);
			default:
				return MakePPDBoolList(data->ppd_opt, option);
			}
#endif
			return MakePPDBoolList(data->ppd_opt, option);
#ifdef	__APPLE__
		}
#endif
	case ID_CNPUNCH:
		option = IDtoPPDOption(id - 1);
		if(option == NULL)
			return NULL;
		return MakeCNPunchBoolList(data->ppd_opt, option);
	case ID_BOOKLET_DLG:
		option = IDtoPPDOption(ID_BOOKLET - 1);
		if(option == NULL)
			return NULL;
		return MakePPDOptionList(data->ppd_opt, option);
	case ID_STARTNUM:
		return IntToChar(data->ppd_opt->startnum_value);
	case ID_USERID:
		return IntToChar(getuid());
	case ID_BACKPAPERPRINT_LABEL:
		return ToChar(GetItemString(data->ppd_opt->items_list, "CNBackPaperPrint"));
	case ID_DISABLE_JOBACCOUNT_BW:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
#ifndef	__APPLE__
			return IntToChar(data->ppd_opt->special->disable_job_account_bw);
#else
			return ToChar(data->ppd_opt->special->disable_job_account_bw == 0 ? "False:True<0>,False<0>" : "True:True<0>,False<0>");
#endif
#if !defined(__APPLE__) && !defined(_OPAL)
	case ID_SHOW_JOBACCOUNT:
		if(data->ppd_opt->special == NULL)
		{
			return NULL;
		}
		else
		{
			return IntToChar(data->ppd_opt->special->show_job_account);
		}
		break;
#endif
	case ID_SHOW_DISABLE_JOBACCOUNT_BW:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
		return IntToChar(data->ppd_opt->special->show_disable_job_account_bw);
	case ID_DETECTPAPER_LABEL:
		return ToChar(GetItemString(data->ppd_opt->items_list, "CNDetectPaperSize"));
	case ID_CNDPICONPICTID:
		if(data->ppd_opt->dpicon_pictid > 0)
			return IntToChar(data->ppd_opt->dpicon_pictid);
		break;
	case ID_CNENABLEFINISHFLAG:
		if(data->ppd_opt->enable_finishflag > 0)
			return IntToChar(data->ppd_opt->enable_finishflag);
		break;
	case ID_CNENABLEINPUTFLAG:
		if(data->ppd_opt->enable_inputflag > 0)
			return IntToChar(data->ppd_opt->enable_inputflag);
		break;
	case ID_CNENABLEQUALITYTYPE:
		if(data->ppd_opt->enable_qualitytype > 0)
			return IntToChar(data->ppd_opt->enable_qualitytype);
		break;
	case ID_INPUTSLOT_TYPE:
		return IntToChar(data->ppd_opt->input_slot_type);

	case ID_CNSHIFTTYPE:
		return IntToChar(data->ppd_opt->shift_pos_type);
	case ID_CNSHIFTUPWARDS:
		if((option = GetUIValue(data, "CNEnableDetailShiftPosition")) != NULL){
			if(strcasecmp(option,"True") == 0){
				return DoubleToChar(data->ppd_opt->detail_shift_upwards);
			}
		}
		return IntToChar(data->ppd_opt->shift_upwards);
	case ID_CNSHIFTRIGHT:
		if((option = GetUIValue(data, "CNEnableDetailShiftPosition")) != NULL){
			if(strcasecmp(option,"True") == 0){
				return DoubleToChar(data->ppd_opt->detail_shift_right);
			}
		}
		return IntToChar(data->ppd_opt->shift_right);
	case ID_CNSHIFTFRLONGEDGE:
		if((option = GetUIValue(data, "CNEnableDetailShiftPosition")) != NULL){
			if(strcasecmp(option,"True") == 0){
				return DoubleToChar(data->ppd_opt->detail_shift_front_long);
			}
		}
		return IntToChar(data->ppd_opt->shift_front_long);
	case ID_CNSHIFTFRSHORTEDGE:
		if((option = GetUIValue(data, "CNEnableDetailShiftPosition")) != NULL){
			if(strcasecmp(option,"True") == 0){
				return DoubleToChar(data->ppd_opt->detail_shift_front_short);
			}
		}
		return IntToChar(data->ppd_opt->shift_front_short);
	case ID_CNSHIFTBKLONGEDGE:
		if((option = GetUIValue(data, "CNEnableDetailShiftPosition")) != NULL){
			if(strcasecmp(option,"True") == 0){
				return DoubleToChar(data->ppd_opt->detail_shift_back_long);
			}
		}
		return IntToChar(data->ppd_opt->shift_back_long);
	case ID_CNSHIFTBKSHORTEDGE:
		if((option = GetUIValue(data, "CNEnableDetailShiftPosition")) != NULL){
			if(strcasecmp(option,"True") == 0){
				return DoubleToChar(data->ppd_opt->detail_shift_back_short);
			}
		}
		return IntToChar(data->ppd_opt->shift_back_short);
	case ID_CNSHIFTPOSITIONMAX:
		return cngplpGetValue(data,kPPD_Items_CNShiftPositionMax);
	case ID_CNSHIFTPOSITIONMIN:
		return cngplpGetValue(data,kPPD_Items_CNShiftPositionMin);
	case ID_CNJOBNOTE:
		if(data->ppd_opt->job_note == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->job_note->note);
	case ID_CNJOBDETAILS:
		if(data->ppd_opt->job_note == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->job_note->details);
	case ID_CNFINDETAILS:
      option = GetUIValue(data, kPPD_Items_CNFinDetails);
      if(option == NULL)
		return 0;
      return IntToChar((strcasecmp(option, "true") == 0) ? 1 : 0);
	case ID_CNOFFSETNUM:
		return IntToChar(data->ppd_opt->offset_num);
	case ID_CNUIOFFSETMAX:
		return cngplpGetValue(data,kPPD_Items_CNUIOffsetMax);
	case ID_CNGUTTERSHIFTNUM:
		return DoubleToChar2(data->ppd_opt->guttershiftnum_value_d);

	case ID_MAX_GUTTER_SHIFT_NUM:
		return cngplpGetValue(data,kPPD_Items_CNMAXGutterShiftNum);
	case ID_MIN_GUTTER_SHIFT_NUM:
		return cngplpGetValue(data,kPPD_Items_CNMINGutterShiftNum);
	case ID_CNTABSHIFT:
		return DoubleToChar(data->ppd_opt->tab_shift);
	case ID_DRIVERROOTPATH:
		if(data->ppd_opt->drv_root_path == NULL)
			return NULL;
		else
			return ToChar(data->ppd_opt->drv_root_path);
	case ID_CNMEDIABRANDLIST:
		return MakeMediaBrandListChar(data->ppd_opt);
	case ID_CNMEDIABRAND:
		return MakeMediaBrandChar(data->ppd_opt);
	case ID_CNINSERTMEDIABRANDLIST:
		return MakeInsertMediaBrandListChar(data->ppd_opt);
	case ID_CNINSERTMEDIABRAND:
		return MakeInsertMediaBrandChar(data->ppd_opt);
	case ID_CNINTERLEAFMEDIABRANDLIST:
		return MakeInterleafMediaBrandListChar(data->ppd_opt);
	case ID_CNINTERLEAFMEDIABRAND:
		return MakeInterleafMediaBrandChar(data->ppd_opt);
	case ID_CNPBINDCOVERMEDIABRANDLIST:
		return MakePBindCoverMediaBrandListChar(data->ppd_opt);
	case ID_CNPBINDCOVERMEDIABRAND:
		return MakePBindCoverMediaBrandChar(data->ppd_opt);
	case ID_CNINSERTTABSHIFT:
		return DoubleToChar(data->ppd_opt->ins_tab_shift);
	case ID_CNINSERTPOS:
		return ToChar(data->ppd_opt->ins_pos);
	case ID_CNINSERTPOSPAPERSOURCE:
		return ToChar(data->ppd_opt->ins_pos_papersource);
	case ID_CNINSERTPOSPRINTON:
		return ToChar(data->ppd_opt->ins_pos_printon);
	case ID_CNTABINSERTPOS:
		return ToChar(data->ppd_opt->tab_ins_pos);
	case ID_CNTABINSERTPOSPAPERSOURCE:
		return ToChar(data->ppd_opt->tab_ins_pos_papersource);
	case ID_CNTABINSERTPOSPRINTON:
		return ToChar(data->ppd_opt->tab_ins_pos_printon);
	case ID_CNTABINSERTMULTIPAPERNUMBER:
		return IntToChar(data->ppd_opt->tab_ins_multi_number);
	case ID_CNTABINSERTMULTIPAPERSOURCE:
		return ToChar(data->ppd_opt->tab_ins_multi_papersource);
	case ID_CNTABINSERTMULTIPAPERTYPE:
		return ToChar(data->ppd_opt->tab_ins_multi_papertype);
	case ID_CNBINNAME:
		return ToChar(data->ppd_opt->bin_name);
	case ID_CNBINNAME_ARRAY:
		return ToChar(data->ppd_opt->bin_name_array);
	case ID_CNOVERLAYFILENAME:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->special->form_name);
	case ID_CNFORMHANDLE:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->special->form_handle);
	case ID_CNFORMLIST:
		return MakeFormListChar(data->ppd_opt);
	case ID_CNADJUSTTRIMNUM:
		return DoubleToChar(data->ppd_opt->adjust_trim_num);
	case ID_CNUITRIMVALMAX:
		return cngplpGetValue(data, kPPD_Items_CNUITrimValMax);
	case ID_CNUITRIMVALMIN:
		return cngplpGetValue(data, kPPD_Items_CNUITrimValMin);
	case ID_CNADJUSTFORETRIMNUM:
		return DoubleToChar(data->ppd_opt->adjust_frtrim_num);
	case ID_CNADJUSTTOPBOTTOMTRIMNUM:
		return DoubleToChar(data->ppd_opt->adjust_tbtrim_num);
	case ID_CNPBINDFINISHFORETRIMNUM:
		return DoubleToChar(data->ppd_opt->pb_fin_fore_trim_num);
	case ID_CNPBINDFINISHTOPBOTTOMTRIMNUM:
		return DoubleToChar(data->ppd_opt->pb_fin_topbtm_trim_num);
	case ID_CNSENDTIMENUM:
		if(data->ppd_opt->fax_setting == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->fax_setting->send_time);
	case ID_CNOUTSIDELINENUMBER:
		if(data->ppd_opt->fax_setting == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->fax_setting->outside_line_number);
	case ID_CNOUTSIDELINENUMINTRA:
		if(data->ppd_opt->fax_setting == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->fax_setting->outside_line_number_intra);
	case ID_CNOUTSIDELINENUMNGN:
		if(data->ppd_opt->fax_setting == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->fax_setting->outside_line_number_ngn);
	case ID_CNOUTSIDELINENUMMYNUMBERNGN:
		if(data->ppd_opt->fax_setting == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->fax_setting->outside_line_number_ngnmynum);
	case ID_CNOUTSIDELINENUMVOIP:
		if(data->ppd_opt->fax_setting == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->fax_setting->outside_line_number_voip);
	case ID_CNSENDER:
		if(data->ppd_opt->fax_setting == NULL)
			return NULL;
		else
			return ToChar(data->ppd_opt->fax_setting->sender_name);
	case ID_HOLD_NAME:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
		return ToChar(data->ppd_opt->special->hold_name);
	case ID_HOLDQUEUE_DATANAME:
		if(data->ppd_opt->special == NULL)
			return NULL;
		else
		return IntToChar(data->ppd_opt->special->holddata_name);
	case ID_CNFEEDPAPERNAME:
		if(data->ppd_opt->feed_paper_name == NULL)
			return NULL;
		else
			return ToChar(data->ppd_opt->feed_paper_name);
	case ID_CNSADDLESETTING:
		option = IDtoPPDOption(id - 1);
		if(option == NULL)
			return NULL;
		return MakeCNSaddleSettingList(data->ppd_opt, option);
	case ID_CNSTACKCOPIESNUM:
		return IntToChar(data->ppd_opt->stack_copies_num);
	case ID_CNSADDLEPRESSADJUSTMENT:
		return IntToChar(data->ppd_opt->saddle_press_adjust);
	case ID_CNLISTIDSPECIALPRINTMODE:
		return IntToChar(data->ppd_opt->list_specialprintmode_value);
#ifndef	__APPLE__
	case ID_ENABLECNOFFSETNUM:
		return ToChar(GetUIValue(data, "EnableCNOffsetNum"));
	case ID_CNFOLDSETTING:
		option = IDtoPPDOption(id - 1);
		if(option == NULL){
			return NULL;
		}
		return MakeCNFoldSettingList(data->ppd_opt, option);
	case ID_CNPRINTSTYLE:
		option = IDtoPPDOption(id - 1);
		if(option == NULL){
			return NULL;
		}
		return MakeCNPrintStyleList(data->ppd_opt, option);
#endif
	case ID_PCFILENAME:
		return ToChar(data->ppd_opt->pcfile_name);
	case ID_MANUFACTURER:
		return ToChar(data->ppd_opt->manufacturer);
	case ID_NICKNAME:
		return ToChar(data->ppd_opt->nickname);
	case ID_CNPDLTYPE:
		return ToChar(data->ppd_opt->cnpdl_type);
	case ID_APPRINTERICONPATH:
		return ToChar(data->ppd_opt->ap_printer_icon_path);
	case ID_CONFLICTCNOFFSETNUM:
		return IntToChar(GetOffsetNumConflict(data));
	case ID_ENABLEINSERTPOSPAPERSOURCE:
		return MakeEnableInsertPosPaperSource(data, 0);
	case ID_ENABLETABINSERTPOSPAPERSOURCE:
		return MakeEnableInsertPosPaperSource(data, 1);
	default:
		option = IDtoPPDOption(id - 1);
		if(option == NULL)
			return NULL;
		return MakePPDOptionList(data->ppd_opt, option);
	}

	return NULL;
}

char* GetDataImageOption(cngplpData *data, int id)
{
	if(id <= ID_POSITION){
		char *option = NULL;
		int index = id - ID_IMAGE_OPTION - 1;
		if((option = IDtoImageOption(index)) != NULL)
			return ToChar(GetCupsValue(data->cups_opt->image->option, option));
	}else if(id == ID_RESO_SCALE){
		return IntToChar(data->cups_opt->image->img_reso_scale);
	}
	return NULL;
}

char* GetDataTextOption(cngplpData *data, int id)
{
	if(id <= ID_PRETTYPRINT){
		char *option = NULL;
		int index = id - ID_TEXT_OPTION - 1;
		if((option = IDtoTextOption(index)) != NULL)
			return ToChar(GetCupsValue(data->cups_opt->text->option, option));
	}else if(id == ID_MARGIN){
		return IntToChar(data->cups_opt->text->margin_on);
	}
	return NULL;
}

char* GetDataHPGLOption(cngplpData *data, int id)
{
	char *option = NULL;
	int index = id - ID_HPGL_OPTION - 1;
	if((option = IDtoHPGLOption(index)) != NULL)
		return ToChar(GetCupsValue(data->cups_opt->hpgl->option, option));
	return NULL;
}

char* GetAllOptionID(cngplpData *data)
{
	PPDOptions *ppd_opt = data->ppd_opt;
	UIItemsList *items_list;
	char *list = 0;
	int i;
	items_list = ppd_opt->items_list;

	while(1){
		if(strcmp(items_list->name, "InputSlot") != 0
		&& strcmp(items_list->name, "MediaType") != 0){
			if(strcmp(items_list->name, "Resolution") == 0){
				if(items_list->num_options > 1)
					list = IDAddList(list, ToID(items_list->name));
			}else{
				list = IDAddList(list, ToID(items_list->name));
			}
		}
#if _UI_DEBUG
DebugDisable(data, ToID(items_list->name));
#endif
		if(items_list->next == NULL)
			break;
		items_list = items_list->next;
	}

	switch(ppd_opt->selectby){
	case SELECTBY_INPUTSLOT:
		list = IDAddList(list, ToID("InputSlot"));
		list = IDAddList(list, ID_INPUTSLOT_TYPE);
		break;
	case SELECTBY_MEDIATYPE:
		list = IDAddList(list, ToID("MediaType"));
		list = IDAddList(list, ID_LIST_MEDIATYPE);
		break;
	case SELECTBY_NONE:
		list = IDAddList(list, ToID("InputSlot"));
		list = IDAddList(list, ToID("MediaType"));
		list = IDAddList(list, ID_LIST_MEDIATYPE);
		break;
	}

	list = IDAddList(list, ID_SIDED1PRINT);
	if(ppd_opt->selectby)
		list = IDAddList(list, ID_SELECTBY);

	if(FindItemsList(ppd_opt->items_list, "Booklet") != NULL)
		list = IDAddList(list, ID_BOOKLET_DLG);

	if(ppd_opt->special != NULL){
		list = IDAddList(list, ID_DATANAME);
		list = IDAddList(list, ID_ENTERNAME);
		list = IDAddList(list, ID_BOXIDNUM);
		list = IDAddList(list, ID_MAX_BOXIDNUM);
		list = IDAddList(list, ID_SECURED_DOCNAME);
		list = IDAddList(list, ID_SECURED_USRNAME);
		list = IDAddList(list, ID_SECURED_PASSWD);
		list = IDAddList(list, ID_JOBACCOUNT);
		list = IDAddList(list, ID_JOBACCOUNT_ID);
		list = IDAddList(list, ID_JOBACCOUNT_PASSWD);
		list = IDAddList(list, ID_CNUSRPASSWORD);
		list = IDAddList(list, ID_SPECIAL_FUNC);
		list = IDAddList(list, ID_DOC_LENGTH);
		list = IDAddList(list, ID_DISABLE_JOBACCOUNT_BW);
		list = IDAddList(list, ID_SHOW_DISABLE_JOBACCOUNT_BW);
		list = IDAddList(list, ID_CNFORMHANDLE);
		list = IDAddList(list, ID_CNOVERLAYFILENAME);
		list = IDAddList(list, ID_HOLD_NAME);
		list = IDAddList(list, ID_HOLDQUEUE_DATANAME);
	}

	if(FindItemsList(ppd_opt->items_list, "BindEdge") != NULL){
		list = IDAddList(list, ID_GUTTER);
		list = IDAddList(list, ID_MAX_GUTTER);
	}
	list = IDAddList(list, ID_PRINTERTYPE);
	list = IDAddList(list, ID_COLOR_MODE);
	list = IDAddList(list, ID_MAX_COPIES);

	if(FindItemsList(ppd_opt->items_list, "CNCopySetNumbering") != NULL){
		list = IDAddList(list, ID_STARTNUM);
	}

	if(ppd_opt->shift_pos_type == 1) {
		list = IDAddList(list, ID_CNSHIFTTYPE);
		list = IDAddList(list, ID_CNSHIFTFRLONGEDGE);
		list = IDAddList(list, ID_CNSHIFTFRSHORTEDGE);
		list = IDAddList(list, ID_CNSHIFTBKLONGEDGE);
		list = IDAddList(list, ID_CNSHIFTBKSHORTEDGE);
	}else if(ppd_opt->shift_pos_type == 2) {
		list = IDAddList(list, ID_CNSHIFTTYPE);
		list = IDAddList(list, ID_CNSHIFTUPWARDS);
		list = IDAddList(list, ID_CNSHIFTRIGHT);
	}

	if(ppd_opt->job_note != NULL){
		list = IDAddList(list, ID_CNJOBNOTE);
		list = IDAddList(list, ID_CNJOBDETAILS);
	}
	if(FindOptionList(ppd_opt->items_list, kPPD_Items_CNOutputPartition, "offset")){
		char *val;
		if((val = GetUIValue(data, kPPD_Items_EnableCNOffsetNum)) != NULL){
			if(strcasecmp(val,"True") == 0){
		list = IDAddList(list, ID_CNOFFSETNUM);
			}
		}
	}

	if(FindOptionList(ppd_opt->items_list, kPPD_Items_CNDisplacementCorrection, "Manual")){
		list = IDAddList(list, ID_CNGUTTERSHIFTNUM);
	}
	{
		char *val;
		if((val = GetUIValue(data, "EnableCNTabShift")) != NULL){
			if(strcasecmp(val,"True") == 0){
				list = IDAddList(list, ID_CNTABSHIFT);
			}
		}
		if((val = GetUIValue(data, "EnableCNInsertTabShift")) != NULL){
			if(strcasecmp(val,"True") == 0){
				list = IDAddList(list, ID_CNINSERTTABSHIFT);
			}
		}
		if((val = GetUIValue(data, "EnableCNSender")) != NULL){
			if(strcasecmp(val,"True") == 0){
				list = IDAddList(list, ID_CNSENDER);
			}
		}
	}
	if(FindItemsList(ppd_opt->items_list, kPPD_Items_CNSheetForInsertion) != NULL){
		list = IDAddList(list, ID_CNINSERTPOS);
		list = IDAddList(list, ID_CNINSERTPOSPAPERSOURCE);
		list = IDAddList(list, ID_CNINSERTPOSPRINTON);
	}
	if((FindOptionList(ppd_opt->items_list, kPPD_Items_CNSheetForInsertion, "TAB"))
	 || (FindOptionList(ppd_opt->items_list, kPPD_Items_CNSheetForInsertion, "TAB1"))){
		list = IDAddList(list, ID_CNTABINSERTPOS);
		list = IDAddList(list, ID_CNTABINSERTPOSPAPERSOURCE);
		list = IDAddList(list, ID_CNTABINSERTPOSPRINTON);
		{
			char *val;
			if((val = GetUIValue(data, "CNMultiPaperSourceInsertTab")) != NULL){
				if(strcasecmp(val,"True") == 0){
					list = IDAddList(list, ID_CNTABINSERTMULTIPAPERNUMBER);
					list = IDAddList(list, ID_CNTABINSERTMULTIPAPERSOURCE);
					list = IDAddList(list, ID_CNTABINSERTMULTIPAPERTYPE);
				}
			}
		}
	}
	if(FindItemsList(ppd_opt->items_list, kPPD_Items_CNAdjustTrim) != NULL){
		list = IDAddList(list, ID_CNADJUSTTRIMNUM);
		list = IDAddList(list, ID_CNADJUSTFORETRIMNUM);
		list = IDAddList(list, ID_CNADJUSTTOPBOTTOMTRIMNUM);
	}
	if(FindItemsList(ppd_opt->items_list, kPPD_Items_CNPBindSpecifyFinishingBy) != NULL){
		list = IDAddList(list, ID_CNPBINDFINISHFORETRIMNUM);
		list = IDAddList(list, ID_CNPBINDFINISHTOPBOTTOMTRIMNUM);
	}
	if(FindOptionList(ppd_opt->items_list, kPPD_Items_InputSlot, "PaperName")){
		list = IDAddList(list, ID_CNFEEDPAPERNAME);
	}
	if(FindItemsList(ppd_opt->items_list, kPPD_Items_CNSendTime) != NULL){
		list = IDAddList(list, ID_CNSENDTIMENUM);
	}
	if(FindItemsList(ppd_opt->items_list, kPPD_Items_CNUseOutsideLineNum) != NULL){
		list = IDAddList(list, ID_CNOUTSIDELINENUMBER);
		list = IDAddList(list, ID_CNOUTSIDELINENUMINTRA);
		list = IDAddList(list, ID_CNOUTSIDELINENUMNGN);
		list = IDAddList(list, ID_CNOUTSIDELINENUMMYNUMBERNGN);
		list = IDAddList(list, ID_CNOUTSIDELINENUMVOIP);
	}
	if(FindItemsList(ppd_opt->items_list, kPPD_Items_CNSpecifyNumOfCopiesStack) != NULL){
		list = IDAddList(list, ID_CNSTACKCOPIESNUM);
	}
	if(FindItemsList(ppd_opt->items_list, kPPD_Items_CNSorterFinish) != NULL){
		list = IDAddList(list, ID_CNBINNAME);
		list = IDAddList(list, ID_CNBINNAME_ARRAY);
	}
	if(FindItemsList(ppd_opt->items_list, kPPD_Items_CNSaddlePress) != NULL){
		list = IDAddList(list, ID_CNSADDLEPRESSADJUSTMENT);
	}
#ifndef	__APPLE__
	if((FindItemsList(ppd_opt->items_list, kPPD_Items_CNZfolding) != NULL)
	   ||(FindItemsList(ppd_opt->items_list, kPPD_Items_CNCfolding) != NULL)
	   ||(FindItemsList(ppd_opt->items_list, kPPD_Items_CNHalfFolding) != NULL)
	   ||(FindItemsList(ppd_opt->items_list, kPPD_Items_CNAccordionZfolding) != NULL)
	   ||(FindItemsList(ppd_opt->items_list, kPPD_Items_CNDoubleParallelFolding) != NULL)){
		list = IDAddList(list, ID_CNFOLDSETTING);
	}

	if((FindItemsList(ppd_opt->items_list, kPPD_Items_CNCfoldSetting) != NULL)
	   ||(FindItemsList(ppd_opt->items_list, kPPD_Items_CNHalfFoldSetting) != NULL)
	   ||(FindItemsList(ppd_opt->items_list, kPPD_Items_CNAccordionZfoldSetting) != NULL)
	   ||(FindItemsList(ppd_opt->items_list, kPPD_Items_CNDoubleParallelFoldSetting) != NULL)){
		list = IDAddList(list, ID_CNFOLDDETAIL);
	}

	list = IDAddList(list, ID_CNPRINTSTYLE);

	if((FindItemsList(ppd_opt->items_list, kPPD_Items_CNVfolding) != NULL)
#if !defined(__APPLE__) && !defined(_OPAL)
	   ||(FindItemsList(ppd_opt->items_list, kPPD_Items_CNVfoldingTrimming) != NULL)
#endif
	   ||(FindItemsList(ppd_opt->items_list, kPPD_Items_CNSaddleStitch) != NULL)
	   ||(FindItemsList(ppd_opt->items_list, kPPD_Items_CNTrimming) != NULL))
		list = IDAddList(list, ID_CNSADDLESETTING);
#endif

	for(i = ID_CNCOPIES; i <= ID_FILTER; i++){
		list = IDAddList(list, i);
	}

	if(ppd_opt->color_mode){
		list = IDAddList(list, ID_HUE);
		list = IDAddList(list, ID_SATURATION);
	}

	for(i = ID_PPI; i <= ID_RESO_SCALE; i++){
		list = IDAddList(list, i);
	}

	if(ppd_opt->color_mode)
		list = IDAddList(list, ID_BLACKPLOT);
	list = IDAddList(list, ID_FITPLOT);
	list = IDAddList(list, ID_PENWIDTH);

	for(i = ID_SETDEFAULT; i <= ID_CANCEL; i++){
		list = IDAddList(list, i);
	}

	return list;
}



char *MakeDuplexBoolList(PPDOptions *ppd_opt)
{
	if(ppd_opt->duplex_valtype != DUPLEX_VALTYPE_TUMBLE){
		return MakePPDBoolList(ppd_opt, "Duplex");
	}else{
		char *glist = NULL;
		char curr[256];
		int dis_tumble, dis_notumble, none;
		UIItemsList *item;

		item = FindItemsList(ppd_opt->items_list, "Duplex");
		if(item == NULL)
			return NULL;

		dis_tumble = GetDisableOpt(ppd_opt->items_list, "Duplex", "DuplexTumble");
		dis_notumble = GetDisableOpt(ppd_opt->items_list, "Duplex", "DuplexNoTumble");
		none = GetDisableOpt(ppd_opt->items_list, "Duplex", "None");

		memset(curr, 0, 256);
		if(item->current_option && item->current_option->name){
			if(strcmp(item->current_option->name, "False") == 0
			|| strcmp(item->current_option->name, "None") == 0){
				if(dis_tumble != 0 && dis_notumble != 0)
					snprintf(curr, 255, "False:True<1>,False<0>");
				else
					snprintf(curr, 255, "False:True<0>,False<0>");
			}else if(dis_tumble != 0 && dis_notumble != 0){
				if(none == 0)
					snprintf(curr, 255, "False:True<1>,False<0>");
				else
					snprintf(curr, 255, "True:True<0>,False<1>");
			}else{
				if(none == 0)
					snprintf(curr, 255, "True:True<0>,False<0>");
				else
					snprintf(curr, 255, "True:True<0>,False<1>");
			}
		}

		return glist = strdup(curr);
	}
}
