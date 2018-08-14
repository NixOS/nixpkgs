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


#include <gdk/gdkkeysyms.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include "combo.h"

void
on_combo_entry_changed     (GtkEditable     *editable,
                                        gpointer         user_data)
{
	CombData *data;
	data = (CombData *)user_data;
	if(TRUE == SigDisable()){
		if((data != NULL) && (FALSE == data->mapped)){
			UpdateDataCombo(data->id, data->widget_name);
		}
	}
	SigEnable();
}

gboolean
on_combo_popwin_event	(GtkWidget     *widget,
                                        GdkEvent       *event,
                                        gpointer       user_data)
{
	CombData *data;
	data = (CombData *)user_data;
	if((data != NULL) && (event != NULL)){
		if(GDK_MAP == event->type){
			data->mapped = TRUE;
		}
		if(GDK_UNMAP == event->type){
			data->mapped = FALSE;
			if(TRUE == SigDisable()){
				UpdateDataCombo(data->id, data->widget_name);
			}
			SigEnable();
		}
	}
	return FALSE;
}

gboolean
on_combo_down_up_event   (GtkWidget     *widget,
                                      GdkEvent       *event,
                                        gpointer       user_data)
{
        CombData *data;
        data = (CombData *)user_data;
        if((data != NULL) && (event != NULL)){
		if((GDK_Down == event->key.keyval) || (GDK_KP_Down == event->key.keyval) ||
		   (GDK_Up == event->key.keyval) || (GDK_KP_Up == event->key.keyval)){
	                data->mapped = TRUE;
	                if(TRUE == SigDisable()){
	                        UpdateDataCombo(data->id, data->widget_name);
	                }
	                SigEnable();
	        }
        }
        return FALSE;
}

void ConnectComboSignal(GladeXML *xml, cngplpData* data, gpointer *widget)
{
	GtkWidget *combo;
	CombData *user_data;
	const gchar *comb_widget_name;
	SignalInfo *signal;
	char *signal_name;
	WidgetInfo *widget_combo = (WidgetInfo *)widget;

	if((widget_combo != NULL) && (widget_combo->name != NULL)){
		combo = glade_xml_get_widget(xml, widget_combo->name);
		user_data = (CombData * )malloc(sizeof(CombData));
		widget_combo->data = user_data;
		if((combo != NULL) && (GTK_COMBO(combo)->entry != NULL) && (user_data != NULL)){
			memset(user_data, 0, sizeof(CombData));
			comb_widget_name = gtk_widget_get_name(GTK_COMBO(combo)->entry);
			signal = widget_combo->signal_list;
			if(signal != NULL){
				user_data->id = GetModID(signal->id);
			}
			if(comb_widget_name != NULL){
				user_data->widget_name = strdup(comb_widget_name);
			}
			while(signal != NULL){
				signal_name = signal->name;
				if(signal_name != NULL){
					if(strcmp(signal_name, "changed") == 0){
						g_signal_connect ((gpointer)(GTK_COMBO(combo)->entry), "changed", G_CALLBACK (on_combo_entry_changed), user_data);
					}
					if(strcmp(signal_name, "event") == 0){
						gtk_signal_connect(GTK_OBJECT(GTK_COMBO(combo)->popwin), "event", GTK_SIGNAL_FUNC(on_combo_popwin_event), user_data);
					}
					if(strcmp(signal_name, "down-up") == 0){
						gtk_signal_connect((gpointer)(GTK_COMBO(combo)->entry), "event", GTK_SIGNAL_FUNC(on_combo_down_up_event), user_data);
					}
				}
				signal = signal->next;
			}
		}
	}
}

void ComboSpecialFunction(cngplpData *data, const char *widget_name)
{
	char *opt = NULL, *opt1 = NULL;
	if(0 == strcmp(widget_name, "SaddleSetting_combo")){
		SetWidgetSensitive("TrimWidth_hbox", FALSE);
		opt = GetCurrOpt(data, ID_CNADJUSTTRIM, NULL);
		if(opt != NULL){
			if(0 == strcasecmp(opt, "Manual")){
				opt1 = GetCurrOpt(data, ID_CNTRIMMING, NULL);
				if(opt1 != NULL){
					if(0 == strcmp(opt1, "True")){
						SetWidgetSensitive("TrimWidth_hbox", TRUE);
					}
					memFree(opt1);
				}
			}
			memFree(opt);
		}

	}
}
