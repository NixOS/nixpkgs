/*
 *  Status monitor for Canon CAPT Printer.
 *  Copyright CANON INC. 2004
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
#include <stdlib.h>
#include <string.h>
#include <gtk/gtk.h>

#include <sys/time.h>

#include "support.h"
#include "callbacks.h"

#include "uimain.h"

#include "widgets.h"

#define	UI_SHOW_TIME	5

static int g_curr_signal;
static long g_sent_job = 0;

static int GetNICDevice(UIStatusWnd *wnd, int status);
static int CheckText(char *text, char *tmp_text);

void SigInit(void)
{
	g_curr_signal = 0;
}

gboolean SigEnable(void)
{
	gboolean enable = TRUE;
	if(g_curr_signal > 0){
		g_curr_signal--;
		enable = FALSE;
	}
	return enable;
}

gboolean SigDisable(void)
{
	gboolean enable = TRUE;
	if(g_curr_signal)
		enable = FALSE;
	g_curr_signal++;

	return enable;
}

GtkWidget* getWidget(GtkWidget *window, char* const name)
{
	return lookup_widget(window, name);
}

void WidgetIteration(void)
{
	while(gtk_events_pending()){
		gtk_main_iteration();
	}
}

void SetDialogTitle(GtkWidget *window, gchar *title)
{
	if(title != NULL)
		gtk_window_set_title(GTK_WINDOW(window), title);
}

void SetWidgetSensitive(GtkWidget *window, gchar* const widgetname, gboolean value)
{
	GtkWidget *widget;
	widget = getWidget(window, widgetname);
	gtk_widget_set_sensitive(widget, value);
}

void SetActiveCheckButton(GtkWidget *window, gchar *button_name, gboolean on)
{
	GtkWidget *button;
	button = getWidget(window, button_name);
	gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(button), on);
}

void SetTextEntry(GtkWidget *window, gchar *entry_name, gchar *text)
{
	GtkWidget *entry;
	entry = getWidget(window, entry_name);
	gtk_entry_set_text(GTK_ENTRY(entry), text);
}

void SetTextToLabel(GtkWidget *window, gchar *label_name, gchar *text)
{
	GtkWidget *label;
	label = getWidget(window, label_name);
	gtk_label_set_text(GTK_LABEL(label), text);
}

void SetButtonLabel(GtkWidget *window, gchar *button_name, gchar *text)
{
    GtkWidget *button;
    button = getWidget(window, button_name);
#ifdef OLD_GTK
    gtk_label_set_text(GTK_LABEL(GTK_BUTTON(button)->child), text);
#else
    gtk_button_set_label(GTK_BUTTON(button), text);
#endif
}

void SetSpinButtonShort(GtkWidget *window, gchar *spinbutton_name, gshort value)
{
	GtkWidget *spin;
	spin = getWidget(window, spinbutton_name);
	gtk_spin_button_set_value(GTK_SPIN_BUTTON(spin), value);
}

void SetTextToTextView(GtkWidget *window, gchar *entry_name, gchar *string)
{
	GtkWidget *textView;
	GtkTextBuffer *text;
	textView = getWidget(window, entry_name);
	text = gtk_text_view_get_buffer(GTK_TEXT_VIEW(textView));
	gtk_text_buffer_set_text(text, string, -1);
}

void SetFocus(GtkWidget *window, gchar *widget_name)
{
	GtkWidget *widget;
	widget = getWidget(window, widget_name);
	gtk_widget_grab_focus(widget);
}

void GetWindowPositionAndSize(GtkWidget *window, gint *x, gint *y, gint *w, gint *h)
{
	gtk_window_get_position(GTK_WINDOW(window), x, y);
	gtk_window_get_size(GTK_WINDOW(window), w, h);
}

void GetScreenSize(GtkWidget *window, gint *w, gint *h)
{
	GdkScreen *screen = gtk_window_get_screen(GTK_WINDOW(window));
	if((w != NULL) && (h != NULL)){
		*w = gdk_screen_get_width(screen);
		*h = gdk_screen_get_height(screen);
	}
}

void WindowMove(GtkWidget *window, gint x, gint y)
{
	gtk_window_move(GTK_WINDOW(window), x, y);
}

void SetSpinButtonFloat(GtkWidget *window, gchar *spinbutton_name, gfloat value)
{
	GtkWidget *spin;
	spin = getWidget(window, spinbutton_name);
	gtk_spin_button_set_value(GTK_SPIN_BUTTON(spin), value);
}

gint GetSpinButtonValue(GtkWidget *window, gchar *spinbutton_name, int value)
{
	GtkWidget *spin;

	spin = getWidget(window, spinbutton_name);

	if(value)
		return (gtk_spin_button_get_value_as_float(GTK_SPIN_BUTTON(spin)) * value);
	else
		return gtk_spin_button_get_value_as_int(GTK_SPIN_BUTTON(spin));
}

gboolean GetToggleButtonActive(GtkWidget *window, gchar *button_name)
{
	GtkWidget *button;

	button = getWidget(window, button_name);

	return gtk_toggle_button_get_active(GTK_TOGGLE_BUTTON(button));
}

void SetBtnWidgetSensitive(GtkWidget *window, gboolean pause, gboolean resume, gboolean cancel)
{
	SetWidgetSensitive(window, "CaptStatusUIPause_togglebutton", pause);
	SetWidgetSensitive(window, "CaptStatusUIResume_togglebutton", resume);
	SetWidgetSensitive(window, "CaptStatusUICancel_button", cancel);
}

void SetJobWidgetSensitive(GtkWidget *window, gboolean pause, gboolean resume, gboolean cancel)
{
	SetWidgetSensitive(window, "pause_job", pause);
	SetWidgetSensitive(window, "resume_job", resume);
	SetWidgetSensitive(window, "cancel_job", cancel);
}

void SetBtnWidgetActive(GtkWidget *window, gboolean pause, gboolean resume)
{
	SetActiveCheckButton(window, "CaptStatusUIPause_togglebutton", pause);
	SetActiveCheckButton(window, "CaptStatusUIResume_togglebutton", resume);
}

#ifdef OLD_GTK
void InsertToText(GtkWidget *window, gchar *entry_name, gchar *string)
{
	GtkWidget *text;
	text = getWidget(window, entry_name);
	gtk_text_insert(GTK_TEXT(text), NULL, NULL, NULL, string, -1);
}

void ThawTextWidget(GtkWidget *window, gchar *entry_name)
{
	GtkWidget *text;
	text = getWidget(window, entry_name);
	gtk_text_thaw(GTK_TEXT(text));
}

void FreezeTextWidget(GtkWidget *window, gchar *entry_name)
{
	GtkWidget *text;
	text = getWidget(window, entry_name);
	gtk_text_freeze(GTK_TEXT(text));
}

void ClearTextWidget(GtkWidget *window, gchar *text_name)
{
	GtkWidget *text;
	text = getWidget(window, text_name);
	gtk_editable_delete_text(GTK_EDITABLE(text), 0, -1);
}

#else
void InsertToText(GtkWidget *window, gchar *entry_name, gchar *string)
{
	GtkWidget *textView;
	GtkTextBuffer *text;
	textView = getWidget(window, entry_name);
	text = gtk_text_view_get_buffer( GTK_TEXT_VIEW(textView) );
	gtk_text_buffer_set_text( text, string, -1 );
}

void ThawTextWidget(GtkWidget *window, gchar *entry_name)
{
}

void FreezeTextWidget(GtkWidget *window, gchar *entry_name)
{
}

void ClearTextWidget(GtkWidget *window, gchar *text_name)
{
	GtkWidget *textView;
	GtkTextBuffer *text;
	textView = getWidget(window, text_name);
	text = gtk_text_view_get_buffer( GTK_TEXT_VIEW(textView) );
	gtk_text_buffer_set_text( text, "", -1 );
}

#endif

void ShowWidget(GtkWidget *window, gchar* const widget_name)
{
	GtkWidget *widget;

	widget = getWidget(window, widget_name);
	if(widget != NULL)
		gtk_widget_show(widget);
}

void HideWidget(GtkWidget *window, gchar* const widget_name)
{
	GtkWidget *widget;

	widget = getWidget(window, widget_name);
	if(widget != NULL)
		gtk_widget_hide(widget);
}
void ComboSignalConnect(GtkWidget *window, gchar *combo_name, GtkSignalFunc sig_func)
{
	GtkWidget *combo;

	combo = getWidget(window, combo_name);

	gtk_widget_realize(combo);
	gtk_signal_connect(GTK_OBJECT(GTK_COMBO(combo)->popwin), "event", GTK_SIGNAL_FUNC(sig_func), NULL);
}

void SetGListToCombo(GtkWidget *window, GList *glist, gchar *combo_name, gchar *curr_name)
{
	GtkWidget *combo, *entry;

	combo = getWidget(window, combo_name);
	entry = GTK_COMBO(combo)->entry;

	if(glist != NULL || curr_name != NULL){
		gtk_combo_set_popdown_strings(GTK_COMBO(combo), glist);
		gtk_entry_set_text(GTK_ENTRY(entry), curr_name);
	}
}

gchar* GetCurrComboText(GtkWidget *window, gchar *combo_entry_name)
{
	GtkWidget *entry;
	char *text;
	entry = getWidget(window, combo_entry_name);

	text = gtk_entry_get_text(GTK_ENTRY(entry));
	return text;
}

gchar* GetTextEntry(GtkWidget *window, char *entry_name)
{
	GtkWidget *entry;

	entry = getWidget(window, entry_name);
	if(entry == NULL)
		return NULL;
	return gtk_entry_get_text(GTK_ENTRY(entry));
}




int StateWidgets(long job_num)
{
	UIStatusWnd *wnd;
	GtkWidget *window;
	unsigned short status_code;
	int ret = 1;
	wnd = g_status_window;
	window = UI_DIALOG(wnd)->window;
	status_code = wnd->pCnskt->status_code;

	if(status_code == CCPD_SB_READY
	|| status_code == CCPD_SB_READY2)
		SetBtnWidgetActive(window, FALSE, TRUE);

	if(status_code == (CCPD_SB_READY | CCPD_SB_STARTJOB)
	|| status_code == (CCPD_SB_READY2 | CCPD_SB_STARTJOB))
		SetBtnWidgetActive(window, FALSE, TRUE);

	if(status_code & CCPD_SB_CLEANING)
		SetBtnWidgetActive(window, FALSE, TRUE);

	if((job_num != CCPD_REQ_RESUME) && (status_code & CCPD_SB_ENA_RESUME))
		SetBtnWidgetActive(window, TRUE, FALSE);

	if(status_code == (CCPD_SB_READY | CCPD_SB_PRINTING)
	|| status_code == (CCPD_SB_READY2 | CCPD_SB_PRINTING))
		SetActiveCheckButton(window, "CaptStatusUIResume_togglebutton", TRUE);
	if(g_sent_job != 0){
		SetBtnWidgetActive(window, TRUE, TRUE);
		ret = 1;
		return ret;
	}

	switch(job_num){
	case CCPD_REQ_PAUSE:
	case OPEREQ_PAUSE:
		if(status_code == (CCPD_SB_READY | CCPD_SB_PRINTING)
		|| status_code == (CCPD_SB_READY2 | CCPD_SB_PRINTING)){
			ret = 0;
			g_sent_job = job_num;
		}else if(status_code ==
		(CCPD_SB_READY | CCPD_SB_PRINTING | CCPD_SB_STARTJOB)
		|| status_code ==
		(CCPD_SB_READY2 | CCPD_SB_PRINTING | CCPD_SB_STARTJOB)){
			ret = 0;
			g_sent_job = job_num;
		}
		break;
	case CCPD_REQ_RESUME:
	case OPEREQ_RESUME:
		if(status_code & CCPD_SB_PAUSE){
			ret = 0;
			g_sent_job = job_num;
		}
		if(status_code & CCPD_SB_PRINTING){
			if(!(status_code & CCPD_SB_PAUSE)){
				SetBtnWidgetActive(window, FALSE, TRUE);
			}
		}
		break;
	case CCPD_REQ_CANCEL:
	case OPEREQ_CANCEL:
		if(status_code & CCPD_SB_PRINTING)
			ret = 0;
		break;
	case CCPD_REQ_CLEANING:
		if(status_code == CCPD_SB_READY
		|| status_code == CCPD_SB_READY2)
			ret = 0;
		break;
	case CCPD_REQ_CLEANING2:
		if(status_code == CCPD_SB_READY
		|| status_code == CCPD_SB_READY2)
			ret = 0;
		break;
	case CCPD_REQ_PRT_INFO:
		if(status_code == CCPD_SB_READY
		|| status_code == CCPD_SB_READY2)
			ret = 0;
		if(status_code & CCPD_SB_SETTINGS)
			ret = 0;
		break;
	case CCPD_REQ_PRT_INFO2:
		if(status_code == CCPD_SB_READY
		|| status_code == CCPD_SB_READY2)
			ret = 0;
		if(status_code & CCPD_SB_SETTINGS)
			ret = 0;
		break;
	case CCPD_REQ_SET_FLASH:
		if(status_code == CCPD_SB_READY
		|| status_code == CCPD_SB_READY2)
			ret = 0;
		if(status_code & CCPD_SB_SETTINGS)
			ret = 0;
		break;
	case CCPD_REQ_CLEANING3:
		if(status_code == CCPD_SB_READY
		|| status_code == CCPD_SB_READY2)
			ret = 0;
		break;
	case CCPD_REQ_CALIBRATION:
		if(status_code == CCPD_SB_READY
		|| status_code == CCPD_SB_READY2)
			ret = 0;
		if(status_code & CCPD_SB_SETTINGS)
			ret = 0;
		if((status_code & CCPD_SB_CRITICAL) | (status_code & CCPD_SB_WARNING)){
			ret = 2;
		}
		break;
	case REQ_SHOWDLG_REGIPAPER:
	case REQ_SHOWDLG_SLEEPS:
	case REQ_SHOWDLG_CCINFO:
	case REQ_SHOWDLG_CANCELJOB:
	case REQ_SHOWDLG_NETWORKS:
	case REQ_SHOWDLG_ASSTPRT:
	case REQ_SHOWDLG_STARTUPSET:
	case REQ_SHOWDLG_COUNTERSINFO:
	case REQ_SHOWDLG_CONSUMABLESINFO:
	case REQ_SHOWDLG_CLEANING:
	case REQ_SHOWDLG_CALIBRATIONSETTINGS:
	case REQ_SHOWDLG_CASSETTESET2:
	case REQ_SHOWDLG_MULTITRAY:
	case REQ_SHOWDLG_PPAVH:
	case REQ_SHOWDLG_RESETUNIT:
		if(status_code == CCPD_SB_READY
		|| status_code == CCPD_SB_READY2)
			ret = 0;
		if(status_code & CCPD_SB_SETTINGS)
			ret = 0;
		if( wnd->nModel == MODEL_LBP3100 ||
		    wnd->nModel == MODEL_LBP3050 ||
		    wnd->nModel == MODEL_LBP3250 ||
		    wnd->nModel == MODEL_LBP3310 ||
		    wnd->nModel == MODEL_LBP3500 ||
		    wnd->nModel == MODEL_LBP5100 ||
		    wnd->nModel == MODEL_LBP5300 ||
		    wnd->nModel == MODEL_LBP5050 ||
		    wnd->nModel == MODEL_LBP7200 ||
		    wnd->nModel == MODEL_LBP7210 ||
		    wnd->nModel == MODEL_LBP6310 ||
		    wnd->nModel == MODEL_LBP6340 ||
		    wnd->nModel == MODEL_LBP6020 ||
		    wnd->nModel == MODEL_LBP7010 ||
		    wnd->nModel == MODEL_LBP9100 ||
		    wnd->nModel == MODEL_LBP9200 ||
		    wnd->nModel == MODEL_LBP6300 ||
		    wnd->nModel == MODEL_LBP6300N ||
		    wnd->nModel == MODEL_LBP6200 ||
		    wnd->nModel == MODEL_LBP6000){
			if((status_code & CCPD_SB_CRITICAL) | (status_code & CCPD_SB_WARNING)){
				ret = 0;
			}
		}
		break;
	default:
		if(status_code == CCPD_SB_READY
		|| status_code == CCPD_SB_READY2)
			ret = 0;
		if(status_code & CCPD_SB_SETTINGS)
			ret = 0;
		break;
	}

	return ret;
}

int CheckShowTime(UIStatusWnd *wnd)
{
	struct timeval time;
	unsigned short status_code = wnd->pCnskt->status_code;
	gettimeofday(&time, NULL);
	if(wnd->time == 1){
		if(status_code == CCPD_SB_STARTJOB)
			return 0;

		if(status_code == (CCPD_SB_STARTJOB | CCPD_SB_WARNING))
			return 0;

		if(status_code == 0)
			return 0;

		wnd->time = (int)time.tv_sec;
		return 0;
	}else{
		if((time.tv_sec - wnd->time) > UI_SHOW_TIME){
			wnd->time = 0;
			return 1;
		}
	}

	return 0;
}

void UpdateWidgets(UIStatusWnd *wnd)
{
	GtkWidget *window;
	unsigned short status_code = 0;
	gboolean pause = FALSE, resume = FALSE, cancel = FALSE;
	gboolean pause_job = FALSE, resume_job = FALSE, cancel_job = FALSE;
	gboolean pause_active = FALSE, resume_active = FALSE;
	gboolean cleaning_job = FALSE;
	gboolean device_menu = FALSE;

	window = UI_DIALOG(wnd)->window;
	status_code = wnd->pCnskt->status_code;
UI_DEBUG("UpdateWidgets status code 0x%04x\n", status_code);

	if(status_code == CCPD_SB_READY
	|| status_code == CCPD_SB_READY2){
		cleaning_job = TRUE;
		device_menu = TRUE;
		g_sent_job = 0;
	}else if(status_code == (CCPD_SB_READY | CCPD_SB_STARTJOB)
	|| status_code == (CCPD_SB_READY2 | CCPD_SB_STARTJOB)){
		cleaning_job = TRUE;
		device_menu = TRUE;
		g_sent_job = 0;
	}else if(status_code & CCPD_SB_CLEANING){
		resume = TRUE;
		resume_active = TRUE;
	}else if(status_code != 0){
		if(status_code & CCPD_SB_PRINTING){
		    switch( wnd->nModel ){
		    case MODEL_LBP3300:
		    case MODEL_LBP5000:
		    case MODEL_LBP3500:
		    case MODEL_LBP5100:
		    case MODEL_LBP5300:
		        break;
		    default:
			cancel = TRUE;
			cancel_job = TRUE;
			break;
		    }
			if(wnd->msg_dlg != NULL
			&& wnd->msg_dlg->type == MSG_TYPE_PRINT_PPAP)
				HideMsgDlg(wnd);
		}
		if(status_code & CCPD_SB_PRINTING){
			if(status_code & CCPD_SB_PAUSE){
				resume = TRUE;
				resume_job = TRUE;
				cancel = TRUE;
				cancel_job = TRUE;
			}
		}
		if((status_code & CCPD_SB_CRITICAL) | (status_code & CCPD_SB_WARNING)){
			if(status_code & CCPD_SB_ENA_RESUME){
				pause = TRUE;
				pause_active = TRUE;
				g_sent_job = 0;
			}
		}else{
			if(status_code & CCPD_SB_PAUSE){
				pause = TRUE;
				pause_job = TRUE;
				pause_active = TRUE;
				g_sent_job = 0;
			}else if(status_code != CCPD_SB_STARTJOB){
				if(!(status_code & CCPD_SB_COM_ERROR)){
					pause = TRUE;
					pause_job = TRUE;
					g_sent_job = 0;
				}
			}
		}
		if(status_code & CCPD_SB_SETTINGS){
			device_menu = TRUE;
		}
	}

	if(!wnd->mode){
		if(wnd->time){
			if(status_code == (CCPD_SB_PRINTING | CCPD_SB_READY)
			|| status_code == (CCPD_SB_PRINTING | CCPD_SB_READY2)){
				if(CheckShowTime(wnd))
					gtk_widget_hide(window);
			}else if(status_code ==
			(CCPD_SB_PRINTING | CCPD_SB_READY | CCPD_SB_STARTJOB)){
				if(CheckShowTime(wnd))
					gtk_widget_hide(window);
			}else if(status_code ==
			(CCPD_SB_PRINTING | CCPD_SB_READY2 | CCPD_SB_STARTJOB)){
				if(CheckShowTime(wnd))
					gtk_widget_hide(window);
			}else if(!(status_code & CCPD_SB_PRINTING)){
				if(CheckShowTime(wnd))
					gtk_widget_hide(window);
			}
		}else{
			if(status_code & CCPD_SB_PRINTING
			|| status_code & CCPD_SB_STARTJOB){
				if((status_code & CCPD_SB_CRITICAL)
				|| (status_code & CCPD_SB_WARNING)
				|| (status_code & CCPD_SB_ENA_RESUME)){
					gtk_widget_show(window);
					wnd->time = 1;
				}
			}else if(status_code == 0
			&& (wnd->pCnskt->response_code == CCPD_RES_NOPRINTER
			|| wnd->pCnskt->response_code == CCPD_RES_PRINTER_ERR)){
				gtk_widget_show(window);
				wnd->time = 1;
			}
		}
	}

	SetBtnWidgetSensitive(window, pause, resume, cancel);
	SetBtnWidgetActive(window, pause_active, resume_active);
	SetJobWidgetSensitive(window, pause_job, resume_job, cancel_job);
	SetWidgetSensitive(window, "cleaning", cleaning_job);
	SetWidgetSensitive(window, "cleaning1", cleaning_job);
	SetWidgetSensitive(window, "cleaning2", cleaning_job);
	SetWidgetSensitive(window, "printing_position_adjustment_print1", cleaning_job);
	SetWidgetSensitive(window, "device_settings1", cleaning_job);

	SetWidgetSensitive(window, "cleaning3", cleaning_job);
	SetWidgetSensitive(window, "consumable_counters1", cleaning_job);
	SetWidgetSensitive(window, "register_paper_size_in_cassettes1", device_menu);
	SetWidgetSensitive(window, "sleep_settings1", device_menu);
	SetWidgetSensitive(window, "settings_of_the_cancel_job_key1", device_menu);
	SetWidgetSensitive(window, "calibration1", cleaning_job);
	SetWidgetSensitive(window, "register_colors_correction1", cleaning_job);
	SetWidgetSensitive(window, "assisting_print_setting1", device_menu);

	if(wnd->nic_flag == 1){
UI_DEBUG("NIC_FLAG =%d\n", wnd->nic_flag);
		if(status_code == CCPD_SB_READY
		|| status_code == CCPD_SB_READY2){
			if(GetNICDevice(wnd, CCPD_SB_READY) > 0){
				SetWidgetSensitive(window, "network_settings1", 1);
				wnd->nic_flag = 2;
			}
		}else if(status_code == (CCPD_SB_READY | CCPD_SB_STARTJOB)){
			if(GetNICDevice(wnd, CCPD_SB_READY) > 0){
				SetWidgetSensitive(window, "network_settings1", 1);
				wnd->nic_flag = 2;
			}
		}else if(status_code == (CCPD_SB_READY2 | CCPD_SB_STARTJOB)){
			if(GetNICDevice(wnd, CCPD_SB_READY) > 0){
				SetWidgetSensitive(window, "network_settings1", 1);
				wnd->nic_flag = 2;
			}
		}
	}

	if(wnd->nNetworkSettings && wnd->nic_flag == 2){
		SetWidgetSensitive(window, "network_settings1", cleaning_job);
	}

	if(wnd->bMenuDisable == 1){
		SetWidgetSensitive(UI_DIALOG(wnd)->window, "menubar1", TRUE);
		SetWidgetSensitive(UI_DIALOG(wnd)->window, "CAPTStatusUIHide_button", TRUE);
		wnd->bMenuDisable = 0;
	}

	if(wnd->text1 != NULL){
		SetTextToLabel(window, "CaptStatusUI_label", wnd->text1);
	}

	if(CheckText(wnd->text2, wnd->tmp_text2)){
UI_DEBUG("text2=[%s] tmp=[%s]\n", wnd->text2, wnd->tmp_text2);
		ClearTextWidget(window, "CaptStatusUI_text");
		if(wnd->text2 != NULL){
			FreezeTextWidget(window, "CaptStatusUI_text");
			InsertToText(window, "CaptStatusUI_text", wnd->text2);
			ThawTextWidget(window, "CaptStatusUI_text");
			mem_free(wnd->tmp_text2);
			wnd->tmp_text2 = strdup(wnd->text2);
		}else{
			mem_free(wnd->tmp_text2);
			wnd->tmp_text2 = NULL;
		}
	}
	mem_free(wnd->text1);
	mem_free(wnd->text2);
}

void UpdateWidgets_Common(UIStatusWnd *wnd)
{
	GtkWidget *window;
	unsigned short status_code = 0;
	gboolean isPauseEnable = FALSE, isResumeEnable = FALSE, isCancelEnable = FALSE;
	gboolean isPauseActive = FALSE, isResumeActive = FALSE;

	window = UI_DIALOG(wnd)->window;
	status_code = wnd->pCnskt->status_code;
UI_DEBUG("UpdateWidgets status code 0x%04x\n", status_code);


	if ((status_code & CCPD_SB_PRINTING) && ( wnd->enableJobOperate )) {
                if( strcmp(wnd->pAlertCode, "CNPrintCanceled") ){
				if( ( strcmp( wnd->pAlertCode, "CNWaiting" ) != 0 ) && ( strcmp( wnd->pAlertCode, "CNCheckPaper" ) != 0 ) ){
		       isPauseEnable = TRUE;
				}
		       isPauseActive = TRUE;
		       isCancelEnable = TRUE;
                }
	}


	if ((status_code & CCPD_SB_PAUSE) && ( wnd->enableJobOperate )) {
		isCancelEnable = TRUE;
		if(( status_code & CCPD_SB_CRITICAL) || ( status_code & CCPD_SB_WARNING )){
			isPauseEnable = FALSE;
			isPauseActive = FALSE;
			isResumeEnable = FALSE;
			isResumeActive = FALSE;
		}
		if( !(strcmp(wnd->pAlertCode, "CNPaused")) ){
			isResumeEnable = TRUE;
			isResumeActive = FALSE;
			isPauseEnable = FALSE;
			isPauseActive = TRUE;
		}
	}


	if(( status_code & CCPD_SB_ENA_RESUME ) && ( wnd->enableJobOperate )){
		isResumeEnable = TRUE;
		isResumeActive = FALSE;
	}

	if( !strcmp(wnd->pAlertCode, "CNCleaningPaper") ){
		isPauseEnable = FALSE;
		isPauseActive = FALSE;
	}


	if(status_code == CCPD_SB_READY
	|| status_code == CCPD_SB_READY2){
		g_sent_job = 0;
	}else if(status_code == (CCPD_SB_READY | CCPD_SB_STARTJOB)
	|| status_code == (CCPD_SB_READY2 | CCPD_SB_STARTJOB)){
		g_sent_job = 0;
	}else if(status_code & CCPD_SB_CLEANING){
	}else if(status_code != 0){
		if(status_code & CCPD_SB_PRINTING){
			if(wnd->msg_dlg != NULL
			&& wnd->msg_dlg->type == MSG_TYPE_PRINT_PPAP)
				HideMsgDlg(wnd);
		}
		if((status_code & CCPD_SB_CRITICAL) | (status_code & CCPD_SB_WARNING)){
			if(status_code & CCPD_SB_ENA_RESUME){
				g_sent_job = 0;
			}
		}else{
			if(status_code & CCPD_SB_PAUSE){
				g_sent_job = 0;
			}else if(status_code != CCPD_SB_STARTJOB){
				if(!(status_code & CCPD_SB_COM_ERROR)){
					g_sent_job = 0;
				}
			}
		}

	}

	if(!wnd->mode){
		if(wnd->time){
			if(status_code == (CCPD_SB_PRINTING | CCPD_SB_READY)
			|| status_code == (CCPD_SB_PRINTING | CCPD_SB_READY2)){
				if(CheckShowTime(wnd))
					gtk_widget_hide(window);
			}else if(status_code ==
			(CCPD_SB_PRINTING | CCPD_SB_READY | CCPD_SB_STARTJOB)){
				if(CheckShowTime(wnd))
					gtk_widget_hide(window);
			}else if(status_code ==
			(CCPD_SB_PRINTING | CCPD_SB_READY2 | CCPD_SB_STARTJOB)){
				if(CheckShowTime(wnd))
					gtk_widget_hide(window);
			}else if(!(status_code & CCPD_SB_PRINTING)){
				if(CheckShowTime(wnd))
					gtk_widget_hide(window);
			}
		}else{
			if(status_code & CCPD_SB_PRINTING
			|| status_code & CCPD_SB_STARTJOB){
				if((status_code & CCPD_SB_CRITICAL)
				|| (status_code & CCPD_SB_WARNING)
				|| (status_code & CCPD_SB_ENA_RESUME)){
					gtk_widget_show(window);
					wnd->time = 1;
				}
			}else if(status_code == 0
			&& (wnd->pCnskt->response_code == CCPD_RES_NOPRINTER
			|| wnd->pCnskt->response_code == CCPD_RES_PRINTER_ERR)){
				gtk_widget_show(window);
				wnd->time = 1;
			}
		}
	}

	SetBtnWidgetSensitive(window, isPauseEnable, isResumeEnable, isCancelEnable);
	SetBtnWidgetActive(window, isPauseActive, isResumeActive);
	SetJobWidgetSensitive(window, isPauseEnable, isResumeEnable, isCancelEnable);


	if(wnd->nic_flag == 1){
UI_DEBUG("NIC_FLAG =%d\n", wnd->nic_flag);
		if(status_code == CCPD_SB_READY
		|| status_code == CCPD_SB_READY2){
			if(GetNICDevice(wnd, CCPD_SB_READY) > 0){
				wnd->nic_flag = 2;
			}
		}else if(status_code == (CCPD_SB_READY | CCPD_SB_STARTJOB)){
			if(GetNICDevice(wnd, CCPD_SB_READY) > 0){
				wnd->nic_flag = 2;
			}
		}else if(status_code == (CCPD_SB_READY2 | CCPD_SB_STARTJOB)){
			if(GetNICDevice(wnd, CCPD_SB_READY) > 0){
				wnd->nic_flag = 2;
			}
		}
	}


	if(wnd->bMenuDisable == 1){
		SetWidgetSensitive(UI_DIALOG(wnd)->window, "menubar1", TRUE);
		SetWidgetSensitive(UI_DIALOG(wnd)->window, "CAPTStatusUIHide_button", TRUE);
		wnd->bMenuDisable = 0;
	}

	if(wnd->text1 != NULL){
		SetTextToLabel(window, "CaptStatusUI_label", wnd->text1);
	}

	if(CheckText(wnd->text2, wnd->tmp_text2)){
UI_DEBUG("text2=[%s] tmp=[%s]\n", wnd->text2, wnd->tmp_text2);
		ClearTextWidget(window, "CaptStatusUI_text");
		if(wnd->text2 != NULL){
			FreezeTextWidget(window, "CaptStatusUI_text");
			InsertToText(window, "CaptStatusUI_text", wnd->text2);
			ThawTextWidget(window, "CaptStatusUI_text");
			mem_free(wnd->tmp_text2);
			wnd->tmp_text2 = strdup(wnd->text2);
		}else{
			mem_free(wnd->tmp_text2);
			wnd->tmp_text2 = NULL;
		}
	}
	mem_free(wnd->text1);
	mem_free(wnd->text2);
}

static int CheckText(char *text, char *tmp_text)
{
	if(text != NULL){
		if(tmp_text != NULL){
			if(strcasecmp(text, tmp_text) != 0)
				return 1;
			else
				return 0;
		}
		return 1;
	}else{
		if(tmp_text != NULL)
			return 1;
		else
			return 0;
	}
}

void HideMonitor(UIStatusWnd *wnd)
{
	gtk_widget_hide(UI_DIALOG(wnd)->window);
	wnd->time = 0;
	wnd->mode = 0;
}

void CreateStatusWidgets(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd)->window;
	int utility = 0, device_settings = 0;

	switch(wnd->cleaning){
	case 0:
		ShowWidget(window, "cleaning");
		break;
	case 1:
		ShowWidget(window, "cleaning1");
		ShowWidget(window, "cleaning2");
		utility++;
		break;
	case 2:
		ShowWidget(window, "cleaning3");
		utility++;
		break;
	}

	if(wnd->ppap){
		ShowWidget(window, "printing_position_adjustment_print1");
		wnd->ppap_dlg = CreatePPAPDlg(UI_DIALOG(wnd));
		utility++;
	}

	if(wnd->nCalibration){
		ShowWidget(window, "calibration1");
		utility++;
	}

	if(utility)
		ShowWidget(window, "utility1");

	switch(wnd->dev){
	case 0:
		break;
	case 1:
		ShowWidget(window, "device_settings1");
		wnd->dev_dlg = CreateDevDlg(UI_DIALOG(wnd));
		break;
	}

	if(wnd->nConsumableCounters){
		ShowWidget(window, "consumable_counters1");
		wnd->ccinfo_dlg = CreateCCInfoDlg(UI_DIALOG(wnd));
	}

	if(wnd->nRegiPapersize){
		ShowWidget(window, "register_paper_size_in_cassettes1");
		wnd->regipaper_dlg = CreateRegiPaperDlg(UI_DIALOG(wnd));
		device_settings++;
	}

	if(wnd->nSleepSetting){
		ShowWidget(window, "sleep_settings1");
		wnd->sleeps_dlg = CreateSleepSettingDlg(UI_DIALOG(wnd));
		device_settings++;
	}

	if(wnd->nCancelJobKey){
		ShowWidget(window, "settings_of_the_cancel_job_key1");
		wnd->cancelkey_dlg = CreateCancelJobKeyDlg(UI_DIALOG(wnd));
		device_settings++;
	}

	if(wnd->nNetworkSettings){
		ShowWidget(window, "network_settings1");
		wnd->networks_dlg = CreateNetworkSDlg(UI_DIALOG(wnd));
		device_settings++;
		if(GetNICDevice(wnd, -1) <= 0){
			SetWidgetSensitive(window, "network_settings1", 0);
		}else{
			wnd->nic_flag = 2;
		}
	}

	if(device_settings)
		ShowWidget(window, "device_settings2");
}


static int GetNICDevice(UIStatusWnd *wnd, int status)
{
	unsigned char elem;
	short status_code = 0;

	if(status != CCPD_SB_READY){
		if(SendRequest(wnd, CCPD_REQ_STATUS) < 0){
			wnd->nic_flag = 1;
			return -1;
		}

		if(wnd->pCnskt->status_code != CCPD_SB_READY){
			wnd->nic_flag = 1;
			return -1;
		}
		if(wnd->pCnskt->status_code != CCPD_SB_READY2){
			wnd->nic_flag = 1;
			return -1;
		}
	}

	status_code = wnd->pCnskt->status_code;

	if(SendRequest(wnd, CCPD_REQ_PRT_INFO2) < 0)
		goto err;
	if(cnsktSeekResData(wnd->pCnskt, 2) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &elem, READ_TYPE_BYTE, -1) < 0)
		goto err;

	wnd->pCnskt->status_code = status_code;
	return elem & PRINTER_FLAGS_SB_NIC;

err:
	wnd->pCnskt->status_code = status_code;
	return -1;
}


void CreateStatusWidgets_LBP5300(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd)->window;

	ShowWidget(window, "consumable_counters1");
	wnd->ccinfo_dlg = CreateCCInfoDlg(UI_DIALOG(wnd));

	ShowWidget(window, "utility1");
	ShowWidget(window, "cleaning3");
	ShowWidget(window, "calibration1");
	ShowWidget(window, "register_colors_correction1");

	ShowWidget(window, "device_settings2");
	ShowWidget(window, "register_paper_size_in_cassettes1");
	wnd->regipaper_dlg = CreateRegiPaperDlg(UI_DIALOG(wnd));
	ShowWidget(window, "settings_of_the_cancel_job_key1");
	wnd->cancelkey_dlg = CreateCancelJobKeyDlg(UI_DIALOG(wnd));
	ShowWidget(window, "sleep_settings1");
	wnd->sleeps_dlg = CreateSleepSettingDlg(UI_DIALOG(wnd));
	ShowWidget(window, "network_settings1");
	wnd->networks_dlg = CreateNetworkSDlg(UI_DIALOG(wnd));
	ShowWidget(window, "assisting_print_setting1");
	wnd->asstprts_dlg = CreateAsstPrtSDlg(UI_DIALOG(wnd));
	wnd->nic_flag = PRINTER_INFO_NIC_ON;
}

void CreateStatusWidgets_LBP3500(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd)->window;

	ShowWidget(window, "utility1");
	ShowWidget(window, "cleaning3");

	ShowWidget(window, "device_settings2");
	ShowWidget(window, "settings_of_the_cancel_job_key1");
	wnd->cancelkey_dlg = CreateCancelJobKeyDlg(UI_DIALOG(wnd));
	ShowWidget(window, "sleep_settings1");
	wnd->sleeps_dlg = CreateSleepSettingDlg(UI_DIALOG(wnd));
	ShowWidget(window, "network_settings1");
	wnd->networks_dlg = CreateNetworkSDlg(UI_DIALOG(wnd));
	SetWidgetSensitive(window, "network_settings1", FALSE);
	wnd->nic_flag = PRINTER_INFO_NIC_CHECK;
}

void CreateStatusWidgets_LBP5100(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd)->window;

	ShowWidget(window, "consumable_counters1");
	wnd->ccinfo_dlg = CreateCCInfoDlg(UI_DIALOG(wnd));

	ShowWidget(window, "utility1");
	ShowWidget(window, "cleaning3");
	ShowWidget(window, "calibration1");

	ShowWidget(window, "device_settings2");
	ShowWidget(window, "register_paper_size_in_cassettes1");
	wnd->regipaper_dlg = CreateRegiPaperDlg(UI_DIALOG(wnd));
	ShowWidget(window, "sleep_settings1");
	wnd->sleeps_dlg = CreateSleepSettingDlg(UI_DIALOG(wnd));
	ShowWidget(window, "network_settings1");
	wnd->networks_dlg = CreateNetworkSDlg(UI_DIALOG(wnd));
	ShowWidget(window, "assisting_print_setting1");
	wnd->asstprts_dlg = CreateAsstPrtSDlg(UI_DIALOG(wnd));
	wnd->nic_flag = PRINTER_INFO_NIC_ON;
}

void CreateStatusWidgets_LBP5050(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd)->window;

	ShowWidget(window, "consumable_counters1");
	wnd->ccinfo_dlg = CreateCCInfoDlg(UI_DIALOG(wnd));

	ShowWidget(window, "utility1");
	ShowWidget(window, "cleaning1");
	ShowWidget(window, "cleaning2");
	ShowWidget(window, "calibration1");
	ShowWidget(window, "register_colors_correction1");


	ShowWidget(window, "device_settings2");
	ShowWidget(window, "register_paper_size_in_cassettes1");
	wnd->regipaper_dlg = CreateRegiPaperDlg(UI_DIALOG(wnd));
	ShowWidget(window, "settings_of_the_cancel_job_key1");
	wnd->cancelkey_dlg = CreateCancelJobKeyDlg(UI_DIALOG(wnd));
	ShowWidget(window, "sleep_settings1");
	wnd->sleeps_dlg = CreateSleepSettingDlg(UI_DIALOG(wnd));
	ShowWidget(window, "startup_settings1");
	wnd->startupsettings_dlg = CreateStartupSettingsDlg(UI_DIALOG(wnd));
	ShowWidget(window, "network_settings1");
	wnd->networks_dlg = CreateNetworkSDlg(UI_DIALOG(wnd));
	ShowWidget(window, "assisting_print_setting1");
	wnd->asstprts_dlg = CreateAsstPrtSDlg(UI_DIALOG(wnd));
	wnd->nic_flag = PRINTER_INFO_NIC_ON;


	HideWidget(window, "CaptStatusUIPause_togglebutton");
	HideWidget(window, "pause_job");
}

void CreateStatusWidgets_LBP7200(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd)->window;

	ShowWidget(window, "consumable_counters1");
	wnd->ccinfo_dlg = CreateCCInfoDlg(UI_DIALOG(wnd));

	ShowWidget(window, "utility1");
	ShowWidget(window, "cleaning1");
	ShowWidget(window, "cleaning2");
	ShowWidget(window, "calibration1");
	ShowWidget(window, "register_colors_correction1");

	ShowWidget(window, "device_settings2");
	ShowWidget(window, "register_paper_size_in_cassettes1");
	wnd->regipaper_dlg = CreateRegiPaperDlg(UI_DIALOG(wnd));
	ShowWidget(window, "settings_of_the_cancel_job_key1");
	wnd->cancelkey_dlg = CreateCancelJobKeyDlg(UI_DIALOG(wnd));
	ShowWidget(window, "sleep_settings1");
	wnd->sleeps_dlg = CreateSleepSettingDlg(UI_DIALOG(wnd));
	ShowWidget(window, "startup_settings1");
	wnd->startupsettings_dlg = CreateStartupSettingsDlg(UI_DIALOG(wnd));
	ShowWidget(window, "network_settings1");
	wnd->networks_dlg = CreateNetworkSDlg(UI_DIALOG(wnd));
	ShowWidget(window, "assisting_print_setting1");
	wnd->asstprts_dlg = CreateAsstPrtSDlg(UI_DIALOG(wnd));
	wnd->nic_flag = PRINTER_INFO_NIC_ON;

	HideWidget(window, "CaptStatusUIPause_togglebutton");
	HideWidget(window, "pause_job");
}


void CreateStatusWidgets_LBP3310(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd)->window;

	ShowWidget(window, "utility1");
	ShowWidget(window, "cleaning3");

	ShowWidget(window, "device_settings2");
	ShowWidget(window, "register_paper_size_in_cassettes1");
	wnd->regipaper_dlg = CreateRegiPaperDlg(UI_DIALOG(wnd));
	ShowWidget(window, "settings_of_the_cancel_job_key1");
	wnd->cancelkey_dlg = CreateCancelJobKeyDlg(UI_DIALOG(wnd));
	ShowWidget(window, "network_settings1");
	wnd->networks_dlg = CreateNetworkSDlg(UI_DIALOG(wnd));
	wnd->nic_flag = PRINTER_INFO_NIC_ON;

	HideWidget(window, "CaptStatusUIPause_togglebutton");
	HideWidget(window, "pause_job");
}

void CreateStatusWidgets_LBP3250(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd)->window;

	ShowWidget(window, "utility1");
	ShowWidget(window, "cleaning3");

	HideWidget(window, "CaptStatusUIPause_togglebutton");
	HideWidget(window, "pause_job");
}

void CreateStatusWidgets_LBP3100(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd)->window;

	ShowWidget(window, "utility1");
	ShowWidget(window, "cleaning3");

	HideWidget(window, "CaptStatusUIPause_togglebutton");
	HideWidget(window, "pause_job");
}

void CreateStatusWidgets_LBP9100(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd)->window;

	ShowWidget(window, "consumable_counters1");
	wnd->ccinfo_dlg = CreateCCInfoDlg(UI_DIALOG(wnd));

	ShowWidget(window, "utility1");
	ShowWidget(window, "printing_position_adjustment_print1");
	wnd->ppap_dlg = CreatePPAPDlg(UI_DIALOG(wnd));

	ShowWidget(window, "calibration1");
	ShowWidget(window, "register_colors_correction1");
	ShowWidget(window, "cleaning3");

	ShowWidget(window, "device_settings2");

	ShowWidget(window, "cassette_settings_1");
	wnd->regipaper_dlg = CreateRegiPaperDlg(UI_DIALOG(wnd));

	ShowWidget(window, "cassette_settings_2");
	wnd->cassetteset2_dlg = CreateCassetteSet2Dlg(UI_DIALOG(wnd));

	ShowWidget(window, "printing_position_adjustment1");
	wnd->ppavh_dlg = CreatePPAVHDlg(UI_DIALOG(wnd));

	ShowWidget(window, "settings_of_the_cancel_job_key1");
	wnd->cancelkey_dlg = CreateCancelJobKeyDlg(UI_DIALOG(wnd));
	ShowWidget(window, "power_save_settings");
	wnd->sleeps_dlg = CreateSleepSettingDlg(UI_DIALOG(wnd));
	ShowWidget(window, "startup_settings1");
	wnd->startupsettings_dlg = CreateStartupSettingsDlg(UI_DIALOG(wnd));

	ShowWidget(window, "reset_part_counters1");
	wnd->resetunit_dlg = CreateResetUnitDlg(UI_DIALOG(wnd));

	ShowWidget(window, "network_settings1");
	wnd->networks_dlg = CreateNetworkSDlg(UI_DIALOG(wnd));
	ShowWidget(window, "assisting_print_setting1");
	wnd->asstprts_dlg = CreateAsstPrtSDlg(UI_DIALOG(wnd));
	wnd->nic_flag = PRINTER_INFO_NIC_ON;

	HideWidget(window, "CaptStatusUIPause_togglebutton");
	HideWidget(window, "pause_job");
}

void CreateStatusWidgets_LBP6300(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd)->window;

	if( IsUS(wnd) == TRUE ){
		ShowWidget(window, "counters");
		wnd->ccinfo_dlg = CreateCCInfoDlg(&wnd->dialog);
	}

	ShowWidget(window, "utility1");
	ShowWidget(window, "cleaning3");

	ShowWidget(window, "device_settings2");

	ShowWidget(window, "cassette_settings");
	wnd->regipaper_dlg = CreateRegiPaperDlg(UI_DIALOG(wnd));

	ShowWidget(window, "multi_purpose_tray_settings1");
	wnd->multitray_dlg = CreateMultiTrayDlg(UI_DIALOG(wnd));

	ShowWidget(window, "settings_of_the_cancel_job_key1");
	wnd->cancelkey_dlg = CreateCancelJobKeyDlg(UI_DIALOG(wnd));

	ShowWidget(window, "network_settings1");
	wnd->networks_dlg = CreateNetworkSDlg(UI_DIALOG(wnd));

	if(wnd->nLangType != LANG_TYPE_JP){
		ShowWidget(window, "assisting_print_setting1");
		wnd->asstprts_dlg = CreateAsstPrtSDlg(UI_DIALOG(wnd));
	}

	wnd->nic_flag = PRINTER_INFO_NIC_ON;

	HideWidget(window, "CaptStatusUIPause_togglebutton");
	HideWidget(window, "pause_job");
}

void CreateStatusWidgets_LBP6000(UIStatusWnd* const wnd)
{
	if( wnd != NULL ){
		GtkWidget* const gtkwindow = wnd->dialog.window;

		if( IsUS(wnd) == TRUE ){
			ShowWidget(gtkwindow, "counters");
			wnd->ccinfo_dlg = CreateCCInfoDlg(&wnd->dialog);
		}

		ShowWidget(gtkwindow, "utility1");
		ShowWidget(gtkwindow, "cleaning3");

		ShowWidget(gtkwindow, "device_settings2");

		ShowWidget(gtkwindow, "power_save_settings");
		wnd->sleeps_dlg = CreateSleepSettingDlg(&wnd->dialog);

		HideWidget(gtkwindow, "CaptStatusUIPause_togglebutton");
		HideWidget(gtkwindow, "pause_job");
	}
}

void CreateStatusWidgets_LBP6200(UIStatusWnd* const wnd)
{
	GtkWidget *window = NULL;
	if(wnd != NULL){
		window = wnd->dialog.window;

		if( window != NULL ){
			ShowWidget(window, "counters");
			wnd->ccinfo_dlg = CreateCCInfoDlg(&wnd->dialog);

			ShowWidget(window, "utility1");
			ShowWidget(window, "cleaning3");

			ShowWidget(window, "device_settings2");
			ShowWidget(window, "power_save_settings");
			wnd->sleeps_dlg = CreateSleepSettingDlg(&wnd->dialog);
			ShowWidget(window, "assisting_print_setting1");
			wnd->asstprts_dlg = CreateAsstPrtSDlg(&wnd->dialog);

			HideWidget(window, "CaptStatusUIPause_togglebutton");
			HideWidget(window, "pause_job");
		}
	}
}
void CreateStatusWidgets_LBP7010(UIStatusWnd* const wnd)
{
	GtkWidget *window = NULL;
	if(wnd != NULL){
		window = wnd->dialog.window;
		if(window != NULL){
			ShowWidget(window, "consumables_information1");
			ShowWidget(window, "counters");
			wnd->ccinfo_dlg = CreateCCInfoDlg(&wnd->dialog);

			ShowWidget(window, "utility1");
			ShowWidget(window, "calibration1");
			ShowWidget(window, "cleaning3");
			wnd->cleaning_dlg = CreateCleaningDlg(&wnd->dialog);
			ShowWidget(window, "toner_cartridge_replacement1");
			wnd->toner_replacement_dlg = CreateTonerReplacementDlg(NULL);

			ShowWidget(window, "device_settings2");
			ShowWidget(window, "sleep_settings1");
			wnd->sleeps_dlg = CreateSleepSettingDlg(&wnd->dialog);
			ShowWidget(window, "calibration_settings1");
			wnd->calibration_Settings_dlg = CreateCalibrationSettingsDlg(&wnd->dialog);

			HideWidget(window, "CaptStatusUIPause_togglebutton");
			HideWidget(window, "pause_job");
		}
	}
}

void CreateStatusWidgets_LBP9200(UIStatusWnd* const wnd)
{
	GtkWidget *window = NULL;

	if(wnd != NULL){
		window = UI_DIALOG(wnd)->window;
		if(window != NULL){
			ShowWidget(window, "consumables_information1");
			ShowWidget(window, "counters");
			wnd->ccinfo_dlg = CreateCCInfoDlg(UI_DIALOG(wnd));

			ShowWidget(window, "utility1");
			ShowWidget(window, "printing_position_adjustment_print1");
			wnd->ppap_dlg = CreatePPAPDlg(UI_DIALOG(wnd));

			ShowWidget(window, "calibration1");
			ShowWidget(window, "color_mismatch_correction1");
			ShowWidget(window, "cleaning3");
			ShowWidget(window, "device_settings2");

			ShowWidget(window, "drawer_settings_1");
			wnd->regipaper_dlg = CreateRegiPaperDlg(UI_DIALOG(wnd));

			ShowWidget(window, "drawer_settings_2");
			wnd->cassetteset2_dlg = CreateCassetteSet2Dlg(UI_DIALOG(wnd));

			ShowWidget(window, "printing_position_adjustment1");
			wnd->ppavh_dlg = CreatePPAVHDlg(UI_DIALOG(wnd));

			ShowWidget(window, "settings_of_the_cancel_job_key1");
			wnd->cancelkey_dlg = CreateCancelJobKeyDlg(UI_DIALOG(wnd));

			ShowWidget(window, "sleep_settings1");
			wnd->sleeps_dlg = CreateSleepSettingDlg(UI_DIALOG(wnd));

			ShowWidget(window, "startup_settings1");
			wnd->startupsettings_dlg = CreateStartupSettingsDlg(UI_DIALOG(wnd));

			ShowWidget(window, "reset_part_counters1");
			wnd->resetunit_dlg = CreateResetUnitDlg(UI_DIALOG(wnd));

			ShowWidget(window, "network_settings1");
			wnd->networks_dlg = CreateNetworkSDlg(UI_DIALOG(wnd));

			ShowWidget(window, "assisting_print_setting1");
			wnd->asstprts_dlg = CreateAsstPrtSDlg(UI_DIALOG(wnd));
			wnd->nic_flag = PRINTER_INFO_NIC_ON;

			HideWidget(window, "CaptStatusUIPause_togglebutton");
			HideWidget(window, "pause_job");
		}
	}
}
void CreateStatusWidgets_LBP7210(UIStatusWnd* const wnd)
{

	GtkWidget *window = NULL;

	if(wnd != NULL){
		window = UI_DIALOG(wnd)->window;
		if(window != NULL){
			ShowWidget(window, "consumables_information1");
			ShowWidget(window, "counters");
			wnd->ccinfo_dlg = CreateCCInfoDlg(UI_DIALOG(wnd));

			ShowWidget(window, "utility1");
			ShowWidget(window, "cleaning1");
			ShowWidget(window, "cleaning2");
			ShowWidget(window, "calibration1");
			ShowWidget(window, "register_colors_correction1");

			ShowWidget(window, "device_settings2");
			ShowWidget(window, "drawer_settings");

			wnd->regipaper_dlg = CreateRegiPaperDlg(UI_DIALOG(wnd));
			ShowWidget(window, "settings_of_the_cancel_job_key1");
			wnd->cancelkey_dlg = CreateCancelJobKeyDlg(UI_DIALOG(wnd));
			ShowWidget(window, "sleep_settings1");
			wnd->sleeps_dlg = CreateSleepSettingDlg(UI_DIALOG(wnd));
			ShowWidget(window, "startup_settings1");
			wnd->startupsettings_dlg = CreateStartupSettingsDlg(UI_DIALOG(wnd));
			ShowWidget(window, "network_settings1");
			wnd->networks_dlg = CreateNetworkSDlg(UI_DIALOG(wnd));
			ShowWidget(window, "assisting_print_setting1");
			wnd->asstprts_dlg = CreateAsstPrtSDlg(UI_DIALOG(wnd));
			wnd->nic_flag = PRINTER_INFO_NIC_ON;

			HideWidget(window, "CaptStatusUIPause_togglebutton");
			HideWidget(window, "pause_job");
		}
	}
}

void CreateStatusWidgets_LBP6310(UIStatusWnd* const wnd)
{
	GtkWidget *window = NULL;

	if(wnd != NULL){
		window = UI_DIALOG(wnd)->window;
		if(window != NULL){

			ShowWidget(window, "counters");
			wnd->ccinfo_dlg = CreateCCInfoDlg(&wnd->dialog);

			ShowWidget(window, "utility1");
			ShowWidget(window, "cleaning3");

			ShowWidget(window, "device_settings2");
			ShowWidget(window, "drawer_settings");

			wnd->regipaper_dlg = CreateRegiPaperDlg(UI_DIALOG(wnd));

			ShowWidget(window, "multi_purpose_tray_settings1");
			wnd->multitray_dlg = CreateMultiTrayDlg(UI_DIALOG(wnd));

			ShowWidget(window, "settings_of_the_cancel_job_key1");
			wnd->cancelkey_dlg = CreateCancelJobKeyDlg(UI_DIALOG(wnd));

			ShowWidget(window, "sleep_settings1");
			wnd->sleeps_dlg = CreateSleepSettingDlg(UI_DIALOG(wnd));

			ShowWidget(window, "network_settings1");
			wnd->networks_dlg = CreateNetworkSDlg(UI_DIALOG(wnd));

			ShowWidget(window, "assisting_print_setting1");
			wnd->asstprts_dlg = CreateAsstPrtSDlg(UI_DIALOG(wnd));

			wnd->nic_flag = PRINTER_INFO_NIC_ON;

			HideWidget(window, "CaptStatusUIPause_togglebutton");
			HideWidget(window, "pause_job");
		}
	}
}

void CreateStatusWidgets_LBP6340(UIStatusWnd* const wnd)
{
	GtkWidget *window = NULL;

	if(wnd != NULL){
		window = UI_DIALOG(wnd)->window;
		if(window != NULL){

			ShowWidget(window, "counters");
			wnd->ccinfo_dlg = CreateCCInfoDlg(&wnd->dialog);

			ShowWidget(window, "utility1");
			ShowWidget(window, "cleaning3");

			ShowWidget(window, "device_settings2");
			ShowWidget(window, "drawer_settings");

			wnd->regipaper_dlg = CreateRegiPaperDlg(UI_DIALOG(wnd));

			ShowWidget(window, "multi_purpose_tray_settings1");
			wnd->multitray_dlg = CreateMultiTrayDlg(UI_DIALOG(wnd));

			ShowWidget(window, "settings_of_the_cancel_job_key1");
			wnd->cancelkey_dlg = CreateCancelJobKeyDlg(UI_DIALOG(wnd));

			ShowWidget(window, "sleep_settings1");
			wnd->sleeps_dlg = CreateSleepSettingDlg(UI_DIALOG(wnd));

			ShowWidget(window, "network_settings1");
			wnd->networks_dlg = CreateNetworkSDlg(UI_DIALOG(wnd));


			wnd->nic_flag = PRINTER_INFO_NIC_ON;

			HideWidget(window, "CaptStatusUIPause_togglebutton");
			HideWidget(window, "pause_job");
		}
	}
}

void CreateStatusWidgets_LBP6020(UIStatusWnd* const wnd)
{

	GtkWidget *window = NULL;

	if(wnd != NULL){
		window = UI_DIALOG(wnd)->window;
		if(window != NULL){

			ShowWidget(window, "counters");
			wnd->ccinfo_dlg = CreateCCInfoDlg(&wnd->dialog);

			ShowWidget(window, "utility1");
			ShowWidget(window, "cleaning3");

			ShowWidget(window, "device_settings2");

			ShowWidget(window, "sleep_settings1");
			wnd->sleeps_dlg = CreateSleepSettingDlg(&wnd->dialog);

			HideWidget(window, "CaptStatusUIPause_togglebutton");
			HideWidget(window, "pause_job");
		}
	}
}


static void DisableJobSensitive(GtkWidget *window)
{
	SetBtnWidgetSensitive(window, FALSE, FALSE, FALSE);
	SetBtnWidgetActive(window, FALSE, TRUE);
	SetJobWidgetSensitive(window, FALSE, FALSE, FALSE);
}

static void SetCCINFOSensitive(GtkWidget *window, int flag)
{
	SetWidgetSensitive(window, "consumable_counters1", flag);
	SetWidgetSensitive(window, "counters", flag);
	SetWidgetSensitive(window, "consumables_information1", flag);
}

static void SetUtilMenuSensitive(GtkWidget *window, int flag)
{
	SetWidgetSensitive(window, "cleaning", flag);

	SetWidgetSensitive(window, "cleaning1", flag);
	SetWidgetSensitive(window, "cleaning2", flag);
	SetWidgetSensitive(window, "printing_position_adjustment_print1", flag);
	SetWidgetSensitive(window, "calibration1", flag);
	SetWidgetSensitive(window, "register_colors_correction1", flag);
	SetWidgetSensitive(window, "color_mismatch_correction1", flag);
	SetWidgetSensitive(window, "cleaning3", flag);
}

static void SetUtilMenuDisableExceptCleaning(GtkWidget *window)
{
	SetWidgetSensitive(window, "calibration1", FALSE);
	SetWidgetSensitive(window, "cleaning3", TRUE);
}

static void SetDevMenuSensitive(GtkWidget *window, int flag)
{
	SetWidgetSensitive(window, "device_settings1", flag);

	SetWidgetSensitive(window, "register_paper_size_in_cassettes1", flag);
	SetWidgetSensitive(window, "drawer_settings", flag);
	SetWidgetSensitive(window, "settings_of_the_cancel_job_key1", flag);
	SetWidgetSensitive(window, "sleep_settings1", flag);
	SetWidgetSensitive(window, "startup_settings1", flag);
	SetWidgetSensitive(window, "network_settings1", flag);
	SetWidgetSensitive(window, "assisting_print_setting1", flag);

	SetWidgetSensitive(window, "cassette_settings_1", flag);
	SetWidgetSensitive(window, "drawer_settings_1", flag);
	SetWidgetSensitive(window, "cassette_settings_2", flag);
	SetWidgetSensitive(window, "drawer_settings_2", flag);
	SetWidgetSensitive(window, "printing_position_adjustment1", flag);
	SetWidgetSensitive(window, "cassette_settings", flag);
	SetWidgetSensitive(window, "reset_part_counters1", flag);
	SetWidgetSensitive(window, "multi_purpose_tray_settings1", flag);

	SetWidgetSensitive(window, "power_save_settings", flag);
	SetWidgetSensitive(window, "calibration_settings1", flag);
}


static void SetOptionMenuSensitive_Common(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd)->window;
	unsigned short status_code = cnsktGetStatusCode(wnd->pCnskt);
	char *pCode = wnd->pAlertCode;


	if(pCode != NULL){

		if( (!(strcmp(pCode, "CNChangePaperSize")) ||
			!(strcmp(pCode, "CNInputMediaSupplyEmpty")) ||
			!(strcmp(pCode, "CNInputMediaSupplyEmpty2")) ||
			!(strcmp(pCode, "CNCheckPaper")) ||
			!(strcmp(pCode, "CNCleaningPaper")) ||
			!(strcmp(pCode, "CNPaused")) ) &&
			( wnd->enableJobOperate ) ){
				SetDevMenuSensitive(window, TRUE);
				SetWidgetSensitive(window, "network_settings1", FALSE);
		}
		else if ( !(strcmp(pCode, "CNSleep")) ||
		!(strcmp(pCode, "PrinterReadyToPrint")) ){
			SetDevMenuSensitive(window, TRUE);
		}
		else {
			SetDevMenuSensitive(window, FALSE);
		}




		if (!(strcmp(pCode, "PrinterReadyToPrint")) ||
			!(strcmp(pCode, "CNSleep"))
		    ) {
		        SetUtilMenuSensitive(window, TRUE);
				if(wnd->nModel == MODEL_LBP7010){
					SetWidgetSensitive(window, "toner_cartridge_replacement1", TRUE);
				}
		}else if(!(strcmp(pCode, "CNServiceError")) ||
				!(strcmp(pCode, "CNJam")) ||
				!(strcmp(pCode, "CNJam2")) ||
				!(strcmp(pCode, "CNDrumMemError")) ||
				!(strcmp(pCode, "CNCoverOpen")) ||
				!(strcmp(pCode, "CNDrumOut")) ||
				!(strcmp(pCode, "CNDataXferError")) ||
				!(strcmp(pCode, "CNMissPrint")) ||
				!(strcmp(pCode, "CNCalibError")) ||
				!(strcmp(pCode, "CNReadyTonerOpenC")) ||
				!(strcmp(pCode, "CNReadyTonerOpenM")) ||
				!(strcmp(pCode, "CNReadyTonerOpenY")) ||
				!(strcmp(pCode, "CNReadyTonerOpenK")) ||
				!(strcmp(pCode, "CNReadyTonerCloseC")) ||
				!(strcmp(pCode, "CNReadyTonerCloseM")) ||
				!(strcmp(pCode, "CNReadyTonerCloseY")) ||
				!(strcmp(pCode, "CNReadyTonerCloseK")) ||
				!(strcmp(pCode, "CNWrongTonerC")) ||
				!(strcmp(pCode, "CNWrongTonerM")) ||
				!(strcmp(pCode, "CNWrongTonerY")) ||
				!(strcmp(pCode, "CNWrongTonerK"))){
			SetUtilMenuSensitive(window, FALSE);
			if(wnd->nModel == MODEL_LBP7010){
				SetWidgetSensitive(window, "toner_cartridge_replacement1", TRUE);
			}
		}else if(!(strcmp(pCode, "CNWaitCleaning"))){
			if(wnd->nModel == MODEL_LBP7010){
				SetWidgetSensitive(window, "toner_cartridge_replacement1", FALSE);
				SetUtilMenuDisableExceptCleaning(window);
			}
		} else {
		        SetUtilMenuSensitive(window, FALSE);
				if(wnd->nModel == MODEL_LBP7010){
					SetWidgetSensitive(window, "toner_cartridge_replacement1", FALSE);
				}

			if ( wnd->nModel == MODEL_LBP5100 ) {
				if (!(strcmp(pCode, "CNTonerOut")) && !(status_code & CCPD_SB_CRITICAL)) {
				        SetUtilMenuSensitive(window, TRUE);
				}
			}
		}

		if(wnd->nModel == MODEL_LBP7010){
			if(!(status_code & CCPD_SB_SETTINGS)){
				SetWidgetSensitive(window, "toner_cartridge_replacement1", FALSE);
			}
		}

if(wnd->ccinfo_dlg != NULL){
		if (!(strcmp(pCode, "CNCheckingStatus")) ||
			!(strcmp(pCode, "CNPrinterCommError")) ||
			!(strcmp(pCode, "CNAdapterCommError")) ||
			!(strcmp(pCode, "CNPrinterPortBusy")) ||
			!(strcmp(pCode, "CNInvalidPort")) ||
			!(strcmp(pCode, "CNIncompatiblePrinter")) ||
			!(strcmp(pCode, "CNIPBlock")) ||
			!(strcmp(pCode, "CNDiskFull")) ||
			!(strcmp(pCode, "CNNoMemory")) ||
			!(strcmp(pCode, "CNShutDown")) ||
			!(strcmp(pCode, "CNFirmUpdate")) ||
			!(strcmp(pCode, "CNCleaning")) ||
			!(strcmp(pCode, "CNPrintCanceled")) ||
			!(strcmp(pCode, "CNPaused")) ||
			!(strcmp(pCode, "CNErrorToServer")) ||
			!(strcmp(pCode, "CNWaiting")) ||
			!(strcmp(pCode, "CNRotateTonerOpen")) ||
			!(strcmp(pCode, "CNRotateTonerClose")) ||
			!(strcmp(pCode, "CNReadyTonerOpenC")) ||
			!(strcmp(pCode, "CNReadyTonerOpenM")) ||
			!(strcmp(pCode, "CNReadyTonerOpenY")) ||
			!(strcmp(pCode, "CNReadyTonerOpenK")) ||
			!(strcmp(pCode, "CNReadyTonerCloseC")) ||
			!(strcmp(pCode, "CNReadyTonerCloseM")) ||
			!(strcmp(pCode, "CNReadyTonerCloseY")) ||
			!(strcmp(pCode, "CNReadyTonerCloseK")) ||
			!(strcmp(pCode, "CNWaitCleaning")) ||
			!(strcmp(pCode, "CNWaitPrinting"))) {
		  SetCCINFOSensitive(window, FALSE);
		}
		else if (!(strcmp(pCode, "CNPrinting"))) {
		  if (( wnd->nModel == MODEL_LBP5100 ) && ( wnd->enableJobOperate )) {
		          SetCCINFOSensitive(window, TRUE);
			}
			else {
			  SetCCINFOSensitive(window, FALSE);
			}
		}
		else {
		  SetCCINFOSensitive(window, TRUE);
		}
 }

	}



}





































static void SetOptionMenuSensitive(UIStatusWnd *wnd)
{
	switch(wnd->nModel){

	case MODEL_LBP3100:
	case MODEL_LBP3050:
	case MODEL_LBP3250:
	case MODEL_LBP3310:
	case MODEL_LBP3500:
	case MODEL_LBP5100:
	case MODEL_LBP5300:
	case MODEL_LBP5050:
	case MODEL_LBP7200:
	case MODEL_LBP9100:
	case MODEL_LBP6300:
	case MODEL_LBP6000:
	case MODEL_LBP6200:
	case MODEL_LBP7010:
	case MODEL_LBP9200:
	case MODEL_LBP6300N:
	case MODEL_LBP6020:
	case MODEL_LBP6310:
	case MODEL_LBP6340:
	case MODEL_LBP7210:
	   SetOptionMenuSensitive_Common(wnd);
	   break;
	default:
	   break;
	}
}

void UpdateWidgets2(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd)->window;

	switch(wnd->nModel){
	case MODEL_LBP3100:
	case MODEL_LBP3050:
	case MODEL_LBP3250:
	case MODEL_LBP3310:
	case MODEL_LBP3500:
	case MODEL_LBP5100:
	case MODEL_LBP5300:
	case MODEL_LBP5050:
	case MODEL_LBP7200:
	case MODEL_LBP9100:
	case MODEL_LBP6300:
	case MODEL_LBP6000:
	case MODEL_LBP6200:
	case MODEL_LBP7010:
	case MODEL_LBP9200:
	case MODEL_LBP6300N:
	case MODEL_LBP6020:
	case MODEL_LBP6310:
	case MODEL_LBP6340:
	case MODEL_LBP7210:
	   	UpdateWidgets_Common(wnd);
	   	break;
	default:
		UpdateWidgets(wnd);
		break;
	}

	if(wnd->isJobDisable == TRUE)
		DisableJobSensitive(window);

	if(wnd->nic_flag == PRINTER_INFO_NIC_CHECK){
		DREQPrtInfo info;
		memset(&info, 0, sizeof(DREQPrtInfo));
		if(GetDREQPrtInfo(wnd, &info) == 0){
			if(info.nNic == TRUE){
				wnd->nic_flag = PRINTER_INFO_NIC_ON;
			}else{
				wnd->nic_flag = PRINTER_INFO_NIC_OFF;
			}
			if(info.pName)
				free(info.pName);
		}
	}

	SetOptionMenuSensitive(wnd);
}





