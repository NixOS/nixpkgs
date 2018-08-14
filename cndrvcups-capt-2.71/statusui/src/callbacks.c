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

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <gtk/gtk.h>

#include "callbacks.h"
#include "interface.h"
#include "support.h"
#include "widgets.h"
#include "data_process.h"
#include "uimain.h"
#include "cleaningdlg.h"

int UpdateJob(long job_num)
{
        int ret = 0;
        ret = StateWidgets(job_num);
	if(ret == 0){
UI_DEBUG("\n");
UI_DEBUG("			UpdateJob <%x>\n", job_num);
UI_DEBUG("\n");
		JobRequest(job_num);
	}
	return ret;
}

void ExitWnd(void)
{
	if(g_status_window->exit == 0){
UI_DEBUG("ExitWnd\n");
		gtk_widget_hide(UI_DIALOG(g_status_window)->window);
		g_status_window->exit = 1;
	}
}

void
on_CaptStatusMonitorWnd_destroy	(GtkObject       *object,
					gpointer	 user_data)
{
UI_DEBUG("destroy\n");
	ExitWnd();
}


gboolean
on_CaptStatusMonitorWnd_delete_event   (GtkWidget       *widget,
					GdkEvent	*event,
					gpointer	 user_data)
{
UI_DEBUG("delete\n");
	ExitWnd();
	return FALSE;
}


