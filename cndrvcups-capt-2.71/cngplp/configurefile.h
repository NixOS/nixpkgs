/*
 *  Print Dialog for Canon LIPS/PS/LIPSLX/UFR2/CAPT Printer.
 *  Copyright CANON INC. 2010
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


#ifndef _CONFIGUREFILE
#define _CONFIGUREFILE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef __cplusplus
extern "C" {
#endif

#define OK_BUTTON 0
#define CANCEL_BUTTON 1
#define RESTORE_BUTTON 2
#define SAVE_BUTTON 3
#define PRINT_BUTTON 4

typedef struct _prop_info{
	char *prop_name;
	char *value;
	char *id;
	char *res;
	char *def;
	struct _prop_info *next;
}PropInfo;

typedef struct _update_info{
	char *value;
	struct _update_info *next;
}UpdateInfo;

typedef struct _condition_info{
	char *name;
	char *id;
	char *value;
	char *widget;
	UpdateInfo *update;
	struct _condition_info *next;
}ConditionInfo;

typedef struct _signal_info{
	char *name;
	char *id;
	char *widget;
	ConditionInfo *condition;
	struct _signal_info *next;
}SignalInfo;

typedef struct _widget_info{
	char *name;
	char *type;
	char *func;
	PropInfo *prop_list;
	SignalInfo *signal_list;
	void *data;
	struct _widget_info *next;
}WidgetInfo;

typedef struct _conflict_info{
	char *widget;
        char *id;
        char *value;
	char *type;
        WidgetInfo *update_list;
        struct _conflict_info *next;
}ConflictInfo;

typedef struct _showwidget_info{
	char *name;
	struct _showwidget_info *next;
}ShowWidgetInfo;

typedef struct _key_info{
	char *name;
	char *value;
	char *type;
	struct _key_info *next;
}KeyInfo;

typedef struct _func_info{
	char *name;
	KeyInfo *func_id;
	KeyInfo *key_list;
	ShowWidgetInfo *show_widget_list;
	WidgetInfo *widget_list;
	ConflictInfo *conflict_list;
	struct _func_info *next;
}FuncInfo;

typedef struct _button_info{
	char *button_name;
	int type;
	char *value;
	struct _button_info *next;
}ButtonInfo;

typedef struct _special_info{
	char *name;
	int type;
	char *parent;
	int print;
	ButtonInfo *button_list;
	ConflictInfo *conflict_list;
	struct _special_info *next;
}SpecialInfo;

typedef struct _config_file{
	FuncInfo *func_list;
	SpecialInfo *special_list;
	FuncInfo *common_list;
}ConfigFile;

ConfigFile* ParseConfigureFile(const char *filename);
void FreeConfigfileData(ConfigFile* data);

#ifdef __cplusplus
}
#endif

#endif
