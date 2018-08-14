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
#ifndef _OPAL
#include <cups/cups.h>
#endif

#include "cngplpdef.h"
#include "cupsoption.h"
#include "ppdoptions.h"


char *g_filter_options[] = {
	"None",
	"Image file options",
	"Text file options",
	"HP-GL/2 options",
	NULL
};

char *g_banner_option[] = {
	"none",
	"standard",
	"classified",
	"secret",
	"confidential",
	"topsecret",
	"unclassified",
	NULL
};

char *g_pageset_options[] = {
	"all",
	"odd",
	"even",
	"range",
	NULL,
};

char *g_position_options[] = {
	"top-left",
	"left",
	"bottom-left",
	"top",
	"center",
	"bottom",
	"top-right",
	"right",
	"bottom-right",
	NULL
};

CupsOptionTxtVal NupTextValue_table[] = {
	{"1 Page per Sheet", "1"},
	{"2 Page per Sheet", "2"},
	{"4 Page per Sheet", "4"},
	{"6 Page per Sheet", "6"},
	{"9 Page per Sheet", "9"},
	{"16 Page per Sheet", "16"},
	{NULL, NULL}
};

void FreeCupsOptVal(CupsOptVal *option)
{
	CupsOptVal *tmp = NULL;

	for(; option != NULL; option = tmp){
		tmp = option->next;

		MemFree(option->option);
		MemFree(option->value);
		free(option);
		option = NULL;
	}
}


void FreeCupsOptions(CupsOptions *cups_opt)
{
	if(cups_opt == NULL)
		return;

	if(cups_opt->image != NULL){
		FreeCupsOptVal(cups_opt->image->option);
		cups_opt->image->option = NULL;
		free(cups_opt->image);
		cups_opt->image = NULL;
	}

	if(cups_opt->text != NULL){
		FreeCupsOptVal(cups_opt->text->option);
		cups_opt->text->option = NULL;
		free(cups_opt->text);
		cups_opt->text = NULL;
	}

	if(cups_opt->hpgl != NULL){
		FreeCupsOptVal(cups_opt->hpgl->option);
		cups_opt->hpgl->option = NULL;
		free(cups_opt->hpgl);
		cups_opt->hpgl = NULL;
	}

	if(cups_opt->common != NULL){
		FreeCupsOptVal(cups_opt->common->option);
		cups_opt->common->option = NULL;
		free(cups_opt->common);
		cups_opt->common = NULL;
	}
	free(cups_opt);
}

CupsOptVal* GetCupsOptVal(CupsOptVal *option, char *key)
{
	CupsOptVal *tmp;
	tmp = option;
	while(1){
		if((strcasecmp(tmp->option, key)) == 0)
			return tmp;
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
	}
	return NULL;
}

char* GetCupsValue(CupsOptVal *option, char *key)
{
	CupsOptVal *tmp;
	tmp = GetCupsOptVal(option, key);

	if(tmp == NULL){
		return NULL;
	}else if(strcmp("number-up", key) == 0){
		int i;
		for(i = 0; NupTextValue_table[i].text != NULL; i++){
			if(strcmp(tmp->value, NupTextValue_table[i].value) == 0){
				return NupTextValue_table[i].text;
			}
		}
	}else{
		return tmp->value;
	}

	return NULL;
}

int SetCupsOption(cngplpData *data, CupsOptVal *option, char *key, char *value)
{
	CupsOptVal *tmp;

	if(option == NULL)
		return -1;
	if(key == NULL)
		return -1;
	if(value == NULL)
		return -1;

	tmp = option;
	while(1){
		if((strcasecmp(tmp->option, key)) == 0){
			if(strcasecmp(tmp->value, value) != 0){
				MemFree(tmp->value);
				tmp->value = strdup(value);
				AddUpdateOption(data, key);
				return 1;
			}
		}
		if(tmp->next == NULL)
			break;
		tmp = tmp->next;
	}

	return 0;
}

int AddCupsOption(CupsOptVal *option, char *key, char *value)
{
	int cnt = 1;
	CupsOptVal *tmp, *opt;

	if((opt = (CupsOptVal *)malloc(sizeof(CupsOptVal))) == NULL)
		return -1;

	memset(opt, 0, sizeof(CupsOptVal));

	opt->option = strdup(key);
	opt->value = strdup(value);

	opt->next = NULL;

	if(option->option == NULL){
		memcpy(option, opt, sizeof(CupsOptVal));
		free(opt);
	}else{
		tmp = option;
		while(1){
			if(tmp->next == NULL)
				break;
			tmp = tmp->next;
			cnt++;
		}
		tmp->next = opt;
	}
	return cnt;
}

void InitCupsCommonOptions(CupsCommonOptions *common)
{
	common->option = (CupsOptVal *)malloc(sizeof(CupsOptVal));
	memset(common->option, 0, sizeof(CupsOptVal));
	AddCupsOption(common->option, "CNCopies", "1");
	AddCupsOption(common->option, "page-set", "all");
#ifndef	__APPLE__
	AddCupsOption(common->option, "page-ranges", "1-");
#else
	AddCupsOption(common->option, "page-ranges", "");
#endif
	AddCupsOption(common->option, "outputorder", "normal");
	AddCupsOption(common->option, "number-up", "1");
	AddCupsOption(common->option, "orientation-requested", "3");
	AddCupsOption(common->option, "brightness", "100");
	AddCupsOption(common->option, "gamma", "1000");
	AddCupsOption(common->option, "job-sheets-start", "none");
	AddCupsOption(common->option, "job-sheets-end", "none");
	AddCupsOption(common->option, "Filter", "None");
}