void
on_job1_activate		       (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{

}


void
on_pause_job_activate		  (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
	if(SigDisable()){
		int cmd = 0;
		switch(g_status_window->nIFVersion){
		case CCPD_IF_VERSION_110:
			cmd = OPEREQ_PAUSE;
			break;
		case CCPD_IF_VERSION_100:
		default:
			cmd = CCPD_REQ_PAUSE;
			break;
		}
		UpdateJob(cmd);
	}
	SigEnable();
}


void
on_cancel_job_activate		 (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
	if(SigDisable()){
		int cmd = 0;
		switch(g_status_window->nIFVersion){
		case CCPD_IF_VERSION_110:
			cmd = OPEREQ_CANCEL;
			break;
		case CCPD_IF_VERSION_100:
		default:
			cmd = CCPD_REQ_CANCEL;
			break;
		}
		UpdateJob(cmd);
	}
	SigEnable();
}


void
on_CaptStatusUIPause_togglebutton_toggled
					(GtkToggleButton *togglebutton,
					gpointer	 user_data)
{
	if(SigDisable()){
		int cmd = 0;
		switch(g_status_window->nIFVersion){
		case CCPD_IF_VERSION_110:
			cmd = OPEREQ_PAUSE;
			break;
		case CCPD_IF_VERSION_100:
		default:
			cmd = CCPD_REQ_PAUSE;
			break;
		}
		UpdateJob(cmd);
	}
	SigEnable();
}


void
on_CaptStatusUIResume_togglebutton_toggled
					(GtkToggleButton *togglebutton,
					gpointer	 user_data)
{
	if(SigDisable()){
		int cmd = 0;
		switch(g_status_window->nIFVersion){
		case CCPD_IF_VERSION_110:
			cmd = OPEREQ_RESUME;
			break;
		case CCPD_IF_VERSION_100:
		default:
			cmd = CCPD_REQ_RESUME;
			break;
		}
		UpdateJob(cmd);
	}
	SigEnable();
}


void
on_CaptStatusUICancel_button_clicked   (GtkButton       *button,
					gpointer	 user_data)
{
	if(SigDisable()){
		int cmd = 0;
		switch(g_status_window->nIFVersion){
		case CCPD_IF_VERSION_110:
			cmd = OPEREQ_CANCEL;
			break;
		case CCPD_IF_VERSION_100:
		default:
			cmd = CCPD_REQ_CANCEL;
			break;
		}
		UpdateJob(cmd);
	}
	SigEnable();
}


void
on_resume_job_activate		 (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
	if(SigDisable()){
		int cmd = 0;
		switch(g_status_window->nIFVersion){
		case CCPD_IF_VERSION_110:
			cmd = OPEREQ_RESUME;
			break;
		case CCPD_IF_VERSION_100:
		default:
			cmd = CCPD_REQ_RESUME;
			break;
		}
		UpdateJob(cmd);
	}
	SigEnable();
}


void
on_options_activate		    (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{

}


void
on_cleaning_activate		   (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
	if(SigDisable()){
		UpdateJob(CCPD_REQ_CLEANING);
	}
	SigEnable();
}


void
on_CAPTStatusUIHide_button_clicked     (GtkButton       *button,
					gpointer	 user_data)
{
	if(SigDisable()){
		ShowMsgDlg(g_status_window, MSG_TYPE_HIDE_MONITOR);
	}
	SigEnable();
}


void
on_hide_statusmonitor_activate	 (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
	if(SigDisable()){
		ShowMsgDlg(g_status_window, MSG_TYPE_HIDE_MONITOR);
	}
	SigEnable();
}


void
on_cleaning1_activate		  (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
  	switch(g_status_window->nModel){
  	case MODEL_LBP5050:
  	case MODEL_LBP7200:
  	case MODEL_LBP7210:
	  ShowMsgDlg(g_status_window, MSG_TYPE_CLEANING1_DATA);
    	break;
  	default:
		ShowMsgDlg(g_status_window, MSG_TYPE_CLEANING1);
    	break;
  	}
}


void
on_cleaning2_activate		  (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
	switch(g_status_window->nModel){
  	case MODEL_LBP5050:
  	case MODEL_LBP7200:
  	case MODEL_LBP7210:
    		ShowMsgDlg(g_status_window, MSG_TYPE_CLEANING2_CMD);
    	break;
  	default:
		ShowMsgDlg(g_status_window, MSG_TYPE_CLEANING2);
    	break;
  	}


}


void
on_printing_position_adjustment_print1_activate
					(GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
	if(SigDisable()){
UI_DEBUG("PPAP active\n");
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->ppap = TRUE;
  		switch(g_status_window->nModel){
		case MODEL_LBP9100:
		case MODEL_LBP9200:
			UpdateJob(REQ_SHOWDLG_PPAP);
			break;
		default:
			UpdateJob(CCPD_REQ_PRT_INFO);
			break;
		}
	}
	SigEnable();
}


void
on_device_settings1_activate	   (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
	if(SigDisable()){
UI_DEBUG("DevS active\n");
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->dev = TRUE;
		UpdateJob(CCPD_REQ_PRT_INFO);
	}
	SigEnable();
}

void
on_PPAPDlg_MltT_radiobutton_toggled    (GtkToggleButton *togglebutton,
					gpointer	 user_data)
{

}

void
on_PPAPDlg_Cas1_radiobutton_toggled    (GtkToggleButton *togglebutton,
					gpointer	 user_data)
{

}


void
on_PPAPDlg_Cas2_radiobutton_toggled    (GtkToggleButton *togglebutton,
					gpointer	 user_data)
{

}


void
on_PPAPDlg_Cas3_radiobutton_toggled    (GtkToggleButton *togglebutton,
					gpointer	 user_data)
{

}


void
on_PPAPDlg_Cas4_radiobutton_toggled    (GtkToggleButton *togglebutton,
					gpointer	 user_data)
{

}


void
on_CheckDuplexUnit_checkbutton_toggled (GtkToggleButton *togglebutton,
					gpointer	 user_data)
{

}


void
on_PPAPDlg_OK_button_clicked	   (GtkButton       *button,
					gpointer	 user_data)
{
	PPAPDlgOK(g_status_window);
}


void
on_PPAPDlg_Cancel_button_clicked       (GtkButton       *button,
					gpointer	 user_data)
{
	PPAPDlgCancel(g_status_window);
}


void
on_DevDlg_2Mode_checkbutton_toggled    (GtkToggleButton *togglebutton,
					gpointer	 user_data)
{

}


void
on_DevDlg_GraMode_checkbutton_toggled  (GtkToggleButton *togglebutton,
					gpointer	 user_data)
{

}


void
on_DevDlg_FlkMode_checkbutton_toggled  (GtkToggleButton *togglebutton,
					gpointer	 user_data)
{

}


void
on_DevDlg_MltT_spinbutton_changed      (GtkEditable     *editable,
					gpointer	 user_data)
{

}


void
on_DevDlg_Cas1_spinbutton_changed      (GtkEditable     *editable,
					gpointer	 user_data)
{

}


void
on_DevDlg_Cas2_spinbutton_changed      (GtkEditable     *editable,
					gpointer	 user_data)
{

}


void
on_DevDlg_Cas3_spinbutton_changed      (GtkEditable     *editable,
					gpointer	 user_data)
{

}


void
on_DevDlg_Cas4_spinbutton_changed      (GtkEditable     *editable,
					gpointer	 user_data)
{

}


void
on_DevDlg_Dplx_spinbutton_changed      (GtkEditable     *editable,
					gpointer	 user_data)
{

}


void
on_DevDlg_OK_button_clicked	    (GtkButton       *button,
					gpointer	 user_data)
{
	DevDlgOK(g_status_window);
}


void
on_DevDlg_Cancel_button_clicked	(GtkButton       *button,
					gpointer	 user_data)
{
	DevDlgCancel(g_status_window);
}



void
on_PPAP_dialog_destroy		 (GtkObject       *object,
					gpointer	 user_data)
{
	PPAPDlgCancel(g_status_window);
}


gboolean
on_PPAP_dialog_delete_event	    (GtkWidget       *widget,
					GdkEvent	*event,
					gpointer	 user_data)
{
	PPAPDlgCancel(g_status_window);

	return TRUE;
}


gboolean
on_DevS_dialog_delete_event	    (GtkWidget       *widget,
					GdkEvent	*event,
					gpointer	 user_data)
{
	DevDlgCancel(g_status_window);
	return TRUE;
}


void
on_DevS_dialog_destroy		 (GtkObject       *object,
					gpointer	 user_data)
{
	DevDlgCancel(g_status_window);
}


void
on_Msg_dialog_destroy		  (GtkObject       *object,
					gpointer	 user_data)
{

}


gboolean
on_Msg_dialog_delete_event	     (GtkWidget       *widget,
					GdkEvent	*event,
					gpointer	 user_data)
{
	HideMsgDlg(g_status_window);
  return FALSE;
}


void
on_MsgDlg_OK_button_clicked	    (GtkButton       *button,
					gpointer	 user_data)
{
	GdkEvent* cur_event = gtk_get_current_event();

 	if ((cur_event->motion.state & GDK_CONTROL_MASK) == GDK_CONTROL_MASK) {
   		g_status_window->nControlKeyFlag=1;

 	}else{
   		g_status_window->nControlKeyFlag=0;
 	}

	MsgDlgOK(g_status_window);
}


void
on_MsgDlg_Cancel_button_clicked	(GtkButton       *button,
					gpointer	 user_data)
{
	MsgDlgCancel(g_status_window);
}


void
on_consumable_counters1_activate       (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_CCINFO);
	}
	SigEnable();
}


void
on_calibration1_activate	       (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
  	switch(g_status_window->nModel){
  	case MODEL_LBP5050:
  	case MODEL_LBP7200:
  	case MODEL_LBP7210:
  	case MODEL_LBP9100:
	case MODEL_LBP7010:
	case MODEL_LBP9200:
    	ShowMsgDlg(g_status_window, MSG_TYPE_DEVREQ_CALIB);
    	break;
  	default:
		ShowMsgDlg(g_status_window, MSG_TYPE_CALIBRATION);
    	break;
  	}


}

void
on_register_paper_size_in_cassettes1_activate
					(GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_REGIPAPER);
	}
	SigEnable();
}


void
on_sleep_settings1_activate	    (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_SLEEPS);
	}
	SigEnable();
}


void
on_network_settings1_activate	  (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_NETWORKS);
	}
	SigEnable();
}

static gboolean g_RegiPaperCas1_changed = FALSE;
static gboolean g_RegiPaperCas1_mapped = FALSE;
static gboolean g_RegiPaperCas2_changed = FALSE;
static gboolean g_RegiPaperCas2_mapped = FALSE;
static gboolean g_RegiPaperCas3_changed = FALSE;
static gboolean g_RegiPaperCas3_mapped = FALSE;
static gboolean g_RegiPaperCas4_changed = FALSE;
static gboolean g_RegiPaperCas4_mapped = FALSE;

