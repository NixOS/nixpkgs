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


#include <strings.h>
#include "checkbutton.h"

#define DEFAULT_USERID 100

void
on_checkbutton_toggled       (GtkToggleButton *togglebutton,
                                        gpointer         user_data)
{
	const CheckData *data = (CheckData *)user_data;
	if(TRUE == SigDisable()){
		if((data != NULL) && (data->toggle != NULL) && (data->untoggle != NULL)){
			if(TRUE == togglebutton->active){
				UpdateData(data->id, data->toggle);
			}else{
				UpdateData(data->id, data->untoggle);
			}
		}else{
			UpdateDataCheck(data->id, (int)togglebutton->active);
		}
	}
	SigEnable();
}

void ConnectCheckbuttonSignal(GladeXML *xml, cngplpData* data, gpointer *widget)
{
	GtkWidget *checkbutton;
	CheckData *user_data;
	SignalInfo *signal;
	ConditionInfo *condition;
	char *signal_name = NULL;
	char *id = NULL;
	WidgetInfo *widget_checkbutton = (WidgetInfo *)widget;

	user_data = (CheckData *)malloc(sizeof(CheckData));
	widget_checkbutton->data = user_data;
	if(user_data != NULL){
		memset(user_data, 0, sizeof(CheckData));
		user_data->toggle = NULL;
		user_data->untoggle = NULL;
		checkbutton = glade_xml_get_widget(xml, widget_checkbutton->name);
		if(checkbutton != NULL){
			signal = widget_checkbutton->signal_list;
			if(signal != NULL){
				signal_name = signal->name;
				condition = signal->condition;
				while(condition != NULL){
					id = condition->id;
					if(strcmp(condition->name, "True") == 0){
						user_data->toggle = condition->value;
					}
					if(strcmp(condition->name, "False") == 0){
						user_data->untoggle = condition->value;
					}
					condition = condition->next;
				}
				if(NULL == id){
					id = signal->id;
				}
				user_data->id = GetModID(id);
				if(signal_name != NULL){
					if(strcmp(signal_name, "toggled") == 0){
						g_signal_connect ((gpointer)checkbutton, "toggled", G_CALLBACK (on_checkbutton_toggled), user_data);
					}
				}
			}
		}
	}
}

void InitCheckbutton(GladeXML *xml, cngplpData* data, const gpointer *widget)
{
	WidgetInfo *widget_checkbutton = (WidgetInfo *)widget;
	PropInfo *prop_list = widget_checkbutton->prop_list;
	PropInfo *property = NULL;
	const char *text = NULL;
	if(prop_list != NULL){
		property = FindProperty(prop_list, "text");
	}
	if(property != NULL){
		text = NameToTextByName(property->res);
		if(text != NULL){
			SetButtonLabel(widget_checkbutton->name, text);
		}
	}
}

void CheckbuttonSpecialFunction(cngplpData* data, const char *widget_name)
{
	if(0 == strcmp(widget_name, "CreepUse_checkbutton")){
		char *opt = NULL, *opt1 = NULL;

		SetWidgetSensitive("hbox82", FALSE);
		opt = GetCurrOpt(data, ID_CNDISPLACEMENTCORRECTION, NULL);
		if(opt != NULL){
			if(0 == strcasecmp(opt, "Manual")){
				opt1 = GetCurrOpt(data, ID_CNCREEP, NULL);
				if(opt1 != NULL){
					if(0 == strcmp(opt1, "True")){
						SetWidgetSensitive("hbox82", TRUE);
					}
					memFree(opt1);
				}
			}
			memFree(opt);
		}
	}
	if((0 == strcmp(widget_name, "JobAccouting_checkbutton")) || (0 == strcmp(widget_name, "DisableJobAccountingBW_checkbutton"))){
		int user_id;
		gboolean active;
		gboolean active1;
		gboolean enable;

		user_id = GetCurrOptInt(ID_USERID, DEFAULT_USERID);
		enable = (user_id == 0) ? TRUE : FALSE;
		if(GetCurrOptInt(ID_SPECIAL_FUNC, 0) != 0){
			active = GetCurrOptInt(ID_JOBACCOUNT, 0);
			SetActiveCheckButton("JobAccouting_checkbutton", active);
			if(active != FALSE){
				active1 = GetCurrOptInt(ID_DISABLE_JOBACCOUNT_BW, 0);
				SetActiveCheckButton("DisableJobAccountingBW_checkbutton", active1);
			}else{
				UpdateDataInt(ID_DISABLE_JOBACCOUNT_BW, 0);
			}
			SetWidgetSensitive("DisableJobAccountingBW_checkbutton", active);
			SetWidgetSensitive("AllowPasswd_checkbutton", active);
			SetWidgetSensitive("JobAccount_button", active);
			if(FALSE == active){
				SetActiveCheckButton("DisableJobAccountingBW_checkbutton", active);
				SetActiveCheckButton("AllowPasswd_checkbutton", active);
			}
		}
		if(FALSE == enable){
			SetWidgetSensitive("JobAccouting_checkbutton", enable);
			SetWidgetSensitive("DisableJobAccountingBW_checkbutton", enable);
			SetWidgetSensitive("AllowPasswd_checkbutton", enable);
			SetWidgetSensitive("JobAccount_button", enable);
		}
	}
}
