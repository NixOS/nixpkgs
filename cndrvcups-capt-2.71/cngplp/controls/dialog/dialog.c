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


#include "dialog.h"

gboolean
on_delete_event                (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data)
{
	const char *dlg_name = (char*)user_data;
	if(dlg_name != NULL){
		if(TRUE == SigDisable()){
			HideDialog(dlg_name, FALSE);
		}
		SigEnable();
	}
	return TRUE;
}


void
on_destroy_event                     (GtkObject       *object,
                                        gpointer         user_data)
{
}

void on_OK_clicked_event		(GtkButton       *button,
                                        gpointer         user_data)
{
	const char *dlg_name = (char *)user_data;

	if(dlg_name != NULL){
		if(TRUE == SigDisable()){
			HideDialog(dlg_name, TRUE);
		}
		SigEnable();
	}
}

void on_Cancel_clicked_event		(GtkButton       *button,
                                        gpointer         user_data)
{
	const char *dlg_name = (char *)user_data;

	if(dlg_name != NULL){
		if(TRUE == SigDisable()){
			HideDialog(dlg_name, FALSE);
		}
		SigEnable();
	}
}

void on_Restore_clicked_event		(GtkButton       *button,
                                        gpointer         user_data)
{
	if(TRUE == SigDisable()){
		RestoreDefault();
	}
	SigEnable();
}

void ConnectDialogSignal(GladeXML *xml, cngplpData* data, gpointer *special)
{
	GtkWidget *dialog;
	ButtonInfo *button_info;
	SpecialInfo *special_dialog = (SpecialInfo *)special;

	if((special_dialog != NULL) && (special_dialog->name != NULL)){
		dialog = glade_xml_get_widget(xml, special_dialog->name);
		if(dialog != NULL){
			g_signal_connect((gpointer)dialog, "delete_event",G_CALLBACK (on_delete_event), special_dialog->name);
			g_signal_connect((gpointer)dialog, "destroy",G_CALLBACK (on_destroy_event), NULL);
			button_info = special_dialog->button_list;
			while(button_info != NULL){
				if(button_info->button_name != NULL){
					GtkWidget *button;
					button = glade_xml_get_widget(xml, button_info->button_name);
					if(button != NULL){
						if(button_info->type == OK_BUTTON){
							g_signal_connect((gpointer)button, "clicked",
									G_CALLBACK (on_OK_clicked_event), special_dialog->name);
						}else if(button_info->type == CANCEL_BUTTON){
							g_signal_connect((gpointer)button, "clicked",
									G_CALLBACK (on_Cancel_clicked_event), special_dialog->name);
						}else if(button_info->type == RESTORE_BUTTON){
							g_signal_connect((gpointer)button, "clicked",
									G_CALLBACK (on_Restore_clicked_event), NULL);
						}
					}
				}
				button_info = button_info->next;
			}
		}
	}
}
