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


#include <stdio.h>
#include <string.h>
#include "label.h"

#define LABEL_MAX	32
#define FLOAT_ZERO	0.005

void InitLabel(GladeXML *xml, cngplpData* data, const gpointer *widget)
{
	WidgetInfo *widget_label = (WidgetInfo *)widget;
	if((widget_label != NULL) && (widget_label->name != NULL)){
		PropInfo *prop_list = widget_label->prop_list;
		PropInfo *property = NULL;
		char label[LABEL_MAX];
		const char *text = NULL;
		char *value = NULL;
		int def_int = 0;
		int max_int = 0;
		int min_int = 0;
		double def_double = 0.0;
		double max_double = 0.0;
		double min_double = 0.0;
		int max_sign = 0;
		int min_sign = 0;
		int digit = -1;
		int id;

		property = FindProperty(prop_list, "digit");
		if(property != NULL){
			if(property->id != NULL){
				id = GetModID(property->id);
				if(-1 == id){
					value = GetCNUIValue(property->id);
				}else{
					value = GetCurrOpt(data, id, NULL);
				}
				if((value != NULL) && (0 == strcasecmp(value, "True"))){
					digit = 1;
				}else{
					digit = 0;
				}
				memFree(value);
			}else{
				if(0 == strcmp(property->value, "int")){
					digit = 0;
				}
				if(0 == strcmp(property->value, "double")){
					digit = 1;
				}
			}
		}
		property = FindProperty(prop_list, "max");
		if(property != NULL){
			max_sign = 1;
			if(digit == 0){
				def_int = atoi(property->def);
				id = GetModID(property->id);
				max_int = GetCurrOptInt(id, def_int);
				if((0 == max_int) && (0 < def_int)){
					max_int = def_int;
				}
			}else{
				def_double = atof(property->def);
				id = GetModID(property->id);
				max_double = GetCurrOptDouble(id, def_double);
				if((max_double < FLOAT_ZERO) && (def_double > FLOAT_ZERO)){
					max_double = def_double;
				}
			}
		}
		property = FindProperty(prop_list, "min");
		if(property != NULL){
			min_sign = 1;
			if(digit == 0){
				def_int = atoi(property->def);
				id = GetModID(property->id);
				min_int = GetCurrOptInt(id, def_int);
			}else{
				def_double = atof(property->def);
				id = GetModID(property->id);
				min_double = GetCurrOptDouble(id, def_double);
			}
		}
		property = FindProperty(prop_list, "text");
		if(property != NULL){
			if(-1 == digit){
				text = NameToTextByName(property->res);
				if(text != NULL){
					SetTextToLabel(widget_label->name, text);
				}
			}else{
				if(0 == digit){
					if(property->value != NULL){
						while(0 != strcmp(property->value, "int")){
							property = FindProperty(property->next, "text");
							if(NULL == property){
								return;
							}
						}
					}
					if((1 == min_sign) && (1 == max_sign)){
						text = NameToTextByName(property->res);
						if(text != NULL){
							snprintf(label, LABEL_MAX - 1, text, min_int, max_int);
							SetTextToLabel(widget_label->name, label);
						}
					}
					if((1 == min_sign) && (0 == max_sign)){
						text = NameToTextByName(property->res);
						if(text != NULL){
							snprintf(label, LABEL_MAX - 1, text, min_int);
							SetTextToLabel(widget_label->name, label);
						}
					}
					if((0 == min_sign) && (1 == max_sign)){
						text = NameToTextByName(property->res);
						if(text != NULL){
							snprintf(label, LABEL_MAX - 1, text, max_int);
							SetTextToLabel(widget_label->name, label);
						}
					}
				}
				if(1 == digit){
					if(property->value != NULL){
						while(0 != strcmp(property->value, "double")){
							property = FindProperty(property->next, "text");
							if(NULL == property){
								return;
							}
						}
					}
					if((1 == min_sign) && (1 == max_sign)){
						text = NameToTextByName(property->res);
						if(text != NULL){
							snprintf(label, LABEL_MAX - 1, text, min_double, max_double);
							SetTextToLabel(widget_label->name, label);
						}
					}
					if((1 == min_sign) && (0 == max_sign)){
						text = NameToTextByName(property->res);
						if(text != NULL){
							snprintf(label, LABEL_MAX - 1, text, min_double);
							SetTextToLabel(widget_label->name, label);
						}
					}
					if((0 == min_sign) && (1 == max_sign)){
						text = NameToTextByName(property->res);
						if(text != NULL){
							snprintf(label, LABEL_MAX - 1, text, max_double);
							SetTextToLabel(widget_label->name, label);
						}
					}
				}
			}
		}
	}
}
