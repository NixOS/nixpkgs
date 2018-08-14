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
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#ifndef _OPAL
#include <cups/cups.h>
#ifdef __APPLE__
#include <cups/file.h>
#include <cups/dir.h>
#endif
#endif


#define MAXWORDSIZE 512

#include "cngplpmod.h"
#include "ppdoptions.h"
#include "cupsoption.h"
#include "ppdkeys.h"
#include "ppdtables.h"
#include "getdata.h"

static int isCUPSSpace(char ch);
static UIConfList* BuffToCUPSUIConfList(char *buff);
static int GetCUPSUIConfList(UIItemsList *list, char *buff);

static int CheckItemCmp(char *str, const char *item);
static int CheckItemPriority(char *str1, char *str2);
static int GetUIConfList(UIItemsList *list, char *buff);
static int GetUIExtChgList(UIItemsList *list, char *buff);
int ChangeDefault(cngplpData *data, char *item_name, char *new_opt);

int SetUIValue(PPDOptions *ppd_opt, char *buf);
void FreeUIValue(UIValueList *uivalue);
int AddCNProtUIValue(PPDOptions *ppd_opt, char *buf);
int SetParamCustomPageSize(PPDOptions *ppd_opt, char *buff);
int SetCustomPageSize(PPDOptions *ppd_opt);
static void ChkCustomPageSize(cngplpData *data, char *item_name, char *opt_name, int flag);
static void CheckInputSlotValue(cngplpData *data, char *item_name, char *opt_name, int flag);
static void CheckCNDuplexValue(cngplpData *data, char *item_name, char *opt_name, int flag);
static int CheckDuplexValueType(PPDOptions *ppd_opt);
void SetMediaBrandConvList(PPDOptions *ppd_opt, char *buff);
void SetMediaBrand(PPDOptions *ppd_opt, char *buff);

static void ChkOverlayForm(cngplpData *data, char *item_name, char *opt_name, int flag);
static void ResetFormListDiable(FormList *form_list);
static void CheckFormHandleValid(cngplpData *data);
static int AddFormData(PPDOptions *ppd_opt, char *buf);
static int ConvertFormStrToStruct(char *buf, FormList *item);
static char* ConvertFormStructToStr(FormList *item);
static void FreeFormList(PPDOptions *ppd_opt);
static void FreeFormItem(FormList *item);
static FormList* FindFormList(FormList *form_list, const char *handle);
static int GetFormCount(PPDOptions *ppd_opt);
static int GetBWFormCount(PPDOptions *ppd_opt);

static void ChkCNMonitorProfile(cngplpData *data, char *item_name, char *opt_name, int flag);
static void ChkCNOutputProfile(cngplpData *data, char *item_name, char *opt_name, int flag);
static void ChkCNInsertSheet(cngplpData *data, char *item_name, char *opt_name, int flag);
static void ChkFrontSheet(cngplpData *data, char *item_name, char *opt_name, int flag);
static void ChkOrientationRequested(cngplpData *data, char *item_name, char *opt_name, int flag);
static void ChkCNPrioritizeLineText(cngplpData *data, char *item_name, char *opt_name, int flag);
static void ChkOffsetNum(cngplpData *data, char *item_name, char *opt_name, int flag);
static void ChkMediaBrandShape(cngplpData *data, char *item_name, char *opt_name, int flag);
int initMediaBrand(PPDOptions *ppd_opt);
int UpdateDeviceProfileList(cngplpData *data, char *item_name, char *buf);
int AddCNProtUIValue(PPDOptions *ppd_opt, char *buf);
int SameOpt(char *dest, char *src, int size);
static int CheckAllDevOptionElm(UIItemsList *list, UIExtConfList *ext);

static char* MakeCNMediaBrandDevOptConfList(cngplpData *data, int id, char *media_type);

char* IDtoPPDOption(int index)
{
	if(index > PPD_OPTION_NUM || index < 0)
		return NULL;
	return (char *)items_table[index];
}

char* IDtoCommonOption(int index)
{
	if(index > items_table_common_num || index < 0)
		return NULL;
	return (char *)items_table_common[index];
}

char* IDtoImageOption(int index)
{
	if(index > items_table_image_num || index < 0)
		return NULL;
	return (char *)items_table_image[index];
}

char* IDtoTextOption(int index)
{
	if(index > items_table_text_num || index < 0)
		return NULL;
	return (char *)items_table_text[index];
}

char* IDtoHPGLOption(int index)
{
	if(index > items_table_hpgl_num || index < 0)
		return NULL;
	return (char *)items_table_hpgl[index];
}

char* IDtoDevOption(int id)
{
	IDKey *tmp = IDKeyDevOptionTbl;
	while(tmp->id > 0){
		if(id == tmp->id)
			return tmp->key;
		tmp++;
	}
	return NULL;
}

void MemFree(void *pointer)
{
	if(pointer != NULL){
		free(pointer);
		pointer = NULL;
	}
}

void FillUpCopy(char *dest, char *src, int size)
{
	char *dp, *sp;
	dp = dest;
	sp = src;

	while(1){
		if(*sp == ' ' || *sp == '\t')
			sp++;
		else if(*sp == '\n' || *sp == 0xd || *sp == '\0')
			break;
		if(dp - dest == size - 1)
			break;
		*dp = *sp;
		sp++;
		dp++;
	}
	*dp = '\0';
}

char* FillUp(char *buff)
{
	char *ptr;
	ptr = buff;
	while(1){
		if(*ptr == ' ' || *ptr == '\t')
			ptr++;
		else if(*ptr == '\0' || *ptr == '\n')
			break;
		else
			break;
	}
	return ptr;
}

char* ChkMainKey(char *dest, char *src, int num)
{
	int i;
	int dc, sc;
	char *dp, *sp;
	dp = dest;
	sp = src;

	for(i = 0; i < num; i++){
		dc = tolower(*dp);
		sc = tolower(*sp);
		if(dc != sc){
			return NULL;
		}
		dp++;
		sp++;
	}
	return dp;
}

void FreeUIConf(UIConfList *uiconf)
{
	UIConfList *tmp;

	for(; uiconf != NULL; uiconf = tmp){
		tmp = uiconf->next;

		MemFree(uiconf->key);
		MemFree(uiconf->option);
		free(uiconf);
		uiconf = NULL;
	}
}

void FreeUIConst(UIConstList *uiconst)
{
	UIConstList *tmp;

	for(; uiconst != NULL; uiconst = tmp){
		tmp = uiconst->next;

		MemFree(uiconst->key);
		MemFree(uiconst->option);
		free(uiconst);
		uiconst = NULL;
	}
}

void FreeOption(UIOptionList *option)
{
	UIOptionList *tmp = NULL;
	UIExtConfList *conf = NULL, *tmp_conf = NULL;
	UIExtChgList *chg = NULL, *tmp_chg = NULL;

	for(; option != NULL; option = tmp){
		tmp = option->next;
		MemFree(option->name);
		MemFree(option->text);
		if(option->num_uiconst != 0)
			FreeUIConst(option->uiconst);
		option->uiconst = NULL;

		for(conf = option->uiconf; conf != NULL; conf = tmp_conf){
			tmp_conf = conf->next;

			FreeUIConf(conf->other_elem);
			FreeUIConf(conf->conf_elem);
			free(conf);
		}
		option->uiconf = NULL;

		for(chg = option->uichg; chg != NULL; chg = tmp_chg){
			tmp_chg = chg->next;

			FreeUIConf(chg->other_elem);
			FreeUIConf(chg->conf_elem);
			free(chg);
		}
		option->uichg = NULL;

		free(option);
		option = NULL;
	}
}

void FreeItems(UIItemsList *items_list)
{
	UIItemsList *tmp;

	for(; items_list != NULL; items_list = tmp){
		tmp = items_list->next;
		MemFree(items_list->name);
		MemFree(items_list->string);
		MemFree(items_list->default_option);
		if(items_list->new_option != NULL)
			items_list->new_option = NULL;
		if(items_list->current_option != NULL)
			items_list->current_option = NULL;

		if(items_list->num_options != 0)
			FreeOption(items_list->opt_lists);

		if(items_list->num_uiconst != 0)
			FreeUIConst(items_list->uiconst);

		items_list->opt_lists = NULL;
		items_list->uiconst = NULL;

		free(items_list);
	}
}

void FreePPDOptions(PPDOptions *ppd_opt)
{
	if(ppd_opt == NULL)
		return;

	MemFree(ppd_opt->printer_name);
#ifdef _OPAL
	if((ppd_opt->special != NULL) && (ppd_opt->special->enter_name != NULL)){
		free(ppd_opt->special->enter_name);
		ppd_opt->special->enter_name = NULL;
	}
	if((ppd_opt->special != NULL) && (ppd_opt->special->doc_name != NULL)){
		free(ppd_opt->special->doc_name);
		ppd_opt->special->doc_name = NULL;
	}
#endif
	FreeFormList(ppd_opt);
	MemFree(ppd_opt->special);
	ppd_opt->special = NULL;
	MemFree(ppd_opt->job_note);
	ppd_opt->job_note = NULL;
	FreeMediaBrand(ppd_opt);
	MemFree(ppd_opt->drv_root_path);
	FreeUIValue(ppd_opt->uivalue);
	ppd_opt->uivalue = NULL;
	FreeItems(ppd_opt->items_list);
	ppd_opt->items_list = NULL;
	FreeItems(ppd_opt->dev_items_list);
	ppd_opt->dev_items_list = NULL;
	MemFree(ppd_opt->ins_pos);
	MemFree(ppd_opt->ins_pos_papersource);
	MemFree(ppd_opt->ins_pos_printon);
	MemFree(ppd_opt->tab_ins_pos);
	MemFree(ppd_opt->tab_ins_pos_papersource);
	MemFree(ppd_opt->tab_ins_pos_printon);
	MemFree(ppd_opt->tab_ins_multi_papersource);
	ppd_opt->tab_ins_multi_papersource = NULL;
	MemFree(ppd_opt->tab_ins_multi_papertype);
	ppd_opt->tab_ins_multi_papertype = NULL;
	MemFree(ppd_opt->fax_setting);
	MemFree(ppd_opt->feed_paper_name);
	MemFree(ppd_opt->bin_name);
	MemFree(ppd_opt->bin_name_array);
	MemFree(ppd_opt->pcfile_name);
	MemFree(ppd_opt->manufacturer);
	MemFree(ppd_opt->nickname);
	MemFree(ppd_opt->cnpdl_type);
	MemFree(ppd_opt->ap_printer_icon_path);
	free(ppd_opt);
}


UIOptionList* FindOptions(UIOptionList *list, char *opt)
{
	UIOptionList *tmp = NULL;

	tmp = list;
	while(1){
		if((ChkMainKey(opt, tmp->name, strlen(opt))) != NULL){
			if(strcasecmp(opt, tmp->name) == 0)
				return tmp;
		}
		if(tmp->next == NULL)
			break;
		tmp = (UIOptionList *)tmp->next;
	}
	return NULL;
}

void DivideKeytextFromUIConst(char *buff, char *key1, char *key2, int size)
{
	char *bp, *kp1, *kp2;
	bp = buff;

	kp1 = key1;
	kp2 = key2;
	while(1){
		if(*bp == ' ' || *bp == '\t' || *bp == '*' || *bp == ':')
			bp++;
		else
			break;
		if(bp - buff == strlen(buff))
			return;
	}

	while(1){
		if(*bp == '*'){
			break;
		}
		if(kp1 - key1 == size - 1)
			break;
		*kp1 = *bp;
		bp++;
		kp1++;
	}

	*kp1 = '\0';

	while(1){
		if(*bp == '\n' || *bp == '\0' || *bp == 0xd)
			break;
		else if(*bp == '*')
			bp++;
		if(kp2 - key2 == size - 1)
			break;
		*kp2 = *bp;
		kp2++;
		bp++;
	}
	*kp2 = '\0';
}

int SetUIConstList(UIItemsList *items_list, UIItemsList *items, int items_num, int item_cnt, char *opt1, char *str2)
{
	UIItemsList *tmp_items;
	UIOptionList *list;
	UIConstList *uiconst, *tmp;
	char *ptr, opt2[MAXWORDSIZE];
	int i, match;
	match = 0;

	tmp_items = items_list;
	for(i = 0; i < items_num; i++){
		if((ptr = ChkMainKey(str2, tmp_items->name, strlen(tmp_items->name))) != NULL){
			FillUpCopy(opt2, ptr, MAXWORDSIZE);
			match++;
			break;
		}
		tmp_items = tmp_items->next;
	}
	if(match == 0)
		return 0;

	if((uiconst = (UIConstList *)malloc(sizeof(UIConstList))) == NULL)
		return ALLOC_ERROR;

	memset(uiconst, 0, sizeof(UIConstList));

	uiconst->key = strdup(tmp_items->name);
	uiconst->option = strdup(opt2);
	uiconst->next = NULL;

	list = FindOptions(items->opt_lists, opt1);

	if(list != NULL){
		if(list->num_uiconst == 0){
			if((list->uiconst = (UIConstList *)malloc(sizeof(UIConstList))) == NULL)
				return ALLOC_ERROR;
			memcpy(list->uiconst, uiconst, sizeof(UIConstList));
			free(uiconst);
		}else{
			tmp = list->uiconst;
			for(i = 0; i < list->num_uiconst - 1; i++){
				tmp = (UIConstList *)tmp->next;
			}
			tmp->next = uiconst;
		}
		list->num_uiconst++;
	}else{
		if(items->num_uiconst == 0){
			if((items->uiconst = (UIConstList *)malloc(sizeof(UIConstList))) == NULL)
				return ALLOC_ERROR;
			memcpy(items->uiconst, uiconst, sizeof(UIConstList));
			free(uiconst);
		}else{
			tmp = items->uiconst;
			for(i = 0; i < items->num_uiconst - 1; i++){
				tmp = (UIConstList *)tmp->next;
			}
			tmp->next = uiconst;
		}
		items->num_uiconst++;
	}

	return 0;
}

int GetUIConst(UIItemsList *items_list, char **items_table, char *buff, int items_num)
{
	int i, err = NO_ERROR;
	char str1[MAXWORDSIZE];
	char str2[MAXWORDSIZE];
	char *ptr;
	char opt1[MAXWORDSIZE];
	UIItemsList *items;

	memset(str1, 0, MAXWORDSIZE);
	memset(str2, 0, MAXWORDSIZE);
	memset(opt1, 0, MAXWORDSIZE);
	DivideKeytextFromUIConst(buff, str1, str2, MAXWORDSIZE);

	if(CheckItemPriority(str1, str2))
		return err;

	items = items_list;
	for(i = 0; i < items_num; i++){
		if((ptr = ChkMainKey(str1, items->name, strlen(items->name))) != NULL){
			FillUpCopy(opt1, ptr, MAXWORDSIZE);
			SetUIConstList(items_list, items, items_num, i, opt1, str2);
			break;
		}
		items = items->next;
		if(items == NULL)
			break;
	}

	return err;
}

int SetUIConstData(UIItemsList *items_list, char **items_table, char *ppd_filename, int item_num)
{
#if defined(__APPLE__) && !defined(_OPAL)
	cups_file_t *fp;
#else
	FILE *fp;
#endif
	char buff[MAXWORDSIZE], *ptr, *cp;

#if defined(__APPLE__) && !defined(_OPAL)
	if((fp = cupsFileOpen(ppd_filename, "r")) == NULL)
#else
	if((fp = fopen(ppd_filename, "r")) == NULL)
#endif
	{
		return ERROR;
	}

#if defined(__APPLE__) && !defined(_OPAL)
	while((cupsFileGets(fp,buff, MAXWORDSIZE)) != NULL)
#else
	while((fgets(buff, MAXWORDSIZE, fp)) != NULL)
#endif
	{
		ptr = FillUp(buff);
		if((cp = ChkMainKey(ptr, "*UIConstraints", 14)) != NULL){
			if((GetUIConst(items_list, items_table, cp, item_num)) != 0)
				return ERROR;
		}else if((cp = ChkMainKey(ptr, "*%CNUIConflict:", 15)) != NULL){
			if((GetUIConfList(items_list, cp)) != 0)
				return ERROR;
		}else if((cp = ChkMainKey(ptr, "*cupsUIConstraints", 18)) != NULL){
			GetCUPSUIConfList(items_list, cp);
		}else if((cp = ChkMainKey(ptr, "*%CNUIChangeDefault:", 20)) != NULL){
			if((GetUIExtChgList(items_list, cp)) != 0)
				return ERROR;
		}else if((cp = ChkMainKey(ptr, "*NonUIConstraints", 17)) != NULL){
			if((GetUIConst(items_list, items_table, cp, item_num)) != 0)
				return ERROR;
		}
	}

#if defined(__APPLE__) && !defined(_OPAL)
	cupsFileClose(fp);
#else
	fclose(fp);
#endif
	return NO_ERROR;
}

int SetOptionList(UIOptionList *opt_list, char *key, char *text, int num_list)
{
	int i;
	UIOptionList *option, *tmp;

	option = (UIOptionList *)malloc(sizeof(UIOptionList));
	if(option == NULL)
		return ALLOC_ERROR;

	memset(option ,0, sizeof(UIOptionList));

	option->name = strdup(key);
	option->text = strdup(text);

	option->next = NULL;

	if(num_list == 1){
		memcpy(opt_list, option, sizeof(UIOptionList));
		free(option);
	}else{
		tmp = opt_list;
		for(i = 0; i < num_list - 2; i++){
			tmp = (UIOptionList *)tmp->next;
		}
		tmp->next = option;
	}
	return 0;
}

void GetUIOption(char *buff, char *key, char *text, int size)
{
	char *bp, *kp, *tp;

	bp = buff;
	kp = key;
	tp = text;

	while(1){
		if(*bp == ' ' || *bp == '\t' || *bp == 0xd)
			bp++;
		if(*bp == 0xa || *bp == '\0' || *bp == ':')
			break;
		if(*bp == '/'){
			bp++;
			break;
		}
		else{
			*kp = *bp;
			kp++;
			bp++;
		}
		if(kp - key == size - 1)
			break;
	}
	*kp = '\0';

	while(1){
		if(*bp == 0xd)
			bp++;
		else if(*bp == 0xa || *bp == '\0' || *bp == ':' || *bp == '"'){
			bp--;
			if(*bp == ' ')
				tp--;
			break;
		}else if(*bp == '/'){
			bp++;
		}else{
			*tp = *bp;
			tp++;
			bp++;
		}
		if(tp - text == size - 1)
			break;
	}
	*tp = '\0';
}

void GetDefUIOption(char *buff, char *default_opt, int size)
{
	char *bufp, *optp;

	bufp = buff;
	optp = default_opt;

	while(1){
		if(*bufp == 0xa || *bufp == '\0')
			break;
		if(*bufp == ' ' || *bufp == '\t' || *bufp == 0xd || *bufp == ':')
			bufp++;
		else{
			*optp = *bufp;
			bufp++;
			optp++;
		}
		if(optp - default_opt == size - 1)
			break;
	}
	*optp = '\0';
}


int SetUIItemParam(UIItemsList *items, char *buff)
{
	char key[MAXWORDSIZE], defkey[MAXWORDSIZE];
	int num_key, num_defkey;
	char *kp, *dkp;

	num_key = snprintf(key, MAXWORDSIZE - 1, "*%s", items->name);
	num_defkey = snprintf(defkey, MAXWORDSIZE - 1, "*Default%s", items->name);

	if(*buff == '*'){
		if((dkp = ChkMainKey(buff, defkey, num_defkey)) != NULL){
			char defopt[MAXWORDSIZE];
			memset(defopt, 0, MAXWORDSIZE);
			GetDefUIOption(dkp, defopt, MAXWORDSIZE);
			items->default_option = strdup(defopt);
		}else if((kp = ChkMainKey(buff, key, num_key)) != NULL){
			char key[MAXWORDSIZE], text[MAXWORDSIZE];
			memset(key, 0, MAXWORDSIZE);
			memset(text, 0, MAXWORDSIZE);
			GetUIOption(kp, key, text, MAXWORDSIZE);
			items->num_options++;
			if((SetOptionList(items->opt_lists, key, text, items->num_options)) == ALLOC_ERROR)
				return ALLOC_ERROR;
		}
	}else{

	}
	return NO_ERROR;
}

int GetUIType(char *buff)
{
	int type = 0;
	if((strstr(buff, "PickOne")) != NULL)
		type = PICKONE;
	else if((strstr(buff, "PickMany")) != NULL)
		type = PICKMANY;
	else if((strstr(buff, "Boolean")) != NULL)
		type = BOOLEAN;
	return type;
}

char* SetItemString(char *buff)
{
	char *ptr = buff;
	char *pstr;
	char *ret = NULL;
	int num = strlen(buff) + 1;
	while(1){
		if(*ptr == '/'){
			ptr++;
			break;
		}
		if(*ptr == '\0' || *ptr == '\n' || *ptr == ':')
			return ret;
		ptr++;
	}
	if((ret = (char *)malloc(num)) == NULL)
		return ret;
	pstr = ret;

	while(1){
		if(*ptr == '\0' || *ptr == '\n')
			return ret;
		if(*ptr == ':'){
			*pstr = '\0';
			break;
		}
		*pstr = *ptr;
		pstr++;
		ptr++;
	}
	return ret;
}

UIItemsList* SetUIItemName(UIItemsList *items_list, char **items_table, char *buff, int num)
{
	UIItemsList *items = NULL, *tmp;
	char mainkey[128], *mp, *ptr;
	int type = -1;
	int i = 0;
	int items_num = num;

	memset(mainkey, 0, sizeof(mainkey));
	ptr = buff;
	mp = mainkey;

	while(1){
		if(*ptr == '\0' || *ptr == '\n')
			return NULL;
		if(isalpha(*ptr))
			break;
		else
			ptr++;
	}

	while(1){
		if(*ptr == '\0' || *ptr == '\n')
			return NULL;
		if(mp - mainkey == 127)
			break;
		if(isalpha(*ptr)){
			*mp = *ptr;
			mp++;
			ptr++;
		}else{
			*mp = '\0';
			break;
		}
	}

	while(1){
		if(items_table[i] == NULL)
			break;
		if((strcasecmp(mainkey, items_table[i])) == 0){
			type = i;
			items_num++;
			items = (UIItemsList *)malloc(sizeof(UIItemsList));
			if(items == NULL)
				return NULL;

			memset(items, 0, sizeof(UIItemsList));

			items->name = strdup(items_table[i]);
			items->next = NULL;
			items->string = SetItemString(ptr);
			items->type = GetUIType(buff);
			items->default_option = NULL;
			items->opt_lists = (UIOptionList *)malloc(sizeof(UIOptionList));
			if(items->opt_lists == NULL)
				return NULL;

			memset(items->opt_lists, 0, sizeof(UIOptionList));

			if(items_num == 1){
				memcpy(items_list, items, sizeof(UIItemsList));
				free(items);
				return items_list;
			}else{
				tmp = items_list;
				for(i = 0; i < items_num - 2; i++){
					tmp = tmp->next;
				}
				tmp->next = items;
			}
			break;
		}
		i++;
	}
	return items;
}

int SetColorMode(char *buff)
{
	char *ptr;
	ptr = FillUp(buff);
	if((ChkMainKey(ptr, "true", 4)) != NULL)
		return 1;
	else if((ChkMainKey(ptr, "false", 5)) != NULL)
		return 0;
	return -1;
}

void SetModelName(PPDOptions *ppd_opt, char *buff)
{
	char *ptr, name[128], *np;

	memset(name, 0, sizeof(name));
	ptr = buff;
	np = name;
	while(1){
		if(*ptr == '\0' || *ptr == '\n')
			break;
		if(*ptr == '\"'){
			ptr++;
			break;
		}
		ptr++;
	}

	while(1){
		if(*ptr == '\0' || *ptr == '\n'){
			*np = '\0';
			break;
		}
		if(*ptr == '\"'){
			*np = '\0';
			break;
		}
		if(np - name == 127)
			break;
		*np = *ptr;
		np++;
		ptr++;
	}

	ppd_opt->printer_name = strdup(name);
}

void SetPrintLang(PPDOptions *ppd_opt, char *buff)
{
	if(strstr(buff, "LIPS4") != NULL){
		ppd_opt->printer_type = PRINTER_TYPE_LIPS;
	}else if(strstr(buff, "PS3") != NULL){
		ppd_opt->printer_type = PRINTER_TYPE_PS;
	}else if(strstr(buff, "UFR2") != NULL){
		ppd_opt->printer_type = PRINTER_TYPE_UFR2;
	}else if(strstr(buff, "CAPT") != NULL){
		ppd_opt->printer_type = PRINTER_TYPE_CAPT;
	}else if(strstr(buff, "FAX") != NULL){
		ppd_opt->printer_type = PRINTER_TYPE_FAX;
	}else{
		ppd_opt->printer_type = PRINTER_TYPE_OTHER;
	}
}

int SetInputSelect(char *buff)
{
	if(strstr(buff, "False") != NULL)
		return SELECTBY_NONE;
	else
		return SELECTBY_INPUTSLOT;
}

double SetMaxLengthDouble(char *buff)
{
	char *ptr, num[32], *np;

	memset(num, 0, sizeof(num));
	ptr = buff;
	np = num;

	while(1){
		if(*ptr == '\0' || *ptr == '\n')
			break;
		if(*ptr == '\"'){
			ptr++;
			break;
		}
		ptr++;
	}

	while(1){
		if(*ptr == '\0' || *ptr == '\n'){
			*np = '\0';
			break;
		}
		if(*ptr == '\"'){
			*np = '\0';
			break;
		}
		if(np - num == 31)
			break;
		*np = *ptr;
		np++;
	ptr++;
	}
	return atof(num);
}

int SetMaxLength(char *buff)
{
	char *ptr, num[32], *np;

	memset(num, 0, sizeof(num));
	ptr = buff;
	np = num;

	while(1){
		if(*ptr == '\0' || *ptr == '\n')
			break;
		if(*ptr == '\"'){
			ptr++;
			break;
		}
		ptr++;
	}

	while(1){
		if(*ptr == '\0' || *ptr == '\n'){
			*np = '\0';
			break;
		}
		if(*ptr == '\"'){
			*np = '\0';
			break;
		}
		if(np - num == 31)
			break;
		*np = *ptr;
		np++;
		ptr++;
	}
	return atoi(num);
}

void SetDriverRootPath(PPDOptions *ppd_opt, char *buff)
{
	char *ptr, name[128], *np;

	memset(name, 0, sizeof(name));
	ptr = buff;
	np = name;
	while(1){
		if(*ptr == '\0' || *ptr == '\n')
			break;
		if(*ptr == '\"'){
			ptr++;
			break;
		}
		ptr++;
	}

	while(1){
		if(*ptr == '\0' || *ptr == '\n'){
			*np = '\0';
			break;
		}
		if(*ptr == '\"'){
			*np = '\0';
			break;
		}
		if(np - name == 127)
			break;
		*np = *ptr;
		np++;
		ptr++;
	}

	ppd_opt->drv_root_path = strdup(name);
}