void InitCupsImageOptions(CupsImageOptions *image)
{
	image->option = (CupsOptVal *)malloc(sizeof(CupsOptVal));
	memset(image->option, 0, sizeof(CupsOptVal));
	AddCupsOption(image->option, "hue", "0");
	AddCupsOption(image->option, "saturation", "100");
	AddCupsOption(image->option, "ppi", "128");
	AddCupsOption(image->option, "scaling", "100");
	AddCupsOption(image->option, "natural-scaling", "100");
	AddCupsOption(image->option, "position", "center");
	image->img_reso_scale = 0;
}

void InitCupsTextOptions(CupsTextOptions *text)
{

	text->option = (CupsOptVal *)malloc(sizeof(CupsOptVal));
	memset(text->option, 0, sizeof(CupsOptVal));
	AddCupsOption(text->option, "cpi", "10");
	AddCupsOption(text->option, "lpi", "6");
	AddCupsOption(text->option, "columns", "1");
	AddCupsOption(text->option, "page-left", "0");
	AddCupsOption(text->option, "page-right", "0");
	AddCupsOption(text->option, "page-top", "0");
	AddCupsOption(text->option, "page-bottom", "0");
	AddCupsOption(text->option, "prettyprint", "false");
	text->margin_on = 0;
	text->margin_unit = 0;
}

void InitCupsHPGLOptions(CupsHPGLOptions *hpgl)
{
	hpgl->option = (CupsOptVal *)malloc(sizeof(CupsOptVal));
	memset(hpgl->option, 0, sizeof(CupsOptVal));
	AddCupsOption(hpgl->option, "blackplot", "false");
	AddCupsOption(hpgl->option, "fitplot", "false");
	AddCupsOption(hpgl->option, "penwidth", "1000");
}

void InitCupsOptions(CupsOptions *cups_opt)
{
	InitCupsCommonOptions(cups_opt->common);
	InitCupsImageOptions(cups_opt->image);
	InitCupsTextOptions(cups_opt->text);
	InitCupsHPGLOptions(cups_opt->hpgl);
}

void ResetCupsCommonOptions(cngplpData *data)
{
	CupsCommonOptions *common = data->cups_opt->common;
	SetCupsOption(data, common->option, "number-up", "1");
	SetCupsOption(data, common->option, "orientation-requested", "3");
	SetCupsOption(data, common->option, "brightness", "100");
	SetCupsOption(data, common->option, "gamma", "1000");
	SetCupsOption(data, common->option, "job-sheets-start", "none");
	SetCupsOption(data, common->option, "job-sheets-end", "none");
	SetCupsOption(data, common->option, "Filter", "None");
}

void ResetCupsImageOptions(cngplpData *data)
{
	CupsImageOptions *image = data->cups_opt->image;
	SetCupsOption(data, image->option, "hue", "0");
	SetCupsOption(data, image->option, "saturation", "100");
	SetCupsOption(data, image->option, "ppi", "128");
	SetCupsOption(data, image->option, "scaling", "100");
	SetCupsOption(data, image->option, "natural-scaling", "100");
	SetCupsOption(data, image->option, "position", "center");
	image->img_reso_scale = 0;
}

void ResetCupsTextOptions(cngplpData *data)
{
	CupsTextOptions *text = data->cups_opt->text;
	SetCupsOption(data, text->option, "cpi", "10");
	SetCupsOption(data, text->option, "lpi", "6");
	SetCupsOption(data, text->option, "columns", "1");
	SetCupsOption(data, text->option, "page-left", "0");
	SetCupsOption(data, text->option, "page-right", "0");
	SetCupsOption(data, text->option, "page-top", "0");
	SetCupsOption(data, text->option, "page-bottom", "0");
	SetCupsOption(data, text->option, "prettyprint", "false");
	text->margin_on = 0;
	text->margin_unit = 0;
}


void ResetCupsHPGLOptions(cngplpData *data)
{
	CupsHPGLOptions *hpgl = data->cups_opt->hpgl;
	SetCupsOption(data, hpgl->option, "blackplot", "false");
	SetCupsOption(data, hpgl->option, "fitplot", "false");
	SetCupsOption(data, hpgl->option, "penwidth", "1000");
}

void ResetCupsOptions(cngplpData *data)
{
	ResetCupsCommonOptions(data);
	ResetCupsImageOptions(data);
	ResetCupsTextOptions(data);
	ResetCupsHPGLOptions(data);
}

int CreateCupsOptions(cngplpData *data)
{
	CupsOptions *cups_opt = data->cups_opt;

        cups_opt->common = (CupsCommonOptions *)malloc(sizeof(CupsCommonOptions));
        if(cups_opt->common == NULL){
                FreeCupsOptions(cups_opt);
                return -1;
	}
	memset(cups_opt->common, 0, sizeof(CupsCommonOptions));
        cups_opt->image = (CupsImageOptions *)malloc(sizeof(CupsImageOptions));
        if(cups_opt->image == NULL){
                FreeCupsOptions(cups_opt);
                return -1;
	}
	memset(cups_opt->image, 0, sizeof(CupsImageOptions));
        cups_opt->text = (CupsTextOptions *)malloc(sizeof(CupsTextOptions));
        if(cups_opt->text == NULL){
                FreeCupsOptions(cups_opt);
                return -1;
	}
	memset(cups_opt->text, 0, sizeof(CupsTextOptions));
        cups_opt->hpgl = (CupsHPGLOptions *)malloc(sizeof(CupsHPGLOptions));
        if(cups_opt->hpgl == NULL){
                FreeCupsOptions(cups_opt);
                return -1;
	}
	memset(cups_opt->hpgl, 0, sizeof(CupsHPGLOptions));
	InitCupsOptions(cups_opt);
	return 0;
}

void DeleteCupsOptions(CupsOptions *cups_opt)
{
        FreeCupsOptions(cups_opt);
}




