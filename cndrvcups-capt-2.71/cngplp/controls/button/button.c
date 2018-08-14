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


#include "button.h"

void
on_button_clicked		(GtkButton	*button,
					gpointer	user_data)
{
	const ButtonData *data = (ButtonData *)user_data;
	if(data != NULL){
		ConditionInfo *condition = data->condition;
		if(data->showdialog != NULL){
			ShowDialog(data->showdialog, 0);
		}else{
			while(condition != NULL){
				char *method;
				method = GetCurrOpt(g_cngplp_data, data->id, NULL);
				if((method != NULL) && (strcmp(method, condition->name) == 0)){
					ShowDialog(condition->widget, 0);
					free(method);
					break;
				}
				condition = condition->next;
			}
		}
	}
}

void ConnectButtonSignal(GladeXML *xml, cngplpData* data, gpointer *widget)
{
	GtkWidget *button;
	ButtonData *user_data;
	SignalInfo *signal;
	ConditionInfo *condition;
	WidgetInfo *widget_button = (WidgetInfo *)widget;

	user_data = (ButtonData *)malloc(sizeof(ButtonData));
	widget_button->data = user_data;
	if(user_data != NULL){
		memset(user_data, 0, sizeof(ButtonData));
		button = glade_xml_get_widget(xml, widget_button->name);
		if(button != NULL){
			signal = widget_button->signal_list;
			if(signal != NULL){
				condition = signal->condition;
				if(signal->widget != NULL){
					user_data->showdialog = signal->widget;
					if(strcmp(signal->name, "clicked") == 0){
						g_signal_connect ((gpointer)button, "clicked", G_CALLBACK (on_button_clicked), user_data);
					}
				}else{
					if(condition != NULL){
						user_data->id = GetModID(condition->id);
						user_data->condition = condition;
						if(strcmp(signal->name, "clicked") == 0){
							g_signal_connect ((gpointer)button, "clicked", G_CALLBACK (on_button_clicked), user_data);
						}
					}else{
						user_data->showdialog = NULL;
						if(strcmp(signal->name, "clicked") == 0){
							g_signal_connect ((gpointer)button, "clicked", G_CALLBACK (on_button_clicked), user_data);
						}
					}
				}
			}
		}
	}
}