void SetPCFileName(PPDOptions *ppd_opt, char *buff)
{
	char *ptr, name[128], *np;

	memset(name, 0, sizeof(name));
	ptr = buff;
	np = name;
	while(1){
		if(*ptr == '\0' || *ptr == '\n'){
			break;
		}
		if(*ptr == '\"'){
			ptr++;
			break;
		}
		ptr++;
	}

	while(1){
		if(*ptr == '\0' || *ptr == '\n'){
			*np = '\0';
			break;
		}
		if(*ptr == '\"'){
			*np = '\0';
			break;
		}
		if(*ptr == '.'){
			*np = '\0';
			break;
		}
		if(*ptr == ' ' || *ptr == ':'){
			ptr++;
			continue;
		}
		if(np - name == 127){
			break;
		}
		*np = *ptr;
		np++;
		ptr++;
	}
	ppd_opt->pcfile_name = strdup(name);
}

char *GetDoubleQuotationValue(PPDOptions *ppd_opt, char *buff)
{
	char *ptr, name[128], *np;

	memset(name, 0, sizeof(name));
	ptr = buff;
	np = name;
	while(1){
		if(*ptr == '\0' || *ptr == '\n')
			break;
		if(*ptr == '\"'){
			ptr++;
			break;
		}
		ptr++;
	}

	while(1){
		if(*ptr == '\0' || *ptr == '\n'){
			*np = '\0';
			break;
		}
		if(*ptr == '\"'){
			*np = '\0';
			break;
		}
		if(np - name == 127)
			break;
		*np = *ptr;
		np++;
		ptr++;
	}

	return strdup(name);
}

int SetPrinterData(PPDOptions *ppd_opt, char *buff)
{
	char *ptr;

	if((ptr = ChkMainKey(buff, "*ModelName:", 10)) != NULL){
		SetModelName(ppd_opt, ptr);
	}else if((ptr = ChkMainKey(buff, "*%CNPrintLang", 13)) != NULL){
		SetPrintLang(ppd_opt, ptr);
		if(ppd_opt->printer_type == PRINTER_TYPE_FAX){
			if(ppd_opt->fax_setting == NULL){
				ppd_opt->fax_setting = (FAXFunc *)malloc(sizeof(FAXFunc));
				if(ppd_opt->fax_setting == NULL)
					return -1;
				memset(ppd_opt->fax_setting, 0, sizeof(FAXFunc));
				cngplp_util_strcpy(ppd_opt->fax_setting->send_time, "0_00");
				cngplp_util_strcpy(ppd_opt->fax_setting->outside_line_number, "");
                strncpy(ppd_opt->fax_setting->outside_line_number_intra, "", 5);
                strncpy(ppd_opt->fax_setting->outside_line_number_ngn, "", 5);
                strncpy(ppd_opt->fax_setting->outside_line_number_ngnmynum, "", 5);
                strncpy(ppd_opt->fax_setting->outside_line_number_voip, "", 5);
			}
		}
	}else if((ptr = ChkMainKey(buff, "*ColorDevice:", 13)) != NULL){
		ppd_opt->color_mode = SetColorMode(ptr);
	}else if((ChkMainKey(buff, "*%CNJobAccount:", 15)) != NULL){
		if(strstr(buff, "True") != NULL){
			if(ppd_opt->special == NULL){
				ppd_opt->special = (SpecialFunc *)malloc(sizeof(SpecialFunc));
				if(ppd_opt->special == NULL)
					return -1;
				memset(ppd_opt->special, 0, sizeof(SpecialFunc));
			}
#if !defined(__APPLE__) && !defined(_OPAL)
			ppd_opt->special->show_job_account =1;
#endif
		}
	}else if((ChkMainKey(buff, "*%CNDisableJobAccountingBW:", 27)) != NULL){
		if(strstr(buff, "True") != NULL){
			if(ppd_opt->special == NULL){
				ppd_opt->special = (SpecialFunc *)malloc(sizeof(SpecialFunc));
				if(ppd_opt->special == NULL)
					return -1;
				memset(ppd_opt->special, 0, sizeof(SpecialFunc));
			}
			ppd_opt->special->show_disable_job_account_bw =1;
		}
	}else if((ChkMainKey(buff, "*%CNMailBox:", 12)) != NULL){
		if(strstr(buff, "True") != NULL){
			if(ppd_opt->special == NULL){
				ppd_opt->special = (SpecialFunc *)malloc(sizeof(SpecialFunc));
				if(ppd_opt->special == NULL)
					return -1;
				memset(ppd_opt->special, 0, sizeof(SpecialFunc));
			}
			AddUIValueList(ppd_opt, "EnableCNMailBox", "True", 0);
		}
	}else if((ChkMainKey(buff, "*%CNSecuredPrint:", 17)) != NULL){
		if(strstr(buff, "True") != NULL){
			if(ppd_opt->special == NULL){
				ppd_opt->special = (SpecialFunc *)malloc(sizeof(SpecialFunc));
				if(ppd_opt->special == NULL)
					return -1;
				memset(ppd_opt->special, 0, sizeof(SpecialFunc));
			}
		}
	}else if((ChkMainKey(buff, "*%CNHoldPrint:", 14)) != NULL){
		if(strstr(buff, "True") != NULL){
			if(ppd_opt->special == NULL){
				ppd_opt->special = (SpecialFunc *)malloc(sizeof(SpecialFunc));
				if(ppd_opt->special == NULL)
					return -1;
				memset(ppd_opt->special, 0, sizeof(SpecialFunc));
			}
		}
	}else if((ChkMainKey(buff, "*%CNInputSelect:", 16)) != NULL){
		ppd_opt->selectby = SetInputSelect(buff);
	}else if((ChkMainKey(buff, "*CNMaxBoxNum:", 13)) != NULL){
		ppd_opt->max_box_num = SetMaxLength(buff);
	}else if((ChkMainKey(buff, "*CNMaxDocStr:", 13)) != NULL){
		ppd_opt->max_doc_length = SetMaxLength(buff);
	}else if((ChkMainKey(buff, "*CNMaxCopies:", 13)) != NULL){
		ppd_opt->max_copy_num = SetMaxLength(buff);
	}else if((ChkMainKey(buff, "*CNMaxGutter:", 13)) != NULL){
		ppd_opt->max_gutter_value = SetMaxLength(buff);
                ppd_opt->max_gutter_value_d = SetMaxLengthDouble(buff);
	}else if((ChkMainKey(buff, "*CNListIDMediaType:", 19)) != NULL){
		ppd_opt->list_mediatype_value = SetMaxLength(buff);
	}else if((ChkMainKey(buff, "*CNListIDPageSize:", 18)) != NULL){
		ppd_opt->list_pagesize_value = SetMaxLength(buff);
	}else if((ChkMainKey(buff, "*%CNDPIconPICTID:", 16)) != NULL){
		ppd_opt->dpicon_pictid = SetMaxLength(buff);
	}else if((ChkMainKey(buff, "*%CNEnableFinishFlag:", 20)) != NULL){
		ppd_opt->enable_finishflag = SetMaxLength(buff);
	}else if((ChkMainKey(buff, "*%CNEnableInputFlag:", 19)) != NULL){
		ppd_opt->enable_inputflag = SetMaxLength(buff);
	}else if((ChkMainKey(buff, "*%CNEnableQualityType:", 21)) != NULL){
		ppd_opt->enable_qualitytype = SetMaxLength(buff);
	}else if((ChkMainKey(buff, "*%CNUIConfFlag:", 15)) != NULL){
		ppd_opt->uiconf_flag = SetMaxLength(buff);
	}else if((ChkMainKey(buff, "*%CNSUMMARYFlag:", 16)) != NULL){
		ppd_opt->summary_flag = SetMaxLength(buff);
#if !defined(__APPLE__) && !defined(_OPAL)
	}else if((ChkMainKey(buff, "*%CNBookletOffset:", 18)) != NULL){
		ppd_opt->booklet_offset = SetMaxLength(buff);
#endif
	}else if((ptr = ChkMainKey(buff, "*%CNUIValue:", 12)) != NULL){
		SetUIValue(ppd_opt, ptr);
	}else if(ChkMainKey(buff, "*CustomPageSize", 15) != NULL){
		if(strstr(buff, "True") != NULL)
			ppd_opt->custom_size = 1;
	}else if((ptr = ChkMainKey(buff, "*ParamCustomPageSize ", 21)) != NULL){
		SetParamCustomPageSize(ppd_opt, ptr);
        }else if((ChkMainKey(buff, "*CNUSType:", 10)) != NULL){
			if(strstr(buff, "True") != NULL){
				ppd_opt->us_type = 1;
			}
	}else if((ChkMainKey(buff, "*CNTblInputSlot:", 16)) != NULL){
		ppd_opt->input_slot_type = SetMaxLength(buff);
	}else if((ChkMainKey(buff, "*CNShiftStartPrintPosType:", 26)) != NULL){
		ppd_opt->shift_pos_type = SetMaxLength(buff);
	}else if((ChkMainKey(buff, "*%CNJobNote:", 12)) != NULL){
		if(strstr(buff, "True") != NULL){
			if(ppd_opt->job_note == NULL){
				ppd_opt->job_note = (JobNote *)malloc(sizeof(JobNote));
				if(ppd_opt->job_note == NULL)
					return -1;
				memset(ppd_opt->job_note, 0, sizeof(JobNote));
			}
		}
	}else if((ptr = ChkMainKey(buff, "*CNDriverRootPath:", 18)) != NULL){
		SetDriverRootPath(ppd_opt, ptr);
	}else if((ptr = ChkMainKey(buff, "*%CNMediaBrand:", 15)) != NULL){
		SetMediaBrand(ppd_opt, ptr);
	}else if((ptr = ChkMainKey(buff, "*%CNMdBrCnvTbl:", 15)) != NULL){
		SetMediaBrandConvList(ppd_opt, ptr);
	}else if((ChkMainKey(buff, "*%CNOverlay:", 12)) != NULL){
		if(strstr(buff, "True") != NULL){
			if(ppd_opt->special == NULL){
				ppd_opt->special = (SpecialFunc *)malloc(sizeof(SpecialFunc));
				if(ppd_opt->special == NULL)
					return -1;
				memset(ppd_opt->special, 0, sizeof(SpecialFunc));
			}
		}
	}else if((ptr = ChkMainKey(buff, "*CN_Prot_DisableCustomRect", 26)) != NULL){
		AddCNProtUIValue(ppd_opt, buff);
	}else if((ptr = ChkMainKey(buff, "*CN_Prot_DisableDisableCustomRect:", 34)) != NULL){
		AddCNProtUIValue(ppd_opt, buff);
	}else if((ChkMainKey(buff, "*CNListIDSpecialPrintMode:", 26)) != NULL){
		ppd_opt->list_specialprintmode_value = SetMaxLength(buff);
	}else if((ptr = ChkMainKey(buff, "*PCFileName:", 12)) != NULL){
		SetPCFileName(ppd_opt, ptr);
	}else if((ptr = ChkMainKey(buff, "*Manufacturer:", 14)) != NULL){
		ppd_opt->manufacturer = GetDoubleQuotationValue(ppd_opt, ptr);
	}else if((ptr = ChkMainKey(buff, "*NickName:", 10)) != NULL){
		ppd_opt->nickname = GetDoubleQuotationValue(ppd_opt, ptr);
	}else if((ptr = ChkMainKey(buff, "*CNPDLType:", 11)) != NULL){
		ppd_opt->cnpdl_type = GetDoubleQuotationValue(ppd_opt, ptr);
	}else if((ptr = ChkMainKey(buff, "*APPrinterIconPath:", 19)) != NULL){
		ppd_opt->ap_printer_icon_path = GetDoubleQuotationValue(ppd_opt, ptr);
	}
	return 0;
}

int SetUIData(PPDOptions *ppd_opt, char **items_table, char *ppd_filename)
{
#if defined(__APPLE__) && !defined(_OPAL)
	cups_file_t *fp;
#else
	FILE *fp;
#endif
	char buff[MAXWORDSIZE], *ptr, *tmp;
	UIItemsList *items_list;
	UIItemsList *items = NULL;
	int items_num = 0;

	items_list = ppd_opt->items_list;
#if defined(__APPLE__) && !defined(_OPAL)
	if((fp = cupsFileOpen(ppd_filename, "r")) == NULL)
#else
	if((fp = fopen(ppd_filename, "r")) == NULL)
#endif
	{
		return ERROR;
	}
#if defined(__APPLE__) && !defined(_OPAL)
	while((cupsFileGets(fp,buff, MAXWORDSIZE)) != NULL)
#else
	while((fgets(buff, MAXWORDSIZE, fp)) != NULL)
#endif
	{
		ptr = FillUp(buff);
		if((tmp = ChkMainKey(ptr, "*OpenUI", 7)) != NULL){
			items = SetUIItemName(items_list, items_table, tmp, items_num);
			if(items != NULL)
				items_num++;
		}else if((strstr(ptr, "*CloseUI")) != NULL){
			items = NULL;
		}else if(items != NULL){
			SetUIItemParam(items, ptr);
		}else{
			SetPrinterData(ppd_opt, ptr);
		}
	}

	if(items_num == 0){
		items_list->name = strdup("dummy");
		items_list->string = strdup("dummy");
		items_list->type = PICKONE;
		items_list->default_option = strdup("dummy");
		items_list->opt_lists = (UIOptionList *)malloc(sizeof(UIOptionList));
		if(items_list->opt_lists != NULL){
			memset(items_list->opt_lists, 0, sizeof(UIOptionList));
			items_list->opt_lists->name = strdup("dummy");
			items_list->opt_lists->text = strdup("dummy");
		}
		items_num++;
	}

	SetCustomPageSize(ppd_opt);
	CheckDuplexValueType(ppd_opt);
	initMediaBrand(ppd_opt);
	InitAdjustTrimm(ppd_opt);

	ppd_opt->items_num = items_num;
#if defined(__APPLE__) && !defined(_OPAL)
	cupsFileClose(fp);
#else
	fclose(fp);
#endif
	return items_num;
}

int ParsePPD(PPDOptions *ppd_opt, char *ppd_filename)
{
	int ret = -1;

	if(ppd_filename == NULL){
		ppd_opt->printer_type = PRINTER_TYPE_OTHER;
		return 1;
	}

	if((ret = SetUIData(ppd_opt, (char **)items_table, ppd_filename)) < 0)
		return -1;

	if(SetUIConstData(ppd_opt->items_list, (char **)items_table, ppd_filename, ret))
		return -1;

	return ret;
}


void InitUIDisable(cngplpData *data)
{
	UIItemsList *items_list = data->ppd_opt->items_list;
	UIItemsList *tmp_list;

	ResetCurrOption(items_list);

#ifdef __APPLE__
	tmp_list = items_list;
	while(1){
		if((tmp_list->current_option != NULL) && (tmp_list->current_option->name != NULL)){
			SetUIConst(data, tmp_list->name, tmp_list->current_option->name);
			MarkDisable(data, tmp_list->name, tmp_list->current_option->name, 1, 0);
		}
		if(tmp_list->next == NULL)
			break;
		tmp_list = tmp_list->next;
	}
	if(data->ppd_opt->special){
		MarkDisable(data, kPPD_Items_Device_CNFormHandle, data->ppd_opt->special->form_handle, 1, 0);
	}

	tmp_list = items_list;
	while(1){
		if((tmp_list->current_option != NULL) && (tmp_list->current_option->name != NULL)){
			RemarkOptValue(data, tmp_list->name);
		}
		if(tmp_list->next == NULL)
			break;
		tmp_list = tmp_list->next;
	}
#else
	tmp_list = items_list;
	while(1){
		if((tmp_list->current_option != NULL) && (tmp_list->current_option->name != NULL)){
			SetUIConst(data, tmp_list->name, tmp_list->current_option->name);
			MarkDisable(data, tmp_list->name, tmp_list->current_option->name, 1, 0);
			RemarkOptValue(data, tmp_list->name);
		}
		if(tmp_list->next == NULL)
			break;
		tmp_list = tmp_list->next;
	}
#endif
}

void ResetUIDisable(cngplpData *data)
{
	UIItemsList *items_list = data->ppd_opt->items_list;
	UIItemsList *tmp_list;
	UIOptionList *tmp_opt;

	tmp_list = items_list;
	while(1){
		tmp_opt = tmp_list->opt_lists;
		while(1){
			tmp_opt->disable = 0;
			if(tmp_opt->next == NULL)
				break;
			tmp_opt = tmp_opt->next;
		}
		tmp_list->disable = 0;
		if(tmp_list->next == NULL)
			break;
		tmp_list = tmp_list->next;
	}

#ifdef __APPLE__
	if(data->ppd_opt->special && data->ppd_opt->special->form_list){
		ResetFormListDiable(data->ppd_opt->special->form_list);
	}
#endif
}

UIOptionList *FindOptionList(UIItemsList *items_list, char *item_name, char *opt_name)
{
	UIItemsList *tmp_items;
	UIOptionList *tmp_opt = NULL;
	tmp_items = items_list;

	if(item_name == NULL || opt_name == NULL)
		return NULL;

	while(1){
		if((strcasecmp(tmp_items->name, item_name)) == 0){
			tmp_opt = tmp_items->opt_lists;
			while(1){
				if((strcasecmp(tmp_opt->name, opt_name)) == 0){
					return tmp_opt;
				}

				if(tmp_opt->next == NULL)
					break;
				tmp_opt = tmp_opt->next;
			}
		}

		if(tmp_items->next == NULL)
			break;
		tmp_items = tmp_items->next;
	}

	return NULL;
}

UIItemsList* FindItemsList(UIItemsList *items_list, char *items_name)
{
	UIItemsList *tmp;
	tmp = items_list;
	while(1){
		if((strcasecmp(tmp->name, items_name)) == 0){
			return tmp;
		}

		if(tmp->next == NULL)
			break;

		tmp = tmp->next;
	}

	return NULL;
}

UIItemsList* FindPrevItemsList(UIItemsList *items_list, char *items_name)
{
	UIItemsList *tmp, *prev = NULL;
	tmp = items_list;
	while(1){
		if((strcasecmp(tmp->name, items_name)) == 0){
			return prev;
		}

		if(tmp->next == NULL)
			break;

		prev = tmp;
		tmp = tmp->next;
	}

	return NULL;
}

void ResetCurrOption(UIItemsList *items_list)
{
	UIItemsList *tmp_items;
	UIOptionList *tmp_opts;

	tmp_items = items_list;

	while(1){
		tmp_opts = tmp_items->opt_lists;

		tmp_items->current_option = tmp_opts;
		while(1){
			if(tmp_items->default_option == NULL){
				tmp_items->current_option = tmp_opts;
				break;
			}

			if(ChkMainKey(tmp_opts->name, tmp_items->default_option, strlen(tmp_items->default_option)) != NULL){
				tmp_items->current_option = tmp_opts;
				break;
			}

			if(tmp_opts->next == NULL)
				break;
			tmp_opts = tmp_opts->next;
		}

		if(tmp_items->next == NULL)
			break;
		tmp_items = tmp_items->next;
	}
}

UIOptionList* FindCurrOption(UIItemsList *list, char *item_name)
{
	UIItemsList *item;

	item = FindItemsList(list, item_name);

	if(item == NULL)
		return NULL;

	if(item->current_option == NULL)
		return NULL;

	return item->current_option;
}

char* FindCurrOpt(UIItemsList *list, char *item_name)
{
	UIItemsList *item;

	item = FindItemsList(list, item_name);

	if(item == NULL)
		return NULL;

	if(item->current_option == NULL)
		return NULL;

	if(item->current_option->name)
		return item->current_option->name;

	if(item->current_option->text)
		return item->current_option->text;

	return NULL;
}

char* GetItemString(UIItemsList *list, char *item_name)
{
	UIItemsList *item = FindItemsList(list, item_name);

	if(item == NULL)
		return NULL;

	return item->string;
}

int GetActiveData(UIItemsList *list, char *item_name)
{
	UIOptionList *opt;
	int active = -1;

	opt = FindCurrOption(list, item_name);

	if(opt != NULL){
		if(strcasecmp(opt->name, "True") == 0)
			active = 1;
		else if(strcasecmp(opt->name, "False") == 0)
			active = 0;
		else if(strcasecmp(opt->name, "None") == 0)
			active = 0;
		else
			active = 1;
	}
	return active;
}

int GetActiveBooklet(PPDOptions *ppd_opt)
{
#ifndef __APPLE__
	return GetActiveData(ppd_opt->items_list, "Booklet");
#else
	UIOptionList *opt;
	int active = -1;

	if(ppd_opt->printer_type == PRINTER_TYPE_CAPT){
		return GetActiveData(ppd_opt->items_list, "Booklet");
	}else{
		opt = FindCurrOption(ppd_opt->items_list, kPPD_Items_CNDuplex);

		if(opt != NULL){
			if(strcasecmp(opt->name, "Booklet") == 0)
				active = 1;
			else if(strcasecmp(opt->name, "PerfectBind") == 0)
				active = 1;
			else
				active = 0;
		}
		return active;
	}
#endif
}

int GetDisableOpt(UIItemsList *list, char *item_name, char *opt_name)
{
	UIOptionList *opt;

	opt = FindOptionList(list, item_name, opt_name);
	if(opt != NULL)
		return opt->disable;

	return -1;
}

int GetDisable(UIItemsList *list, char *item_name)
{
	UIItemsList *item;
	UIOptionList *opt;
	int disable = 0;

	item = FindItemsList(list, item_name);
	if(item == NULL)
		return -1;

	opt = item->opt_lists;
	while(1){
		disable += opt->disable;
		if(opt->next == NULL)
			break;
		opt = opt->next;
	}

	return disable;
}

int CurrDisable(UIItemsList *lists, char *item_name)
{
	UIItemsList *opt_item;

	opt_item = FindItemsList(lists, item_name);
	if(opt_item != NULL){
		if(opt_item->current_option != NULL){
			if(opt_item->current_option->disable)
				return 1;
		}
	}
	return 0;
}

void UpdateEnableData(cngplpData *data, char *item_name, int num)
{
	UIItemsList *lists = data->ppd_opt->items_list;
	UIItemsList *item;
	UIOptionList *opt;
	int cnt = 0;

	item = FindItemsList(lists, item_name);
	if(item != NULL){
		if(item->opt_lists == NULL)
			return;
		opt = item->opt_lists;

		if(item->default_option != NULL){
			while(1){
				if(strcmp(opt->name,item->default_option) == 0){
					if(!opt->disable){
						UpdatePPDData(data, item_name, opt->name);
						return;
					}
				}
				if(opt->next == NULL)
					break;
				opt = opt->next;
			}
			opt = item->opt_lists;
		}
		while(1){
			if(!opt->disable){
				if(num == cnt){
					UpdatePPDData(data, item_name, opt->name);
					break;
				}
				cnt++;
			}
			if(opt->next == NULL)
				break;
			opt = opt->next;
		}
	}
}
void CheckOptValid(cngplpData *data, char *item_name, int num)
{
	UIItemsList *tmp;

	tmp = data->ppd_opt->items_list;
	while(1){
		if(CurrDisable(data->ppd_opt->items_list, tmp->name) > 0){
				UpdateEnableData(data, tmp->name, num);
			if(strcmp(kPPD_Items_MediaType, tmp->name) == 0){
				UpdateMediaBrandWithCurrMediaType(data,1);
			}
		}
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
	}
}

void RemarkOptValue(cngplpData *data, char *item_name)
{
	if(strcmp("PageSize", item_name) == 0){
		CheckOptValid(data, item_name, 0);
	}else if(strcmp("BindEdge", item_name) == 0){
		CheckOptValid(data, item_name, 1);
	}else{
		CheckOptValid(data, item_name, 0);
	}
}


void CreateOptionByItem(char **update_options, char *item_name)
{
	char *tmp = NULL;

	if( (update_options == NULL) ||
		(item_name == NULL)
	){
		return;
	}

	if(*update_options == NULL){
		tmp = strdup(item_name);
		if(tmp == NULL){
			return;
		}
		*update_options = tmp;
	}
	else{
		int size;

		if(SameOpt(*update_options, item_name, strlen(item_name))){
			return;
		}
		size = strlen(item_name) + strlen(*update_options) + 4;
		tmp = (char *)malloc(size);
		memset(tmp, 0, size);
		cngplp_util_strcpy(tmp, *update_options);
		cngplp_util_strcat(tmp, ",");
		cngplp_util_strcat(tmp, item_name);

		MemFree(*update_options);

		*update_options = tmp;
	}
}

void UpdatePPDData_Priority(cngplpData *data, char *item_name, char *new_opt)
{
	UIItemsList *list = data->ppd_opt->items_list;
	UIItemsList *opt_item;

	opt_item = FindItemsList(list, item_name);
	if(opt_item != NULL){
		if(new_opt){
			opt_item->new_option = strdup(new_opt);
		}else{
			opt_item->new_option = strdup(opt_item->default_option);
		}
		if(opt_item->current_option != NULL){
			ResetUIConst(data, item_name, opt_item->current_option->name);
			MarkDisable(data, item_name, opt_item->current_option->name, -1, 1);
		}

		UpdateCurrOption(opt_item);

		{
			UIOptionList *temp_opt = NULL;
			UIConstList *temp_const = NULL;
			char *pList = NULL;
			char *pList_tmp = NULL;

			temp_opt = FindOptionList(list, item_name, opt_item->current_option->name);
			if(temp_opt && (temp_const = temp_opt->uiconst) != NULL){
				while(temp_opt->num_uiconst){
					CreateOptionByItem(&pList, temp_const->key);
					if(temp_const->next == NULL)
						break;
					temp_const = temp_const->next;
				}

				if(pList){
					char *tok = NULL;

					for(tok = strtok_r(pList, ",", &pList_tmp); tok != NULL; tok = strtok_r(NULL, ",", &pList_tmp)) {
						UpdatePPDData_Priority(data, tok, NULL);
					}
					free(pList);
					pList = NULL;
				}
			}
		}

		if(opt_item->current_option != NULL){
			SetUIConst(data, item_name, opt_item->current_option->name);
			MarkDisable(data, item_name, opt_item->current_option->name, 1, 1);
		}

		RemarkOptValue(data, item_name);
		ChangeDefault(data, item_name, opt_item->current_option->name);
	}
}

void UpdatePPDData(cngplpData *data, char *item_name, char *new_opt)
{
	UIItemsList *list = data->ppd_opt->items_list;
	UIItemsList *opt_item;

	opt_item = FindItemsList(list, item_name);
	if(opt_item != NULL){
		if(new_opt){
			opt_item->new_option = strdup(new_opt);
		}else{
			opt_item->new_option = strdup(opt_item->default_option);
		}
		if(opt_item->current_option != NULL){
			ResetUIConst(data, item_name, opt_item->current_option->name);
			MarkDisable(data, item_name, opt_item->current_option->name, -1, 1);
		}
		UpdateCurrOption(opt_item);
		if(opt_item->current_option != NULL){
			SetUIConst(data, item_name, opt_item->current_option->name);
			MarkDisable(data, item_name, opt_item->current_option->name, 1, 1);
		}

		RemarkOptValue(data, item_name);
        if(opt_item->current_option != NULL){
            ChangeDefault(data, item_name, opt_item->current_option->name);
        }
	}
}

void UpdateCurrOption(UIItemsList *curr_items)
{
	UIOptionList *tmp_opt_list;

	tmp_opt_list = curr_items->opt_lists;

	while(1){
		if(strlen(tmp_opt_list->text)){
			if(strcasecmp(curr_items->new_option, tmp_opt_list->text) == 0){
				curr_items->current_option = tmp_opt_list;
				break;
			}
			if(strcasecmp(curr_items->new_option, tmp_opt_list->name) == 0){
				curr_items->current_option = tmp_opt_list;
				break;
			}
		}else{
			if(strcasecmp(curr_items->new_option, tmp_opt_list->name) == 0){
				curr_items->current_option = tmp_opt_list;
				break;
			}
		}

		if(tmp_opt_list->next == NULL)
			break;
		tmp_opt_list = tmp_opt_list->next;
	}

	MemFree(curr_items->new_option);
	curr_items->new_option = NULL;
}

