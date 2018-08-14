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

#include "uimain.h"
#include "widgets.h"
#include "interface.h"
#include "calibrationsettingsdlg.h"
#include "data_process.h"
#include "callbacks.h"
#include "support.h"

#define EXECUTE_LATER					1
#define EXECUTE_IMMEDIATELY				0
#define STARTUP_CALIB_DEFAULT			EXECUTE_LATER
#define DREQ_ENABLE_PERIODICAL_CALIB	0x8000U
#define DREQ_DISENABLE_PERIODICAL_CALIB	0x0000U

#define MAX_HOUR 23
#define MIN_HOUR 0
#define MAX_MINUTES 59
#define MIN_MINUTES 0
#define MASK_ZERO 0x0000
#define MASK_MINUTES 0x00FF
#define MASK_HOUR 0x1F00
#define ONE_BYTE 8

static void ConvertTimeDataToShort(const short periodicalCalibTime, short *const hour, short *const minutes);
static void ConvertShortToTimeData(UIStatusWnd *const wnd, const short hour, const short minutes, const short useTimer);

static int GetDefaultCalibrationSettings(UIStatusWnd *const wnd);
static int GetCurrentCalibrationSettings(UIStatusWnd *const wnd);
static void InitCalibrationSettingsDlgWidgets(const UIStatusWnd *const wnd);

static StartupCalibration StartupCalibrationTable[] = {
	{N_("Execute Later"), 1},
	{N_("Execute Immediately"), 0},
	{NULL, -1}
};

UICalibrationSettingsDlg* CreateCalibrationSettingsDlg(UIDialog *parent)
{
	UICalibrationSettingsDlg *dialog;

	dialog = (UICalibrationSettingsDlg *)CreateDialog(sizeof(UICalibrationSettingsDlg), parent);

	UI_DIALOG(dialog)->window = create_CalibrationSettingsDlg_dialog();

	ComboSignalConnect(UI_DIALOG(dialog)->window, "CalibrationSettingsDlg_Startup_combo", GTK_SIGNAL_FUNC(on_CalibrationSettingsDlg_Startup_combo_popwin_event));

	return dialog;
}

void ShowCalibrationSettingsDlg(UIStatusWnd *wnd)
{
	if(wnd != NULL){
		if(GetDefaultCalibrationSettings(wnd) == 0){
			SigDisable();
			InitCalibrationSettingsDlgWidgets(wnd);
			SigEnable();

			ShowDialog((UIDialog *)wnd->calibration_Settings_dlg, NULL);
		}
	}
}

static void ConvertTimeDataToShort(const short periodicalCalibTime, short *const hour, short *const minutes)
{
	if((hour != NULL) && (minutes != NULL)){
		*hour = (periodicalCalibTime & MASK_HOUR) >> ONE_BYTE;
		*minutes = periodicalCalibTime & MASK_MINUTES;

		if(((*hour) < MIN_HOUR) || ((*hour) > MAX_HOUR)){
			*hour = MIN_HOUR;
		}

		if(((*minutes) < MIN_MINUTES) || ((*minutes) > MAX_MINUTES)){
			*minutes = MIN_MINUTES;
		}
	}
}

static void ConvertShortToTimeData(UIStatusWnd *const wnd, const short hour, const short minutes, const short useTimer)
{
	if(wnd != NULL){
		wnd->calibration_Settings_dlg->periodicalCalibTime = MASK_ZERO;
		wnd->calibration_Settings_dlg->periodicalCalibTime += (hour << ONE_BYTE) & MASK_HOUR;
		wnd->calibration_Settings_dlg->periodicalCalibTime += minutes & MASK_MINUTES;
		wnd->calibration_Settings_dlg->periodicalCalibTime += useTimer;
	}
}

static int GetDefaultCalibrationSettings(UIStatusWnd *const wnd)
{
	short sValue = 0;
	long ulValue = 0;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0){
		goto err;
	}
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_CALIB) < 0){
		goto err;
	}
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0){
		goto err;
	}
	if(cnsktGetResData(wnd->pCnskt, &sValue, READ_TYPE_SHORT, -1) < 0){
		goto err;
	}
	wnd->calibration_Settings_dlg->periodicalCalibTime = sValue;
	if(cnsktGetResData(wnd->pCnskt, &sValue, READ_TYPE_SHORT, -1) < 0){
		goto err;
	}
	wnd->calibration_Settings_dlg->calibMode = sValue;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0){
		goto err;
	}
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_STARTUPSET) < 0){
		goto err;
	}
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0){
		goto err;
	}
	if(cnsktGetResData(wnd->pCnskt, &ulValue, READ_TYPE_LONG, -1) < 0){
		goto err;
	}
	wnd->calibration_Settings_dlg->startupMode = ulValue;

	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;


}