void
on_RegiPaper_Cas1_combo_entry_changed  (GtkEditable     *editable,
					gpointer	 user_data)
{
	if(SigDisable()){
		g_RegiPaperCas1_changed = TRUE;
		if(!g_RegiPaperCas1_mapped){
			g_RegiPaperCas1_changed = FALSE;
		}
	}
	SigEnable();
}

gboolean
on_RegiPaper_Cas1_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_RegiPaperCas1_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_RegiPaperCas1_mapped = FALSE;
		if(SigDisable()){
			g_RegiPaperCas1_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_RegiPaper_Cas2_combo_entry_changed  (GtkEditable     *editable,
					gpointer	 user_data)
{
	if(SigDisable()){
		g_RegiPaperCas2_changed = TRUE;
		if(!g_RegiPaperCas2_mapped){
			g_RegiPaperCas2_changed = FALSE;
		}
	}
	SigEnable();
}

gboolean
on_RegiPaper_Cas2_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_RegiPaperCas2_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_RegiPaperCas2_mapped = FALSE;
		if(SigDisable()){
			g_RegiPaperCas2_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}

void
on_RegiPaper_Cas3_combo_entry_changed  (GtkEditable     *editable,
					gpointer	 user_data)
{
	if(SigDisable()){
		g_RegiPaperCas3_changed = TRUE;
		if(!g_RegiPaperCas3_mapped){
			g_RegiPaperCas3_changed = FALSE;
		}
	}
	SigEnable();
}

gboolean
on_RegiPaper_Cas3_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_RegiPaperCas3_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_RegiPaperCas3_mapped = FALSE;
		if(SigDisable()){
			g_RegiPaperCas3_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}

void
on_RegiPaper_Cas4_combo_entry_changed  (GtkEditable     *editable,
					gpointer	 user_data)
{
	if(SigDisable()){
		g_RegiPaperCas4_changed = TRUE;
		if(!g_RegiPaperCas4_mapped){
			g_RegiPaperCas4_changed = FALSE;
		}
	}
	SigEnable();
}

gboolean
on_RegiPaper_Cas4_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_RegiPaperCas4_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_RegiPaperCas4_mapped = FALSE;
		if(SigDisable()){
			g_RegiPaperCas4_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}

void
on_RegiPaper_OK_clicked		(GtkButton       *button,
					gpointer	 user_data)
{
	switch(g_status_window->nIFVersion){
	case CCPD_IF_VERSION_110:
		RegiPaperDlgOK2(g_status_window);
		break;
	case CCPD_IF_VERSION_100:
	default:
		RegiPaperDlgOK(g_status_window);
		break;
	}
}


void
on_RegiPaper_Cancel_clicked	    (GtkButton       *button,
					gpointer	 user_data)
{
	HideRegiPaperDlg(g_status_window);
}


void
on_CCDlg_OK_button_clicked	     (GtkButton       *button,
					gpointer	 user_data)
{
	HideCCInfoDlg(g_status_window);
}



void
on_RegiPaper_dialog_destroy	    (GtkObject       *object,
					gpointer	 user_data)
{

}


gboolean
on_RegiPaper_dialog_delete_event       (GtkWidget       *widget,
					GdkEvent	*event,
					gpointer	 user_data)
{
	HideRegiPaperDlg(g_status_window);
	return TRUE;
}


void
on_ConsumablesCounters_dialog_destroy  (GtkObject       *object,
					gpointer	 user_data)
{

}


gboolean
on_ConsumablesCounters_dialog_delete_event
					(GtkWidget       *widget,
					GdkEvent	*event,
					gpointer	 user_data)
{
	HideCCInfoDlg(g_status_window);
  return TRUE;
}


gboolean
on_SleepS_dialog_delete_event	  (GtkWidget       *widget,
					GdkEvent	*event,
					gpointer	 user_data)
{
	HideSleepSettingDlg(g_status_window);
	return TRUE;
}


void
on_SleepS_dialog_destroy	       (GtkObject       *object,
					gpointer	 user_data)
{

}


void
on_SleepSDlg_Use_checkbutton_toggled   (GtkToggleButton *togglebutton,
					gpointer	 user_data)
{
	if(SigDisable()){
		UpdateSleepSettingDlgWidgets(g_status_window, (int)togglebutton->active);
	}
	SigEnable();
}

static gboolean g_SleepTime_changed = FALSE;
static gboolean g_SleepTime_mapped = FALSE;

void
on_SleepSDlg_Time_combo_entry_changed  (GtkEditable     *editable,
					gpointer	 user_data)
{
	if(SigDisable()){
		g_SleepTime_changed = TRUE;
		if(!g_SleepTime_mapped){
			g_SleepTime_changed = FALSE;
		}
	}
	SigEnable();

}

gboolean
on_SleepSDlg_Time_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_SleepTime_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_SleepTime_mapped = FALSE;
		if(SigDisable()){
			g_SleepTime_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_SleepSDlg_OK_button_clicked	 (GtkButton       *button,
					gpointer	 user_data)
{
	SleepSettingDlgOK(g_status_window);
}


void
on_SleepSDlg_Cancel_button_clicked     (GtkButton       *button,
					gpointer	 user_data)
{
	HideSleepSettingDlg(g_status_window);
}


gboolean
on_CancelJobKeyDlg_dialog_delete_event (GtkWidget       *widget,
					GdkEvent	*event,
					gpointer	 user_data)
{
	HideCancelJobKeyDlg(g_status_window);
	return TRUE;
}


void
on_CancelJobKeyDlg_dialog_destroy      (GtkObject       *object,
					gpointer	 user_data)
{

}


void
on_CJKDlg_ErrorJob_checkbutton_toggled (GtkToggleButton *togglebutton,
					gpointer	 user_data)
{
	if(SigDisable()){
		UpdateCancelJobKeyDlgWidgets(g_status_window, (int)togglebutton->active);
	}
	SigEnable();
}


void
on_CJKDlg_PrintJob_checkbutton_toggled (GtkToggleButton *togglebutton,
					gpointer	 user_data)
{

}


void
on_CJKDlg_OK_button_clicked	    (GtkButton       *button,
					gpointer	 user_data)
{
	CancelJobKeyDlgOK(g_status_window);
}


void
on_CJKDlg_Cancel_button_clicked	(GtkButton       *button,
					gpointer	 user_data)
{
	HideCancelJobKeyDlg(g_status_window);
}


void
on_cleaning3_activate		  (GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
	switch(g_status_window->nModel){
	case MODEL_LBP3250:
	case MODEL_LBP3100:
	case MODEL_LBP3050:
	case MODEL_LBP6000:
	case MODEL_LBP6020:
	case MODEL_LBP6200:
		ShowMsgDlg(g_status_window, MSG_TYPE_CLEANING);
		break;
	case MODEL_LBP3300:
		ShowMsgDlg(g_status_window, MSG_TYPE_CLEANING_3300);
		break;
	case MODEL_LBP3500:
	case MODEL_LBP5300:
	case MODEL_LBP5100:
	case MODEL_LBP3310:
	case MODEL_LBP9100:
	case MODEL_LBP6300:
	case MODEL_LBP6310:
	case MODEL_LBP6340:
	case MODEL_LBP9200:
	case MODEL_LBP6300N:
	case MODEL_LBP5000:
		ShowMsgDlg(g_status_window, MSG_TYPE_CLEANING_DATA);
		break;
	case MODEL_LBP7010:
		if(SigDisable()){
			SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
			SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
			g_status_window->bMenuDisable = 1;
			UpdateJob(REQ_SHOWDLG_CLEANING);
		}
		SigEnable();
		break;
	}
}



void
on_settings_of_the_cancel_job_key1_activate
					(GtkMenuItem     *menuitem,
					gpointer	 user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_CANCELJOB);
	}
	SigEnable();
}