void ResetUIConst(cngplpData *data, char *old_item_name, char *old_opt_name)
{
	UIItemsList *items_list = data->ppd_opt->items_list;
	if(old_opt_name != NULL){
		UIOptionList *old_opt;
		UIConstList *old_const;

		old_opt = FindOptionList(items_list, old_item_name, old_opt_name);
		if(old_opt == NULL)
			return;
		if((old_const = old_opt->uiconst) == NULL)
			return;

		while(old_opt->num_uiconst){
			if(old_const->option != NULL){
				UIOptionList *chng_opt;
				chng_opt = FindOptionList(items_list, old_const->key, old_const->option);
				if(chng_opt != NULL){
					chng_opt->disable--;
					AddUpdateOption(data, old_const->key);
				}
			}else{
				UIItemsList *chng_item;
				chng_item = FindItemsList(items_list, old_const->key);
				if(chng_item != NULL){
					chng_item->disable--;
					AddUpdateOption(data, old_const->key);
				}
			}

			if(old_const->next == NULL)
				break;
			old_const = old_const->next;
		}
	}else{
		UIItemsList *old_item;
		UIConstList *old_const;

		old_item = FindItemsList(items_list, old_item_name);
		if(old_item == NULL)
			return;
		if((old_const = old_item->uiconst) == NULL)
			return;

		while(old_item->num_uiconst){
			if(old_const->option != NULL){
				UIOptionList *chng_opt;
				chng_opt = FindOptionList(items_list, old_const->key, old_const->option);
				if(chng_opt != NULL){
					AddUpdateOption(data, old_const->key);
					chng_opt->disable--;
				}
			}else{
				UIItemsList *chng_item;
				chng_item = FindItemsList(items_list, old_const->key);
				if(chng_item != NULL){
					chng_item->disable--;
					AddUpdateOption(data, old_const->key);
				}
			}

			if(old_const->next == NULL)
				break;
			old_const = old_const->next;
		}
	}
}

void SetUIConst(cngplpData *data, char *new_item_name, char *new_opt_name)
{
	UIItemsList *items_list = data->ppd_opt->items_list;
	if(new_opt_name != NULL){
		UIOptionList *new_opt;
		UIConstList *new_const;

		new_opt = FindOptionList(items_list, new_item_name, new_opt_name);
		if(new_opt == NULL)
			return;
		if((new_const = new_opt->uiconst) == NULL)
			return;

		while(new_opt->num_uiconst){
			if(new_const->option != NULL){
				UIOptionList *chng_opt;
				chng_opt = FindOptionList(items_list, new_const->key, new_const->option);
				if(chng_opt != NULL){
					chng_opt->disable++;
					AddUpdateOption(data, new_const->key);
				}
			}else{
				UIItemsList *chng_item;
				chng_item = FindItemsList(items_list, new_const->key);
				if(chng_item != NULL){
					chng_item->disable++;
					AddUpdateOption(data, new_const->key);
				}
			}
			if(new_const->next == NULL)
				break;
			new_const = new_const->next;
		}
	}else{
		UIItemsList *new_item;
		UIConstList *new_const;

		new_item = FindItemsList(items_list, new_item_name);
		if(new_item == NULL)
			return;
		if((new_const = new_item->uiconst) == NULL)
			return;

		while(new_item->num_uiconst){
			if(new_const->option != NULL){
				UIOptionList *chng_opt;
				chng_opt = FindOptionList(items_list, new_const->key, new_const->option);
				if(chng_opt != NULL){
					chng_opt->disable++;
					AddUpdateOption(data, new_const->key);
				}
			}else{
				UIItemsList *chng_item;
				chng_item = FindItemsList(items_list, new_const->key);
				if(chng_item != NULL){
					chng_item->disable++;
					AddUpdateOption(data, new_const->key);
				}
			}

			if(new_const->next == NULL)
				break;
			new_const = new_const->next;
		}
	}
}

void AllUpdatePPDData(cngplpData *data)
{
	UIItemsList *list = data->ppd_opt->items_list;
	UIItemsList *tmp_list;

	tmp_list = list;
	while(1){
		if((tmp_list->current_option != NULL) && (tmp_list->current_option->name != NULL)){
			SetUIConst(data, tmp_list->name, tmp_list->current_option->name);
			MarkDisable(data, tmp_list->name, tmp_list->current_option->name, 1, 0);
		}
		if(tmp_list->next == NULL)
			break;
		tmp_list = tmp_list->next;

	}
#ifdef __APPLE__
	if(data->ppd_opt->special){
		MarkDisable(data, kPPD_Items_Device_CNFormHandle, data->ppd_opt->special->form_handle, 1, 0);
	}
#endif
}

void InitUpdateOption(cngplpData *data)
{
	data->update_flag = 1;
	MemFree(data->update_options);
	data->update_options = NULL;
}

int SameOpt(char *dest, char *src, int size)
{
	char *pdest, str[256], *pstr;

	memset(str, 0, 256);
	pdest = dest;
	pstr = str;

	while(1){
		if(*pdest == '\0'){
			*pstr = '\0';
			if(strcmp(str, src) == 0)
				return 1;
			else
				return 0;
		}
		if(*pdest == ','){
			*pstr = '\0';
			if(strcmp(str, src) == 0)
				return 1;
			pdest++;
			pstr = str;
		}
		if(pstr - str == 255)
			break;
		*pstr = *pdest;
		pdest++;
		pstr++;
	}
	return 0;
}

void AddUpdateOption(cngplpData *data, char *item_name)
{
	char *tmp;
	if(data->update_flag == 0)
		return;

	if(data->update_options == NULL){
		tmp = strdup(item_name);
		if(tmp == NULL)
			return;
		data->update_options = tmp;
	}else{
		int size;

		if(SameOpt(data->update_options, item_name, strlen(item_name)))
			return;

		size = strlen(item_name) + strlen(data->update_options) + 4;
		tmp = (char *)malloc(size);
		memset(tmp, 0, size);
		cngplp_util_strcpy(tmp, data->update_options);
		cngplp_util_strcat(tmp, ",");
		cngplp_util_strcat(tmp, item_name);

		MemFree(data->update_options);

		data->update_options = tmp;
	}
}


int ToID(char *item_name)
{
	int i = 0;
	if(item_name == NULL)
		return -1;

	while(items_table[i] != NULL){
		if(strcmp(items_table[i], item_name) == 0)
			return i + 1;
		i++;
	}
	i = 0;
	while(items_table_common[i] != NULL){
		if(strcmp(items_table_common[i], item_name) == 0)
			return i + 1 + ID_COMMON_OPTION;
		i++;
	}
	i = 0;
	while(items_table_image[i] != NULL){
		if(strcmp(items_table_image[i], item_name) == 0)
			return i + 1 + ID_IMAGE_OPTION;
		i++;
	}
	i = 0;
	while(items_table_text[i] != NULL){
		if(strcmp(items_table_text[i], item_name) == 0)
			return i + 1 + ID_TEXT_OPTION;
		i++;
	}
	i = 0;
	while(items_table_hpgl[i] != NULL){
		if(strcmp(items_table_hpgl[i], item_name) == 0)
			return i + 1 + ID_HPGL_OPTION;
		i++;
	}
	if(strcmp(item_name, "Filter") == 0)
		return ID_FILTER;
	else if(strcmp(item_name, "Reso-Scale") == 0)
		return ID_RESO_SCALE;
	else if(strcmp(item_name, "Margin") == 0)
		return ID_MARGIN;
	else if(strcmp(item_name, "PrintStyle") == 0)
		return ID_SIDED1PRINT;
	else if(strcmp(item_name, "SelectBy") == 0)
		return ID_SELECTBY;
	else if(strcmp(item_name, "JobAccount") == 0)
		return ID_JOBACCOUNT;
	else if(strcmp(item_name, "PrinterName") == 0)
		return ID_PRINTERNAME;
	else if(strcmp(item_name, "DataName") == 0)
		return ID_DATANAME;
	else if(strcmp(item_name, "HoldDataName") == 0)
		return ID_HOLDQUEUE_DATANAME;
	return -1;
}

char* OptionToIDList(char *list)
{
	char *ptr, *plist, id[256];
	char *id_list = 0;

	if(list == NULL)
		return NULL;

	ptr = id;
	plist = list;

	while(1){
		if(*plist == '\0'){
			int tmp;
			*ptr = '\0';
			if((tmp = ToID(id)) != -1)
				id_list = IDAddList(id_list, tmp);
			break;
		}
		if(*plist == ','){
			int tmp;
			*ptr = '\0';
			if((tmp = ToID(id)) != -1)
				id_list = IDAddList(id_list, tmp);
			plist++;
			ptr = id;
		}
		if(ptr - id == 255)
			break;
		*ptr = *plist;
		ptr++;
		plist++;
	}
	return id_list;
}

char* IDAddList(char *list, int id)
{
	char *tmp;
	char *num;

	if(id == -1)
		return list;

	num = (char *)malloc(256);
	memset(num, 0, 256);
	snprintf(num, 255, "%d", id);

	if(list == NULL){
		tmp = strdup(num);
	}else{
		int size = strlen(list) + strlen(num) + 2;
		tmp = (char *)malloc(size);
		memset(tmp, 0, size);
		cngplp_util_strcpy(tmp, list);
		cngplp_util_strcat(tmp, ",");
		cngplp_util_strcat(tmp, num);
		MemFree(list);
	}
	MemFree(num);
	return tmp;
}

char* ExitUpdateOption(cngplpData *data)
{
	if(data->update_flag && data->update_options){
		data->update_flag = 0;
		return OptionToIDList(data->update_options);
	}
	return NULL;
}

static int CheckItemCmp(char *str, const char *item)
{
	int item_len = 0;
	int str_len = 0;
	int status = 0;
	int blank = 0;

	if ((str != NULL) && (item != NULL)) {
		item_len = strlen(item);
		str_len = strlen(str);

		if ((str_len > item_len) && (str[item_len] == ' ')) {
			blank = 1;
		}

		if (blank) {
			if ((strncmp(str, item, item_len) == 0)) {
				status = 1;
			}
		}
	}
	return status;
}


static int CheckItemPriority(char *str1, char *str2)
{
	int set_const = 0;
	int skip_const = 1;
	if(str1 == NULL || str2 == NULL)
		return skip_const;

	if(strstr(str1, items_table[ID_PAGESIZE - 1]) != NULL)
		return set_const;
	if(strstr(str2, items_table[ID_PAGESIZE - 1]) != NULL){
#ifndef __APPLE__
		if(strstr(str1, items_table[ID_CNDEVICETYPE - 1]) != NULL)
			return set_const;
		else
#endif
		return skip_const;
	}
#ifdef __APPLE__
	if(CheckItemCmp(str1, items_table[ID_DUPLEX - 1])){
		return set_const;
	}
	if(CheckItemCmp(str2, items_table[ID_DUPLEX - 1])){
		return skip_const;
	}
#endif
#if 0
	if(strstr(str1, items_table[ID_CNFINISHER - 1]) != NULL)
		return set_const;
	if(strstr(str2, items_table[ID_CNFINISHER - 1]) != NULL)
		return skip_const;

	if(strstr(str1, items_table[ID_CNDUPLEXUNIT - 1]) != NULL)
		return set_const;
	if(strstr(str2, items_table[ID_CNDUPLEXUNIT - 1]) != NULL)
		return skip_const;

	if(strstr(str1, items_table[ID_CNSRCOPTION - 1]) != NULL)
		return set_const;
	if(strstr(str2, items_table[ID_CNSRCOPTION - 1]) != NULL)
		return skip_const;

	if(strstr(str1, items_table[ID_CNFOLDER - 1]) != NULL)
		return set_const;
	if(strstr(str2, items_table[ID_CNFOLDER - 1]) != NULL)
		return skip_const;

	if(strstr(str1, items_table[ID_CNPUNCHER - 1]) != NULL)
		return set_const;
	if(strstr(str2, items_table[ID_CNPUNCHER - 1]) != NULL)
		return skip_const;

	if(strstr(str1, items_table[ID_CNINSERTER - 1]) != NULL)
		return set_const;
	if(strstr(str2, items_table[ID_CNINSERTER - 1]) != NULL)
		return skip_const;

	if(strstr(str1, items_table[ID_CNTRIMMER - 1]) != NULL)
		return set_const;
	if(strstr(str2, items_table[ID_CNTRIMMER - 1]) != NULL)
		return skip_const;

	if(strstr(str2, items_table[ID_INPUTSLOT - 1]) != NULL)
		return skip_const;

	if(strstr(str2, items_table[ID_COLLATE - 1]) != NULL
	&& strstr(str1, items_table[ID_CNOUTPUTPARTITION - 1]) != NULL)
		return skip_const;
#endif
	return 0;
}

static UIConfList* BuffToUIConfList(char *buff)
{
	UIConfList *tmp_list = NULL;
	UIConfList *tmp = NULL;
	UIConfList *uiconf = NULL;
	char *ptr = NULL;
	int i, cnt = 0, kakkoCnt = 0;
	char str[MAXWORDSIZE];
	char *ptr_s = NULL;

	ptr = buff;

	memset(str, 0, MAXWORDSIZE);

	if((tmp = (UIConfList *)malloc(sizeof(UIConfList))) == NULL)
		return NULL;
	memset(tmp, 0, sizeof(UIConfList));

	if((uiconf = (UIConfList *)malloc(sizeof(UIConfList))) == NULL)
		return NULL;
	memset(uiconf, 0, sizeof(UIConfList));

	ptr_s = str;
	for(i = 0; i < MAXWORDSIZE - 1; i++){
		if(*ptr == '\n' || *ptr == 0xd || *ptr == '\0'){
			break;
		}else if(*ptr == '*'){
			ptr++;
		}else if(*ptr == '('){
			kakkoCnt++;
			if(kakkoCnt == 1){
				*ptr_s = '\0';
                if(tmp != NULL){
                    tmp->key = strdup(str);
                }
				ptr_s = str;
				ptr++;
			}
		}else if(*ptr == ')'){
			if(kakkoCnt == 1){
				*ptr_s = '\0';
                if(tmp != NULL){
                    tmp->option = strdup(str);
                }
				ptr_s = str;
                if(tmp != NULL){
                    tmp->next = NULL;
                }
				if(cnt == 0){
					if(tmp != NULL){
						memcpy(uiconf, tmp, sizeof(UIConfList));
						free(tmp);
						tmp = NULL;
					}
				}else{
					tmp_list = uiconf;
					while(1){
						if(tmp_list->next == NULL)
							break;
						tmp_list = tmp_list->next;
					}
					tmp_list->next = tmp;
					tmp = NULL;
				}
				kakkoCnt = 0;
			}else{
				kakkoCnt--;
			}
		}else if(*ptr == ','){
			cnt++;
			ptr++;
			ptr_s = str;
			kakkoCnt = 0;
			if((tmp = (UIConfList *)malloc(sizeof(UIConfList))) == NULL)
				return NULL;
			memset(tmp, 0, sizeof(UIConfList));
			continue;
		}
		*ptr_s = *ptr;
		ptr++;
		ptr_s++;
	}

	return uiconf;
}

static UIConfList* GetLastUIConfList(UIConfList *conf)
{
	UIConfList *tmp = conf;
	while(1){
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
	}
	return tmp;
}

static int SetUIConfList(UIItemsList *list, UIConfList *cond, UIConfList *dis, UIConfList *curr)
{
	UIOptionList *tmp_opt = NULL;
	UIExtConfList *ext = NULL;
	UIConfList *tmp = NULL, *elem = NULL;

	if(cond == NULL || dis == NULL || curr == NULL)
		return 1;

	ext = (UIExtConfList *)malloc(sizeof(UIExtConfList));
	if(ext == NULL)
		return 1;
	ext->other_elem = NULL;
	ext->conf_elem = NULL;
	ext->next = NULL;

	tmp_opt = FindOptionList(list, curr->key, curr->option);
	if(tmp_opt == NULL){
		free(ext);
		return 1;
	}

	elem = (UIConfList *)malloc(sizeof(UIConfList));
	if(elem == NULL)
		return 1;
	memset(elem, 0, sizeof(UIConfList));

	tmp = cond;
	while(1){
		if(strcmp(curr->key, tmp->key) != 0
		|| strcmp(curr->option, tmp->option) != 0){
			elem->key = strdup(tmp->key);
			elem->option = strdup(tmp->option);
			elem->next = NULL;
			if(ext->other_elem == NULL){
				ext->other_elem = elem;
			}else{
				UIConfList *last = NULL;
				last = GetLastUIConfList(ext->other_elem);
				last->next = elem;
			}
			elem = NULL;
			elem = (UIConfList *)malloc(sizeof(UIConfList));
			if(elem == NULL)
				return 1;
			memset(elem, 0, sizeof(UIConfList));
		}
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
	}

	tmp = dis;
	while(1){
		elem->key = strdup(tmp->key);
		elem->option = strdup(tmp->option);
		elem->next = NULL;
		if(ext->conf_elem == NULL){
			ext->conf_elem = elem;
		}else{
			UIConfList *last = NULL;
			last = GetLastUIConfList(ext->conf_elem);
			last->next = elem;
		}
		elem = NULL;
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
		elem = (UIConfList *)malloc(sizeof(UIConfList));
		if(elem == NULL)
			return 1;
		memset(elem, 0, sizeof(UIConfList));
	}

	if(tmp_opt->uiconf == NULL){
		tmp_opt->uiconf = (UIExtConfList *)malloc(sizeof(UIExtConfList));
		memcpy(tmp_opt->uiconf, ext, sizeof(UIExtConfList));
		free(ext);
	}else{
		UIExtConfList *uiconf = tmp_opt->uiconf;
		while(1){
			if(uiconf->next == NULL)
				break;
			uiconf = uiconf->next;
		}
		uiconf->next = ext;
	}

	return 0;
}

static int GetUIConfList(UIItemsList *list, char *buff)
{
	UIConfList *tmp = NULL;
	UIConfList *condition = NULL, *disabled = NULL;
	char *ptr = NULL;
	int i, cnt = 0;
	char str[MAXWORDSIZE], *ptr_s = NULL;
	ptr = buff;


	for(i = 0; i < MAXWORDSIZE - 1; i++){
		if(*ptr == ' '){
			ptr++;
			break;
		}else if(*ptr == '\n' || *ptr == '\0'){
			return 0;
		}
		ptr++;
	}

	memset(str, 0, MAXWORDSIZE);
	ptr_s = str;
	for(i = 0; i < MAXWORDSIZE - 1; i++){
		if(*ptr == ':'){
			ptr++;
			break;
		}else if(*ptr == '\n' || *ptr == '\0'){
			return 0;
		}
		*ptr_s = *ptr;
		ptr_s++;
		ptr++;
	}
	*ptr_s = '\0';

	if((condition = BuffToUIConfList(str)) == NULL)
		return 0;

	memset(str, 0, MAXWORDSIZE);
	ptr_s = str;
	for(i = 0; i < MAXWORDSIZE - 1; i++){
		if(*ptr == '\n' || *ptr == '\0'){
			break;
		}
		*ptr_s = *ptr;
		ptr_s++;
		ptr++;
	}
	*ptr_s = '\0';

	if((disabled = BuffToUIConfList(str)) == NULL){
		FreeUIConf(condition);
		return 0;
	}

	cnt = 0;
	tmp = condition;
	while(1){
		SetUIConfList(list, condition, disabled, tmp);
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
		cnt++;
	}

	FreeUIConf(condition);
	FreeUIConf(disabled);

	return 0;
}


static int CheckUIConfOtherElem(UIItemsList *list, UIExtConfList *ext)
{
	UIConfList *other = NULL;

	if(ext->other_elem == NULL)
		return 0;
	other = ext->other_elem;
	while(1){
		char *curr;
		curr = FindCurrOpt(list, other->key);
		if(curr == NULL)
			return 1;
		if(strcmp(curr, other->option) != 0)
			return 1;
		if(other->next == NULL)
			break;
		other = other->next;
	}
	return 0;
}

static int SetDisableUIConfList(cngplpData *data, UIExtConfList *ext, int flag)
{
	UIItemsList *list = data->ppd_opt->items_list;
	UIConfList *conf = NULL;

	if(ext->conf_elem == NULL)
		return 1;
	conf = ext->conf_elem;
	while(1){
		UIOptionList *chg = NULL;

		if(strcmp("###", conf->option) == 0){
			UIItemsList *tmp = FindItemsList(list, conf->key);
			if(tmp == NULL)
				goto skip;
			chg = tmp->opt_lists;
			if(chg == NULL)
				goto skip;
			while(1){
				chg->disable += flag;
				if(chg->next == NULL)
					break;
				chg = chg->next;
			}
			AddUpdateOption(data, conf->key);
		}else{
			chg = FindOptionList(list, conf->key, conf->option);
			if(chg != NULL){
				chg->disable += flag;
				AddUpdateOption(data, conf->key);
			}
		}
skip:
		if(conf->next == NULL)
			break;
		conf = conf->next;
	}
	return 0;
}

