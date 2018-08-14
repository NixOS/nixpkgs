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

#include <gtk/gtk.h>


void
on_CaptStatusMonitorWnd_destroy        (GtkObject       *object,
                                        gpointer         user_data);

gboolean
on_CaptStatusMonitorWnd_delete_event   (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_job1_activate                       (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_pause_job_activate                  (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_cancel_job_activate                 (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_pause_job_activate                  (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_cancel_job_activate                 (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_CaptStatusUIPause_togglebutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_CaptStatusUIResume_togglebutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_CaptStatusUICancel_button_clicked   (GtkButton       *button,
                                        gpointer         user_data);

void
on_resume_job_activate                 (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_options_activate                    (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_cleaning_activate                   (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_CAPTStatusUIHide_button_clicked     (GtkButton       *button,
                                        gpointer         user_data);

void
on_hide_statusmonitor_activate         (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_cleaning1_activate                  (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_cleaning2_activate                  (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_printing_position_adjustment_print1_activate
                                        (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_device_settings1_activate           (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_PPAPDlg_Cas1_radiobutton_toggled    (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_PPAPDlg_Cas2_radiobutton_toggled    (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_PPAPDlg_Cas3_radiobutton_toggled    (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_PPAPDlg_Cas4_radiobutton_toggled    (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_CheckDuplexUnit_checkbutton_toggled (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_PPAPDlg_OK_button_clicked           (GtkButton       *button,
                                        gpointer         user_data);

void
on_PPAPDlg_Cancel_button_clicked       (GtkButton       *button,
                                        gpointer         user_data);

void
on_DevDlg_2Mode_checkbutton_toggled    (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_DevDlg_GraMode_checkbutton_toggled  (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_DevDlg_FlkMode_checkbutton_toggled  (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_DevDlg_MltT_spinbutton_changed      (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_DevDlg_Cas1_spinbutton_changed      (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_DevDlg_Cas2_spinbutton_changed      (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_DevDlg_Cas3_spinbutton_changed      (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_DevDlg_Cas4_spinbutton_changed      (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_DevDlg_Dplx_spinbutton_changed      (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_DevDlg_OK_button_clicked            (GtkButton       *button,
                                        gpointer         user_data);

void
on_DevDlg_Cancel_button_clicked        (GtkButton       *button,
                                        gpointer         user_data);

void
on_PPAPDlg_MltT_radiobutton_toggled    (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_PPAP_dialog_destroy                 (GtkObject       *object,
                                        gpointer         user_data);

gboolean
on_PPAP_dialog_delete_event            (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

gboolean
on_DevS_dialog_delete_event            (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_DevS_dialog_destroy                 (GtkObject       *object,
                                        gpointer         user_data);

void
on_Msg_dialog_destroy                  (GtkObject       *object,
                                        gpointer         user_data);

gboolean
on_Msg_dialog_delete_event             (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_MsgDlg_OK_button_clicked            (GtkButton       *button,
                                        gpointer         user_data);

void
on_MsgDlg_Cancel_button_clicked        (GtkButton       *button,
                                        gpointer         user_data);

void
on_consumable_counters1_activate       (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_calibration1_activate               (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_cleaning4_activate                  (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_register_paper_size_in_cassettes1_activate
                                        (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_sleep_settings1_activate            (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_settings_of_the_cancel_job_key2_activate
                                        (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_network_settings2_activate          (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_RegiPaper_Cas1_combo_entry_changed  (GtkEditable     *editable,
                                        gpointer         user_data);

gboolean
on_RegiPaper_Cas1_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

void
on_RegiPaper_Cas2_combo_entry_changed  (GtkEditable     *editable,
                                        gpointer         user_data);

gboolean
on_RegiPaper_Cas2_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

void
on_RegiPaper_OK_clicked                (GtkButton       *button,
                                        gpointer         user_data);

void
on_RegiPaper_Cancel_clicked            (GtkButton       *button,
                                        gpointer         user_data);

void
on_CCDlg_OK_button_clicked             (GtkButton       *button,
                                        gpointer         user_data);

void
on_RegiPaper_dialog_destroy            (GtkObject       *object,
                                        gpointer         user_data);

gboolean
on_RegiPaper_dialog_delete_event       (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_ConsumablesCounters_dialog_destroy  (GtkObject       *object,
                                        gpointer         user_data);

gboolean
on_ConsumablesCounters_dialog_delete_event
                                        (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

gboolean
on_SleepS_dialog_delete_event          (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_SleepS_dialog_destroy               (GtkObject       *object,
                                        gpointer         user_data);

void
on_SleepSDlg_Use_checkbutton_toggled   (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_SleepSDlg_Time_combo_entry_changed  (GtkEditable     *editable,
                                        gpointer         user_data);

gboolean
on_SleepSDlg_Time_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

void
on_SleepSDlg_OK_button_clicked         (GtkButton       *button,
                                        gpointer         user_data);

void
on_SleepSDlg_Cancel_button_clicked     (GtkButton       *button,
                                        gpointer         user_data);

gboolean
on_CancelJobKeyDlg_dialog_delete_event (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_CancelJobKeyDlg_dialog_destroy      (GtkObject       *object,
                                        gpointer         user_data);

void
on_CJKDlg_ErrorJob_checkbutton_toggled (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_CJKDlg_PrintJob_checkbutton_toggled (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_CJKDlg_OK_button_clicked            (GtkButton       *button,
                                        gpointer         user_data);

void
on_CJKDlg_Cancel_button_clicked        (GtkButton       *button,
                                        gpointer         user_data);

void
on_cleaning3_activate                  (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_settings_of_the_cancel_job_key1_activate
                                        (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_network_settings1_activate          (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_ConsumableCounters_button_clicked   (GtkButton       *button,
                                        gpointer         user_data);

void
on_NetworjSDlg_dialog_destroy          (GtkObject       *object,
                                        gpointer         user_data);

gboolean
on_NetworjSDlg_dialog_delete_event     (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_NetworkSDlg_RARP_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_NetworkSDlg_BOOTP_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_NetworkSDlg_DHCP_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_NetworkSDlg_IPSetting_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_IP1_entry_focus_out_event
                                        (GtkWidget       *widget,
                                        GdkEventFocus   *event,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_IP2_entry_focus_out_event
                                        (GtkWidget       *widget,
                                        GdkEventFocus   *event,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_IP3_entry_focus_out_event
                                        (GtkWidget       *widget,
                                        GdkEventFocus   *event,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_IP4_entry_focus_out_event
                                        (GtkWidget       *widget,
                                        GdkEventFocus   *event,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_Sub1_entry_focus_out_event
                                        (GtkWidget       *widget,
                                        GdkEventFocus   *event,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_Sub2_entry_focus_out_event
                                        (GtkWidget       *widget,
                                        GdkEventFocus   *event,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_Sub3_entry_focus_out_event
                                        (GtkWidget       *widget,
                                        GdkEventFocus   *event,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_Sub4_entry_focus_out_event
                                        (GtkWidget       *widget,
                                        GdkEventFocus   *event,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_Gate1_entry_focus_out_event
                                        (GtkWidget       *widget,
                                        GdkEventFocus   *event,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_Gate2_entry_focus_out_event
                                        (GtkWidget       *widget,
                                        GdkEventFocus   *event,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_Gate3_entry_focus_out_event
                                        (GtkWidget       *widget,
                                        GdkEventFocus   *event,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_Gate4_entry_focus_out_event
                                        (GtkWidget       *widget,
                                        GdkEventFocus   *event,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_Password_entry_focus_out_event
                                        (GtkWidget       *widget,
                                        GdkEventFocus   *event,
                                        gpointer         user_data);

void
on_NetworkSDlg_Password_entry_changed  (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_NetWorkSDlg_OK_button_clicked       (GtkButton       *button,
                                        gpointer         user_data);

void
on_NetworkSDlg_button_clicked          (GtkButton       *button,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_dialog_delete_event     (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_NetworkSDlg_dialog_destroy          (GtkObject       *object,
                                        gpointer         user_data);

gboolean
on_NetworkSDlg_IPSetting_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);


void
on_register_colors_correction1_activate
                                        (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_assisting_print_setting1_activate   (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

gboolean
on_AsstPrtSDlg_dialog_delete_event     (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_AsstPrtSDlg_dialog_destroy          (GtkObject       *object,
                                        gpointer         user_data);

void
on_AsstPrtSDlg_highspeed_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_AsstPrtSDlg_mode_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

gboolean
on_AsstPrtSDlg_mode_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

gboolean
on_AsstPrtSDlg_colormisfrequency_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

gboolean
on_AsstPrtSDlg_paperjamreduction_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

void
on_AsstPrtSDlg_OK_button_clicked       (GtkButton       *button,
                                        gpointer         user_data);

void
on_AsstPrtSDlg_Cancel_button_clicked   (GtkButton       *button,
                                        gpointer         user_data);

void
on_AsstPrtSDlg_ReduceStreaks_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_startup_settings1_activate          (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_AsstPrtSDlg_preventpoorquality_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_AsstPrtSDlg_cleanevery2sheets_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

gboolean
on_StartupSettingsDlg_dialog_delete_event
                                        (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_StartupSettingsDlg_dialog_destroy   (GtkObject       *object,
                                        gpointer         user_data);

void
on_StartupSettingsDlg_QualityCorr_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_StartupSettingsDlg_OK_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data);

void
on_StartupSettingsDlg_Cancel_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data);

gboolean
on_StartupSettingsDlg_QualityCorr_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
							 gpointer	user_data);

void
on_cassette_settings_activate          (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_cassette_settings_1_activate        (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_cassette_settings_2_activate        (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_CassetteSet2Dlg_dialog_destroy      (GtkObject       *object,
                                        gpointer         user_data);

gboolean
on_CassetteSet2Dlg_dialog_delete_event (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_CassetteSet2Dlg_OK_clicked          (GtkButton       *button,
                                        gpointer         user_data);

void
on_CassetteSet2Dlg_Cancel_clicked      (GtkButton       *button,
                                        gpointer         user_data);

void
on_multi_purpose_tray_activate         (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_printing_position_adjustment_activate
                                        (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_reset_unit_activate                 (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_ResetUnitDlg_dialog_destroy         (GtkObject       *object,
                                        gpointer         user_data);

gboolean
on_ResetUnitDlg_dialog_delete_event    (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_ResetUnitDlg_OK_button_clicked      (GtkButton       *button,
                                        gpointer         user_data);

void
on_ResetUnitDlg_Cancel_button_clicked  (GtkButton       *button,
                                        gpointer         user_data);

void
on_AsstPrtSDlg_adjusttemp_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_AsstPrtSDlg_adjust16k_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

gboolean
on_MultiTrayDlg_dialog_delete_event    (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_MultiTrayDlg_dialog_destroy         (GtkObject       *object,
                                        gpointer         user_data);

void
on_MultiTrayDlg_OK_button_clicked      (GtkButton       *button,
                                        gpointer         user_data);

void
on_MultiTrayDlg_Cancel_button_clicked  (GtkButton       *button,
                                        gpointer         user_data);

gboolean
on_PPAVHDlg_dialog_delete_event        (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_PPAVHDlg_dialog_destroy             (GtkObject       *object,
                                        gpointer         user_data);

void
on_PPAVHDlg_OK_button_clicked          (GtkButton       *button,
                                        gpointer         user_data);

void
on_PPAVHDlg_Cancel_button_clicked      (GtkButton       *button,
                                        gpointer         user_data);

void
on_PPAVHDlg_Vertical_Multi_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_PPAVHDlg_Vertical_Cas1_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_PPAVHDlg_Vertical_Cas2_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_PPAVHDlg_Vertical_Cas3_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_PPAVHDlg_Vertical_Cas4_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_PPAVHDlg_Vertical_Duplex_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_PPAVHDlg_Horizontal_Multi_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_PPAVHDlg_Horizontal_Cas1_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_PPAVHDlg_Horizontal_Cas2_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_PPAVHDlg_Horizontal_Cas3_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_PPAVHDlg_Horizontal_Cas4_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_PPAVHDlg_Horizontal_Duplex_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

gboolean
on_PPAVHDlg_Vertical_Multi_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

gboolean
on_PPAVHDlg_Vertical_Cas1_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

gboolean
on_PPAVHDlg_Vertical_Cas2_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

gboolean
on_PPAVHDlg_Vertical_Cas3_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

gboolean
on_PPAVHDlg_Vertical_Cas4_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

gboolean
on_PPAVHDlg_Vertical_Duplex_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

gboolean
on_PPAVHDlg_Horizontal_Multi_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

gboolean
on_PPAVHDlg_Horizontal_Cas1_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

gboolean
on_PPAVHDlg_Horizontal_Cas2_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

gboolean
on_PPAVHDlg_Horizontal_Cas3_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

gboolean
on_PPAVHDlg_Horizontal_Cas4_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

gboolean
on_PPAVHDlg_Horizontal_Duplex_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);


void
on_RegiPaper_Cas3_combo_entry_changed  (GtkEditable     *editable,
                                        gpointer         user_data);

gboolean
on_RegiPaper_Cas3_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);

void
on_RegiPaper_Cas4_combo_entry_changed  (GtkEditable     *editable,
                                        gpointer         user_data);

gboolean
on_RegiPaper_Cas4_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
					gpointer	user_data);


void
on_power_save_settings_activate        (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_counters_activate                   (GtkMenuItem     *menuitem,
                                        gpointer         user_data);
void
on_TonerReplacementDlg_Cyan_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data);

void
on_TonerReplacementDlg_Magenta_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data);

void
on_TonerReplacementDlg_Yellow_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data);

void
on_TonerReplacementDlg_Black_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data);

void
on_TonerReplacementDlg_OK_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data);

void
on_TonerReplacementDlg_Cancel_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data);

void
on_CleaningDlg_FixingUnitCleaning1_radiobutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_CleaningDlg_FixingUnitCleaning2_radiobutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_CleaningDlg_DrumCleaning1_radiobutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_CleaningDlg_DrumCleaning2_radiobutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_CleaningDlg_OK_button_clicked       (GtkButton       *button,
                                        gpointer         user_data);

void
on_CleaningDlg_Cancel_button_clicked   (GtkButton       *button,
                                        gpointer         user_data);

void
on_toner_cartridge_replacement1_activate
                                        (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

gboolean
on_TonerReplacementDlg_dialog_delete_event
                                        (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_TonerReplacementDlg_dialog_destroy  (GtkObject       *object,
                                        gpointer         user_data);

gboolean
on_CleaningDlg_dialog_delete_event     (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_CleaningDlg_dialog_destroy          (GtkObject       *object,
                                        gpointer         user_data);

gboolean
on_CalibrationSettingsDlg_dialog_delete_event
                                        (GtkWidget       *widget,
                                        GdkEvent        *event,
                                        gpointer         user_data);

void
on_CalibrationSettingsDlg_dialog_destroy
                                        (GtkObject       *object,
                                        gpointer         user_data);

void
on_CalibrationSettingsDlg_UseCalibTimer_checkbutton_toggled
                                        (GtkToggleButton *togglebutton,
                                        gpointer         user_data);

void
on_CalibrationSettingsDlg_Hour_spinbutton_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_CalibrationSettingDlg_Minute_spinbutton_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_CalibrationSettingsDlg_StartupCalibSetting_comboboxentry_changed
                                        (GtkComboBox     *combobox,
                                        gpointer         user_data);

void
on_CalibrationSettingsDlg_OK_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data);

void
on_CalibrationSettingsDlg_Cancel_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data);

void
on_calibration_settings1_activate      (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

gboolean
on_CalibrationSettingsDlg_Startup_combo_popwin_event	(GtkWidget	*widget,
					GdkEvent	*event,
							 gpointer	user_data);

void
on_CalibrationSettingsDlg_Startup_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);


void
on_consumables_information1_activate   (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_TonerReplacementDlg_Finish_button_clicked
                                        (GtkButton       *button,
                                        gpointer         user_data);

void
on_AsstPrtSDlg_colormisfrequency_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_AsstPrtSDlg_paperjamreduction_combo_entry_changed
                                        (GtkEditable     *editable,
                                        gpointer         user_data);

void
on_color_mismatch_correction1_activate (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_drawer_settings_1_activate          (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_drawer_settings_2_activate          (GtkMenuItem     *menuitem,
                                        gpointer         user_data);

void
on_drawer_settings_activate            (GtkMenuItem     *menuitem,
                                        gpointer         user_data);
