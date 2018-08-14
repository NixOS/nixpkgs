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


#include <math.h>
#include <string.h>
#include <stdlib.h>
#include "spinbutton.h"

#define FLOAT_ZERO_VALUE 0.005

void
on_spinbutton_value_changed	(GtkSpinButton	*spinbutton,
					gpointer	user_data)
{
	const SpinData *data = (SpinData *)user_data;
	if(data != NULL){
		if(TRUE == SigDisable()){
			double value;
			value = GetSpinButtonValue(data->name);
			UpdateDataDouble(data->id, value);
		}
		SigEnable();
	}
}

void ConnectSpinbuttonSignal(GladeXML *xml, cngplpData* data, gpointer *widget)
{
	GtkWidget *spinbutton;
	SpinData *user_data;
	SignalInfo *signal;
	char *signal_name;
	WidgetInfo *widget_spinbutton = (WidgetInfo *)widget;

	user_data = (SpinData *)malloc(sizeof(SpinData));
	widget_spinbutton->data = user_data;
	if((widget_spinbutton != NULL) && (user_data != NULL) && (widget_spinbutton->name != NULL)){
		memset(user_data, 0, sizeof(SpinData));
		signal = widget_spinbutton->signal_list;
		if(signal != NULL){
			if(signal->id != NULL){
				user_data->id = GetModID(signal->id);
			}
			user_data->name = widget_spinbutton->name;
			spinbutton = glade_xml_get_widget(xml, widget_spinbutton->name);
			if(spinbutton != NULL){
				signal_name = signal->name;
				if(signal_name != NULL){
					if(0 == strcmp(signal_name, "value_changed")){
						g_signal_connect ((gpointer)spinbutton, "value_changed", G_CALLBACK (on_spinbutton_value_changed), user_data);
					}
				}
			}
		}
	}
}

void InitSpinbutton(GladeXML *xml, cngplpData* data, const gpointer *widget)
{
	WidgetInfo *widget_spinbutton = (WidgetInfo *)widget;
	if(widget_spinbutton != NULL){
		PropInfo *prop_list = widget_spinbutton->prop_list;
		PropInfo *property = NULL;
		GtkWidget *spinbutton = NULL;
		GtkObject *adj = NULL;
		double def_double = 0.0;
		double max_double = 0.0;
		double min_double = 0.0;
		int id = -1;
		int digit = 0;
		char *value = NULL;
		double val = 0.0;

		spinbutton = glade_xml_get_widget(xml, widget_spinbutton->name);
		if(spinbutton != NULL){
			property = FindProperty(prop_list, "text");
			if(property != NULL){
				def_double = atof(property->def);
				id = GetModID(property->id);
				val = GetCurrOptDouble(id, def_double);
			}

			property = FindProperty(prop_list, "digit");
			if(property != NULL){
				if(property->id != NULL){
					id = GetModID(property->id);
					if(id == -1){
						value = GetCNUIValue(property->id);
					}else{
						value = GetCurrOpt(data, id, NULL);
					}
					if((value != NULL) && (0 == strcasecmp(value, "True"))){
						if(property->value != NULL){
							digit = atoi(property->value);
							gtk_spin_button_set_digits(GTK_SPIN_BUTTON(spinbutton), digit);
							adj = GTK_OBJECT(gtk_spin_button_get_adjustment(GTK_SPIN_BUTTON(spinbutton)));
							GTK_ADJUSTMENT(adj)->step_increment = pow(0.1, digit);
							gtk_spin_button_set_adjustment(GTK_SPIN_BUTTON(spinbutton), GTK_ADJUSTMENT(adj));
						}
						memFree(value);
					}
				}else if(property->value != NULL){
					digit = atoi(property->value);
					if(digit > 0){
						gtk_spin_button_set_digits(GTK_SPIN_BUTTON(spinbutton), digit);
						adj = GTK_OBJECT(gtk_spin_button_get_adjustment(GTK_SPIN_BUTTON(spinbutton)));
						GTK_ADJUSTMENT(adj)->step_increment = pow(0.1, digit);
						gtk_spin_button_set_adjustment(GTK_SPIN_BUTTON(spinbutton), GTK_ADJUSTMENT(adj));
					}
				}
			}

			property = FindProperty(prop_list, "max");
			if(property != NULL){
				def_double = atof(property->def);
				id = GetModID(property->id);
				max_double = GetCurrOptDouble(id, def_double);
				if((max_double < FLOAT_ZERO_VALUE) && (def_double > FLOAT_ZERO_VALUE)){
					max_double = def_double;
				}
				adj = GTK_OBJECT(gtk_spin_button_get_adjustment(GTK_SPIN_BUTTON(spinbutton)));
				GTK_ADJUSTMENT(adj)->upper = max_double;
				gtk_spin_button_set_adjustment(GTK_SPIN_BUTTON(spinbutton), GTK_ADJUSTMENT(adj));
			}
			property = FindProperty(prop_list, "min");
			if(property != NULL){
				def_double = atof(property->def);
				id = GetModID(property->id);
				min_double = GetCurrOptDouble(id, def_double);
				adj = GTK_OBJECT(gtk_spin_button_get_adjustment(GTK_SPIN_BUTTON(spinbutton)));
				GTK_ADJUSTMENT(adj)->lower = min_double;
				gtk_spin_button_set_adjustment(GTK_SPIN_BUTTON(spinbutton), GTK_ADJUSTMENT(adj));
			}
			gtk_spin_button_set_value(GTK_SPIN_BUTTON(spinbutton), val);
		}
	}
}

void SpinbuttonSpecialFunction(cngplpData* data, const char *widget_name)
{
	char *opt = NULL, *opt1 = NULL;
	if(0 == strcmp(widget_name, "CorrectWidth_spinbutton")){
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
	if(0 == strcmp(widget_name, "TrimWidth_spinbutton")){
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