static int isCUPSSpace(char ch)
{
	return (ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n');
}

static UIConfList* BuffToCUPSUIConfList(char *buff)
{
	int  err   = NO_ERROR;
	char *ptr  = NULL;
	char *vptr = NULL;
	char valueBuff[MAXWORDSIZE] = {0};

	UIConfList *confListHead = NULL;
	UIConfList *confListCur  = NULL;

	if(memchr(buff, '\0', MAXWORDSIZE) == NULL){
		return NULL;
	}

	ptr = strchr(buff, ':');
	if(ptr == NULL){
		return NULL;
	}

	for(ptr = strchr(ptr, '*'); ptr != '\0' && err == NO_ERROR; ptr = strchr(ptr, '*'))
	{
		UIConfList *tmpConfList = NULL;

		tmpConfList = (UIConfList*)calloc(1, sizeof(UIConfList));

		if(tmpConfList == NULL){
			err = ERROR;
		}
		else{
			if(confListHead == NULL){
				confListHead = tmpConfList;
			}
			else{
				confListCur->next = tmpConfList;
			}

			confListCur = tmpConfList;

			ptr++;

			vptr = valueBuff;
			while(!isCUPSSpace(*ptr) && *ptr != '\0'){
				*vptr = *ptr;
				ptr++;
				vptr++;
			}

			*vptr = '\0';
			confListCur->key = strdup(valueBuff);

			while(isCUPSSpace(*ptr)){
				ptr++;
			}

			if(*ptr == '*' || *ptr == '\0'){
				err = ERROR;
				break;
			}
			else{
				vptr = valueBuff;
				while(!isCUPSSpace(*ptr) && *ptr != '\0'){
					*vptr = *ptr;
					ptr++;
					vptr++;
				}

				*vptr = '\0';
				confListCur->option = strdup(valueBuff);
			}
		}
	}

	if(err == ERROR){
		FreeUIConf(confListHead);
		confListHead = NULL;
	}

	return confListHead;
}

static int GetCUPSUIConfList(UIItemsList *list, char *buff)
{
	int  err = NO_ERROR;
	UIConfList *confListHead = NULL;
	UIConfList *confListCur  = NULL;
	UIConfList *disabledHead = NULL;

	if(list == NULL || buff == NULL){
		return ERROR;
	}

	confListHead = BuffToCUPSUIConfList(buff);

	if(confListHead == NULL){
		err = ERROR;
	}
	else{
		confListCur = confListHead;
		while(confListCur != NULL){
			if(confListCur->next != NULL){
				if(confListCur->next->next == NULL){
					disabledHead = confListCur->next;
					confListCur->next = NULL;
					break;
				}
			}
			confListCur = confListCur->next;
		}

		if(disabledHead == NULL){
			err = ERROR;
		}
		else{
			confListCur = confListHead;

			while(confListCur != NULL){
				err = SetUIConfList(list, confListHead, disabledHead, confListCur);

				if(err == 1){
					err = ERROR;
					break;
				}
				confListCur = confListCur->next;
			}
		}

		FreeUIConf(confListHead);
		FreeUIConf(disabledHead);
	}

	return err;
}

int MarkDisableOpt(cngplpData *data, char *item_name, char *opt_name, int flag)
{
	UIItemsList *list = data->ppd_opt->items_list;
	UIOptionList *opt = NULL;

	if((opt = FindOptionList(list, item_name, opt_name)) != NULL){
		opt->disable += flag;
		AddUpdateOption(data, item_name);
	}
	return 0;
}

int MarkDisableFeedCustom(cngplpData *data, char *item_name, char *opt_name, int flag, float width, float height)
{
	if( width > height ){
		MarkDisableOpt(data, item_name, "True", flag);
	}else{
		if(strcmp(opt_name, "False") == 0){
			MarkDisableOpt(data, item_name, "False", flag);
		}
	}

	return 0;
}

static void ChkCNPaperSelection(cngplpData *data, char *item_name, char *opt_name, int flag)
{
	UIItemsList *list = data->ppd_opt->items_list;
	char *curr = NULL;
	char *collate = NULL;
	int copies = 1;

	if((curr = FindCurrOpt(list, "CNPaperSelection")) == NULL)
		return;

	if(strcmp(item_name, "CNCopies") == 0){
		copies = atoi(opt_name);
		if(copies < 2)
			return ;

		collate = FindCurrOpt(list, "Collate");
		if(collate == NULL)
			return ;

		if(strcmp(collate, "True") == 0)
			return;

	}else if(strcmp(item_name, "Collate") == 0){
		CupsOptVal *common = data->cups_opt->common->option;

		if(strcmp(opt_name, "True") == 0)
			return ;

		curr = GetCupsValue(common, "CNCopies");
		copies = atoi(curr);

		if(copies < 2)
			return;
	}else{
		return;
	}

	MarkDisableOpt(data, "CNPaperSelection", "Interleaf", flag);

}

static int CheckMarkDisable(cngplpData *data, char *item_name, char *opt_name, int flag)
{
	int uiconf_flag = data->ppd_opt->uiconf_flag;

	if(uiconf_flag & CNUICONF_FLG_CNCOPIES_COLLATE){
		if(strcmp(item_name, "CNCopies") == 0
		|| strcmp(item_name, "Collate") == 0)
			ChkCNPaperSelection(data, item_name, opt_name, flag);
	}
	if(uiconf_flag & CNUICONF_FLG_CUSTOMSIZE){
		if(strcmp(item_name, "PageSize") == 0
		&& strcmp(opt_name, "Custom") == 0)
			ChkCustomPageSize(data, item_name, opt_name, flag);
	}
	if(uiconf_flag & CNUICONF_FLG_INPUTSLOT){
		if(strcmp(item_name, "InputSlot") == 0)
			CheckInputSlotValue(data, item_name, opt_name, flag);
	}
	if(uiconf_flag & CNUICONF_FLG_CNDUPLEX){
		if(strcmp(item_name, kPPD_Items_CNDuplex) == 0)
			CheckCNDuplexValue(data, item_name, opt_name, flag);
	}
	if(uiconf_flag & CNUICONF_FLG_CNOUTPUTPROFILE){
		ChkCNOutputProfile(data, item_name, opt_name, flag);
	}
	if(uiconf_flag & CNUICONF_FLG_CNMONITORPROFILE){
		ChkCNMonitorProfile(data, item_name, opt_name, flag);
	}
	if(uiconf_flag & CNUICONF_FLG_NUMBER_UP){
		ChkCNInsertSheet(data, item_name, opt_name, flag);
		ChkFrontSheet(data, item_name, opt_name, flag);
	}
	if(uiconf_flag & CNUICONF_FLG_ORIENTATION_REQUESTED){
		ChkOrientationRequested(data, item_name, opt_name, flag);
	}
#ifdef __APPLE__
	ChkOffsetNum(data, item_name, opt_name, flag);
#endif
	ChkMediaBrandShape(data, item_name, opt_name, flag);

    ChkCNPrioritizeLineText(data, item_name, opt_name, flag);

#ifdef __APPLE__
	ChkOverlayForm(data, item_name, opt_name, flag);
#endif

	return 0;
}

static int CountUIConfOtherElem(UIExtConfList *ext)
{
	int cnt = 0;
	UIConfList *other = NULL;

	other = ext->other_elem;
	while(other != NULL){
		cnt++;
		other = other->next;
	}
	return cnt;
}
int MarkDisable(cngplpData *data, char *item_name, char *opt_name, int flag, int other)
{
	UIItemsList *items_list = data->ppd_opt->items_list;
	UIOptionList *opt = NULL;
	UIExtConfList *ext = NULL;

	if(opt_name == NULL || item_name == NULL)
		return 0;

	CheckMarkDisable(data, item_name, opt_name, flag);

	opt = FindOptionList(items_list, item_name, opt_name);
	if(opt == NULL)
		return 0;

	if(opt->uiconf == NULL)
		return 0;

	ext = opt->uiconf;
	while(1){
#if 0
		if(CheckUIConfOtherElem(items_list, ext))
			return 1;

		SetDisableUIConfList(data, ext, flag);
#else
		if(!CheckUIConfOtherElem(items_list, ext)){
			if(other == 1){
				SetDisableUIConfList(data, ext, flag * (CountUIConfOtherElem(ext)+1));
			}
			else {
				SetDisableUIConfList(data, ext, flag);
			}
		}
#endif
		if(ext->next == NULL)
			break;
		ext = ext->next;
	}

	return 0;
}

#define	BUFSIZE	256

UIValueList* FindUIValueList(UIValueList *list, char *key)
{
	UIValueList *tmp = NULL;

	if(list == NULL || key == NULL)
		return NULL;

	tmp = list;
	while(1){
		if(strcasecmp(tmp->key, key) == 0){
			return tmp;
		}
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
	}
	return NULL;
}

void UpdateUIValue(cngplpData *data, char *key, char *value)
{
	UIValueList *tmp = NULL, *list = NULL;

	list = data->ppd_opt->uivalue;

	if(list == NULL || key == NULL || value == NULL)
		return;

	if((tmp = FindUIValueList(list, key)) != NULL){
		if(tmp->value != NULL){
			MarkDisable(data, key, tmp->value, -1, 1);
			MemFree(tmp->value);
			tmp->value = strdup(value);
			MarkDisable(data, key, value, 1, 1);
			RemarkOptValue(data, key);
		}
	}
}

char* GetUIValue(cngplpData *data, char *key)
{
	UIValueList *tmp = NULL, *list = NULL;

	list = data->ppd_opt->uivalue;

	if(list == NULL || key == NULL)
		return NULL;

	if((tmp = FindUIValueList(list, key)) != NULL)
		return tmp->value;

	return NULL;
}

char* GetAllUIValue(cngplpData *data)
{
	UIValueList *uivalue = data->ppd_opt->uivalue;
	char *list = NULL, *tmp = NULL;
	char value[512];

	if(uivalue == NULL)
		return NULL;

	while(1){
		memset(value, 0, 512);
		snprintf(value, 512, "%s=%s", uivalue->key, uivalue->value);
		if(list == NULL){
			tmp = strdup(value);
		}else{
			int size = strlen(list) + strlen(value) + 2;
			tmp = (char *)malloc(size);
			memset(tmp, 0, size);
			cngplp_util_strcpy(tmp, list);
			cngplp_util_strcat(tmp, ",");
			cngplp_util_strcat(tmp, value);
			MemFree(list);
		}
		list = tmp;
		if(uivalue->next == NULL)
			break;
		uivalue = uivalue->next;
	}

	return list;
}

void FreeUIValue(UIValueList *uivalue)
{
	UIValueList *tmp;

	for(; uivalue != NULL; uivalue = tmp){
		tmp = uivalue->next;
		MemFree(uivalue->key);
		MemFree(uivalue->value);
		free(uivalue);
		uivalue = NULL;
	}
}

int AddUIValueList(PPDOptions *ppd_opt, char *key, char *value, int opt_flag)
{
	UIValueList *list = NULL;

	if(key == NULL || value == NULL)
		return 1;

	if(FindUIValueList(ppd_opt->uivalue, key) != NULL)
		return 1;

	list = (UIValueList *)malloc(sizeof(UIValueList));
	if(list == NULL)
		return 1;
	memset(list, 0, sizeof(UIValueList));
	list->key = strdup(key);
	list->value = strdup(value);
	list->opt_flag = opt_flag;

	if(ppd_opt->uivalue == NULL){
		ppd_opt->uivalue = (UIValueList *)malloc(sizeof(UIValueList));
		if(ppd_opt->uivalue == NULL)
			return 1;
		memset(ppd_opt->uivalue, 0, sizeof(UIValueList));
		memcpy(ppd_opt->uivalue, list, sizeof(UIValueList));
		free(list);
	}else{
		UIValueList *tmp = ppd_opt->uivalue;
		while(1){
			if(tmp->next == NULL)
				break;
			tmp = tmp->next;
		}
		tmp->next = list;
	}
	return 0;
}

int DeleteUIValueList(PPDOptions *ppd_opt, char *key)
{
	UIValueList *list = NULL, *tmp = NULL;

	list = ppd_opt->uivalue;
	if(list == NULL || key == NULL)
		return 1;

	while(1){
		if(list->next == NULL)
			break;
		if(strcasecmp(list->next->key, key) == 0){
			tmp = list->next;
			if(tmp->next == NULL){
				list->next = NULL;
				MemFree(tmp->key);
				MemFree(tmp->value);
				free(tmp);
			}else{
				list->next = tmp->next;
				MemFree(tmp->key);
				MemFree(tmp->value);
				free(tmp);
			}
			break;
		}
		list = list->next;
	}

	return 0;
}

int SetUIValue(PPDOptions *ppd_opt, char *buf)
{
	char *ptr = buf;
	char *p_key = NULL, key[BUFSIZE];
	char *p_val = NULL, val[BUFSIZE];
	int opt_flag = 0;

	memset(key, 0, BUFSIZE);
	memset(val, 0, BUFSIZE);

	p_key = key;
	while(1){
		if(*ptr == '\n' || *ptr == 0xd || *ptr == '\0')
			return 1;
		if(*ptr == ' ' || *ptr == '\t')
			ptr++;
		if(*ptr == '*')
			ptr++;
		if(*ptr == '(')
			break;
		if(p_key - key == BUFSIZE - 1)
			return 1;
		*p_key = *ptr;
		ptr++;
		p_key++;
	}
	*p_key = '\0';

	ptr++;
	p_val = val;
	while(1){
		if(*ptr == '\n' || *ptr == 0xd || *ptr == '\0')
			return 1;
		if(*ptr == ')')
			break;
		if(p_val - val == BUFSIZE - 1)
			break;
		*p_val = *ptr;
		ptr++;
		p_val++;
	}
	*p_val = '\0';

	if(ptr != NULL){
		if(strstr(ptr, "True") != NULL)
			opt_flag = 1;
	}

	AddUIValueList(ppd_opt, key, val, opt_flag);

	return 0;
}

int AddCNProtUIValue(PPDOptions *ppd_opt, char *buf)
{
	char *ptr = buf+1;
	char *p_key = NULL, key[BUFSIZE];
	char *p_val = NULL, val[BUFSIZE];

	memset(key, 0, BUFSIZE);
	memset(val, 0, BUFSIZE);

	p_key = key;
	while(1){
		if(*ptr == '\n' || *ptr == 0xd || *ptr == '\0')
			return 1;
		if(*ptr == ' ' || *ptr == '\t')
			ptr++;
		if(*ptr == ':')
			break;
		if(p_key - key == BUFSIZE - 1)
			return 1;
		*p_key = *ptr;
		ptr++;
		p_key++;
	}
	*p_key = '\0';

	while(1){
		if(*ptr == '\n' || *ptr == 0xd || *ptr == '\0')
			return 1;
		if(*ptr == ' ' || *ptr == '\t')
			ptr++;
		if(*ptr == '\"')
			break;
		ptr++;
	}
	ptr++;
	p_val = val;
	while(1){
		if(*ptr == '\n' || *ptr == 0xd || *ptr == '\0')
			return 1;
		if(*ptr == '\"')
			break;
		if(p_val - val == BUFSIZE - 1)
			break;
		*p_val = *ptr;
		ptr++;
		p_val++;
	}
	*p_val = '\0';

	AddUIValueList(ppd_opt, key, val, 0);

	return 0;
}

#define	IS_USER_MEDIA_BRAND(id)		((id & 0xFFFF0000) != 0)
int ConvertMediaBrandConvListStrToStruct(char *buf, MediaBrandConvertList *item)
{
	char *ptr = buf;
	char *p_key = NULL, key[BUFSIZE];
	char *p_val = NULL, val[BUFSIZE];

	memset(item, 0, sizeof(MediaBrandConvertList));

	while(1){
		memset(key, 0, BUFSIZE);
		memset(val, 0, BUFSIZE);

		p_key = key;
		while(1){
			if(*ptr == '\n' || *ptr == 0xd || *ptr == '\0'){
				if(item->name){
					free(item->name);
					item->name = NULL;
				}
				return 1;
			}
			if(*ptr == ':')
				break;
			if(p_key - key == BUFSIZE - 1){
				if(item->name){
					free(item->name);
					item->name = NULL;
				}
				return 1;
			}
			*p_key = *ptr;
			ptr++;
			p_key++;
		}
		*p_key = '\0';

		ptr++;
		p_val = val;
		while(1){
			if(*ptr == '\n' || *ptr == 0xd || *ptr == '\0')
				break;
			if(*ptr == ',')
				break;
			if(p_val - val == BUFSIZE - 1)
				break;
			*p_val = *ptr;
			ptr++;
			p_val++;
		}
		*p_val = '\0';

		if(strlen(key) == 0 || strlen(val) == 0){
			if(item->name){
				free(item->name);
				item->name = NULL;
			}
			return 1;
		}else if(strcmp(key, kPPD_Items_MediaBrand_Name) == 0){
			item->name = strdup(val);
		}else if(strcmp(key, kPPD_Items_MediaBrand_WeightMin) == 0){
			item->weight_min = atol(val);
			item->flag |= MEDIA_BRAND_FLG_WEIGHT_MIN;
		}else if(strcmp(key, kPPD_Items_MediaBrand_WeightMax) == 0){
			item->weight_max = atol(val);
			item->flag |= MEDIA_BRAND_FLG_WEIGHT_MAX;
		}else if(strcmp(key, kPPD_Items_MediaBrand_Surface) == 0){
			item->surface = atol(val);
			item->flag |= MEDIA_BRAND_FLG_SURFACE;
		}else if(strcmp(key, kPPD_Items_MediaBrand_Shape) == 0){
			item->shape = atol(val);
			item->flag |= MEDIA_BRAND_FLG_SHAPE;
		}else if(strcmp(key, kPPD_Items_MediaBrand_Color) == 0){
			item->color = atol(val);
			item->flag |= MEDIA_BRAND_FLG_COLOR;
		}

		if(*ptr == '\n' || *ptr == 0xd || *ptr == '\0' || (p_val - val == BUFSIZE - 1))
			break;
		else
			ptr++;
	}

	return 0;
}

int AddMediaBrandConvList(PPDOptions *ppd_opt, char *buf)
{
	MediaBrandConvertList *new_item = NULL, *tmp_item = NULL;

	if(ppd_opt->media_brand == NULL){
		ppd_opt->media_brand = (MediaBrand *)malloc(sizeof(MediaBrand));
		if(ppd_opt->media_brand == NULL)
			return 1;
		memset(ppd_opt->media_brand, 0, sizeof(MediaBrand));
	}

	new_item = (MediaBrandConvertList *)malloc(sizeof(MediaBrandConvertList));
	if(new_item == NULL)
		return 1;

	if(ConvertMediaBrandConvListStrToStruct(buf, new_item)){
		free(new_item);
		return 1;
	}

	if(ppd_opt->media_brand->convert_list == NULL){
		ppd_opt->media_brand->convert_list = new_item;
	}else{
		tmp_item = ppd_opt->media_brand->convert_list;
		while(tmp_item->next != NULL)
			tmp_item = tmp_item->next;
		tmp_item->next = new_item;
	}
	return 0;
}

void SetMediaBrandConvList(PPDOptions *ppd_opt, char *buff)
{
	char *ptr, value[256], *np;

	memset(value, 0, sizeof(value));
	ptr = buff;
	np = value;
	while(1){
		if(*ptr == '\0' || *ptr == '\n')
			break;
		if(*ptr == '\"'){
			ptr++;
			break;
		}
		ptr++;
	}

	while(1){
		if(*ptr == '\0' || *ptr == '\n'){
			*np = '\0';
			break;
		}
		if(*ptr == '\"'){
			*np = '\0';
			break;
		}
		if(np - value == 255)
			break;
		*np = *ptr;
		np++;
		ptr++;
	}

	AddMediaBrandConvList(ppd_opt, value);
}

int ConvertMediaBrandStrToStruct(char *buf, MediaBrandList *item)
{
	char *ptr = buf;
	char *p_key = NULL, key[BUFSIZE];
	char *p_val = NULL, val[BUFSIZE];

	memset(item, 0, sizeof(MediaBrandList));

	while(1){
		memset(key, 0, BUFSIZE);
		memset(val, 0, BUFSIZE);

		p_key = key;
		while(1){
			if(*ptr == '\n' || *ptr == 0xd || *ptr == '\0'){
				if(item->name){
					free(item->name);
					item->name = NULL;
				}
				return 1;
			}
			if(*ptr == ':')
				break;
			if(p_key - key == BUFSIZE - 1){
				if(item->name){
					free(item->name);
					item->name = NULL;
				}
				return 1;
			}
			*p_key = *ptr;
			ptr++;
			p_key++;
		}
		*p_key = '\0';

		ptr++;
		p_val = val;
		while(1){
			if(*ptr == '\n' || *ptr == 0xd || *ptr == '\0')
				break;
			if(*ptr == ',')
				break;
			if(p_val - val == BUFSIZE - 1)
				break;
			*p_val = *ptr;
			ptr++;
			p_val++;
		}
		*p_val = '\0';

		if(strlen(key) == 0){
			if(item->name){
				free(item->name);
				item->name = NULL;
			}
			return 1;
		}else if(strcmp(key, kPPD_Items_MediaBrand_ID) == 0){
			item->id = atol(val);
		}else if(strcmp(key, kPPD_Items_MediaBrand_Name) == 0){
			item->name = strdup(val);
		}else if(strcmp(key, kPPD_Items_MediaBrand_Weight) == 0){
			item->weight = atol(val);
		}else if(strcmp(key, kPPD_Items_MediaBrand_Surface) == 0){
			item->surface = atol(val);
		}else if(strcmp(key, kPPD_Items_MediaBrand_Shape) == 0){
			item->shape = atol(val);
		}else if(strcmp(key, kPPD_Items_MediaBrand_Color) == 0){
			item->color = atol(val);
		}

		if(*ptr == '\n' || *ptr == 0xd || *ptr == '\0' || (p_val - val == BUFSIZE - 1))
			break;
		else
			ptr++;
	}

	return 0;
}

int AddMediaBrand(PPDOptions *ppd_opt, char *buf)
{
	MediaBrandList *new_item = NULL, *tmp_item = NULL;

	if(ppd_opt->media_brand == NULL){
		ppd_opt->media_brand = (MediaBrand *)malloc(sizeof(MediaBrand));
		if(ppd_opt->media_brand == NULL)
			return 1;
		memset(ppd_opt->media_brand, 0, sizeof(MediaBrand));
	}

	new_item = (MediaBrandList *)malloc(sizeof(MediaBrandList));
	if(new_item == NULL)
		return 1;

	if(ConvertMediaBrandStrToStruct(buf, new_item)){
		free(new_item);
		return 1;
	}

	if(ppd_opt->media_brand->brand_list == NULL){
		ppd_opt->media_brand->brand_list = new_item;
	}else{
		tmp_item = ppd_opt->media_brand->brand_list;
		while(tmp_item->next != NULL)
			tmp_item = tmp_item->next;
		tmp_item->next = new_item;
	}
	return 0;
}

void SetMediaBrand(PPDOptions *ppd_opt, char *buff)
{
	char *ptr, value[256], *np;

	memset(value, 0, sizeof(value));
	ptr = buff;
	np = value;
	while(1){
		if(*ptr == '\0' || *ptr == '\n')
			break;
		if(*ptr == '\"'){
			ptr++;
			break;
		}
		ptr++;
	}

	while(1){
		if(*ptr == '\0' || *ptr == '\n'){
			*np = '\0';
			break;
		}
		if(*ptr == '\"'){
			*np = '\0';
			break;
		}
		if(np - value == 255)
			break;
		*np = *ptr;
		np++;
		ptr++;
	}

	AddMediaBrand(ppd_opt, value);
}

void FreeMediaBrandConvList(PPDOptions *ppd_opt)
{
	MediaBrandConvertList *item, *tmp_item;

	if(ppd_opt->media_brand == NULL)
		return;
	if(ppd_opt->media_brand->convert_list == NULL)
		return;

	item = ppd_opt->media_brand->convert_list;
	while(item != NULL){
		tmp_item = item->next;
		MemFree(item->name);
		free(item);
		item = tmp_item;
	}

	ppd_opt->media_brand->convert_list = NULL;
}

void FreeMediaBrandItem(MediaBrandList *item)
{
	if(item == NULL)
		return;
	MemFree(item->name);
}

void FreeMediaBrandList(PPDOptions *ppd_opt, int flag)
{
	MediaBrandList *item, *tmp_item;

	if(ppd_opt->media_brand == NULL)
		return;
	if(ppd_opt->media_brand->brand_list == NULL)
		return;

	item = ppd_opt->media_brand->brand_list;

	if(flag == 1){
		if(!(IS_USER_MEDIA_BRAND(item->id))){
			tmp_item = item;
			item = item->next;
			while(item != NULL){
				if(IS_USER_MEDIA_BRAND(item->id)){
					tmp_item->next = NULL;
					break;
				}
				tmp_item = item;
				item = item->next;
			}
		}
	}

	while(item != NULL){
		tmp_item = item->next;
		FreeMediaBrandItem(item);
		free(item);
		item = tmp_item;
	}

	if(flag == 0){
		ppd_opt->media_brand->brand_list = NULL;
	}
}

void FreeMediaBrand(PPDOptions *ppd_opt)
{
	if(ppd_opt->media_brand == NULL)
		return;

	FreeMediaBrandList(ppd_opt, 0);
	FreeMediaBrandConvList(ppd_opt);
	free(ppd_opt->media_brand);
	ppd_opt->media_brand = NULL;
}

int RemakeMediaBrandList(PPDOptions *ppd_opt, char *buf)
{
	char *start, *end;
	char key[BUFSIZE];
	char find_top_str[BUFSIZE];
	long len;
	MediaBrandList *tmp_item;
	long save_id;
	long save_ins_id = 34;
	long save_interleaf_id = 3;
	long save_pb_cover_id = 3;

	if(ppd_opt->media_brand == NULL)
		return 1;
	if(ppd_opt->media_brand->brand_list == NULL)
		return 1;

	save_id = ppd_opt->media_brand->cur_item->id;
	if(ppd_opt->media_brand->cur_ins_item != NULL)
		save_ins_id = ppd_opt->media_brand->cur_ins_item->id;
	if(ppd_opt->media_brand->cur_interleaf_item != NULL)
		save_interleaf_id = ppd_opt->media_brand->cur_interleaf_item->id;
	if(ppd_opt->media_brand->cur_pb_cover_item != NULL)
		save_pb_cover_id = ppd_opt->media_brand->cur_pb_cover_item->id;

	FreeMediaBrandList(ppd_opt, 1);

	if(buf == NULL)
		return 0;

	snprintf(find_top_str, BUFSIZE - 1, ",%s:", kPPD_Items_MediaBrand_ID);

	start = buf;
	while(1){
		end = strstr(start, find_top_str);
		if(end != NULL){
			len = end - start;
		}else{
			len = strlen(buf) - (start - buf);
		}
		if(len > BUFSIZE - 1)
			break;

		memset(key, 0, BUFSIZE);
		memcpy(key, start, len);
		AddMediaBrand(ppd_opt, key);

		if(end == NULL)
			break;

		start = end + 1;
	}

	if(IS_USER_MEDIA_BRAND(save_id)){
		ppd_opt->media_brand->cur_item = NULL;

		tmp_item = ppd_opt->media_brand->brand_list;
		while(tmp_item != NULL)
		{
			if(tmp_item->id == save_id){
				ppd_opt->media_brand->cur_item = tmp_item;
			}
			tmp_item = tmp_item->next;
		}

		if(ppd_opt->media_brand->cur_item == NULL){
			ppd_opt->media_brand->cur_item = ppd_opt->media_brand->def_item;
		}
	}

	if((ppd_opt->media_brand->cur_ins_item != NULL)
	|| (IS_USER_MEDIA_BRAND(save_ins_id))){
		ppd_opt->media_brand->cur_ins_item = NULL;

		tmp_item = ppd_opt->media_brand->brand_list;
		while(tmp_item != NULL)
		{
			if(tmp_item->id == save_ins_id){
				ppd_opt->media_brand->cur_ins_item = tmp_item;
			}
			tmp_item = tmp_item->next;
		}

		if(ppd_opt->media_brand->cur_ins_item == NULL){
			ppd_opt->media_brand->cur_ins_item = ppd_opt->media_brand->def_ins_item;
		}
	}

	if((ppd_opt->media_brand->cur_interleaf_item != NULL)
	|| (IS_USER_MEDIA_BRAND(save_interleaf_id))){
		ppd_opt->media_brand->cur_interleaf_item = NULL;

		tmp_item = ppd_opt->media_brand->brand_list;
		while(tmp_item != NULL)
		{
			if(tmp_item->id == save_interleaf_id){
				ppd_opt->media_brand->cur_interleaf_item = tmp_item;
			}
			tmp_item = tmp_item->next;
		}

		if(ppd_opt->media_brand->cur_interleaf_item == NULL){
			ppd_opt->media_brand->cur_interleaf_item = ppd_opt->media_brand->def_interleaf_item;
		}
	}

	if((ppd_opt->media_brand->cur_pb_cover_item != NULL)
	|| (IS_USER_MEDIA_BRAND(save_pb_cover_id))){
		ppd_opt->media_brand->cur_pb_cover_item = NULL;

		tmp_item = ppd_opt->media_brand->brand_list;
		while(tmp_item != NULL)
		{
			if(tmp_item->id == save_pb_cover_id){
				ppd_opt->media_brand->cur_pb_cover_item = tmp_item;
			}
			tmp_item = tmp_item->next;
		}

		if(ppd_opt->media_brand->cur_pb_cover_item == NULL){
			ppd_opt->media_brand->cur_pb_cover_item = ppd_opt->media_brand->def_pb_cover_item;
		}
	}

	return 0;
}

int initMediaBrand(PPDOptions *ppd_opt)
{
	UIItemsList *media_type_list = NULL;
	UIItemsList *interleaf_media_type = NULL;
	UIItemsList *pb_cover_media_type = NULL;
	MediaBrandList *tmp_item;

	if(ppd_opt->media_brand == NULL)
		return 1;
	if(ppd_opt->media_brand->brand_list == NULL)
		return 1;

	if((media_type_list = FindItemsList(ppd_opt->items_list, kPPD_Items_MediaType)) == NULL)
		return 1;

	interleaf_media_type = FindItemsList(ppd_opt->items_list, kPPD_Items_CNInterleafMediaType);
	pb_cover_media_type = FindItemsList(ppd_opt->items_list, kPPD_Items_CNPBindCoverMediaType);

	tmp_item = ppd_opt->media_brand->brand_list;
	while(tmp_item != NULL)
	{
		if(IS_USER_MEDIA_BRAND(tmp_item->id)){
			break;
		}else{
			if((ppd_opt->media_brand->def_item == NULL)
			&& (strcmp(media_type_list->default_option, tmp_item->name) == 0)){
				ppd_opt->media_brand->def_item = tmp_item;
				ppd_opt->media_brand->cur_item = tmp_item;
			}
			if((ppd_opt->media_brand->def_ins_item == NULL)
			&& (tmp_item->shape == 2)){
				ppd_opt->media_brand->def_ins_item = tmp_item;
				ppd_opt->media_brand->cur_ins_item = tmp_item;
			}
			if((interleaf_media_type != NULL)
			&& (ppd_opt->media_brand->def_interleaf_item == NULL)
			&& (strcmp(interleaf_media_type->default_option, tmp_item->name) == 0)){
				ppd_opt->media_brand->def_interleaf_item = tmp_item;
				ppd_opt->media_brand->cur_interleaf_item = tmp_item;
			}
			if((pb_cover_media_type != NULL)
			&& (ppd_opt->media_brand->def_pb_cover_item == NULL)
			&& (strcmp(pb_cover_media_type->default_option, tmp_item->name) == 0)){
				ppd_opt->media_brand->def_pb_cover_item = tmp_item;
				ppd_opt->media_brand->cur_pb_cover_item = tmp_item;
			}

			if((ppd_opt->media_brand->def_item != NULL)
			&& (ppd_opt->media_brand->def_ins_item != NULL)
			&& (ppd_opt->media_brand->def_interleaf_item != NULL)
			&& (ppd_opt->media_brand->def_pb_cover_item != NULL)){
				break;
			}
		}
		tmp_item = tmp_item->next;
	}

	return 0;
}

UIOptionList* GetMediaBrandMediaType(PPDOptions *ppd_opt, char *media_type, MediaBrandList *new_item)
{
	UIOptionList *tmp_opt = NULL;
	MediaBrandConvertList *tmp_conv_list = NULL;

	if(ppd_opt->media_brand == NULL)
		return NULL;
	if(ppd_opt->media_brand->brand_list == NULL)
		return NULL;
	if(ppd_opt->media_brand->convert_list == NULL)
		return NULL;

	for(tmp_conv_list = ppd_opt->media_brand->convert_list; tmp_conv_list != NULL; tmp_conv_list = tmp_conv_list->next){
		if(tmp_conv_list->flag & MEDIA_BRAND_FLG_WEIGHT_MIN){
			if(new_item->weight < tmp_conv_list->weight_min)
				continue;
		}
		if(tmp_conv_list->flag & MEDIA_BRAND_FLG_WEIGHT_MAX){
			if(new_item->weight > tmp_conv_list->weight_max)
				continue;
		}
		if(tmp_conv_list->flag & MEDIA_BRAND_FLG_SURFACE){
			if(new_item->surface != tmp_conv_list->surface)
				continue;
		}
		if(tmp_conv_list->flag & MEDIA_BRAND_FLG_SHAPE){
			if(new_item->shape != tmp_conv_list->shape)
				continue;
		}
		if(tmp_conv_list->flag & MEDIA_BRAND_FLG_COLOR){
			if(new_item->color != tmp_conv_list->color)
				continue;
		}

		tmp_opt = FindOptionList(ppd_opt->items_list, media_type, tmp_conv_list->name);
		break;
	}

	return tmp_opt;
}

void ChkMediaBrandInterleafSheet(cngplpData *data, int flag)
{
	MediaBrandList *tmp_item;
	char *curr;

	tmp_item = data->ppd_opt->media_brand->cur_item;
	if(tmp_item == NULL)
		return;

	if((curr = FindCurrOpt(data->ppd_opt->items_list, kPPD_Items_CNSelectBy)) == NULL){
		return;
	}else{
		if(strcmp(curr, "PaperType") != 0)
			return;
	}

	if(tmp_item->shape == 2)
		MarkDisableOpt(data, kPPD_Items_CNInterleafSheet, "True", flag);
}

void UpdateMediaBrandWithCurrMediaType(cngplpData *data, int exeCurrDisableFlag)
{
	MediaBrandList *tmp_item;
	char *media_type = NULL;

	if(data->ppd_opt->media_brand == NULL)
		return;
	if(data->ppd_opt->media_brand->brand_list == NULL)
		return;

	media_type = FindCurrOpt(data->ppd_opt->items_list, kPPD_Items_MediaType);
	if(media_type == NULL)
		return;

    if (exeCurrDisableFlag == 1)
    {
        if(CurrDisable(data->ppd_opt->items_list, kPPD_Items_MediaType) > 0)
            return;
    }

	ChkMediaBrandInterleafSheet(data, -1);

	data->ppd_opt->media_brand->cur_item = NULL;
	tmp_item = data->ppd_opt->media_brand->brand_list;
	while(tmp_item != NULL)
	{
		if(strcmp(media_type, tmp_item->name) == 0){
			data->ppd_opt->media_brand->cur_item = tmp_item;
			break;
		}
		tmp_item = tmp_item->next;
	}

	if(data->ppd_opt->media_brand->cur_item == NULL){
		data->ppd_opt->media_brand->cur_item = data->ppd_opt->media_brand->def_item;
	}

	ChkMediaBrandInterleafSheet(data, 1);
}

void UpdateMediaBrand(cngplpData *data, char *new_opt)
{
	MediaBrandList		new_item;
	MediaBrandList		*tmp_item;
	UIOptionList		*tmp_opt;

	if(data->ppd_opt->media_brand == NULL)
		return;
	if(data->ppd_opt->media_brand->brand_list == NULL)
		return;

	if(ConvertMediaBrandStrToStruct(new_opt, &new_item))
		return;

	ChkMediaBrandInterleafSheet(data, -1);

	tmp_item = data->ppd_opt->media_brand->brand_list;
	while(tmp_item != NULL)
	{
		if(new_item.id == tmp_item->id){
			if((strcmp(new_item.name, tmp_item->name) == 0)
			&& (new_item.weight == tmp_item->weight)
			&& (new_item.surface == tmp_item->surface)
			&& (new_item.shape == tmp_item->shape)
			&& (new_item.color == tmp_item->color)){
				data->ppd_opt->media_brand->cur_item = tmp_item;
			}else{
				data->ppd_opt->media_brand->cur_item = data->ppd_opt->media_brand->def_item;
			}

			if(IS_USER_MEDIA_BRAND(tmp_item->id)){
				tmp_opt = GetMediaBrandMediaType(data->ppd_opt, kPPD_Items_MediaType, data->ppd_opt->media_brand->cur_item);
				if(tmp_opt != NULL)
					UpdatePPDData(data, kPPD_Items_MediaType, tmp_opt->name);
				else
					UpdatePPDData(data, kPPD_Items_MediaType, NULL);
			}else{
				UpdatePPDData(data, kPPD_Items_MediaType, data->ppd_opt->media_brand->cur_item->name);
			}

			break;
		}
		tmp_item = tmp_item->next;
	}

	ChkMediaBrandInterleafSheet(data, 1);

	FreeMediaBrandItem(&new_item);
}

void UpdateInsertMediaBrand(cngplpData *data, char *new_opt)
{
	MediaBrandList		new_item;
	MediaBrandList		*tmp_item;

	if(data->ppd_opt->media_brand == NULL)
		return;
	if(data->ppd_opt->media_brand->brand_list == NULL)
		return;
	if(data->ppd_opt->media_brand->def_ins_item == NULL)
		return;

	if(ConvertMediaBrandStrToStruct(new_opt, &new_item))
		return;

	tmp_item = data->ppd_opt->media_brand->brand_list;
	while(tmp_item != NULL)
	{
		if(new_item.id == tmp_item->id){
			if((strcmp(new_item.name, tmp_item->name) == 0)
			&& (new_item.weight == tmp_item->weight)
			&& (new_item.surface == tmp_item->surface)
			&& (new_item.shape == tmp_item->shape)
			&& (new_item.color == tmp_item->color)){
				data->ppd_opt->media_brand->cur_ins_item = tmp_item;
			}else{
				data->ppd_opt->media_brand->cur_ins_item = data->ppd_opt->media_brand->def_ins_item;
			}
			break;
		}
		tmp_item = tmp_item->next;
	}

	FreeMediaBrandItem(&new_item);
}

void UpdateInterleafMediaBrand(cngplpData *data, char *new_opt)
{
	MediaBrandList		new_item;
	MediaBrandList		*tmp_item;

	if(data->ppd_opt->media_brand == NULL)
		return;
	if(data->ppd_opt->media_brand->brand_list == NULL)
		return;
	if(data->ppd_opt->media_brand->def_interleaf_item == NULL)
		return;

	if(ConvertMediaBrandStrToStruct(new_opt, &new_item))
		return;

	tmp_item = data->ppd_opt->media_brand->brand_list;
	while(tmp_item != NULL)
	{
		if(new_item.id == tmp_item->id){
			if((strcmp(new_item.name, tmp_item->name) == 0)
			&& (new_item.weight == tmp_item->weight)
			&& (new_item.surface == tmp_item->surface)
			&& (new_item.shape == tmp_item->shape)
			&& (new_item.color == tmp_item->color)){
				data->ppd_opt->media_brand->cur_interleaf_item = tmp_item;
			}else{
				data->ppd_opt->media_brand->cur_interleaf_item = data->ppd_opt->media_brand->def_interleaf_item;
			}
			break;
		}
		tmp_item = tmp_item->next;
	}

	FreeMediaBrandItem(&new_item);
}

void UpdatePBindCoverMediaBrand(cngplpData *data, char *new_opt)
{
	MediaBrandList		new_item;
	MediaBrandList		*tmp_item;
	UIOptionList		*tmp_opt;

	if(data->ppd_opt->media_brand == NULL)
		return;
	if(data->ppd_opt->media_brand->brand_list == NULL)
		return;
	if(data->ppd_opt->media_brand->def_pb_cover_item == NULL)
		return;

	if(ConvertMediaBrandStrToStruct(new_opt, &new_item))
		return;

	tmp_item = data->ppd_opt->media_brand->brand_list;
	while(tmp_item != NULL)
	{
		if(new_item.id == tmp_item->id){
			if((strcmp(new_item.name, tmp_item->name) == 0)
			&& (new_item.weight == tmp_item->weight)
			&& (new_item.surface == tmp_item->surface)
			&& (new_item.shape == tmp_item->shape)
			&& (new_item.color == tmp_item->color)){
				data->ppd_opt->media_brand->cur_pb_cover_item = tmp_item;
			}else{
				data->ppd_opt->media_brand->cur_pb_cover_item = data->ppd_opt->media_brand->def_pb_cover_item;
			}

			if(IS_USER_MEDIA_BRAND(tmp_item->id)){
				tmp_opt = GetMediaBrandMediaType(data->ppd_opt, kPPD_Items_CNPBindCoverMediaType, data->ppd_opt->media_brand->cur_pb_cover_item);
				if(tmp_opt != NULL)
					UpdatePPDData(data, kPPD_Items_CNPBindCoverMediaType, tmp_opt->name);
				else
					UpdatePPDData(data, kPPD_Items_CNPBindCoverMediaType, NULL);
			}else{
				UpdatePPDData(data, kPPD_Items_CNPBindCoverMediaType, data->ppd_opt->media_brand->cur_pb_cover_item->name);
			}

			break;
		}
		tmp_item = tmp_item->next;
	}

	FreeMediaBrandItem(&new_item);
}

char* ConvertMediaBrandStructToStr(MediaBrandList *item)
{
	char *glist = NULL;
	char str[BUFSIZE];

	snprintf(str, BUFSIZE - 1, "%s:%ld", kPPD_Items_MediaBrand_ID, item->id);
	glist = AddList(glist, str);

	snprintf(str, BUFSIZE - 1, "%s:%s", kPPD_Items_MediaBrand_Name, item->name);
	glist = AddList(glist, str);

	snprintf(str, BUFSIZE - 1, "%s:%ld", kPPD_Items_MediaBrand_Weight, item->weight);
	glist = AddList(glist, str);

	snprintf(str, BUFSIZE - 1, "%s:%ld", kPPD_Items_MediaBrand_Surface, item->surface);
	glist = AddList(glist, str);

	snprintf(str, BUFSIZE - 1, "%s:%ld", kPPD_Items_MediaBrand_Shape, item->shape);
	glist = AddList(glist, str);

	snprintf(str, BUFSIZE - 1, "%s:%ld", kPPD_Items_MediaBrand_Color, item->color);
	glist = AddList(glist, str);

	return glist;
}

char* MakeMediaBrandListChar(PPDOptions *ppd_opt)
{
	char *glist = NULL;
	char *str = NULL;
	MediaBrandList *tmp_item;
	int disable = 0;
	char buf[BUFSIZE];
	UIOptionList *tmp_opt;

	if(ppd_opt->media_brand == NULL)
		return NULL;
	if(ppd_opt->media_brand->brand_list == NULL)
		return NULL;

	tmp_item = ppd_opt->media_brand->brand_list;
	while(tmp_item != NULL)
	{
		str = ConvertMediaBrandStructToStr(tmp_item);
		if(str != NULL){
			glist = AddList(glist, str);

			if(IS_USER_MEDIA_BRAND(tmp_item->id)){
				tmp_opt = GetMediaBrandMediaType(ppd_opt, kPPD_Items_MediaType, tmp_item);
				if(tmp_opt != NULL)
					disable = tmp_opt->disable;
				else
					disable = 0;
			}else{
				disable = GetDisableOpt(ppd_opt->items_list, kPPD_Items_MediaType, tmp_item->name);
			}
			snprintf(buf, BUFSIZE - 1, "<%d>", disable);
			glist = AddList(glist, buf);

			free(str);
		}
		tmp_item = tmp_item->next;
	}

	return glist;
}

char* MakeMediaBrandChar(PPDOptions *ppd_opt)
{
	char *str = NULL;

	if(ppd_opt->media_brand == NULL)
		return NULL;
	if(ppd_opt->media_brand->cur_item == NULL)
		return NULL;

	str = ConvertMediaBrandStructToStr(ppd_opt->media_brand->cur_item);

	return str;
}

char* MakeInsertMediaBrandListChar(PPDOptions *ppd_opt)
{
	char *glist = NULL;
	char *str = NULL;
	MediaBrandList *tmp_item;

	if(ppd_opt->media_brand == NULL)
		return NULL;
	if(ppd_opt->media_brand->brand_list == NULL)
		return NULL;

	tmp_item = ppd_opt->media_brand->brand_list;
	while(tmp_item != NULL)
	{
		if(tmp_item->shape == 2){
			str = ConvertMediaBrandStructToStr(tmp_item);
			if(str != NULL){
				glist = AddList(glist, str);

				glist = AddList(glist, "<0>");

				free(str);
			}
		}
		tmp_item = tmp_item->next;
	}

	return glist;
}

char* MakeInsertMediaBrandChar(PPDOptions *ppd_opt)
{
	char *str = NULL;

	if(ppd_opt->media_brand == NULL)
		return NULL;
	if(ppd_opt->media_brand->cur_ins_item == NULL)
		return NULL;

	str = ConvertMediaBrandStructToStr(ppd_opt->media_brand->cur_ins_item);

	return str;
}

char* MakeInterleafMediaBrandListChar(PPDOptions *ppd_opt)
{
	char *glist = NULL;
	char *str = NULL;
	MediaBrandList *tmp_item;
	UIOptionList *tmp_opt;
	char buf[BUFSIZE];

	if(ppd_opt->media_brand == NULL)
		return NULL;
	if(ppd_opt->media_brand->brand_list == NULL)
		return NULL;

	tmp_item = ppd_opt->media_brand->brand_list;
	while(tmp_item != NULL)
	{
		if(IS_USER_MEDIA_BRAND(tmp_item->id))
			tmp_opt = GetMediaBrandMediaType(ppd_opt, kPPD_Items_CNInterleafMediaType, tmp_item);
		else
			tmp_opt = FindOptionList(ppd_opt->items_list, kPPD_Items_CNInterleafMediaType, tmp_item->name);
		if(tmp_opt != NULL){
			str = ConvertMediaBrandStructToStr(tmp_item);
			if(str != NULL){
				glist = AddList(glist, str);

				snprintf(buf, BUFSIZE - 1, "<%d>", tmp_opt->disable);
				glist = AddList(glist, buf);

				free(str);
			}
		}
		tmp_item = tmp_item->next;
	}

	return glist;
}

char* MakeInterleafMediaBrandChar(PPDOptions *ppd_opt)
{
	char *str = NULL;

	if(ppd_opt->media_brand == NULL)
		return NULL;
	if(ppd_opt->media_brand->cur_interleaf_item == NULL)
		return NULL;

	str = ConvertMediaBrandStructToStr(ppd_opt->media_brand->cur_interleaf_item);

	return str;
}

char* MakePBindCoverMediaBrandListChar(PPDOptions *ppd_opt)
{
	char *glist = NULL;
	char *str = NULL;
	MediaBrandList *tmp_item;
	UIOptionList *tmp_opt;
	char buf[BUFSIZE];

	if(ppd_opt->media_brand == NULL)
		return NULL;
	if(ppd_opt->media_brand->brand_list == NULL)
		return NULL;

	tmp_item = ppd_opt->media_brand->brand_list;
	while(tmp_item != NULL)
	{
		if(IS_USER_MEDIA_BRAND(tmp_item->id))
			tmp_opt = GetMediaBrandMediaType(ppd_opt, kPPD_Items_CNPBindCoverMediaType, tmp_item);
		else
			tmp_opt = FindOptionList(ppd_opt->items_list, kPPD_Items_CNPBindCoverMediaType, tmp_item->name);
		if(tmp_opt != NULL){
			str = ConvertMediaBrandStructToStr(tmp_item);
			if(str != NULL){
				glist = AddList(glist, str);

				snprintf(buf, BUFSIZE - 1, "<%d>", tmp_opt->disable);
				glist = AddList(glist, buf);

				free(str);
			}
		}
		tmp_item = tmp_item->next;
	}

	return glist;
}

char* MakePBindCoverMediaBrandChar(PPDOptions *ppd_opt)
{
	char *str = NULL;

	if(ppd_opt->media_brand == NULL)
		return NULL;
	if(ppd_opt->media_brand->cur_pb_cover_item == NULL)
		return NULL;

	str = ConvertMediaBrandStructToStr(ppd_opt->media_brand->cur_pb_cover_item);

	return str;
}

static void ChkOverlayForm(cngplpData *data, char *item_name, char *opt_name, int flag)
{
	UIItemsList *items_list = data->ppd_opt->items_list;
	char *curr_overlay = NULL;
	char *curr_colormode = NULL;
	FormList *tmp_item = NULL;

	if((strcmp(item_name, kPPD_Items_CNColorMode) != 0)
	 &&(strcmp(item_name, kPPD_Items_CNOverlay) != 0)
	 &&(strcmp(item_name, kPPD_Items_Device_CNFormHandle) != 0)){
		return;
	}

	if(data->ppd_opt->special == NULL){
		return;
	}
	if((curr_overlay = FindCurrOpt(items_list, kPPD_Items_CNOverlay)) == NULL){
		return;
	}

	if((strcmp(item_name, kPPD_Items_CNColorMode) == 0)
	 ||(strcmp(item_name, kPPD_Items_Device_CNFormHandle) == 0)){
		if((curr_colormode = FindCurrOpt(items_list, kPPD_Items_CNColorMode)) != NULL){
			if(strcmp(curr_colormode, "mono") == 0){
				tmp_item = data->ppd_opt->special->form_list;
				while(tmp_item){
					if(strcmp(tmp_item->color, kPPD_Items_Form_COLOR_COLOR) == 0){
						tmp_item->disable+=flag;
					}
					tmp_item = tmp_item->next;
				}
			}
		}
	}

	if((strcmp(item_name, kPPD_Items_CNOverlay) == 0)
	 ||(strcmp(item_name, kPPD_Items_Device_CNFormHandle) == 0)){
		if( (strcmp(curr_overlay, "UseOverlay") != 0)
		 && (strcmp(curr_overlay, "ClearCoatingForm") != 0)){
			tmp_item = data->ppd_opt->special->form_list;
			while(tmp_item){
				tmp_item->disable+=flag;
				tmp_item = tmp_item->next;
			}
		}
	}

	if((strcmp(item_name, kPPD_Items_Device_CNFormHandle) == 0)){
		if(GetFormCount(data->ppd_opt) == 0){
			MarkDisableOpt(data, kPPD_Items_CNOverlay, "UseOverlay", flag);
			MarkDisableOpt(data, kPPD_Items_CNOverlay, "ClearCoatingForm", flag);
		}
	}
	if((strcmp(item_name, kPPD_Items_CNColorMode) == 0)
	 ||(strcmp(item_name, kPPD_Items_Device_CNFormHandle) == 0)){
		if((curr_colormode != NULL) && (strcmp(curr_colormode, "mono") == 0)){
			if(GetBWFormCount(data->ppd_opt) == 0){
				MarkDisableOpt(data, kPPD_Items_CNOverlay, "UseOverlay", flag);
				MarkDisableOpt(data, kPPD_Items_CNOverlay, "ClearCoatingForm", flag);
			}
		}
	}
}

static void ResetFormListDiable(FormList *form_list)
{
	FormList *tmp_item = NULL;

	tmp_item = form_list;
	while(tmp_item){
		tmp_item->disable = 0;
		tmp_item = tmp_item->next;
	}
}

int UpdateFormHandle(cngplpData *data, const char *handle)
{
	int size = 0;

	if(handle == NULL){
		return 1;
	}

	if(data->ppd_opt->special){
		size = sizeof(data->ppd_opt->special->form_handle);
		memset(data->ppd_opt->special->form_handle, 0, size);
		strncpy(data->ppd_opt->special->form_handle, handle, size-1);
	}

	CheckFormHandleValid(data);

	return 0;
}

static void CheckFormHandleValid(cngplpData *data)
{
	char *curr_overlay = NULL;
	FormList *tmp_item = NULL;

	if(data->ppd_opt->special == NULL){
		return;
	}

	if((curr_overlay = FindCurrOpt(data->ppd_opt->items_list, kPPD_Items_CNOverlay)) == NULL){
		return;
	}

	if( (strcmp(curr_overlay, "UseOverlay") == 0)
	 || (strcmp(curr_overlay, "ClearCoatingForm") == 0)
	){
		tmp_item = FindFormList(data->ppd_opt->special->form_list, data->ppd_opt->special->form_handle);
		if((tmp_item == NULL) || (tmp_item->disable > 0)){
			UpdatePPDData(data, kPPD_Items_CNOverlay, "NoUseOverlay");
		}
	}
}

int UpdateFormList(cngplpData *data, const char *buf)
{
	PPDOptions *ppd_opt = data->ppd_opt;
	const char *start = NULL, *end = NULL;
	char *item_str = NULL;
	char find_top_str[BUFSIZE];
	long len = 0;

	if(ppd_opt->special == NULL){
		return 1;
	}

	MarkDisable(data, kPPD_Items_Device_CNFormHandle, ppd_opt->special->form_handle, -1, 1);

	FreeFormList(ppd_opt);

	if(buf != NULL){
		snprintf(find_top_str, BUFSIZE - 1, ",%s:", kPPD_Items_Form_HANDLE);

		start = buf;
		while(1){
			end = strstr(start, find_top_str);
			if(end != NULL){
				len = end - start;
			}else{
				len = strlen(buf) - (start - buf);
			}

			item_str = calloc(1, len+1);
			if(item_str){
				memcpy(item_str, start, len);

				AddFormData(ppd_opt, item_str);

				free(item_str);
				item_str = NULL;
			}

			if(end == NULL){
				break;
			}

			start = end + 1;
		}
	}

	MarkDisable(data, kPPD_Items_Device_CNFormHandle, ppd_opt->special->form_handle, 1, 1);

	UpdateFormHandle(data, ppd_opt->special->form_handle);

	return 0;
}

static int AddFormData(PPDOptions *ppd_opt, char *buf)
{
	FormList *new_item = NULL, *tmp_item = NULL;

	if(ppd_opt->special == NULL){
		return 1;
	}

	new_item = (FormList *)malloc(sizeof(FormList));
	if(new_item == NULL){
		return 1;
	}

	if(ConvertFormStrToStruct(buf, new_item)){
		free(new_item);
		return 1;
	}

	if(ppd_opt->special->form_list == NULL){
		ppd_opt->special->form_list = new_item;
	}else{
		tmp_item = ppd_opt->special->form_list;
		while(tmp_item->next != NULL){
			tmp_item = tmp_item->next;
		}
		tmp_item->next = new_item;
	}
	return 0;
}

static int ConvertFormStrToStruct(char *buf, FormList *item)
{
	char *tok = NULL;
	char *p_tmp = NULL;
	char *p_key = NULL;
	char *p_val = NULL;

	memset(item, 0, sizeof(FormList));

	for(tok = strtok_r(buf, ",", &p_tmp); tok != NULL; tok = strtok_r(NULL, ",", &p_tmp)) {
		p_key = tok;
		p_val = strchr(tok, ':');
		if(p_val){
			*p_val = '\0';
			p_val += 1;

			if(strcmp(p_key, kPPD_Items_Form_HANDLE) == 0){
				item->handle = strdup(p_val);
			}else if(strcmp(p_key, kPPD_Items_Form_NAME) == 0){
				item->name = strdup(p_val);
			}else if(strcmp(p_key, kPPD_Items_Form_DATE) == 0){
				item->date = strdup(p_val);
			}else if(strcmp(p_key, kPPD_Items_Form_COLOR) == 0){
				item->color = strdup(p_val);
			}
		}
	}

	if( (item->handle == NULL)
	 || (item->name   == NULL)
	 || (item->date   == NULL)
	 || (item->color  == NULL)
	){
		FreeFormItem(item);
		return 1;
	}

	return 0;
}

char* MakeFormListChar(PPDOptions *ppd_opt)
{
	char *glist = NULL;
	char *str = NULL;
	FormList *tmp_item;

	if(ppd_opt->special == NULL){
		return NULL;
	}

	tmp_item = ppd_opt->special->form_list;
	while(tmp_item != NULL)
	{
		str = ConvertFormStructToStr(tmp_item);
		if(str != NULL){
			glist = AddList(glist, str);
			free(str);
		}
		tmp_item = tmp_item->next;
	}

	return glist;
}

static char* ConvertFormStructToStr(FormList *item)
{
	char *glist = NULL;
	char str[BUFSIZE];

	snprintf(str, BUFSIZE - 1, "%s:%s", kPPD_Items_Form_HANDLE, item->handle);
	glist = AddList(glist, str);

	snprintf(str, BUFSIZE - 1, "%s:%s", kPPD_Items_Form_NAME, item->name);
	glist = AddList(glist, str);

	snprintf(str, BUFSIZE - 1, "%s:%s", kPPD_Items_Form_DATE, item->date);
	glist = AddList(glist, str);

	snprintf(str, BUFSIZE - 1, "%s:%s<%d>", kPPD_Items_Form_COLOR, item->color, item->disable);
	glist = AddList(glist, str);

	return glist;
}

static void FreeFormList(PPDOptions *ppd_opt)
{
	FormList *item, *tmp_item;

	if(ppd_opt->special == NULL){
		return;
	}

	item = ppd_opt->special->form_list;
	while(item != NULL){
		tmp_item = item->next;
		FreeFormItem(item);
		free(item);
		item = tmp_item;
	}

	ppd_opt->special->form_list = NULL;
}

static void FreeFormItem(FormList *item)
{
	if(item == NULL){
		return;
	}
	MemFree(item->handle);
	item->handle = NULL;
	MemFree(item->name);
	item->name = NULL;
	MemFree(item->date);
	item->date = NULL;
	MemFree(item->color);
	item->color = NULL;
}

static FormList* FindFormList(FormList *form_list, const char *handle)
{
	FormList *tmp_item = NULL;

	tmp_item = form_list;
	while(tmp_item){
		if(strcmp(tmp_item->handle, handle) == 0){
			break;
		}
		tmp_item = tmp_item->next;
	}

	return tmp_item;
}

static int GetFormCount(PPDOptions *ppd_opt)
{
	int count = 0;
	FormList *tmp_item = NULL;

	if(ppd_opt->special == NULL){
		return count;
	}

	tmp_item = ppd_opt->special->form_list;
	while(tmp_item){
		count++;
		tmp_item = tmp_item->next;
	}

	return count;
}

static int GetBWFormCount(PPDOptions *ppd_opt)
{
	int count = 0;
	FormList *tmp_item = NULL;

	if(ppd_opt->special == NULL){
		return count;
	}

	tmp_item = ppd_opt->special->form_list;
	while(tmp_item){
		if(strcmp(tmp_item->color, kPPD_Items_Form_COLOR_BW) == 0){
			count++;
		}
		tmp_item = tmp_item->next;
	}

	return count;
}

UIOptionList* MakeDeviceProfileOptionList(char *item_name, char *buf, int *num_options)
{
	char *ptr;
	char *p_name;
	char name[128];
	UIOptionList *option;

	*num_options = 0;

	option = (UIOptionList *)malloc(sizeof(UIOptionList));
	if(option == NULL){
		return NULL;
	}

	memset(option, 0, sizeof(UIOptionList));

	ptr = buf;
	while(1){
		p_name = name;
		while(1){
			if(*ptr == '\n' || *ptr == 0xd || *ptr == '\0')
				break;
			if(*ptr == ',')
				break;
			if(p_name - name == sizeof(name) - 1)
				break;
			*p_name = *ptr;
			ptr++;
			p_name++;
		}
		*p_name = '\0';

		(*num_options)++;
		if((SetOptionList(option, name, name, *num_options)) == ALLOC_ERROR){
			FreeOption(option);
			return NULL;
		}

		if(*ptr == '\n' || *ptr == 0xd || *ptr == '\0')
			break;
		else
			ptr++;
	}

	return option;
}

UIItemsList* MakeDeviceProfileItemList(char *item_name, char *buf)
{
	UIItemsList *items;

	items = (UIItemsList *)malloc(sizeof(UIItemsList));
	if(items == NULL)
		return NULL;

	memset(items, 0, sizeof(UIItemsList));

	items->name = strdup(item_name);
	items->next = NULL;
	items->string = strdup(item_name);
	items->type = PICKONE;
	items->default_option = NULL;
	items->opt_lists = MakeDeviceProfileOptionList(item_name, buf, &(items->num_options));
	if(items->opt_lists == NULL){
		FreeItems(items);
		return NULL;
	}

	return items;
}

int UpdateMonitorProfileList(cngplpData *data, char *buf)
{
	UpdateDeviceProfileList(data, kPPD_Items_CNMonitorProfile, buf);
	UpdateDeviceProfileList(data, kPPD_Items_CNImageMonitorProfile, buf);
	UpdateDeviceProfileList(data, kPPD_Items_CNGraphicsMonitorProfile, buf);
	UpdateDeviceProfileList(data, kPPD_Items_CNTextMonitorProfile, buf);
	return 0;
}

static void ChkCNMonitorProfile(cngplpData *data, char *item_name, char *opt_name, int flag)
{
	UIOptionList *tmp_dev_opt;
	UIItemsList *dev_item;

	if(data->ppd_opt->dev_items_list == NULL)
		return;

	if((strcmp(item_name, kPPD_Items_CNMatchingMode) != 0)
	 || (strcmp(opt_name, "Printer") == 0)){
		return;
	 }

	dev_item = FindItemsList(data->ppd_opt->dev_items_list, kPPD_Items_CNMonitorProfile);
	if(dev_item != NULL){
		tmp_dev_opt = dev_item->opt_lists;
		while(tmp_dev_opt != NULL){
			MarkDisableOpt(data, kPPD_Items_CNMonitorProfile, tmp_dev_opt->name, flag);
			tmp_dev_opt = tmp_dev_opt->next;
		}
	}

	dev_item = FindItemsList(data->ppd_opt->dev_items_list, kPPD_Items_CNImageMonitorProfile);
	if(dev_item != NULL){
		tmp_dev_opt = dev_item->opt_lists;
		while(tmp_dev_opt != NULL){
			MarkDisableOpt(data, kPPD_Items_CNImageMonitorProfile, tmp_dev_opt->name, flag);
			tmp_dev_opt = tmp_dev_opt->next;
		}
	}

	dev_item = FindItemsList(data->ppd_opt->dev_items_list, kPPD_Items_CNGraphicsMonitorProfile);
	if(dev_item != NULL){
		tmp_dev_opt = dev_item->opt_lists;
		while(tmp_dev_opt != NULL){
			MarkDisableOpt(data, kPPD_Items_CNGraphicsMonitorProfile, tmp_dev_opt->name, flag);
			tmp_dev_opt = tmp_dev_opt->next;
		}
	}

	dev_item = FindItemsList(data->ppd_opt->dev_items_list, kPPD_Items_CNTextMonitorProfile);
	if(dev_item != NULL){
		tmp_dev_opt = dev_item->opt_lists;
		while(tmp_dev_opt != NULL){
			MarkDisableOpt(data, kPPD_Items_CNTextMonitorProfile, tmp_dev_opt->name, flag);
			tmp_dev_opt = tmp_dev_opt->next;
		}
	}
}


int UpdateDeviceProfileList(cngplpData *data, char *item_name, char *buf)
{
	int result = NO_ERROR;
	PPDOptions *ppd_opt = data->ppd_opt;
	UIItemsList *tmp_item, *prev_item, *new_item;
	UIItemsList *prof_item, *dev_item = NULL;
	char *cur;
	UIOptionList *tmp_dev_opt, *prev_opt, *tmp_opt;
	UIOptionList *new_opt;
	int num_new_options = 0;
	int find_flg = 0;

	prof_item = FindItemsList(ppd_opt->items_list, item_name);
	if(prof_item == NULL)
		return 1;

	cur = FindCurrOpt(ppd_opt->items_list, item_name);
	if(cur == NULL)
		return 1;

	if(ppd_opt->uiconf_flag & CNUICONF_FLG_CNOUTPUTPROFILE){
		if(strcmp(item_name, kPPD_Items_CNOutputProfile) == 0)
			MarkDisable(data, kPPD_Items_CNRGBMatchingMethod, FindCurrOpt(ppd_opt->items_list, kPPD_Items_CNRGBMatchingMethod), -1, 1);
	}
	if(ppd_opt->uiconf_flag & CNUICONF_FLG_CNMONITORPROFILE){
		if((strcmp(item_name, kPPD_Items_CNMonitorProfile) == 0)
		 || (strcmp(item_name, kPPD_Items_CNImageMonitorProfile) == 0)
		 || (strcmp(item_name, kPPD_Items_CNGraphicsMonitorProfile) == 0)
		 || (strcmp(item_name, kPPD_Items_CNTextMonitorProfile) == 0)
		){
			MarkDisable(data, kPPD_Items_CNMatchingMode, FindCurrOpt(ppd_opt->items_list, kPPD_Items_CNMatchingMode), -1, 1);
			MarkDisable(data, kPPD_Items_CNGraphicsMode, FindCurrOpt(ppd_opt->items_list, kPPD_Items_CNGraphicsMode), -1, 1);
		}
	}
	if(strcmp(item_name, kPPD_Items_CNRGBInputLightClrSpace) == 0)
		MarkDisable(data, kPPD_Items_CNRGBMatchingMode, FindCurrOpt(ppd_opt->items_list, kPPD_Items_CNRGBMatchingMode), -1, 1);
	if(strcmp(item_name, kPPD_Items_CNCMYKInputLightClrSpace) == 0)
		MarkDisable(data, kPPD_Items_CNCMYKMatchingMode, FindCurrOpt(ppd_opt->items_list, kPPD_Items_CNCMYKMatchingMode), -1, 1);

	prof_item->new_option = strdup(prof_item->default_option);
	UpdateCurrOption(prof_item);
	prof_item->new_option = strdup(cur);

	if((ppd_opt->dev_items_list != NULL)
	 && ((dev_item = FindItemsList(ppd_opt->dev_items_list, item_name)) != NULL)
	){
		prev_opt = NULL;
		tmp_opt = prof_item->opt_lists;
		while(tmp_opt != NULL){
			find_flg = 0;
			tmp_dev_opt = dev_item->opt_lists;
			while(tmp_dev_opt != NULL){
				if(strcmp(tmp_opt->name, tmp_dev_opt->name) == 0){
					prof_item->num_options--;
					if(prev_opt == NULL){
						tmp_opt = prof_item->opt_lists->next;
						prof_item->opt_lists->next = NULL;
						FreeOption(prof_item->opt_lists);
						prof_item->opt_lists = tmp_opt;
						find_flg = 1;
						break;
					}else{
						prev_opt->next = tmp_opt->next;
						tmp_opt->next = NULL;
						FreeOption(tmp_opt);
						tmp_opt = prev_opt->next;
						find_flg = 1;
						break;
					}
				}
				tmp_dev_opt = tmp_dev_opt->next;
			}
			if(find_flg == 1)
				continue;

			prev_opt = tmp_opt;
			tmp_opt = tmp_opt->next;
		}
	}

	if(buf != NULL)
	{
		new_item = MakeDeviceProfileItemList(item_name, buf);
		if(new_item == NULL){
			result = 1;
		}else{

			if(ppd_opt->dev_items_list == NULL){
				ppd_opt->dev_items_list = new_item;
			}else{
				tmp_item = FindItemsList(ppd_opt->dev_items_list, item_name);
				if(tmp_item == NULL){
					tmp_item = ppd_opt->dev_items_list;
					while(1){
						if(tmp_item->next == NULL){
							tmp_item->next = new_item;
							break;
						}
						tmp_item = tmp_item->next;
					}
				}else{
					new_item->next = tmp_item->next;
					tmp_item->next = NULL;
					prev_item = FindPrevItemsList(ppd_opt->dev_items_list, item_name);
					if(prev_item != NULL){
						prev_item->next = new_item;
					}else{
						ppd_opt->dev_items_list = new_item;
					}
					FreeItems(tmp_item);
				}
			}
		}

		if(result == NO_ERROR)
		{
			new_opt = MakeDeviceProfileOptionList(item_name, buf, &num_new_options);
			if(new_opt == NULL){
				result = 1;
			}else{

				find_flg = 0;
				prev_opt = NULL;
				tmp_opt = prof_item->opt_lists;
				while(tmp_opt != NULL){
					if(strcmp(tmp_opt->name, "Off") == 0){
						tmp_dev_opt = new_opt;
						while(1){
							if(tmp_dev_opt->next == NULL){
								tmp_dev_opt->next = tmp_opt;
								break;
							}
							tmp_dev_opt = tmp_dev_opt->next;
						}
						if(prev_opt == NULL){
							prof_item->opt_lists = new_opt;
						}else{
							prev_opt->next = new_opt;
						}
						find_flg = 1;
						break;
					}
					prev_opt = tmp_opt;
					tmp_opt = tmp_opt->next;
				}
				if(find_flg == 0){
                    if(prev_opt != NULL){
                        prev_opt->next = new_opt;
                    }
				}
				prof_item->num_options += num_new_options;
			}
		}
	}

	UpdateCurrOption(prof_item);

	if(ppd_opt->uiconf_flag & CNUICONF_FLG_CNOUTPUTPROFILE){
		if(strcmp(item_name, kPPD_Items_CNOutputProfile) == 0)
			MarkDisable(data, kPPD_Items_CNRGBMatchingMethod, FindCurrOpt(ppd_opt->items_list, kPPD_Items_CNRGBMatchingMethod), 1, 1);
	}
	if(ppd_opt->uiconf_flag & CNUICONF_FLG_CNMONITORPROFILE){
		if((strcmp(item_name, kPPD_Items_CNMonitorProfile) == 0)
		 || (strcmp(item_name, kPPD_Items_CNImageMonitorProfile) == 0)
		 || (strcmp(item_name, kPPD_Items_CNGraphicsMonitorProfile) == 0)
		 || (strcmp(item_name, kPPD_Items_CNTextMonitorProfile) == 0)
		){
			MarkDisable(data, kPPD_Items_CNMatchingMode, FindCurrOpt(ppd_opt->items_list, kPPD_Items_CNMatchingMode), 1, 1);
			MarkDisable(data, kPPD_Items_CNGraphicsMode, FindCurrOpt(ppd_opt->items_list, kPPD_Items_CNGraphicsMode), 1, 1);
		}
	}
	if(strcmp(item_name, kPPD_Items_CNRGBInputLightClrSpace) == 0)
		MarkDisable(data, kPPD_Items_CNRGBMatchingMode, FindCurrOpt(ppd_opt->items_list, kPPD_Items_CNRGBMatchingMode), 1, 1);
	if(strcmp(item_name, kPPD_Items_CNCMYKInputLightClrSpace) == 0)
		MarkDisable(data, kPPD_Items_CNCMYKMatchingMode, FindCurrOpt(ppd_opt->items_list, kPPD_Items_CNCMYKMatchingMode), 1, 1);

	return result;
}

static void ChkCNOutputProfile(cngplpData *data, char *item_name, char *opt_name, int flag)
{
	UIOptionList *tmp_dev_opt;
	UIItemsList *dev_item;

	if(data->ppd_opt->dev_items_list == NULL)
		return;

	if((strcmp(item_name, kPPD_Items_CNRGBMatchingMethod) != 0)
	 || (strcmp(opt_name, "Perceptual") != 0)){
		return;
	 }

	dev_item = FindItemsList(data->ppd_opt->dev_items_list, kPPD_Items_CNOutputProfile);
	if(dev_item == NULL)
		return;

	tmp_dev_opt = dev_item->opt_lists;
	while(tmp_dev_opt != NULL){
		MarkDisableOpt(data, kPPD_Items_CNOutputProfile, tmp_dev_opt->name, flag);
		tmp_dev_opt = tmp_dev_opt->next;
	}
}

static void ChkCNInsertSheet(cngplpData *data, char *item_name, char *opt_name, int flag)
{
	UIItemsList *list = data->ppd_opt->items_list;
	char *curr = NULL;
	int nup = 1;

	if((curr = FindCurrOpt(list, kPPD_Items_CNInsertSheet)) == NULL)
		return;

	if(strcmp(item_name, kPPD_Items_Common_number_up) == 0){
		nup = atoi(opt_name);
		if(nup < 2)
			return;
	}else{
		return;
	}

	MarkDisableOpt(data, kPPD_Items_CNInsertSheet, "True", flag);
}

static void ChkFrontSheet(cngplpData *data, char *item_name, char *opt_name, int flag)
{
	UIItemsList *tmp_item = NULL;
	UIOptionList *tmp_opt = NULL;
	int nup = 1;

	if(strcmp(item_name, kPPD_Items_Common_number_up) == 0){
		nup = atoi(opt_name);
		if(nup < 2)
			return;
	}else{
		return;
	}

	if((tmp_item = FindItemsList(data->ppd_opt->items_list, kPPD_Items_CNFrontPrintOn)) != NULL){
		tmp_opt = tmp_item->opt_lists;
		while(tmp_opt){
			if(strcmp(tmp_opt->name, "Off") != 0){
				MarkDisableOpt(data, kPPD_Items_CNFrontPrintOn, tmp_opt->name, flag);
			}
			tmp_opt = tmp_opt->next;
		}
	}

	if((tmp_item = FindItemsList(data->ppd_opt->items_list, kPPD_Items_CNBackPrintOn)) != NULL){
		tmp_opt = tmp_item->opt_lists;
		while(tmp_opt){
			if(strcmp(tmp_opt->name, "Off") != 0){
				MarkDisableOpt(data, kPPD_Items_CNBackPrintOn, tmp_opt->name, flag);
			}
			tmp_opt = tmp_opt->next;
		}
	}
}

#define	CNCONF_ORIENTATION_TYPE1	1
static void ChkOrientationRequested(cngplpData *data, char *item_name, char *opt_name, int flag)
{
	UIItemsList *items_list = data->ppd_opt->items_list;
	char *ptr = NULL;
	int type = 0;
	int orientation = 0;
	char *curr = NULL;
	int nup = 1;

	if((strcmp(item_name, kPPD_Items_Common_orientation_requested) != 0)
	 &&(strcmp(item_name, kPPD_Items_Common_number_up) != 0)
	 &&(strcmp(item_name, kPPD_Items_CNSelectBy) != 0)
	 &&(strcmp(item_name, kPPD_Items_MediaType) != 0)){
		return;
	}

	if((ptr = GetUIValue(data, kPPD_Items_CNUIConfOrientationRequestedType)) == NULL){
		return;
	}
	type = atoi(ptr);

	if((curr = GetCupsValue(data->cups_opt->common->option, kPPD_Items_Common_orientation_requested)) == NULL){
		return;
	}
	orientation = atoi(curr);

	if((curr = GetCupsValue(data->cups_opt->common->option, kPPD_Items_Common_number_up)) != NULL){
		nup = atoi(curr);
	}

	switch(type){
		case CNCONF_ORIENTATION_TYPE1:
			if((nup == 2) || (nup == 6)){
				if((orientation != 3) && (orientation != 6)){
					return;
				}
			}else{
				if((orientation != 4) && (orientation != 5)){
					return;
				}
			}

			if((curr = FindCurrOpt(items_list, kPPD_Items_CNSelectBy)) == NULL){
				return;
			}else{
				if(strcmp(curr, "PaperType") != 0){
					return;
				}
			}

			if((curr = FindCurrOpt(items_list, kPPD_Items_MediaType)) == NULL){
				return;
			}else{
				if((strcmp(curr, "BOND") != 0) && (strcmp(curr, "HEAVY2") != 0)){
					return;
				}
			}

			MarkDisableOpt(data, kPPD_Items_CNStaple, "True", flag);
			break;
	}
}
static void ChkCNPrioritizeLineText(cngplpData *data, char *item_name, char *opt_name, int flag)
{
    int          err = NO_ERROR;
    UIOptionList *tmp_opt = NULL;
	UIItemsList  *tmp_item = NULL;

    if(data->ppd_opt->dev_items_list == NULL)
    {
        err = ERROR;
    }

    if (err == NO_ERROR)
    {
        if(strcasecmp(item_name, kPPD_Items_CNOutputProfile) == 0)
        {
            tmp_item = FindItemsList(data->ppd_opt->items_list, kPPD_Items_CNPrioritizeLineText);
            if( tmp_item != NULL )
            {
                tmp_opt = tmp_item->opt_lists;

                if(strcasecmp(opt_name, "Default") != 0)
                {
                    while(tmp_opt != NULL){
                        if (strcasecmp(tmp_opt->name,"False") != 0)
                        {
                            MarkDisableOpt(data, kPPD_Items_CNPrioritizeLineText, tmp_opt->name, flag);
                        }
                        tmp_opt = tmp_opt->next;
                    }
                }
            }
        }
    }
}

static void ChkOffsetNum(cngplpData *data, char *item_name, char *opt_name, int flag)
{
	if((strcasecmp(item_name, kPPD_Items_CNStaple) == 0) && (strcasecmp(opt_name, "True") == 0)){
		if(!IsConflictBetweenFunctions(data, kPPD_Items_CNStaple, "True", kPPD_Items_CNOutputPartition, "offset")){
			if(flag > 0){
				data->ppd_opt->offset_num = 1;
			}
		}
	}else if((strcasecmp(item_name, kPPD_Items_Collate) == 0) && (strcasecmp(opt_name, "False") == 0)){
		if(flag > 0){
			data->ppd_opt->offset_num = 1;
		}
	}
	return;
}

int GetOffsetNumConflict(cngplpData *data)
{
	UIItemsList *items_list = data->ppd_opt->items_list;
	char *curr = NULL;
	int conflict = 0;

	if(data == NULL){
		return 0;
	}

	if((curr = FindCurrOpt(items_list, kPPD_Items_CNOutputPartition)) == NULL){
		conflict = 1;
	}else{
		if(strcasecmp(curr, "offset") != 0){
			conflict = 1;
		}
	}

	if(conflict == 0){
		if((curr = FindCurrOpt(items_list, kPPD_Items_Collate)) == NULL){
			conflict = 1;
		}else{
			if(strcasecmp(curr, "True") != 0){
				conflict = 1;
			}
		}
	}

	if(conflict == 0){
		if(!IsConflictBetweenFunctions(data, kPPD_Items_CNStaple, "True", kPPD_Items_CNOutputPartition, "offset")){
			if((curr = FindCurrOpt(items_list, kPPD_Items_CNStaple)) != NULL){
				if(strcasecmp(curr, "True") == 0){
					conflict = 1;
				}
			}
		}
	}

	return conflict;
}

int IsConflictBetweenFunctions(cngplpData *data, char *cond_item_name, char *cond_opt_name, char *dst_item_name, char *dst_opt_name)
{
	UIItemsList *items_list = data->ppd_opt->items_list;
	UIOptionList *cond_list = NULL;
	int conflict = 0;
	UIConstList *tmp_const = NULL;
	UIExtConfList *tmp_conf = NULL;
	UIConfList *tmp_cons_list = NULL;

	if((data == NULL) || (cond_item_name == NULL) || (cond_opt_name == NULL) || (dst_item_name == NULL) || (dst_opt_name == NULL)){
		return 0;
	}

	cond_list = FindOptionList(items_list, cond_item_name, cond_opt_name);
	if(cond_list == NULL){
		conflict = 0;
	}else{
		tmp_const = cond_list->uiconst;
		while(tmp_const != NULL){
			if(strcasecmp(tmp_const->key, dst_item_name) == 0){
				if(strcasecmp(tmp_const->option, dst_opt_name) == 0){
					conflict = 1;
					break;
				}
			}
			tmp_const = tmp_const->next;
		}

		if(conflict == 0){
			tmp_conf = cond_list->uiconf;
			while(tmp_conf != NULL){
				tmp_cons_list = tmp_conf->conf_elem;
				while(tmp_cons_list != NULL){
					if(strcasecmp(tmp_cons_list->key, dst_item_name) == 0){
						if(strcasecmp(tmp_cons_list->option, dst_opt_name) == 0){
							if(tmp_conf->other_elem == NULL){
								conflict = 1;
								break;
							}
							else {
								if(CheckAllDevOptionElm(items_list, tmp_conf)){
									conflict = 1;
									break;
								}
							}
						}
					}
					tmp_cons_list = tmp_cons_list->next;
				}
				if(conflict != 0){
					break;
				}
				tmp_conf = tmp_conf->next;
			}
		}
	}

	return conflict;
}

static void ChkMediaBrandShape(cngplpData *data, char *item_name, char *opt_name, int flag)
{
	if(data->ppd_opt->media_brand == NULL)
		return;
	if(data->ppd_opt->media_brand->brand_list == NULL)
		return;

	if(strcmp(item_name, kPPD_Items_CNSelectBy) == 0){
		ChkMediaBrandInterleafSheet(data, flag);
	}
}

int InitAdjustTrimm(PPDOptions *ppd_opt)
{
	UIValueList *tmp_uival = NULL;

	ppd_opt->adjust_trim_num = 0.0;
	if((tmp_uival = FindUIValueList(ppd_opt->uivalue, "CNUIAdjustTrimNumDefault")) != NULL)
	{
#if !defined(__APPLE__) && !defined(_OPAL)
		ConvertDecimalPoint(tmp_uival->value);
#endif
		ppd_opt->adjust_trim_num = atof(tmp_uival->value);
	}
	ppd_opt->adjust_frtrim_num = 0.0;
	if((tmp_uival = FindUIValueList(ppd_opt->uivalue, "CNUIAdjustTrimNumDefault")) != NULL)
		ppd_opt->adjust_frtrim_num = atof(tmp_uival->value);
	ppd_opt->adjust_tbtrim_num = 0.0;
	if((tmp_uival = FindUIValueList(ppd_opt->uivalue, "CNUIAdjustTopBottomTrimNumDefault")) != NULL)
		ppd_opt->adjust_tbtrim_num = atof(tmp_uival->value);

	ppd_opt->pb_fin_fore_trim_num = 0.0;
	if((tmp_uival = FindUIValueList(ppd_opt->uivalue, "CNUIPBindFinForeTrimNumDefault")) != NULL)
		ppd_opt->pb_fin_fore_trim_num = atof(tmp_uival->value);
	ppd_opt->pb_fin_topbtm_trim_num = 0.0;
	if((tmp_uival = FindUIValueList(ppd_opt->uivalue, "CNUIPBindFinTopBottomTrimNumDefault")) != NULL)
		ppd_opt->pb_fin_topbtm_trim_num = atof(tmp_uival->value);

	return 0;
}




int AddOptionList(PPDOptions *ppd_opt, char *key, char *value)
{
	UIItemsList *item = ppd_opt->items_list, *tmp_list = NULL;
	UIOptionList *new_opt = NULL, *tmp_opt = NULL;

	if(key == NULL || value == NULL || item == NULL)
		return 1;

	if((tmp_list = FindItemsList(item, key)) == NULL)
		return 1;

	if((tmp_opt = tmp_list->opt_lists) != NULL){
		new_opt = (UIOptionList *)malloc(sizeof(UIOptionList));
		if(new_opt == NULL)
			return 1;
		memset(new_opt, 0, sizeof(UIOptionList));

		new_opt->name = strdup(value);
		new_opt->text = strdup(value);
		new_opt->next = NULL;

		while(1){
			if(tmp_opt->next == NULL)
				break;
			tmp_opt = tmp_opt->next;
		}
		tmp_opt->next = new_opt;
	}
	return 0;
}

int SetCustomPageSize(PPDOptions *ppd_opt)
{
	int opt_flag = 0;

	if(ppd_opt->custom_size){
		AddOptionList(ppd_opt, "PageSize", "Custom");

		AddUIValueList(ppd_opt, "CNPaperWidth", "0", opt_flag);
		AddUIValueList(ppd_opt, "CNPaperHeight", "0", opt_flag);

		if(FindItemsList(ppd_opt->items_list, kPPD_Items_CNPBindCoversheet) != NULL){
			AddOptionList(ppd_opt, kPPD_Items_CNPBindCoversheet, "Custom");

			AddUIValueList(ppd_opt, "CNBindCoverPaperWidth", "0", opt_flag);
			AddUIValueList(ppd_opt, "CNBindCoverPaperHeight", "0", opt_flag);
		}

		if(FindItemsList(ppd_opt->items_list, kPPD_Items_CNPBindMainPaper) != NULL){
			AddOptionList(ppd_opt, kPPD_Items_CNPBindMainPaper, "Custom");

			AddUIValueList(ppd_opt, "CNBindMainPaperWidth", "0", opt_flag);
			AddUIValueList(ppd_opt, "CNBindMainPaperHeight", "0", opt_flag);
		}

		if(FindItemsList(ppd_opt->items_list, kPPD_Items_CNPBindFinishing) != NULL){
			AddOptionList(ppd_opt, kPPD_Items_CNPBindFinishing, "Custom");

			AddUIValueList(ppd_opt, "CNBindFinPaperWidth", "0", opt_flag);
			AddUIValueList(ppd_opt, "CNBindFinPaperHeight", "0", opt_flag);
		}
	}else{
		DeleteUIValueList(ppd_opt, "CNUIMinWidth");
		DeleteUIValueList(ppd_opt, "CNUIMaxWidth");
		DeleteUIValueList(ppd_opt, "CNUIMinHeight");
		DeleteUIValueList(ppd_opt, "CNUIMaxHeight");
		DeleteUIValueList(ppd_opt, "CNUISizeUnit");
	}

	return 0;
}

int SetParamCustomPageSize(PPDOptions *ppd_opt, char *buff)
{
	char *ptr = NULL, kind[BUFSIZE], unit[BUFSIZE], min[BUFSIZE], max[BUFSIZE];
	char *t_ptr = NULL;

	if(buff == NULL)
		return 0;

	ptr = buff;
	t_ptr = kind;
	memset(kind, 0, BUFSIZE);
	while(1){
		if(*ptr == '\n' || *ptr == '\0')
			return 0;
		if(*ptr == ' ')
			ptr++;
		if(*ptr == ':')
			break;
		if(*ptr == 'O')
			return 0;
		if(t_ptr - kind == BUFSIZE - 1)
			return 0;
		*t_ptr = *ptr;
		t_ptr++;
		ptr++;
	}
	t_ptr = '\0';
	ptr++;

	while(1){
		if(*ptr == '\n' || *ptr == '\0')
			return 0;
		if(isalpha(*ptr))
			break;
		ptr++;
	}

	t_ptr = unit;
	memset(unit, 0, BUFSIZE);
	while(1){
		if(*ptr == '\n' || *ptr == '\0')
			return 0;
		if(*ptr == ' ')
			break;
		if(t_ptr - unit == BUFSIZE - 1)
			return 0;
		*t_ptr = *ptr;
		t_ptr++;
		ptr++;
	}
	t_ptr = '\0';
	ptr++;

	t_ptr = min;
	memset(min, 0, BUFSIZE);
	while(1){
		if(*ptr == '\n' || *ptr == '\0')
			return 0;
		if(*ptr == ' ')
			break;
		if(t_ptr - min == BUFSIZE - 1)
			return 0;
		*t_ptr = *ptr;
		t_ptr++;
		ptr++;
	}
	t_ptr = '\0';
	ptr++;

	t_ptr = max;
	memset(max, 0, BUFSIZE);
	while(1){
		if(*ptr == '\n' || *ptr == '\0')
			break;
		if(*ptr == ' ')
			break;
		if(t_ptr - max == BUFSIZE - 1)
			return 0;
		*t_ptr = *ptr;
		t_ptr++;
		ptr++;
	}
	t_ptr = '\0';

	if(strcasecmp(kind, "Width") == 0){
		AddUIValueList(ppd_opt, "CNUIMinWidth", min, 0);
		AddUIValueList(ppd_opt, "CNUIMaxWidth", max, 0);
	}else if(strcasecmp(kind, "Height") == 0){
		AddUIValueList(ppd_opt, "CNUIMinHeight", min, 0);
		AddUIValueList(ppd_opt, "CNUIMaxHeight", max, 0);
	}
	AddUIValueList(ppd_opt, "CNUISizeUnit", unit, 0);

	return 0;
}

int CheckCustomSize(cngplpData *data, float *width, float *height)
{
	float in_w = *width, in_h = *height;
	float max_w = 0.0, max_h = 0.0, min_w = 0.0, min_h = 0.0;
	char *tmp = NULL;

	if((tmp = GetUIValue(data, "CNUIMinWidth")) != NULL)
		min_w = atof(tmp);

	if((tmp = GetUIValue(data, "CNUIMaxWidth")) != NULL)
		max_w = atof(tmp);

	if((tmp = GetUIValue(data, "CNUIMinHeight")) != NULL)
		min_h = atof(tmp);

	if((tmp = GetUIValue(data, "CNUIMaxHeight")) != NULL)
		max_h = atof(tmp);

	if(min_w != 0 && min_w > in_w)
		in_w = min_w;

	if(max_w != 0 && max_w < in_w)
		in_w = max_w;

	if(min_h != 0 && min_h > in_h)
		in_h = min_h;

	if(max_h != 0 && max_h < in_h)
		in_h = max_h;

	*width = in_w;
	*height = in_h;

	return 0;
}

int GetCustomSize(char *value, float *width, float *height)
{
	char *v_ptr = NULL;
	char buff[BUFSIZE], *b_ptr = NULL;

	*width = 0.0;
	*height = 0.0;

	v_ptr = value;
	while(1){
		if(*v_ptr == '\0' || *v_ptr == '\n')
			return 0;
		if(*v_ptr == '.'){
			*v_ptr = '\0';
			break;
		}
		v_ptr++;
	}
	v_ptr++;

	memset(buff, 0, BUFSIZE);
	b_ptr = buff;
	while(1){
		if(*v_ptr == '\0' || *v_ptr == '\n')
			return 0;
		if(*v_ptr == 'x')
			break;
		if(b_ptr - buff == BUFSIZE - 1){
			v_ptr++;
			continue;
		}
		*b_ptr = *v_ptr;
		v_ptr++;
		b_ptr++;
	}
	*b_ptr = '\0';
	*width = atof(buff);
	v_ptr++;

	memset(buff, 0, BUFSIZE);
	b_ptr = buff;
	while(1){
		if(*v_ptr == '\0' || *v_ptr == '\n')
			break;
		if(b_ptr - buff == BUFSIZE - 1)
			break;
		*b_ptr = *v_ptr;
		v_ptr++;
		b_ptr++;
	}
	*b_ptr = '\0';
	*height = atof(buff);

	return 0;
}

int SetCustomSize(cngplpData *data, char *value)
{
	char size[BUFSIZE];
	float width = 0.0, height = 0.0;
	char *tmp = NULL;
	float prev_w = 0.0, prev_h = 0.0;

	if(data->ppd_opt->custom_size == 0)
		return 0;

	if(value == NULL)
		return 0;

	if(strstr(value, "Custom") != NULL){
		GetCustomSize(value, &width, &height);

		CheckCustomSize(data, &width, &height);

		if((tmp = GetUIValue(data, "CNPaperWidth")) != NULL)
			prev_w = atof(tmp);

		if((tmp = GetUIValue(data, "CNPaperHeight")) != NULL)
			prev_h = atof(tmp);

		if(width == prev_w && height == prev_h)
			return 1;

		memset(size, 0, BUFSIZE);
		snprintf(size, BUFSIZE - 1, "%.3f", width);
		UpdateUIValue(data, "CNPaperWidth", size);

		memset(size, 0, BUFSIZE);
		snprintf(size, BUFSIZE - 1, "%.3f", height);
		UpdateUIValue(data, "CNPaperHeight", size);
	}else{
		if((tmp = GetUIValue(data, "CNPaperWidth")) != NULL)
			prev_w = atof(tmp);
		if((tmp = GetUIValue(data, "CNPaperHeight")) != NULL)
			prev_h = atof(tmp);

		if(prev_w != 0.0 && prev_h != 0.0){
			UpdateUIValue(data, "CNPaperWidth", "0.0");
			UpdateUIValue(data, "CNPaperHeight", "0.0");
		}
	}
	return 0;
}


#define	CNCONF_INPUTSLOT_TYPE1		1
#define	CNCONF_INPUTSLOT_TYPE2		2
#define	CNCONF_INPUTSLOT_TYPE3		3
static void CheckInputSlotValue(cngplpData *data, char *item_name, char *opt_name, int flag)
{
	float width = 0.0, height = 0.0;
	float longedge = 0.0, shortedge = 0.0;
	int type = 0;
	char *ptr = NULL;


	if((ptr = GetUIValue(data, "CNUIConfInputSlot")) == NULL)
		ptr = "0";
	type = atoi(ptr);

	switch(type){
	case CNCONF_INPUTSLOT_TYPE1:
		if((ptr = GetUIValue(data, "CNPaperWidth")) == NULL)
			ptr = "595.0";
		width = atof(ptr);
		if((ptr = GetUIValue(data, "CNPaperHeight")) == NULL)
			ptr = "842.0";
		height = atof(ptr);

		longedge = (width <= height) ? height : width;
		shortedge = (longedge == height) ? width : height;

		if(strcmp(opt_name, "Cas1") == 0
	    || strcmp(opt_name, "Cas2") == 0
		|| strcmp(opt_name, "Cas3") == 0
		|| strcmp(opt_name, "Cas4") == 0
		|| strcmp(opt_name, "Auto") == 0){

			if(longedge >= 595.2 && longedge <= 842.0){
				if(shortedge >= 419.0 && shortedge < 595.2){
					MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "False", flag, width, height);
				}
				else{
					MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);
				}
			}
		}

		else if(strcmp(opt_name, "Manual") == 0){
			if(longedge >= 595.2 && longedge <= 842.0){
				MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);
			}
		}
		break;

	case CNCONF_INPUTSLOT_TYPE2:
	case CNCONF_INPUTSLOT_TYPE3:
		if((ptr = GetUIValue(data, "CNPaperWidth")) == NULL)
			ptr = "595.0";
		width = atof(ptr);
		if((ptr = GetUIValue(data, "CNPaperHeight")) == NULL)
			ptr = "842.0";
		height = atof(ptr);

		longedge = (width <= height) ? height : width;
		shortedge = (longedge == height) ? width : height;

		if(strcmp(opt_name, "Auto") == 0){
			if(360.0 <= longedge && longedge < 515.9){
				if(type == CNCONF_INPUTSLOT_TYPE3){
					if(216.0 <= shortedge && shortedge < 340.1){
						MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
					}
					else if(340.1 <= shortedge && shortedge <= 515.9){
						MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);
					}
				}
				else {
					if(216.0 <= shortedge && shortedge < 360.0){
						MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
					}
					else if(360.0 <= shortedge && shortedge <= 515.9){
						MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);
					}
				}
			}
			else if(515.9 <= longedge && longedge < 595.2){
				if(216.0 <= shortedge && shortedge < 515.9){
					MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
				}
				else if(515.9 <= shortedge && shortedge < 595.2){
					MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);
				}
			}
			else if(595.2 <= longedge && longedge <= 842.0){
				if(216.0 <= shortedge && shortedge < 419.5){
					MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
				}
				else if(419.5 <= shortedge && shortedge < 515.9){
				}
				else if(515.9 <= shortedge && shortedge < 595.2){
					MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "False", flag, width, height);
				}
				else if(595.2 <= shortedge && shortedge <= 842.0){
					MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);
				}
			}
			else {
				MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
			}
		}

		else if(strcmp(opt_name, "Manual") == 0){
			if(360.0 <= longedge && longedge < 515.9){
				if(type == CNCONF_INPUTSLOT_TYPE3){
					if(216.0 <= shortedge && shortedge < 340.1){
						MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
						MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
					}
					else if(340.1 <= shortedge && shortedge <= 515.9){
						MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
						MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);
					}
				}
				else {
					if(216.0 <= shortedge && shortedge < 360.0){
						MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
						MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
					}
					else if(360.0 <= shortedge && shortedge <= 515.9){
						MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
						MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);

					}
				}
			}
			else if(515.9 <= longedge && longedge <= 842.0){
				if(type == CNCONF_INPUTSLOT_TYPE3){
					if(216.0 <= shortedge && shortedge < 340.1){
						MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
						MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
					}
					else if(340.1 <= shortedge && shortedge < 419.5){
						MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
						MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);
					}
					else if(419.5 <= shortedge && shortedge < 842.0){
						MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);
					}
				}
				else {
					if(216.0 <= shortedge && shortedge < 360.0){
						MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
						MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
					}
					else if(360.0 <= shortedge && shortedge < 419.5){
						MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
						MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);

					}
					else if(419.5 <= shortedge && shortedge < 842.0){
						MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);
					}
				}
			}
			else if(842.0 < longedge && longedge <= 1224.0){
				if(216.0 <= shortedge && shortedge < 419.5){
					MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
					MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
				}
				else if(419.5 <= shortedge && shortedge <= 842.0){
					MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
				}
				else if(842.0 < shortedge && shortedge <= 907.1){
					MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
					MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
				}
			}
			else if(1224.0 < longedge && longedge <= 1296.0){
				if(216.0 <= shortedge && shortedge <= 907.1){
					MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
					MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
				}
			}
			else if(1296.0 < longedge && longedge <= 3401.0){
				if(595.2 <= shortedge && shortedge <= 842.0){
					MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
					MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
				}
			}
		}

		else if(strcmp(opt_name, "Cas1") == 0){
			if(515.9 <= longedge && longedge <= 842.0){
				if(283.4 <= shortedge && shortedge < 419.5){
					MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
					MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
				}
				else if(419.5 <= shortedge && shortedge < 515.9){
					MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
				}
				else if(515.9 <= shortedge && shortedge <= 842.0){
					MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);
				}
			}
			else if(842.0 < longedge && longedge <= 1224.0){
				if(283.4 <= shortedge && shortedge < 419.5){
					MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
					MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
				}
				else if(419.5 <= shortedge && shortedge <= 842.0){
					MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
				}
			}
		}

		else if(strcmp(opt_name, "Cas2") == 0
				|| strcmp(opt_name, "Cas3") == 0
				|| strcmp(opt_name, "Cas4") == 0){
			if(595.2 <= longedge && longedge <= 842.0){
				if(419.5 <= shortedge && shortedge < 515.9){
					MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
					MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "False", flag, width, height);
				}
				else if(515.9 <= shortedge && shortedge < 595.2){
					MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "False", flag, width, height);
				}
				else if(595.2 <= shortedge && shortedge <= 842.0){
					MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);
				}
			}
			else if(842.0 < longedge && longedge <= 1224.0){
				if(595.2 <= shortedge && shortedge <= 842.0){
					MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
				}
			}
		}
			break;

		default:
			break;
	}
}