void
on_NetworkSDlg_RARP_checkbutton_toggled
					(GtkToggleButton *togglebutton,
					gpointer	 user_data)
{
	if(SigDisable()){
		g_status_window->networks_dlg->bRARP = togglebutton->active;
		UpdateNetWorkSDlgWidgets(g_status_window, 1);
	}
	SigEnable();
}


void
on_NetworkSDlg_BOOTP_checkbutton_toggled
					(GtkToggleButton *togglebutton,
					gpointer	 user_data)
{
	if(SigDisable()){
		g_status_window->networks_dlg->bBOOTP = togglebutton->active;
		UpdateNetWorkSDlgWidgets(g_status_window, 3);
	}
	SigEnable();
}


void
on_NetworkSDlg_DHCP_checkbutton_toggled
					(GtkToggleButton *togglebutton,
					gpointer	 user_data)
{
	if(SigDisable()){
		g_status_window->networks_dlg->bDHCP = togglebutton->active;
		UpdateNetWorkSDlgWidgets(g_status_window, 2);
	}
	SigEnable();
}


static gboolean g_IPSetting_changed = FALSE;
static gboolean g_IPSetting_mapped = FALSE;

void
on_NetworkSDlg_IPSetting_combo_entry_changed
					(GtkEditable     *editable,
					gpointer	 user_data)
{
	if(SigDisable()){
		g_IPSetting_changed = TRUE;
		if(!g_IPSetting_mapped){
			UpdateNetWorkSDlgWidgets(g_status_window, 0);
			g_IPSetting_changed = FALSE;
		}
	}
	SigEnable();
}

