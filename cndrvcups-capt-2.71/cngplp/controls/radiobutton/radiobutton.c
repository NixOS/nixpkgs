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


#include <string.h>
#include <stdlib.h>
#include "radiobutton.h"

const gchar *g_dataname_button_name[] = {
	"EnterName_radiobutton",
	"UseFileName_radiobutton",
	NULL
};

const gchar *g_holdqueue_dataname_button_name[] =
{
	"HoldQueue_EnterName_RadioButton",
	"HoldQueue_UseFileName_RadioButton",
	NULL
};

void
on_radiobutton_toggled		(GtkToggleButton *togglebutton,
					gpointer	user_data)
{
	const RadioData *data = (RadioData *)user_data;
	if(data != NULL){
		if(TRUE == SigDisable()){
			if(TRUE == togglebutton->active){
				if(data->toggle != NULL){
					UpdateData(data->id, data->toggle);
				}
			}
			if(FALSE == togglebutton->active){
				if(data->untoggle != NULL){
					UpdateData(data->id, data->untoggle);
				}
			}
		}
		SigEnable();
	}
}

void ConnectRadiobuttonSignal(GladeXML *xml, cngplpData* data, gpointer *widget)
{
	GtkWidget *radiobutton;
	RadioData *user_data;
	SignalInfo *signal;
	ConditionInfo *condition;
	char *signal_name;
	char *id = NULL;
	WidgetInfo *widget_radiobutton = (WidgetInfo *)widget;

	user_data = (RadioData *)malloc(sizeof(RadioData));
	widget_radiobutton->data = user_data;
	if((widget_radiobutton != NULL) && (user_data != NULL) && (widget_radiobutton->name != NULL)){
		memset(user_data, 0, sizeof(RadioData));
		radiobutton = glade_xml_get_widget(xml, widget_radiobutton->name);
		if(radiobutton != NULL){
			signal = widget_radiobutton->signal_list;
			if(signal != NULL){
				signal_name = signal->name;
				condition = signal->condition;
				while(condition != NULL){
					id = condition->id;
					if(0 == strcmp(condition->name, "True")){
						user_data->toggle = condition->value;
					}
					if(0 == strcmp(condition->name, "False")){
						user_data->untoggle = condition->value;
					}
					condition = condition->next;
				}
				if(NULL == id){
					id = signal->id;
				}
				user_data->id = GetModID(id);
				if(signal_name != NULL){
					if(0 == strcmp(signal_name, "toggled")){
						g_signal_connect ((gpointer)radiobutton, "toggled", G_CALLBACK (on_radiobutton_toggled), user_data);
					}
				}
			}
		}
	}
}

void RadiobuttonSpecialFunction(cngplpData* data, const char *widget_name)
{
	if(0 == strcmp(widget_name, "UseFileName_radiobutton")){
		int data_name;
		data_name = GetCurrOptInt(ID_DATANAME, 0);
		if(data->file_name != NULL){
			SetWidgetSensitive(widget_name, TRUE);
		}else{
			SetWidgetSensitive(widget_name, FALSE);
			data_name = 0;
		}
		SetActiveRadioButton(g_dataname_button_name, data_name);
	}else if(0 == strcmp(widget_name, "HoldQueue_UseFileName_RadioButton")){
		int data_name_type;
		data_name_type = GetCurrOptInt(ID_HOLDQUEUE_DATANAME, 0);
		if(data->file_name != NULL){
			SetWidgetSensitive(widget_name, TRUE);
		}else{
			SetWidgetSensitive(widget_name, FALSE);
			data_name_type = 0;
		}
		SetActiveRadioButton(g_holdqueue_dataname_button_name, data_name_type);
	}
}