#define	CNCONF_CNDUPLEX_TYPE1		1
#define	CNCONF_CNDUPLEX_TYPE2		2
static void CheckCNDuplexValue(cngplpData *data, char *item_name, char *opt_name, int flag)
{
	float width = 0.0, height = 0.0;
	float longedge = 0.0, shortedge = 0.0;
	int type = 0;
	char *ptr = NULL;


	if((ptr = GetUIValue(data, "CNUIConfCNDuplex")) == NULL)
		ptr = "0";
	type = atoi(ptr);

	switch(type){
	case CNCONF_CNDUPLEX_TYPE1:
		if(strcmp(opt_name, "True") == 0){
			if((ptr = GetUIValue(data, "CNPaperWidth")) == NULL)
				ptr = "595.0";
			width = atof(ptr);
			if((ptr = GetUIValue(data, "CNPaperHeight")) == NULL)
				ptr = "842.0";
			height = atof(ptr);

			longedge = (width <= height) ? height : width;
			shortedge = (longedge == height) ? width : height;

			if((longedge >= 595.2 && longedge <= 842.0) && (shortedge >= 419.0 && shortedge < 595.2)){
				MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "False", flag, width, height);
			}
		}
		break;
	case CNCONF_CNDUPLEX_TYPE2:
		if(strcmp(opt_name, "True") == 0){
			if((ptr = GetUIValue(data, "CNPaperWidth")) == NULL)
				ptr = "515.9";
			width = atof(ptr);
			if((ptr = GetUIValue(data, "CNPaperHeight")) == NULL)
				ptr = "842.0";
			height = atof(ptr);

			longedge = (width <= height) ? height : width;
			shortedge = (longedge == height) ? width : height;

			if((longedge >= 515.9 && longedge <= 842.0) && (shortedge >= 419.0 && shortedge < 515.9)){
				MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas2", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas3", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas4", flag);
			}
		}
		break;
	default:
		break;
	}
}