gboolean
on_NetworkSDlg_IPSetting_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_IPSetting_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_IPSetting_mapped = FALSE;
		if(SigDisable()){
			UpdateNetWorkSDlgWidgets(g_status_window, 0);
			g_IPSetting_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


gboolean
on_NetworkSDlg_IP1_entry_focus_out_event
					(GtkWidget       *widget,
					GdkEventFocus   *event,
					gpointer	 user_data)
{
	if(SigDisable()){
		CheckNetIPEntry(g_status_window, "NetworkSDlg_IP1_entry");
	}
	SigEnable();
  return FALSE;
}


gboolean
on_NetworkSDlg_IP2_entry_focus_out_event
					(GtkWidget       *widget,
					GdkEventFocus   *event,
					gpointer	 user_data)
{
	if(SigDisable()){
		CheckNetIPEntry(g_status_window, "NetworkSDlg_IP2_entry");
	}
	SigEnable();

  return FALSE;
}


gboolean
on_NetworkSDlg_IP3_entry_focus_out_event
					(GtkWidget       *widget,
					GdkEventFocus   *event,
					gpointer	 user_data)
{
	if(SigDisable()){
		CheckNetIPEntry(g_status_window, "NetworkSDlg_IP3_entry");
	}
	SigEnable();

  return FALSE;
}


gboolean
on_NetworkSDlg_IP4_entry_focus_out_event
					(GtkWidget       *widget,
					GdkEventFocus   *event,
					gpointer	 user_data)
{
	if(SigDisable()){
		CheckNetIPEntry(g_status_window, "NetworkSDlg_IP4_entry");
	}
	SigEnable();

  return FALSE;
}


gboolean
on_NetworkSDlg_Sub1_entry_focus_out_event
					(GtkWidget       *widget,
					GdkEventFocus   *event,
					gpointer	 user_data)
{
	if(SigDisable()){
		CheckNetIPEntry(g_status_window, "NetworkSDlg_Sub1_entry");
	}
	SigEnable();

  return FALSE;
}


gboolean
on_NetworkSDlg_Sub2_entry_focus_out_event
					(GtkWidget       *widget,
					GdkEventFocus   *event,
					gpointer	 user_data)
{
	if(SigDisable()){
		CheckNetIPEntry(g_status_window, "NetworkSDlg_Sub2_entry");
	}
	SigEnable();

  return FALSE;
}


gboolean
on_NetworkSDlg_Sub3_entry_focus_out_event
					(GtkWidget       *widget,
					GdkEventFocus   *event,
					gpointer	 user_data)
{
	if(SigDisable()){
		CheckNetIPEntry(g_status_window, "NetworkSDlg_Sub3_entry");
	}
	SigEnable();

  return FALSE;
}


gboolean
on_NetworkSDlg_Sub4_entry_focus_out_event
					(GtkWidget       *widget,
					GdkEventFocus   *event,
					gpointer	 user_data)
{
	if(SigDisable()){
		CheckNetIPEntry(g_status_window, "NetworkSDlg_Sub4_entry");
	}
	SigEnable();

  return FALSE;
}


gboolean
on_NetworkSDlg_Gate1_entry_focus_out_event
					(GtkWidget       *widget,
					GdkEventFocus   *event,
					gpointer	 user_data)
{
	if(SigDisable()){
		CheckNetIPEntry(g_status_window, "NetworkSDlg_Gate1_entry");
	}
	SigEnable();

  return FALSE;
}


gboolean
on_NetworkSDlg_Gate2_entry_focus_out_event
					(GtkWidget       *widget,
					GdkEventFocus   *event,
					gpointer	 user_data)
{
	if(SigDisable()){
		CheckNetIPEntry(g_status_window, "NetworkSDlg_Gate2_entry");
	}
	SigEnable();

  return FALSE;
}


gboolean
on_NetworkSDlg_Gate3_entry_focus_out_event
					(GtkWidget       *widget,
					GdkEventFocus   *event,
					gpointer	 user_data)
{
	if(SigDisable()){
		CheckNetIPEntry(g_status_window, "NetworkSDlg_Gate3_entry");
	}
	SigEnable();

  return FALSE;
}


gboolean
on_NetworkSDlg_Gate4_entry_focus_out_event
					(GtkWidget       *widget,
					GdkEventFocus   *event,
					gpointer	 user_data)
{
	if(SigDisable()){
		CheckNetIPEntry(g_status_window, "NetworkSDlg_Gate4_entry");
	}
	SigEnable();

  return FALSE;
}


gboolean
on_NetworkSDlg_Password_entry_focus_out_event
					(GtkWidget       *widget,
					GdkEventFocus   *event,
					gpointer	 user_data)
{
	if(SigDisable()){
	}
	SigEnable();
  return FALSE;
}


void
on_NetworkSDlg_Password_entry_changed  (GtkEditable     *editable,
					gpointer	 user_data)
{
	if(SigDisable()){
	}
	SigEnable();
}


void
on_NetWorkSDlg_OK_button_clicked       (GtkButton       *button,
					gpointer	 user_data)
{
	NetWorkSDlgOK(g_status_window);
}


void
on_NetworkSDlg_button_clicked	  (GtkButton       *button,
					gpointer	 user_data)
{
	HideNetWorkSDlg(g_status_window);
}


gboolean
on_NetworkSDlg_dialog_delete_event     (GtkWidget       *widget,
					GdkEvent	*event,
					gpointer	 user_data)
{

	HideNetWorkSDlg(g_status_window);
	return TRUE;
}


void
on_NetworkSDlg_dialog_destroy	  (GtkObject       *object,
					gpointer	 user_data)
{

}




void
on_register_colors_correction1_activate
                                        (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	ShowMsgDlg(g_status_window, MSG_TYPE_DEVREQ_REGICLR);
}


void
on_assisting_print_setting1_activate   (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_ASSTPRT);
	}
	SigEnable();
}


gboolean
on_AsstPrtSDlg_dialog_delete_event     (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data)
{
	HideAsstPrtSDlg(g_status_window);
	return TRUE;
}


void
on_AsstPrtSDlg_dialog_destroy          (GtkObject       *object,
                                        gpointer         user_data)
{

}


void
on_AsstPrtSDlg_highspeed_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data)
{
	if(SigDisable()){
		UpdateAsstPrtSDlgWidgets(g_status_window, (int)togglebutton->active);
	}
	SigEnable();
}

static gboolean g_AsstPrtMode_changed = FALSE;
static gboolean g_AsstPrtMode_mapped = FALSE;


void
on_AsstPrtSDlg_mode_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_AsstPrtMode_changed = TRUE;
		if(!g_AsstPrtMode_mapped){
			g_AsstPrtMode_changed = FALSE;
		}
	}
	SigEnable();
}

gboolean
on_AsstPrtSDlg_mode_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_AsstPrtMode_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_AsstPrtMode_mapped = FALSE;
		if(SigDisable()){
			g_AsstPrtMode_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_AsstPrtSDlg_OK_button_clicked       (GtkButton       *button,
                                        gpointer         user_data)
{
	AsstPrtSDlgOK(g_status_window);
}


void
on_AsstPrtSDlg_Cancel_button_clicked   (GtkButton       *button,
                                        gpointer         user_data)
{
	HideAsstPrtSDlg(g_status_window);
}


void
on_AsstPrtSDlg_ReduceStreaks_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data)
{
	if(SigDisable()){
		UpdateAsstPrtSDlgWidgets(g_status_window, (int)togglebutton->active);
	}

	SigEnable();

}

static gboolean g_StartupSettingsQualityCorr_changed = FALSE;
static gboolean g_StartupSettingsQualityCorr_mapped = FALSE;

void
on_startup_settings1_activate          (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_STARTUPSET);
	}
	SigEnable();
}


void
on_AsstPrtSDlg_preventpoorquality_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data)
{
	if(SigDisable()){
		UpdateAsstPrtSDlgWidgets(g_status_window, (int)togglebutton->active);
	}

	SigEnable();
}


void
on_AsstPrtSDlg_cleanevery2sheets_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data)
{
	if(SigDisable()){
		UpdateAsstPrtSDlgWidgets(g_status_window, (int)togglebutton->active);
	}

	SigEnable();
}


gboolean
on_StartupSettingsDlg_dialog_delete_event
                                        (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data)
{
	HideStartupSettingsDlg(g_status_window);
	return TRUE;
}


void
on_StartupSettingsDlg_dialog_destroy   (GtkObject       *object,
                                        gpointer         user_data)
{

}


void
on_StartupSettingsDlg_QualityCorr_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_StartupSettingsQualityCorr_changed = TRUE;
		if(!g_StartupSettingsQualityCorr_mapped){
			g_StartupSettingsQualityCorr_changed = FALSE;
		}
	}
	SigEnable();
}


void
on_StartupSettingsDlg_OK_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data)
{
	StartupSettingsDlgOK(g_status_window);
}


void
on_StartupSettingsDlg_Cancel_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data)
{
	HideStartupSettingsDlg(g_status_window);
}

