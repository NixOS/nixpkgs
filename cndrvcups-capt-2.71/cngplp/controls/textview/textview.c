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


#include <stdlib.h>
#include <string.h>
#include "textview.h"

#define TEXTVIEW_TEXT_MAX 	256
#define TEXTVIEW_ASCII_FLAG	0x80
#define TEXTVIEW_TWO_BYTE_WORD	0x8F
#define TEXTVIEW_TWO_BYTE	2
#define TEXTVIEW_THREE_BYTE_WORD 0x40
#define TEXTVIEW_THREE_BYTE	3

void CheckTextView(const char *textview_name, const int length)
{
	gchar ID[TEXTVIEW_TEXT_MAX], *tmp = NULL;
	int num = 0, cnt = 0, i = 0;
	int code = 0;
	if(NULL ==textview_name){
		return;
	}

	code = UTF8;
	tmp = GetTextofTextView(textview_name);
	num = strlen(tmp);
	if(0 == code){
		if(length <= num){
			SetTextofTextView(textview_name, tmp, length);
		}
		return;
	}

	for(i = 0; i < num; i++, cnt++){
		guchar ch = tmp[i];
		if(length <= cnt){
			break;
		}
		if((ch & TEXTVIEW_ASCII_FLAG) != 0){
			cnt++;
			if(length <= cnt)
				break;
			switch(code){
			case EUC:
				if(ch == TEXTVIEW_TWO_BYTE_WORD){
					i += TEXTVIEW_TWO_BYTE;
				}else{
					i++;
				}
				break;
			case UTF8:
				if((ch & TEXTVIEW_THREE_BYTE_WORD) != 0){
					if((ch & (TEXTVIEW_THREE_BYTE_WORD >> 1)) != 0){
						if((ch & (TEXTVIEW_THREE_BYTE_WORD >> 2)) != 0){
							i += TEXTVIEW_THREE_BYTE;
						}else{
							i += TEXTVIEW_TWO_BYTE;
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
	memset(ID, 0, TEXTVIEW_TEXT_MAX);
	strncpy(ID, tmp, i);

	if(length <= cnt){
		SetTextofTextView(textview_name, ID, -1);
	}
}

gboolean
on_textview_focus_out_event	(GtkWidget	*widget,
					GdkEventFocus	*event,
					gpointer	user_data)
{
	TextViewData *data;
	data = (TextViewData *)user_data;
	if(data != NULL){
		if(TRUE == SigDisable()){
			gchar *text;
			text = GetTextofTextView(data->widget_name);
			if(text != NULL){
				UpdateData(data->id, text);
			}
		}
		SigEnable();
	}
	return FALSE;
}

void on_textbuffer_changed	(GtkTextBuffer	*textbuffer,
					gpointer	user_data)
{
	TextViewData *data;
	data = (TextViewData *)user_data;
	if(data != NULL){
		if(TRUE == SigDisable()){
			CheckTextView(data->widget_name, data->length);
		}
		SigEnable();
	}
}

void ConnectTextviewSignal(GladeXML *xml, cngplpData* data, gpointer *widget)
{
	GtkTextView *textview;
	TextViewData *user_data;
	SignalInfo *signal;
	PropInfo *property;
	char *signal_name;
	GtkTextBuffer *text_buffer = NULL;
	int id = -1, def = 0;
	WidgetInfo *widget_textview = (WidgetInfo *)widget;

	if(widget_textview != NULL){
		textview = GTK_TEXT_VIEW(glade_xml_get_widget(xml, widget_textview->name));
		if(textview != NULL){
			text_buffer = gtk_text_view_get_buffer(textview);
			user_data = (TextViewData * )malloc(sizeof(TextViewData));
			widget_textview->data = user_data;
			if((text_buffer != NULL) && (user_data != NULL)){
				memset(user_data, 0, sizeof(TextViewData));
				signal = widget_textview->signal_list;
				user_data->id = GetModID(signal->id);
				user_data->widget_name = widget_textview->name;

				property = FindProperty(widget_textview->prop_list, "length");
				if(property != NULL){
					if(property->value != NULL){
						user_data->length = atoi(property->value);
					}else if(property->id != NULL){
						id = GetModID(property->id);
						def = atoi(property->def);
						user_data->length = GetCurrOptInt(id, def);
					}
				}

				while(signal != NULL){
					signal_name = signal->name;
					if(signal_name != NULL){
						if(0 == strcmp(signal_name, "changed")){
							g_signal_connect(G_OBJECT(text_buffer), "changed", G_CALLBACK (on_textbuffer_changed), user_data);
						}
						if(0 == strcmp(signal_name, "focus_out_event")){
							g_signal_connect((gpointer)textview, "focus_out_event", G_CALLBACK (on_textview_focus_out_event), user_data);
						}
					}
					signal = signal->next;
				}
			}
		}
	}
}

void InitTextview(GladeXML *xml, cngplpData* data, const gpointer *widget)
{
	PropInfo *property = NULL;
	char *text = NULL;
	int id = -1;
	WidgetInfo *widget_textview = (WidgetInfo *)widget;

	if((widget_textview != NULL) && widget_textview->name != NULL){
		property = FindProperty(widget_textview->prop_list, "text");
		if(property != NULL){
			id = GetModID(property->id);
			text = GetOptionList(data, id);
			if(text != NULL){
				SetTextofTextView(widget_textview->name, text, -1);
				memFree(text);
			}
		}
	}
}