#define	CNCONF_CUSTOMSIZE_TYPE1	1
#define	CNCONF_CUSTOMSIZE_TYPE2	2
#define	CNCONF_CUSTOMSIZE_TYPE3	3
#define	CNCONF_CUSTOMSIZE_TYPE4	4
#define	CNCONF_CUSTOMSIZE_TYPE5	5
#define	CNCONF_CUSTOMSIZE_TYPE6	6
#define	CNCONF_CUSTOMSIZE_TYPE7	7
#define	CNCONF_CUSTOMSIZE_TYPE8	8
#define	CNCONF_CUSTOMSIZE_TYPE9	9
#define	CNCONF_CUSTOMSIZE_TYPE10 10
#define	CNCONF_CUSTOMSIZE_TYPE11 11
#define	CNCONF_CUSTOMSIZE_TYPE12 12
#define	CNCONF_CUSTOMSIZE_TYPE13 13
#define	CNCONF_CUSTOMSIZE_TYPE14 14
#define	CNCONF_CUSTOMSIZE_TYPE15 15
#define	CNCONF_CUSTOMSIZE_TYPE16 16
#define	CNCONF_CUSTOMSIZE_TYPE17 17
#define	CNCONF_CUSTOMSIZE_TYPE18 18
#define	CNCONF_CUSTOMSIZE_TYPE19 19