gboolean
on_StartupSettingsDlg_QualityCorr_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_StartupSettingsQualityCorr_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_StartupSettingsQualityCorr_mapped = FALSE;
		if(SigDisable()){
			g_StartupSettingsQualityCorr_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}

void
on_cassette_settings_activate         (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_REGIPAPER);
	}
	SigEnable();
}

void
on_cassette_settings_1_activate        (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_REGIPAPER);
	}
	SigEnable();
}


void
on_cassette_settings_2_activate        (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_CASSETTESET2);
	}
	SigEnable();
}


void
on_CassetteSet2Dlg_dialog_destroy      (GtkObject       *object,
                                        gpointer         user_data)
{

}


gboolean
on_CassetteSet2Dlg_dialog_delete_event (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data)
{
	HideCassetteSet2Dlg(g_status_window);
	return TRUE;
}


void
on_CassetteSet2Dlg_OK_clicked          (GtkButton       *button,
                                        gpointer         user_data)
{
	CassetteSet2DlgOK(g_status_window);
}


void
on_CassetteSet2Dlg_Cancel_clicked      (GtkButton       *button,
                                        gpointer         user_data)
{
	HideCassetteSet2Dlg(g_status_window);
}


void
on_multi_purpose_tray_activate         (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_MULTITRAY);
	}
	SigEnable();
}


gboolean
on_MultiTrayDlg_dialog_delete_event    (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data)
{
	HideMultiTrayDlg(g_status_window);
	return TRUE;
}


void
on_MultiTrayDlg_dialog_destroy         (GtkObject       *object,
                                        gpointer         user_data)
{

}


void
on_MultiTrayDlg_OK_button_clicked      (GtkButton       *button,
                                        gpointer         user_data)
{
	MultiTrayDlgOK(g_status_window);
}


void
on_MultiTrayDlg_Cancel_button_clicked  (GtkButton       *button,
                                        gpointer         user_data)
{
	HideMultiTrayDlg(g_status_window);
}

static gboolean g_PPAVHVerMulti_changed = FALSE;
static gboolean g_PPAVHVerMulti_mapped = FALSE;
static gboolean g_PPAVHVerCas1_changed = FALSE;
static gboolean g_PPAVHVerCas1_mapped = FALSE;
static gboolean g_PPAVHVerCas2_changed = FALSE;
static gboolean g_PPAVHVerCas2_mapped = FALSE;
static gboolean g_PPAVHVerCas3_changed = FALSE;
static gboolean g_PPAVHVerCas3_mapped = FALSE;
static gboolean g_PPAVHVerCas4_changed = FALSE;
static gboolean g_PPAVHVerCas4_mapped = FALSE;
static gboolean g_PPAVHVerDuplex_changed = FALSE;
static gboolean g_PPAVHVerDuplex_mapped = FALSE;

static gboolean g_PPAVHHorMulti_changed = FALSE;
static gboolean g_PPAVHHorMulti_mapped = FALSE;
static gboolean g_PPAVHHorCas1_changed = FALSE;
static gboolean g_PPAVHHorCas1_mapped = FALSE;
static gboolean g_PPAVHHorCas2_changed = FALSE;
static gboolean g_PPAVHHorCas2_mapped = FALSE;
static gboolean g_PPAVHHorCas3_changed = FALSE;
static gboolean g_PPAVHHorCas3_mapped = FALSE;
static gboolean g_PPAVHHorCas4_changed = FALSE;
static gboolean g_PPAVHHorCas4_mapped = FALSE;
static gboolean g_PPAVHHorDuplex_changed = FALSE;
static gboolean g_PPAVHHorDuplex_mapped = FALSE;

void
on_printing_position_adjustment_activate
                                        (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_PPAVH);
	}
	SigEnable();
}


gboolean
on_PPAVHDlg_dialog_delete_event        (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data)
{
	HidePPAVHDlg(g_status_window);
	return TRUE;
}


void
on_PPAVHDlg_dialog_destroy             (GtkObject       *object,
                                        gpointer         user_data)
{

}


void
on_PPAVHDlg_OK_button_clicked          (GtkButton       *button,
                                        gpointer         user_data)
{
	PPAVHDlgOK(g_status_window);
}


void
on_PPAVHDlg_Cancel_button_clicked      (GtkButton       *button,
                                        gpointer         user_data)
{
	HidePPAVHDlg(g_status_window);
}


void
on_PPAVHDlg_Vertical_Multi_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_PPAVHVerMulti_changed = TRUE;
		if(!g_PPAVHVerMulti_mapped){
			g_PPAVHVerMulti_changed = FALSE;
		}
	}
	SigEnable();

}


gboolean
on_PPAVHDlg_Vertical_Multi_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_PPAVHVerMulti_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_PPAVHVerMulti_mapped = FALSE;
		if(SigDisable()){
			g_PPAVHVerMulti_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_PPAVHDlg_Vertical_Cas1_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_PPAVHVerCas1_changed = TRUE;
		if(!g_PPAVHVerCas1_mapped){
			g_PPAVHVerCas1_changed = FALSE;
		}
	}
	SigEnable();

}


gboolean
on_PPAVHDlg_Vertical_Cas1_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_PPAVHVerCas1_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_PPAVHVerCas1_mapped = FALSE;
		if(SigDisable()){
			g_PPAVHVerCas1_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_PPAVHDlg_Vertical_Cas2_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_PPAVHVerCas2_changed = TRUE;
		if(!g_PPAVHVerCas2_mapped){
			g_PPAVHVerCas2_changed = FALSE;
		}
	}
	SigEnable();

}


gboolean
on_PPAVHDlg_Vertical_Cas2_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_PPAVHVerCas2_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_PPAVHVerCas2_mapped = FALSE;
		if(SigDisable()){
			g_PPAVHVerCas2_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_PPAVHDlg_Vertical_Cas3_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_PPAVHVerCas3_changed = TRUE;
		if(!g_PPAVHVerCas3_mapped){
			g_PPAVHVerCas3_changed = FALSE;
		}
	}
	SigEnable();

}