static int GetCurrentCalibrationSettings(UIStatusWnd *const wnd)
{
	char *currentStartupCalibration = NULL;
	int i = 0;
	short hour = 0;
	short minutes = 0;
	short useTimer = 0;

	if(wnd == NULL){
		goto err;
	}

	GtkWidget *window = UI_DIALOG(wnd->calibration_Settings_dlg)->window;

	hour = (short)GetSpinButtonValue(window, "CalibrationSettingsDlg_Hour_spinbutton", 0);
	minutes = (short)GetSpinButtonValue(window, "CalibrationSettingsDlg_Minutes_spinbutton", 0);
	if(GetToggleButtonActive(window, "CalibrationSettingsDlg_UseCalibTimer_checkbutton") == TRUE){
		useTimer = (short)DREQ_ENABLE_PERIODICAL_CALIB;
	}else{
		useTimer = (short)DREQ_DISENABLE_PERIODICAL_CALIB;
	}
	ConvertShortToTimeData(wnd, hour, minutes, useTimer);

	currentStartupCalibration = GetCurrComboText(window, "CalibrationSettingsDlg_Startup_entry");
	if(currentStartupCalibration != NULL){
		for(i = 0; _(StartupCalibrationTable[i].modeName) != NULL; i++){
			if(strcmp(currentStartupCalibration, _(StartupCalibrationTable[i].modeName)) == 0){
				wnd->calibration_Settings_dlg->startupMode = StartupCalibrationTable[i].modeCode;
				break;
			}
		}
		if(_(StartupCalibrationTable[i].modeName) == NULL){
			goto err;
		}
	}else{
		goto err;
	}

	return 0;

err:
	return 1;
}

static void InitCalibrationSettingsDlgWidgets(const UIStatusWnd *const wnd)
{
	if(wnd != NULL){
		GtkWidget *window = UI_DIALOG(wnd->calibration_Settings_dlg)->window;
		GList *glist = NULL;
		int currentItem = STARTUP_CALIB_DEFAULT;
		int currentItemIndex = 0;
		const int useTimer = (int)(wnd->calibration_Settings_dlg->periodicalCalibTime & DREQ_ENABLE_PERIODICAL_CALIB);
		short hour = 0;
		short minutes = 0;
		int index = 0;

		ConvertTimeDataToShort(wnd->calibration_Settings_dlg->periodicalCalibTime, &hour, &minutes);

		SetSpinButtonShort(window, "CalibrationSettingsDlg_Hour_spinbutton", hour);
		SetSpinButtonShort(window, "CalibrationSettingsDlg_Minutes_spinbutton", minutes);

		if(useTimer != 0){
			SetActiveCheckButton(window, "CalibrationSettingsDlg_UseCalibTimer_checkbutton", TRUE);
			UpdateCalibrationSettingsDlgWidgets(wnd, TRUE);
		}else{
			SetActiveCheckButton(window, "CalibrationSettingsDlg_UseCalibTimer_checkbutton", FALSE);
			UpdateCalibrationSettingsDlgWidgets(wnd, FALSE);
		}

		if((EXECUTE_IMMEDIATELY <= wnd->calibration_Settings_dlg->startupMode) && (wnd->calibration_Settings_dlg->startupMode <= EXECUTE_LATER)){
			currentItem = (int)wnd->calibration_Settings_dlg->startupMode;
		}
		for(index = 0; StartupCalibrationTable[index].modeName != NULL; index++){
			glist = g_list_append(glist, _(StartupCalibrationTable[index].modeName));
			if(StartupCalibrationTable[index].modeCode == currentItem){
				currentItemIndex = index;
			}
		}
		SetGListToCombo(window, glist, "CalibrationSettingsDlg_Startup_combo", _(StartupCalibrationTable[currentItemIndex].modeName));
		g_list_free(glist);
	}
}

void HideCalibrationSettingsDlg(const UIStatusWnd *const wnd)
{
	if(wnd != NULL){
		HideDialog((UIDialog *)wnd->calibration_Settings_dlg);
	}
}

void UpdateCalibrationSettingsDlgWidgets(const UIStatusWnd *const wnd, const int use_timer)
{
	if(wnd != NULL){
		GtkWidget *window = UI_DIALOG(wnd->calibration_Settings_dlg)->window;
		SetWidgetSensitive(window, "hbox82", use_timer);
	}
}

void CalibrationSettingsDlgOK(UIStatusWnd *wnd)
{
	if(wnd == NULL){
		goto error;
	}

	HideCalibrationSettingsDlg(wnd);

	if(GetCurrentCalibrationSettings(wnd) != 0){
		goto error;
	}

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG * 2) < 0){
		goto error;
	}
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_SET_CALIB) < 0){
		goto error;
	}
	if(cnsktSetReqShort(wnd->pCnskt, wnd->calibration_Settings_dlg->periodicalCalibTime) < 0){
		goto error;
	}
	if(cnsktSetReqShort(wnd->pCnskt, wnd->calibration_Settings_dlg->calibMode) < 0){
		goto error;
	}
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0){
		goto error;
	}

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG * 2) < 0){
		goto error;
	}
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_SET_STARTUPSET) < 0){
		goto error;
	}
	if(cnsktSetReqLong(wnd->pCnskt, wnd->calibration_Settings_dlg->startupMode) < 0){
		goto error;
	}
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0){
		goto error;
	}

	return;
error:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
	return;
}