static void ChkCustomPageSize(cngplpData *data, char *item_name, char *opt_name, int flag)
{
	double width = 0.0, height = 0.0;
	double longedge = 0.0, shortedge = 0.0;
	int type = 0;
	char *ptr = NULL;
	double elongate_min_height = 0.0;


	if((ptr = GetUIValue(data, "CNPaperWidth")) == NULL)
		ptr = "595.0";
	width = atof(ptr);
	if((ptr = GetUIValue(data, "CNPaperHeight")) == NULL)
		ptr = "842.0";
	height = atof(ptr);

	if((ptr = GetUIValue(data, "CNUIConfCustomSize")) == NULL)
		ptr = "0";
	type = atoi(ptr);

	switch(type){
	case CNCONF_CUSTOMSIZE_TYPE1:
		if((width < 595.0 || width > 842.0)
		|| (height < 419.0 || height >1224.0)){
			if(data->ppd_opt->duplex_valtype == DUPLEX_VALTYPE_TRUE){
				MarkDisableOpt(data, "Duplex", "True", flag);
			}else{
				MarkDisableOpt(data, "Duplex", "DuplexTumble", flag);
				MarkDisableOpt(data, "Duplex", "DuplexNoTumble", flag);
			}
			MarkDisableOpt(data, "InputSlot", "Cas2", flag);
			MarkDisableOpt(data, "InputSlot", "Cas3", flag);
			MarkDisableOpt(data, "InputSlot", "Cas4", flag);
		}
		break;
	case CNCONF_CUSTOMSIZE_TYPE2:
		if((width < 297.638 || width > 864.568)
		|| (height < 515.906 || height >1296.001)){
			MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexFront", flag);
			MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexBack", flag);
		}
		break;
	case CNCONF_CUSTOMSIZE_TYPE3:
		if((width < 419.0 || width > 612.0)
		|| (height < 595.0 || height > 1008.0)){
			MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas1", flag);
			MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas2", flag);
		}
		break;
	case CNCONF_CUSTOMSIZE_TYPE4:
		longedge = (width <= height) ? height : width;
		shortedge = (longedge == height) ? width : height;

		MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas1", flag);

		if(longedge >= 595.2 && longedge <= 842.0){
			if(shortedge < 419.0 || shortedge > 842.0){
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas2", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas3", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas4", flag);
				MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
				MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
			}
			else{
				MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);
			}
		}
		else if(longedge > 842.0 && longedge <= 1224.0){
			if(shortedge < 595.2 || shortedge > 842.0){
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas2", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas3", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas4", flag);
				MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
			}
			MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
		}
		else{
			MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas2", flag);
			MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas3", flag);
			MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas4", flag);
			MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
			MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
			if(longedge > 1296.0){
				MarkDisableOpt(data, kPPD_Items_Resolution, "1200", flag);
			}
		}
		break;
	case CNCONF_CUSTOMSIZE_TYPE5:
		if((ptr = GetUIValue(data, "CNElongateMinHeight")) != NULL){
			elongate_min_height = atof(ptr);
			if(height >= elongate_min_height){
				MarkDisableOpt(data, kPPD_Items_CNColorMode, "color", flag);
			}
		}
		break;
	case CNCONF_CUSTOMSIZE_TYPE6:
		if((ptr = GetUIValue(data, "CNElongateMinHeight")) != NULL){
			elongate_min_height = atof(ptr);
			if(height >= elongate_min_height){
				MarkDisableOpt(data, kPPD_Items_CNColorMode, "color", flag);
				MarkDisableOpt(data, kPPD_Items_Resolution, "1200", flag);
				MarkDisableOpt(data, kPPD_Items_CNOverlay, "ClearCoatingEntirePage", flag);
				MarkDisableOpt(data, kPPD_Items_CNOverlay, "ClearCoatingForm", flag);
			}
		}
		break;
	case CNCONF_CUSTOMSIZE_TYPE7:
		if((width < 297.638 || width > 864.568)
		   || (height < 515.906 || height >1296.001)){
			MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexFront", flag);
			MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexBack", flag);
		}
		if((ptr = GetUIValue(data, "CNElongateMinHeight")) != NULL){
			elongate_min_height = atof(ptr);
			if(height >= elongate_min_height){
				MarkDisableOpt(data, kPPD_Items_Resolution, "1200", flag);
			}
		}
		break;
	case CNCONF_CUSTOMSIZE_TYPE8:
		if((width < 515.906 || width > 936.001)
		|| (height < 515.906 || height >1382.458)){
			MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexFront", flag);
			MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexBack", flag);
		}
		break;
	case CNCONF_CUSTOMSIZE_TYPE9:
		if((width < 419.528 || width > 884.409)
		   || (height < 595.276 || height > 1224.000)){
			MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexFront", flag);
			MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexBack", flag);
		}
		if((ptr = GetUIValue(data, "CNElongateMinHeight")) != NULL){
			elongate_min_height = atof(ptr);
			if(height >= elongate_min_height){
				MarkDisableOpt(data, kPPD_Items_Resolution, "1200", flag);
				MarkDisableOpt(data, kPPD_Items_CNStaple, "True", flag);
			}
		}
		break;

	case CNCONF_CUSTOMSIZE_TYPE10:
		if((width >= 216.0 && width < 419.5)
		|| (height >= 360.0 && height < 595.2)){
			MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas1", flag);
			MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas2", flag);
		}
		break;
	case CNCONF_CUSTOMSIZE_TYPE11:
		if((ptr = GetUIValue(data, "CNElongateMinHeight")) != NULL){
			elongate_min_height = atof(ptr);
			if(height >= elongate_min_height){
				MarkDisableOpt(data, kPPD_Items_Resolution, "1200", flag);
				MarkDisableOpt(data, kPPD_Items_CNOverlay, "ClearCoatingEntirePage", flag);
				MarkDisableOpt(data, kPPD_Items_CNOverlay, "ClearCoatingForm", flag);
			}
		}
		break;
		case CNCONF_CUSTOMSIZE_TYPE12:
			if((width < 283.4 || width > 612.0) || (height < 419.5 || height > 1008.0)){
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas1", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas2", flag);
			}
			break;
		case CNCONF_CUSTOMSIZE_TYPE13:
			longedge = (width <= height) ? height : width;
			shortedge = (longedge == height) ? width : height;

			if(( 595.2 <= longedge && longedge <= 842.0) && ( 419.5 <= shortedge && shortedge <= 842.0)){
				MarkDisableFeedCustom(data, kPPD_Items_CNFeedCustomHorizontally, "Both", flag, width, height);
			}
			else if(( 842.0 < longedge && longedge <= 1224.0) && ( 595.2 <= shortedge && shortedge <= 842.0)){
				MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
			}
			else{
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas1", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas2", flag);
				MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
				MarkDisableOpt(data, kPPD_Items_CNFeedCustomHorizontally, "True", flag);
			}
			break;
		case CNCONF_CUSTOMSIZE_TYPE14:
			longedge = (width <= height) ? height : width;
			shortedge = (longedge == height) ? width : height;

			if((595.2 <= shortedge && shortedge <= 842.0) && (595.2 <= longedge && longedge <= 1224.0)){
			}
			else if((419.5 <= shortedge && shortedge < 515.9) && (595.2 <= longedge && longedge <= 842.0)){
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Auto", flag);
			}
			else if((515.9 <= shortedge && shortedge < 595.2) && (595.2 <= longedge && longedge <= 842.0)){
			}
			else if((419.5 <= shortedge && shortedge <= 842.0) && (515.9 <= longedge && longedge <= 1224.0)){
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas2", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas3", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas4", flag);
			}
			else if((283.4 <= shortedge && shortedge <= 842.0) && ( 515.9 <= longedge && longedge <= 1224.0)){
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas2", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas3", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas4", flag);
				MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
			}
			else if((216.0 <= shortedge && shortedge <= 907.1) && (360 <= longedge && longedge <= 1296)){
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas1", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas2", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas3", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas4", flag);
				MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
			}
			else if((595.2 <= shortedge && shortedge <= 842.0) && (1296.2 <= longedge && longedge <= 3401)){
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas1", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas2", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas3", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas4", flag);
				MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
				MarkDisableOpt(data, kPPD_Items_Resolution, "1200", flag);
				MarkDisableOpt(data, kPPD_Items_CNGradation, "High2", flag);
				MarkDisableOpt(data, kPPD_Items_MediaType, "Envelope", flag);
			}
			else{
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas1", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas2", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas3", flag);
				MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas4", flag);
				MarkDisableOpt(data, kPPD_Items_CNDuplex, "True", flag);
			}
			if(850.4 < shortedge){
				MarkDisableOpt(data, kPPD_Items_Resolution, "1200", flag);
			}
			break;
	case CNCONF_CUSTOMSIZE_TYPE15:
		if((ptr = GetUIValue(data, "CNElongateMinHeight")) != NULL){
			elongate_min_height = atof(ptr);
			if(height >= elongate_min_height){
				MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexFront", flag);
				MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexBack", flag);
				MarkDisableOpt(data, kPPD_Items_Resolution, "1200", flag);
				MarkDisableOpt(data, kPPD_Items_CNOverlay, "ClearCoatingEntirePage", flag);
				MarkDisableOpt(data, kPPD_Items_CNOverlay, "ClearCoatingForm", flag);
			}
		}
		break;
	case CNCONF_CUSTOMSIZE_TYPE16:
		if((216.0 <= width && width < 297.6) || (360.0 <= height && height < 419.5)){
			MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas1", flag);
			MarkDisableOpt(data, kPPD_Items_InputSlot, "Cas2", flag);
		}
		break;
	case CNCONF_CUSTOMSIZE_TYPE17:
		if((width < 419.528 || width > 842.0)
			   || (height < 515.906 || height > 1275.591)){
			MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexFront", flag);
			MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexBack", flag);
		}
		if(width > 850.393) {
			MarkDisableOpt(data, kPPD_Items_Resolution, "1200", flag);
		}
		break;

    case CNCONF_CUSTOMSIZE_TYPE18:

        if ( ( width  >= 216.000 && width  <   538.867 )  &&
             ( height >= 419.528 && height <= 1008.000))
        {
            MarkDisableOpt(data, kPPD_Items_CNOutputAdjustment, "False", flag);
        }
        else if ( ( width  >= 538.867 && width  <= 612.000 ) &&
                  ( height >= 419.528 && height <= 769.323 ))
        {
            MarkDisableOpt(data, kPPD_Items_CNOutputAdjustment, "False", flag);
        }
        else
        {
        }

        break;

    case CNCONF_CUSTOMSIZE_TYPE19:
        if( (width  < 419.528) || (width  >  841.890) ||
			(height < 595.276) || (height > 1224.000)
        ) {
			MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexFront", flag);
			MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexBack", flag);
        }
		if((ptr = GetUIValue(data, "CNElongateMinHeight")) != NULL){
			elongate_min_height = atof(ptr);
			if(height >= elongate_min_height){
				MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexFront", flag);
				MarkDisableOpt(data, kPPD_Items_CNDuplex, "DuplexBack", flag);
				MarkDisableOpt(data, kPPD_Items_MediaType, "ENVELOPE", flag);
				MarkDisableOpt(data, kPPD_Items_MediaType, "ENVELOPEH", flag);
				MarkDisableOpt(data, kPPD_Items_Resolution, "1200", flag);
			}
		}
		break;

	default:
		break;
	}
}


static int CheckDuplexValueType(PPDOptions *ppd_opt)
{
	UIItemsList *list = ppd_opt->items_list, *duplex_item = NULL;
	UIOptionList *opt = NULL;

	if((duplex_item = FindItemsList(list, "Duplex")) == NULL)
		return 0;

	if((opt = duplex_item->opt_lists) != NULL){
		while(1){
			if(strncmp(opt->name, "True", strlen(opt->name)) == 0){
				ppd_opt->duplex_valtype = DUPLEX_VALTYPE_TRUE;
				break;
			}
			if(strncmp(opt->name, "DuplexTumble", strlen(opt->name)) == 0){
				ppd_opt->duplex_valtype = DUPLEX_VALTYPE_TUMBLE;
				break;
			}
			if(opt->next == NULL)
				break;
			opt = opt->next;
		}
	}
	return 1;
}



int CheckCustomSize_bind(cngplpData *data, float width, float height, char *min_w_key, char *max_w_key, char *min_h_key, char *max_h_key)
{
	float max_w = 0.0, max_h = 0.0, min_w = 0.0, min_h = 0.0;
	char *tmp = NULL;
	int result = 0;

	if((tmp = GetUIValue(data, min_w_key)) != NULL)
		min_w = atof(tmp);

	if((tmp = GetUIValue(data, max_w_key)) != NULL)
		max_w = atof(tmp);

	if((tmp = GetUIValue(data, min_h_key)) != NULL)
		min_h = atof(tmp);

	if((tmp = GetUIValue(data, max_h_key)) != NULL)
		max_h = atof(tmp);

	if(min_w != 0 && min_w > width)
		result = 1;
	else if(max_w != 0 && max_w < width)
		result = 1;
	else if(min_h != 0 && min_h > height)
		result = 1;
	else if(max_h != 0 && max_h < height)
		result = 1;

	return result;
}