gboolean
on_PPAVHDlg_Vertical_Cas3_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_PPAVHVerCas3_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_PPAVHVerCas3_mapped = FALSE;
		if(SigDisable()){
			g_PPAVHVerCas3_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_PPAVHDlg_Vertical_Cas4_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_PPAVHVerCas4_changed = TRUE;
		if(!g_PPAVHVerCas4_mapped){
			g_PPAVHVerCas4_changed = FALSE;
		}
	}
	SigEnable();

}


gboolean
on_PPAVHDlg_Vertical_Cas4_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_PPAVHVerCas4_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_PPAVHVerCas4_mapped = FALSE;
		if(SigDisable()){
			g_PPAVHVerCas4_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_PPAVHDlg_Vertical_Duplex_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_PPAVHVerDuplex_changed = TRUE;
		if(!g_PPAVHVerDuplex_mapped){
			g_PPAVHVerDuplex_changed = FALSE;
		}
	}
	SigEnable();

}


gboolean
on_PPAVHDlg_Vertical_Duplex_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_PPAVHVerDuplex_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_PPAVHVerDuplex_mapped = FALSE;
		if(SigDisable()){
			g_PPAVHVerDuplex_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_PPAVHDlg_Horizontal_Multi_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_PPAVHHorMulti_changed = TRUE;
		if(!g_PPAVHHorMulti_mapped){
			g_PPAVHHorMulti_changed = FALSE;
		}
	}
	SigEnable();

}


gboolean
on_PPAVHDlg_Horizontal_Multi_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_PPAVHHorMulti_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_PPAVHHorMulti_mapped = FALSE;
		if(SigDisable()){
			g_PPAVHHorMulti_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_PPAVHDlg_Horizontal_Cas1_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_PPAVHHorCas1_changed = TRUE;
		if(!g_PPAVHHorCas1_mapped){
			g_PPAVHHorCas1_changed = FALSE;
		}
	}
	SigEnable();

}


gboolean
on_PPAVHDlg_Horizontal_Cas1_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_PPAVHHorCas1_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_PPAVHHorCas1_mapped = FALSE;
		if(SigDisable()){
			g_PPAVHHorCas1_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_PPAVHDlg_Horizontal_Cas2_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_PPAVHHorCas2_changed = TRUE;
		if(!g_PPAVHHorCas2_mapped){
			g_PPAVHHorCas2_changed = FALSE;
		}
	}
	SigEnable();

}


gboolean
on_PPAVHDlg_Horizontal_Cas2_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_PPAVHHorCas2_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_PPAVHHorCas2_mapped = FALSE;
		if(SigDisable()){
			g_PPAVHHorCas2_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_PPAVHDlg_Horizontal_Cas3_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_PPAVHHorCas3_changed = TRUE;
		if(!g_PPAVHHorCas3_mapped){
			g_PPAVHHorCas3_changed = FALSE;
		}
	}
	SigEnable();

}


gboolean
on_PPAVHDlg_Horizontal_Cas3_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_PPAVHHorCas3_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_PPAVHHorCas3_mapped = FALSE;
		if(SigDisable()){
			g_PPAVHHorCas3_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_PPAVHDlg_Horizontal_Cas4_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_PPAVHHorCas4_changed = TRUE;
		if(!g_PPAVHHorCas4_mapped){
			g_PPAVHHorCas4_changed = FALSE;
		}
	}
	SigEnable();

}


gboolean
on_PPAVHDlg_Horizontal_Cas4_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_PPAVHHorCas4_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_PPAVHHorCas4_mapped = FALSE;
		if(SigDisable()){
			g_PPAVHHorCas4_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_PPAVHDlg_Horizontal_Duplex_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_PPAVHHorDuplex_changed = TRUE;
		if(!g_PPAVHHorDuplex_mapped){
			g_PPAVHHorDuplex_changed = FALSE;
		}
	}
	SigEnable();

}


gboolean
on_PPAVHDlg_Horizontal_Duplex_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_PPAVHHorDuplex_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_PPAVHHorDuplex_mapped = FALSE;
		if(SigDisable()){
			g_PPAVHHorDuplex_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_reset_unit_activate                 (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_RESETUNIT);
	}
	SigEnable();
}


void
on_ResetUnitDlg_dialog_destroy         (GtkObject       *object,
                                        gpointer         user_data)
{

}


gboolean
on_ResetUnitDlg_dialog_delete_event    (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data)
{
	HideResetUnitDlg(g_status_window);
	return TRUE;
}


void
on_ResetUnitDlg_OK_button_clicked      (GtkButton       *button,
                                        gpointer         user_data)
{
	ResetUnitDlgOK(g_status_window);
}


void
on_ResetUnitDlg_Cancel_button_clicked  (GtkButton       *button,
                                        gpointer         user_data)
{
	HideResetUnitDlg(g_status_window);
}


void
on_AsstPrtSDlg_adjusttemp_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data)
{

}


void
on_AsstPrtSDlg_adjust16k_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data)
{

}


void
on_power_save_settings_activate        (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	int res = 0;
	gboolean resbool = FALSE;

	if(g_status_window != NULL){
	if(SigDisable() == TRUE){
		SetWidgetSensitive(g_status_window->dialog.window, "menubar1", FALSE);
		SetWidgetSensitive(g_status_window->dialog.window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		res = UpdateJob(REQ_SHOWDLG_SLEEPS);
	}
	resbool = SigEnable();
	}
}

void
on_counters_activate                   (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	int res = 0;
	gboolean resbool = FALSE;

	if(g_status_window != NULL){
		if(SigDisable() == TRUE){
			SetWidgetSensitive(g_status_window->dialog.window, "menubar1", FALSE);
			SetWidgetSensitive(g_status_window->dialog.window, "CAPTStatusUIHide_button", FALSE);
			g_status_window->bMenuDisable = 1;
			switch(g_status_window->nModel){
				case MODEL_LBP7010:
				case MODEL_LBP9200:
					res = UpdateJob(REQ_SHOWDLG_COUNTERSINFO);
					break;
				default:
					res = UpdateJob(REQ_SHOWDLG_CCINFO);
					break;
			}
		}
		resbool = SigEnable();
	}
}


void
on_TonerReplacementDlg_Cyan_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data)
{
	RequestRotate(g_status_window, DREQ_ROTATE_CARTRIDGE_C);
}


