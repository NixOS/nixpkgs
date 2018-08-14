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


#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#include "entry.h"

#define ENTRY_TEXT_MAX	128
#define ASCII_FLAG	0x80
#define TWO_BYTE_WORD	0x8F
#define TWO_BYTE	2
#define THREE_BYTE_WORD	0x40
#define THREE_BYTE	3

void CheckDigit(const char *entry_name)
{
	int num = 0;
	const gchar *tmp = NULL;

	if(entry_name != NULL){
		tmp = GetTextEntry(entry_name);
		num = strlen(tmp);

		if(num > 0){
			tmp += num - 1;
			if((tmp != NULL) && (0 == isdigit(*tmp))){
				num = num - 1;
			}
		}
		SetCursolPosition(entry_name, num);
	}
}

void CheckEnter(const char *entry_name, const char *digit, int length)
{
	gchar id[ENTRY_TEXT_MAX];
	const gchar* tmp = NULL;
	int num = 0, cnt = 0, i;
	int code = 0;
	int check_digit = 0;
	int flag = 0;

	if(entry_name == NULL){
		return;
	}

	code = UTF8;
	if((digit != NULL) && (0 == strcmp(digit, "True"))){
		check_digit = TRUE;
	}

	tmp = GetTextEntry(entry_name);
	num = strlen(tmp);
	for(i = 0; i < num; i++, cnt++){
		guchar ch = tmp[i];
		if(cnt >= length){
			break;
		}
		if((ch & ASCII_FLAG) != 0){
			flag = TRUE;
			cnt++;
			if(cnt >= length){
				break;
			}
			switch(code){
			case EUC:
				if(ch == TWO_BYTE_WORD){
					i += TWO_BYTE;
				}else{
					i++;
				}
				break;
			case UTF8:
				if((ch & THREE_BYTE_WORD) != 0){
					if((ch & (THREE_BYTE_WORD >> 1)) != 0){
						if((ch & (THREE_BYTE_WORD >> 2)) != 0){
							i += THREE_BYTE;
						}else{
							i += TWO_BYTE;
						}
					}else{
						i++;
					}
				}
				break;
			default:
				break;
			}
		}
	}
	if(check_digit == TRUE){
		if(flag == TRUE){
			if(strcmp(entry_name, "PassWd_entry") == 0){
				fprintf(stderr, "PassWord(Secured Print) is invalid value\n");
			}else if(strcmp(entry_name, "JobAccountID_entry") == 0){
				fprintf(stderr, "ID(JobAccount) is invalid value\n");
			}else if(strcmp(entry_name, "JobAccountPassWD_entry") == 0){
				fprintf(stderr, "PassWord(JobAccount) is invalid value\n");
			}
		}else{
			CheckDigit(entry_name);
		}
	}

	memset(id, 0, ENTRY_TEXT_MAX);
	strncpy(id, tmp, i);

	if(cnt >= length){
		SetTextEntry(entry_name, id);
		SetCursolPosition(entry_name, -1);
	}
}

gboolean
on_entry_focus_out_event	(GtkWidget	*widget,
					GdkEventFocus   *event,
					gpointer	user_data)
{
	EntryData *data;
	data = (EntryData *)user_data;
	if(data != NULL){
		if(TRUE == SigDisable()){
			const gchar *text = NULL;
			text = GetTextEntry(data->widget_name);
			if(text != NULL){
				UpdateData(data->id, text);
			}
		}
		SigEnable();
	}
	return FALSE;
}

void
on_entry_changed	(GtkEditable	*editable,
				gpointer	user_data)
{
	EntryData *data;
	data = (EntryData *)user_data;
	if(data != NULL){
		if(TRUE == SigDisable()){
			CheckEnter(data->widget_name, data->numeric, data->length);
		}
		SigEnable();
	}
}

void ConnectEntrySignal(GladeXML *xml, cngplpData* data, gpointer *widget)
{
	GtkWidget *entry;
	EntryData *user_data;
	SignalInfo *signal;
	PropInfo *property;
	int id, def;
	char *signal_name;
	WidgetInfo *widget_entry = (WidgetInfo *)widget;

	if((widget_entry != NULL) && (widget_entry->name != NULL)){
		entry = glade_xml_get_widget(xml, widget_entry->name);
		user_data = (EntryData * )malloc(sizeof(EntryData));
		widget_entry->data = user_data;
		if((entry != NULL) && (user_data != NULL)){
			memset(user_data, 0, sizeof(EntryData));
			user_data->widget_name = widget_entry->name;

			property = FindProperty(widget_entry->prop_list, "length");
			if(property != NULL){
				if(property->value != NULL){
					user_data->length = atoi(property->value);
				}else if(property->id != NULL){
					id = GetModID(property->id);
					def = atoi(property->def);
					user_data->length = GetCurrOptInt(id, def);
				}
			}
			property = FindProperty(widget_entry->prop_list, "numeric");
			if(property != NULL){
				user_data->numeric = property->value;
			}

			signal = widget_entry->signal_list;
			while(signal != NULL){
				signal_name = signal->name;
				user_data->id = GetModID(signal->id);
				if(signal_name != NULL){
					if(0 == strcmp(signal_name, "changed")){
						g_signal_connect ((gpointer)entry, "changed", G_CALLBACK (on_entry_changed), user_data);
					}
					if(0 == strcmp(signal_name, "focus_out_event")){
						g_signal_connect ((gpointer)entry, "focus_out_event", G_CALLBACK (on_entry_focus_out_event), user_data);
					}
				}
				signal = signal->next;
			}
		}
	}
}

void InitEntry(GladeXML *xml, cngplpData* data, const gpointer *widget)
{
	PropInfo *property = NULL;
	int id = 0;
	int def = 0,length = 0;
	char *text;
	WidgetInfo *widget_entry = (WidgetInfo *)widget;

	if((widget_entry != NULL) && (widget_entry->name != NULL)){
		property = FindProperty(widget_entry->prop_list, "length");
		if(property != NULL){
			if(property->value != NULL){
				length = atoi(property->value);
			}else if(property->id != NULL){
				id = GetModID(property->id);
				def = atoi(property->def);
				length = GetCurrOptInt(id, def);
			}
			SetTextMaxLength(widget_entry->name, length);
		}
		property = FindProperty(widget_entry->prop_list, "text");
		if(property != NULL){
			id = GetModID(property->id);
			text = GetCurrOpt(data, id, NULL);
			if(text != NULL){
				SetTextEntry(widget_entry->name, text);
				memFree(text);
			}
		}
	}
}

void EntrySpecialFunction(cngplpData* data, const char *widget_name)
{
	if(0 == strcmp(widget_name, "PassWd_entry")){
		SetEntryVisibility(widget_name);
	}
	if(0 == strcmp(widget_name, "JobAccountPassWD_entry")){
		SetEntryVisibility(widget_name);
	}
}