void UpdateBindCover(cngplpData *data, char *item_name, char *value)
{
	char new_val[BUFSIZE];
	char size[BUFSIZE];
	float width = 0.0, height = 0.0;
	char *tmp = NULL;
	float prev_w = 0.0, prev_h = 0.0;
	char w_key[BUFSIZE], h_key[BUFSIZE];
	char min_w_key[BUFSIZE], max_w_key[BUFSIZE], min_h_key[BUFSIZE], max_h_key[BUFSIZE];

	memset(new_val, 0, BUFSIZE);
	memset(w_key, 0, BUFSIZE);
	memset(h_key, 0, BUFSIZE);
	memset(min_w_key, 0, BUFSIZE);
	memset(max_w_key, 0, BUFSIZE);
	memset(min_h_key, 0, BUFSIZE);
	memset(max_h_key, 0, BUFSIZE);

	if(strcmp(item_name, kPPD_Items_CNPBindCoversheet) == 0){
		strncpy(w_key, "CNBindCoverPaperWidth", BUFSIZE - 1);
		strncpy(h_key, "CNBindCoverPaperHeight", BUFSIZE - 1);
		strncpy(min_w_key, "CNUIBindCoverMinWidth", BUFSIZE - 1);
		strncpy(max_w_key, "CNUIBindCoverMaxWidth", BUFSIZE - 1);
		strncpy(min_h_key, "CNUIBindCoverMinHeight", BUFSIZE - 1);
		strncpy(max_h_key, "CNUIBindCoverMaxHeight", BUFSIZE - 1);
	}else if(strcmp(item_name, kPPD_Items_CNPBindMainPaper) == 0){
		strncpy(w_key, "CNBindMainPaperWidth", BUFSIZE - 1);
		strncpy(h_key, "CNBindMainPaperHeight", BUFSIZE - 1);
		strncpy(min_w_key, "CNUIBindMainMinWidth", BUFSIZE - 1);
		strncpy(max_w_key, "CNUIBindMainMaxWidth", BUFSIZE - 1);
		strncpy(min_h_key, "CNUIBindMainMinHeight", BUFSIZE - 1);
		strncpy(max_h_key, "CNUIBindMainMaxHeight", BUFSIZE - 1);
	}else if(strcmp(item_name, kPPD_Items_CNPBindFinishing) == 0){
		strncpy(w_key, "CNBindFinPaperWidth", BUFSIZE - 1);
		strncpy(h_key, "CNBindFinPaperHeight", BUFSIZE - 1);
		strncpy(min_w_key, "CNUIBindFinMinWidth", BUFSIZE - 1);
		strncpy(max_w_key, "CNUIBindFinMaxWidth", BUFSIZE - 1);
		strncpy(min_h_key, "CNUIBindFinMinHeight", BUFSIZE - 1);
		strncpy(max_h_key, "CNUIBindFinMaxHeight", BUFSIZE - 1);
	}

	if(strstr(value, "Custom") != NULL){
		GetCustomSize(value, &width, &height);

		if(CheckCustomSize_bind(data, width, height, min_w_key, max_w_key, min_h_key, max_h_key) != 0){
			UIItemsList *item;

			item = FindItemsList(data->ppd_opt->items_list, item_name);
			if(item != NULL){
				strncpy(new_val, item->default_option, BUFSIZE - 1);

				UpdateUIValue(data, w_key, "0.0");
				UpdateUIValue(data, h_key, "0.0");
			}
		}else{
			strncpy(new_val, value, BUFSIZE - 1);
			memset(size, 0, BUFSIZE);
			snprintf(size, BUFSIZE - 1, "%.3f", width);
			UpdateUIValue(data, w_key, size);

			memset(size, 0, BUFSIZE);
			snprintf(size, BUFSIZE - 1, "%.3f", height);
			UpdateUIValue(data, h_key, size);
		}
	}else{
		strncpy(new_val, value, BUFSIZE - 1);
		if((tmp = GetUIValue(data, w_key)) != NULL)
			prev_w = atof(tmp);
		if((tmp = GetUIValue(data, h_key)) != NULL)
			prev_h = atof(tmp);

		if(prev_w != 0.0 && prev_h != 0.0){
			UpdateUIValue(data, w_key, "0.0");
			UpdateUIValue(data, h_key, "0.0");
		}
	}

	UpdatePPDData(data, item_name, new_val);
}


char *dev_option_list[] = {
	kPPD_Items_CNSrcOption,
	kPPD_Items_CNFinisher,
	kPPD_Items_CNPuncher,
	kPPD_Items_CNFolder,
	kPPD_Items_CNTrimmer,
	kPPD_Items_CNInsertUnit,
	kPPD_Items_CNTrayCSetting,
	kPPD_Items_CNSidePaperDeck,
	kPPD_Items_CNHardDisk,
	kPPD_Items_CNSpecID,
	kPPD_Items_CNTotalMemSize,
	kPPD_Items_CNDupUnit,
	kPPD_Items_CNEnableMultiInserter,
	kPPD_Items_CNCopyTray,
	kPPD_Items_CNFinTray,
	kPPD_Items_CNStacker,
	kPPD_Items_CNBinderOption,
	kPPD_Items_CNOptionStaple,
	kPPD_Items_CNFAXNumOfLine,
	kPPD_Items_CNFAXDialLine1,
	kPPD_Items_CNFAXDialLine2,
	kPPD_Items_CNFAXDialLine3,
	kPPD_Items_CNFAXDialLine4,
	kPPD_Items_CNProPuncher,
	kPPD_Items_CNTopBottomTrimmer,
	kPPD_Items_CNSaddleUnit,
	kPPD_Items_CNInnerTrimmer,
	kPPD_Items_CNUserSeparateMode,
	kPPD_Items_CNUseSecuredPrint,
	kPPD_Items_CNEnableCMSSettings,
	kPPD_Items_CNUseJobAccount,
	kPPD_Items_CNUseUsrManagement,
	NULL
};

static int CheckAllDevOptionElm(UIItemsList *list, UIExtConfList *ext)
{
	UIConstList *tmp_cons_list;
	int idx;

	if(ext->other_elem == NULL)
		return 1;

	if(!CheckUIConfOtherElem(list, ext)){
		tmp_cons_list = ext->other_elem;
		while(tmp_cons_list != NULL){
			for(idx = 0; dev_option_list[idx] != NULL; idx++){
				if(strcmp(tmp_cons_list->key, dev_option_list[idx]) == 0)
					break;
			}
			if(dev_option_list[idx] == NULL)
				return 0;
			tmp_cons_list = tmp_cons_list->next;
		}
	}
	else{
		return 0;
	}

	return 1;
}

static int getDevOptionDisableCount(PPDOptions *ppd_opt, char *key, char *value)
{
	int disable = 0;
	UIItemsList *item;
	UIConstList *tmp_cons_list;
	UIExtConfList *temp_uiconf_list;
	int idx = 0;

	for(idx = 0; dev_option_list[idx] != NULL; idx++){
		item = FindItemsList(ppd_opt->items_list, dev_option_list[idx]);
		if(item == NULL)
			continue;

		tmp_cons_list = item->current_option->uiconst;
		while(tmp_cons_list != NULL){
			if((strcmp(tmp_cons_list->key, key) == 0) && (strcmp(tmp_cons_list->option, value) == 0)){
				disable++;
			}
			tmp_cons_list = tmp_cons_list->next;
		}

		temp_uiconf_list = item->current_option->uiconf;
		while(temp_uiconf_list != NULL){

			tmp_cons_list = temp_uiconf_list->conf_elem;
			while(tmp_cons_list != NULL){
				if(strcmp(tmp_cons_list->key, key) == 0){
					if((strcmp(tmp_cons_list->option, value) == 0) || (strcmp(tmp_cons_list->option, "###") == 0)){
						if(CheckAllDevOptionElm(ppd_opt->items_list, temp_uiconf_list))
							disable++;
					}
				}
				tmp_cons_list = tmp_cons_list->next;
			}

			temp_uiconf_list = temp_uiconf_list->next;
		}
	}

	return disable;
}

static char* MakeDevOptConfList(cngplpData *data, int id)
{
	char *glist = NULL;
	char tmp[256];
	UIItemsList *item;
	UIOptionList *tmp_opt_list;
	char *item_name;
	int disable = 0;

	item_name = IDtoPPDOption(id - 1);
	if(item_name == NULL)
		return NULL;

	item = FindItemsList(data->ppd_opt->items_list, item_name);
	if(item == NULL)
		return NULL;

	tmp_opt_list = item->opt_lists;
	while(1){
		if(tmp_opt_list->disable > 0)
		{
			disable = getDevOptionDisableCount(data->ppd_opt, item_name, tmp_opt_list->name);
			snprintf(tmp, 255, "%s<%d>", tmp_opt_list->name, disable);
		}
		else {
			snprintf(tmp, 255, "%s<%d>", tmp_opt_list->name, 0);
		}
		glist = (char*)AddList(glist, tmp);

		if(tmp_opt_list->next == NULL)
			break;
		tmp_opt_list = tmp_opt_list->next;
	}

	return glist;
}

static char* MakeCNMediaBrandDevOptConfList(cngplpData *data, int id, char *media_type)
{
	int             disable = 0;
	char            *glist = NULL;
	char            buf[BUFSIZE];

	MediaBrandList  *tmp_item;
    UIOptionList    *tmp_opt;

	if(data->ppd_opt->media_brand == NULL ||
       data->ppd_opt->media_brand->brand_list == NULL ||
       media_type == NULL)
    {
		return NULL;
    }

	tmp_item = data->ppd_opt->media_brand->brand_list;

	while(tmp_item != NULL)
	{
        if(IS_USER_MEDIA_BRAND(tmp_item->id))
        {
            tmp_opt = GetMediaBrandMediaType(data->ppd_opt, media_type, tmp_item);
            if(tmp_opt != NULL)
            {
                disable = getDevOptionDisableCount(data->ppd_opt, media_type, tmp_opt->name);
            }
            else
            {
                disable = 0;
            }
        }
        else
        {
            disable = getDevOptionDisableCount(data->ppd_opt, media_type, tmp_item->name);
        }

        snprintf(buf, 255, "%s<%d>", tmp_item->name, disable);

        glist = AddList(glist, buf);

		tmp_item = tmp_item->next;
	}

	return glist;
}

static char* MakeCNPunchDevOptConfList(cngplpData *data, int id)
{
	char *glist = NULL;
	char tmp[256];
	UIItemsList *item;
	UIOptionList *tmp_opt_list;
	char *item_name;
	int disable = 0;

	item_name = IDtoPPDOption(id - 1);
	if(item_name == NULL)
		return NULL;

	item = FindItemsList(data->ppd_opt->items_list, item_name);
	if(item == NULL)
		return NULL;

	tmp_opt_list = item->opt_lists;
	while(1){

		if(strcmp(tmp_opt_list->name, "Left") == 0){
			if(tmp_opt_list->disable > 0)
			{
				disable = getDevOptionDisableCount(data->ppd_opt, item_name, tmp_opt_list->name);
				snprintf(tmp, 255, "%s<%d>", "True", disable);
			}
			else {
				snprintf(tmp, 255, "%s<%d>", "True", 0);
			}
			glist = (char*)AddList(glist, tmp);
		}
		else if(strcmp(tmp_opt_list->name, "None") == 0){
			snprintf(tmp, 255, "%s<%d>", "False", 0);
		}

		if(tmp_opt_list->next == NULL)
			break;
		tmp_opt_list = tmp_opt_list->next;
	}

	return glist;
}

char *MakeCNSaddleSettingDevOptConfList(cngplpData *data, int id)
{
	char *glist = NULL;
	char *tmp_glist = NULL;
	int disable;
	UIItemsList *item;
	char tmp[256];

	item = FindItemsList(data->ppd_opt->items_list, kPPD_Items_CNVfolding);
	if(item != NULL){
		disable = getDevOptionDisableCount(data->ppd_opt, kPPD_Items_CNVfolding, "True");
		snprintf(tmp, 255, "%s<%d>", "VFolding", disable);
		tmp_glist = AddList(tmp_glist, tmp);
	}

	item = FindItemsList(data->ppd_opt->items_list, kPPD_Items_CNSaddleStitch);
	if(item != NULL){
		disable = getDevOptionDisableCount(data->ppd_opt, kPPD_Items_CNSaddleStitch, "True");
		snprintf(tmp, 255, "%s<%d>", "SaddleStitch", disable);
		tmp_glist = AddList(tmp_glist, tmp);
	}

	item = FindItemsList(data->ppd_opt->items_list, kPPD_Items_CNVfoldingTrimming);
	if(item != NULL){
		disable = getDevOptionDisableCount(data->ppd_opt, kPPD_Items_CNVfoldingTrimming, "True");
		snprintf(tmp, 255, "%s<%d>", "VFoldingTrimming", disable);
		tmp_glist = AddList(tmp_glist, tmp);
	}

	item = FindItemsList(data->ppd_opt->items_list, kPPD_Items_CNTrimming);
	if(item != NULL){
		disable = getDevOptionDisableCount(data->ppd_opt, kPPD_Items_CNTrimming, "True");
		snprintf(tmp, 255, "%s<%d>", "Trimming", disable);
		tmp_glist = AddList(tmp_glist, tmp);
	}

	if(tmp_glist){
		disable = getDevOptionDisableCount(data->ppd_opt, kPPD_Items_CNSaddleStitch, "True");
		snprintf(tmp, 255, "%s<%d>", "Off", disable);
		glist = AddList(glist, tmp);
		glist = AddList(glist, tmp_glist);
	}

	MemFree(tmp_glist);

	return glist;
}

char* GetPPDDevOptionConflict(cngplpData *data, int id)
{
	switch(id){
	case ID_CNPUNCH:
		return MakeCNPunchDevOptConfList(data, id);
	case ID_CNSADDLESETTING:
		return MakeCNSaddleSettingDevOptConfList(data, id);
	default:
		return MakeDevOptConfList(data, id);
	}
}

char* GetPPDDevOptionConflict_DeviceInfo(cngplpData *data, int id)
{
	char *glist = NULL;
	char tmp[256];
	switch(id){
	case ID_DISABLE_JOBACCOUNT_BW:
		if(data->ppd_opt->special->show_disable_job_account_bw == 1){
			if(!isUseJobAccount(data->ppd_opt)){
				snprintf(tmp, 255, "%s<%d>", "True", 1);
				glist = (char*)AddList(glist, tmp);
				snprintf(tmp, 255, "%s<%d>", "False", 1);
				glist = (char*)AddList(glist, tmp);
			}else{
				snprintf(tmp, 255, "%s<%d>", "True", 0);
				glist = (char*)AddList(glist, tmp);
				snprintf(tmp, 255, "%s<%d>", "False", 0);
				glist = (char*)AddList(glist, tmp);
			}
		}else
			glist = NULL;
		break;

    case ID_CNMEDIABRANDLIST:
        glist =  MakeCNMediaBrandDevOptConfList(data, id,kPPD_Items_MediaType);
        break;
    case ID_CNINTERLEAFMEDIABRANDLIST:
        glist =  MakeCNMediaBrandDevOptConfList(data, id,kPPD_Items_CNInterleafMediaType);
        break;
    case ID_CNPBINDCOVERMEDIABRANDLIST:
        glist =  MakeCNMediaBrandDevOptConfList(data, id,kPPD_Items_CNPBindCoverMediaType);
        break;
    case ID_CNINSERTMEDIABRANDLIST:
        glist =  MakeCNMediaBrandDevOptConfList(data, id,kPPD_Items_MediaType);
        break;
	default:
		glist = NULL;
	}
	return glist;
}

int GetOptionDisableCount(PPDOptions *ppd_opt, char *conf_key, char *key, char *value)
{
	int disable = 0;
	UIItemsList *item;
	UIConstList *tmp_cons_list;
	UIExtConfList *temp_uiconf_list;

	item = FindItemsList(ppd_opt->items_list, conf_key);
	if(item == NULL)
		return 0;

	tmp_cons_list = item->current_option->uiconst;
	while(tmp_cons_list != NULL){
		if((strcmp(tmp_cons_list->key, key) == 0) && (strcmp(tmp_cons_list->option, value) == 0)){
			disable++;
		}
		tmp_cons_list = tmp_cons_list->next;
	}

	temp_uiconf_list = item->current_option->uiconf;
	while(temp_uiconf_list != NULL){

		tmp_cons_list = temp_uiconf_list->conf_elem;
		while(tmp_cons_list != NULL){
			if(strcmp(tmp_cons_list->key, key) == 0){
				if((strcmp(tmp_cons_list->option, value) == 0) || (strcmp(tmp_cons_list->option, "###") == 0)){
					if(!CheckUIConfOtherElem(ppd_opt->items_list, temp_uiconf_list))
						disable++;
				}
			}
			tmp_cons_list = tmp_cons_list->next;
		}

		temp_uiconf_list = temp_uiconf_list->next;
	}

	return disable;
}

static char* MakeFuncVerConfList(cngplpData *data, int id)
{
	char *glist = NULL;
	char tmp[256];
	UIItemsList *item;
	UIOptionList *tmp_opt_list;
	char *item_name;
	int disable = 0;

	item_name = IDtoPPDOption(id - 1);
	if(item_name == NULL)
		return NULL;

	item = FindItemsList(data->ppd_opt->items_list, item_name);
	if(item == NULL)
		return NULL;

	tmp_opt_list = item->opt_lists;
	while(1){
		if(tmp_opt_list->disable > 0)
		{
			disable = GetOptionDisableCount(data->ppd_opt, kPPD_Items_CNSpecID, item_name, tmp_opt_list->name);
			snprintf(tmp, 255, "%s<%d>", tmp_opt_list->name, disable);
		}
		else {
			snprintf(tmp, 255, "%s<%d>", tmp_opt_list->name, 0);
		}
		glist = (char*)AddList(glist, tmp);

		if(tmp_opt_list->next == NULL)
			break;
		tmp_opt_list = tmp_opt_list->next;
	}

	return glist;
}

char* GetPPDFuncVerConflict(cngplpData *data, int id)
{
	switch(id){
	default:
		return MakeFuncVerConfList(data, id);
	}
}
static int SetUIExtChgList(UIItemsList *list, UIConfList *cond, UIConfList *dis, UIConfList *curr)
{
	UIOptionList *tmp_opt = NULL;
	UIExtConfList *ext = NULL;
	UIConfList *tmp = NULL, *elem = NULL;

	if(cond == NULL || dis == NULL || curr == NULL)
		return 1;

	ext = (UIExtConfList *)malloc(sizeof(UIExtConfList));
	if(ext == NULL)
		return 1;
	ext->other_elem = NULL;
	ext->conf_elem = NULL;
	ext->next = NULL;

	tmp_opt = FindOptionList(list, curr->key, curr->option);
	if(tmp_opt == NULL)
		return 1;

	elem = (UIConfList *)malloc(sizeof(UIConfList));
	if(elem == NULL)
		return 1;
	memset(elem, 0, sizeof(UIConfList));

	tmp = cond;
	while(1){
		if(strcmp(curr->key, tmp->key) != 0
		|| strcmp(curr->option, tmp->option) != 0){
			elem->key = strdup(tmp->key);
			elem->option = strdup(tmp->option);
			elem->next = NULL;
			if(ext->other_elem == NULL){
				ext->other_elem = elem;
			}else{
				UIConfList *last = NULL;
				last = GetLastUIConfList(ext->other_elem);
				last->next = elem;
			}
			elem = NULL;
			elem = (UIConfList *)malloc(sizeof(UIConfList));
			if(elem == NULL)
				return 1;
			memset(elem, 0, sizeof(UIConfList));
		}
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
	}

	tmp = dis;
	while(1){
		elem->key = strdup(tmp->key);
		elem->option = strdup(tmp->option);
		elem->next = NULL;
		if(ext->conf_elem == NULL){
			ext->conf_elem = elem;
		}else{
			UIConfList *last = NULL;
			last = GetLastUIConfList(ext->conf_elem);
			last->next = elem;
		}
		elem = NULL;
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
		elem = (UIConfList *)malloc(sizeof(UIConfList));
		if(elem == NULL)
			return 1;
		memset(elem, 0, sizeof(UIConfList));
	}

	if(tmp_opt->uichg == NULL){
		tmp_opt->uichg = (UIExtChgList *)malloc(sizeof(UIExtChgList));
		memcpy(tmp_opt->uichg, ext, sizeof(UIExtChgList));
		free(ext);
	}else{
		UIExtChgList *uichg = tmp_opt->uichg;
		while(1){
			if(uichg->next == NULL)
				break;
			uichg = uichg->next;
		}
		uichg->next = ext;
	}

	return 0;
}

static int GetUIExtChgList(UIItemsList *list, char *buff)
{
	UIConfList *tmp = NULL;
	UIConfList *condition = NULL, *disabled = NULL;
	char *ptr = NULL;
	int i, cnt = 0;
	char str[MAXWORDSIZE], *ptr_s = NULL;
	ptr = buff;

	for(i = 0; i < MAXWORDSIZE - 1; i++){
		if(*ptr == ' '){
			ptr++;
			break;
		}else if(*ptr == '\n' || *ptr == '\0'){
			return 0;
		}
		ptr++;
	}

	memset(str, 0, MAXWORDSIZE);
	ptr_s = str;
	for(i = 0; i < MAXWORDSIZE - 1; i++){
		if(*ptr == ':'){
			ptr++;
			break;
		}else if(*ptr == '\n' || *ptr == '\0'){
			return 0;
		}
		*ptr_s = *ptr;
		ptr_s++;
		ptr++;
	}
	*ptr_s = '\0';

	if((condition = BuffToUIConfList(str)) == NULL)
		return 0;

	memset(str, 0, MAXWORDSIZE);
	ptr_s = str;
	for(i = 0; i < MAXWORDSIZE - 1; i++){
		if(*ptr == '\n' || *ptr == '\0'){
			break;
		}
		*ptr_s = *ptr;
		ptr_s++;
		ptr++;
	}
	*ptr_s = '\0';

	if((disabled = BuffToUIConfList(str)) == NULL){
		FreeUIConf(condition);
		return 0;
	}

	cnt = 0;
	tmp = condition;
	while(1){
		SetUIExtChgList(list, condition, disabled, tmp);
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
		cnt++;
	}

	FreeUIConf(condition);
	FreeUIConf(disabled);

	return 0;
}

int CheckUIChgOtherElem(UIItemsList *list, UIExtChgList *chg)
{
	UIChgList *other = NULL;

	if(chg->other_elem == NULL)
		return 0;

	other = chg->other_elem;
	while(1){
		char *curr;
		curr = FindCurrOpt(list, other->key);
		if(curr == NULL)
			return 1;
		if(strncmp(curr, other->option, max(strlen(curr), strlen(other->option))) != 0)
			return 1;
		if(other->next == NULL)
			break;
		other = other->next;
	}
	return 0;
}

static int UpdateDefault(cngplpData *data, UIExtChgList *ext)
{
	UIItemsList *list = data->ppd_opt->items_list;
	UIChgList *chg = NULL;

	if(ext->conf_elem == NULL)
		return 1;

	chg = ext->conf_elem;
	while(1){
		if(FindOptionList(list, chg->key, chg->option) != NULL){
			UpdatePPDData(data, chg->key, chg->option);
			AddUpdateOption(data, chg->key);
		}
		if(chg->next == NULL)
			break;
		chg = chg->next;
	}
	return 0;
}

int ChangeDefault(cngplpData *data, char *item_name, char *new_opt)
{
	UIItemsList *items_list = data->ppd_opt->items_list;
	UIOptionList *opt = NULL;
	UIExtChgList *ext = NULL;

	opt = FindOptionList(items_list, item_name, new_opt);
	if(opt == NULL)
		return 0;

	if(opt->uichg == NULL)
		return 0;

	ext = opt->uichg;
	while(1){
		if(!CheckUIChgOtherElem(items_list, ext)){
			UpdateDefault(data, ext);
		}
		if(ext->next == NULL)
			break;
		ext = ext->next;
	}

	return 0;
}
void UpdatePPDDataForCancel(cngplpData *data, char *item_name, char *new_opt)
{
	UIItemsList *list = data->ppd_opt->items_list;
	UIItemsList *opt_item;

	opt_item = FindItemsList(list, item_name);
	if(opt_item != NULL){
		if(new_opt){
			opt_item->new_option = strdup(new_opt);
		}else{
			opt_item->new_option = strdup(opt_item->default_option);
		}
		if(opt_item->current_option != NULL){
			ResetUIConst(data, item_name, opt_item->current_option->name);
			MarkDisable(data, item_name, opt_item->current_option->name, -1, 1);
		}
		UpdateCurrOption(opt_item);
		if(opt_item->current_option != NULL){
			SetUIConst(data, item_name, opt_item->current_option->name);
			MarkDisable(data, item_name, opt_item->current_option->name, 1, 1);
		}
	}
}

void UpdatePPDDataForDefault(cngplpData *data, char *item_name)
{
	UIItemsList *list = data->ppd_opt->items_list;
	UIItemsList *opt_item;

	opt_item = FindItemsList(list, item_name);
	if(opt_item != NULL){
		opt_item->new_option = strdup(opt_item->default_option);
		if(opt_item->current_option != NULL){
			ResetUIConst(data, item_name, opt_item->current_option->name);
			MarkDisable(data, item_name, opt_item->current_option->name, -1, 1);
		}
		UpdateCurrOption(opt_item);
		if(opt_item->current_option != NULL){
			SetUIConst(data, item_name, opt_item->current_option->name);
			MarkDisable(data, item_name, opt_item->current_option->name, 1, 1);
            ChangeDefault(data, item_name, opt_item->current_option->name);
		}
	}
}

int isUseJobAccount(PPDOptions *ppd_opt)
{
#ifndef __APPLE__
	return ppd_opt->special->job_account;
#else
	char *tmp_opt;
	char *tmp_opt2;
	tmp_opt = FindCurrOpt(ppd_opt->items_list,kPPD_Items_CNUseJobAccount);
	if(tmp_opt != NULL){
		if(strcmp(tmp_opt, "True") == 0){
			tmp_opt2 = FindCurrOpt(ppd_opt->items_list,kPPD_Items_CNPdeUseJobAccount);
			if(tmp_opt2 != NULL){
				if(strcmp(tmp_opt2, "False") == 0){
					return 0;
				}
			}
			tmp_opt2 = FindCurrOpt(ppd_opt->items_list,kPPD_Items_CNUsrManagement);
			if(tmp_opt2 != NULL){
				if(strcasecmp(tmp_opt2, "Dept") != 0){
					return 0;
				}
			}
			return 1;
		}
		else {
			return 0;
		}
	}
	return 0;
#endif
}

int isUseUserManagement(PPDOptions *ppd_opt)
{
	char *tmp_opt;

	tmp_opt = FindCurrOpt(ppd_opt->items_list,kPPD_Items_CNUsrManagement);
	if(tmp_opt != NULL){
		if(strcasecmp(tmp_opt, "User") == 0){
			return 1;
		}
	}
	return 0;
}

void SetDefaultOptIfAllOptConflict(cngplpData *data)
{
	UIItemsList *tmp_list = NULL;
	UIOptionList *tmp_opt = NULL;

	UIItemsList *items_list = data->ppd_opt->items_list;
	tmp_list = items_list;

	while(1){
		tmp_opt = tmp_list->opt_lists;
		while(1){
			if(tmp_opt->disable > 0){
				if(tmp_opt->next == NULL){
					tmp_list->current_option = FindOptionList(items_list, tmp_list->name, tmp_list->default_option);
					break;
				}else{
					tmp_opt = tmp_opt->next;
				}
			}else{
				break;
			}
		}
		if(tmp_list->next == NULL)
			break;
		tmp_list = tmp_list->next;
	}
}