void
on_TonerReplacementDlg_Magenta_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data)
{
	RequestRotate(g_status_window, DREQ_ROTATE_CARTRIDGE_M);
}


void
on_TonerReplacementDlg_Yellow_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data)
{
	RequestRotate(g_status_window, DREQ_ROTATE_CARTRIDGE_Y);
}


void
on_TonerReplacementDlg_Black_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data)
{
	RequestRotate(g_status_window, DREQ_ROTATE_CARTRIDGE_K);
}


void
on_TonerReplacementDlg_Finish_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data)
{
	TonerReplacementDlgFinish(g_status_window);
}

void
on_CleaningDlg_OK_button_clicked       (GtkButton       *button,
                                        gpointer         user_data)
{
	CleaningDlgOK(g_status_window);
}


void
on_CleaningDlg_Cancel_button_clicked   (GtkButton       *button,
                                        gpointer         user_data)
{
	HideCleaningDlg(g_status_window);
}


void
on_toner_cartridge_replacement1_activate
                                        (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	if(SigDisable()){
		ShowTonerReplacementDlg(g_status_window);
	}
	SigEnable();
}


gboolean
on_TonerReplacementDlg_dialog_delete_event
                                        (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data)
{
  TonerReplacementDlgCancel(g_status_window);
  return TRUE;
}


void
on_TonerReplacementDlg_dialog_destroy  (GtkObject       *object,
                                        gpointer         user_data)
{

}


gboolean
on_CleaningDlg_dialog_delete_event     (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data)
{
  HideCleaningDlg(g_status_window);
  return TRUE;
}


void
on_CleaningDlg_dialog_destroy          (GtkObject       *object,
                                        gpointer         user_data)
{

}


gboolean
on_CalibrationSettingsDlg_dialog_delete_event
                                        (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data)
{
  HideCalibrationSettingsDlg(g_status_window);
  return TRUE;
}


void
on_CalibrationSettingsDlg_dialog_destroy
                                        (GtkObject       *object,
                                        gpointer         user_data)
{

}


void
on_CalibrationSettingsDlg_UseCalibTimer_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data)
{
	if(SigDisable()){
		UpdateCalibrationSettingsDlgWidgets(g_status_window, (int)togglebutton->active);
	}
	SigEnable();
}


void
on_CalibrationSettingsDlg_OK_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data)
{
	CalibrationSettingsDlgOK(g_status_window);
}


void
on_CalibrationSettingsDlg_Cancel_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data)
{
	HideCalibrationSettingsDlg(g_status_window);
}


void
on_calibration_settings1_activate      (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_CALIBRATIONSETTINGS);
	}
	SigEnable();
}


static gboolean g_CalibrationSettingsStartup_changed = FALSE;
static gboolean g_CalibrationSettingsStartup_mapped = FALSE;


gboolean
on_CalibrationSettingsDlg_Startup_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
							 gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_CalibrationSettingsStartup_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_CalibrationSettingsStartup_mapped = FALSE;
		if(SigDisable()){
			g_CalibrationSettingsStartup_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}


void
on_CalibrationSettingsDlg_Startup_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_CalibrationSettingsStartup_changed = TRUE;
		if(!g_CalibrationSettingsStartup_mapped){
			g_CalibrationSettingsStartup_changed = FALSE;
		}
	}
	SigEnable();
}


void
on_consumables_information1_activate   (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{

	int res = 0;
	gboolean resbool = FALSE;

	if(g_status_window != NULL){
		if(SigDisable() == TRUE){
			SetWidgetSensitive(g_status_window->dialog.window, "menubar1", FALSE);
			SetWidgetSensitive(g_status_window->dialog.window, "CAPTStatusUIHide_button", FALSE);
			g_status_window->bMenuDisable = 1;
			res = UpdateJob(REQ_SHOWDLG_CONSUMABLESINFO);
		}
		resbool = SigEnable();
	}
}

static gboolean g_AsstPrtColorMisFrequency_changed = FALSE;
static gboolean g_AsstPrtColorMisFrequency_mapped = FALSE;

gboolean
on_AsstPrtSDlg_colormisfrequency_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
							 gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_AsstPrtColorMisFrequency_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_AsstPrtColorMisFrequency_mapped = FALSE;
		if(SigDisable()){
			g_AsstPrtColorMisFrequency_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}

void
on_AsstPrtSDlg_colormisfrequency_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_AsstPrtColorMisFrequency_changed = TRUE;
		if(!g_AsstPrtColorMisFrequency_mapped){
			g_AsstPrtColorMisFrequency_changed = FALSE;
		}
	}
	SigEnable();
}

static gboolean g_AsstPrtPaperJamReduction_changed = FALSE;
static gboolean g_AsstPrtPaperJamReduction_mapped = FALSE;

gboolean
on_AsstPrtSDlg_paperjamreduction_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
							 gpointer	user_data)
{
	if(event->type == GDK_MAP){
		g_AsstPrtPaperJamReduction_mapped = TRUE;
	}else if(event->type == GDK_UNMAP){
		g_AsstPrtPaperJamReduction_mapped = FALSE;
		if(SigDisable()){
			g_AsstPrtPaperJamReduction_changed = FALSE;
		}
		SigEnable();
	}
	return FALSE;
}

void
on_AsstPrtSDlg_paperjamreduction_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data)
{
	if(SigDisable()){
		g_AsstPrtPaperJamReduction_changed = TRUE;
		if(!g_AsstPrtPaperJamReduction_mapped){
			g_AsstPrtPaperJamReduction_changed = FALSE;
		}
	}
	SigEnable();
}

void
on_color_mismatch_correction1_activate (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	ShowMsgDlg(g_status_window, MSG_TYPE_DEVREQ_CLRMIS);
}


void
on_drawer_settings_1_activate          (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_REGIPAPER);
	}
	SigEnable();
}


void
on_drawer_settings_2_activate          (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_CASSETTESET2);
	}
	SigEnable();
}


void
on_drawer_settings_activate            (GtkMenuItem     *menuitem,
                                        gpointer         user_data)
{
	if(SigDisable()){
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "menubar1", FALSE);
		SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", FALSE);
		g_status_window->bMenuDisable = 1;
		UpdateJob(REQ_SHOWDLG_REGIPAPER);
	}
	SigEnable();
}

