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
#include "sleepsdlg.h"
#include "data_process.h"
#include "callbacks.h"
#include "support.h"

#define	SLEEPSDLG_NOT_USE_SLEEP	0x8000
#define	SLEEPTIMER_DATA_LENGTH 4

static int GetSleepTime(UIStatusWnd *wnd, unsigned short *timer);
static void InitSleepSettingDlgWidgets(UIStatusWnd *wnd, unsigned short use_sleep);

static int GetSleepTime2(UIStatusWnd *wnd, unsigned short *timer);

static char *SleepTimeTbl[] = {
	"1","5","10","15","30","60","90","120","150","180",NULL
};

typedef struct {
	int type;
	char* labeltext;
}StrText;

#define	LABEL_TYPE_SLEEPMODE		0
#define	LABEL_TYPE_POWERSAVEMODE	1
#define	LABEL_TYPE_SLEEPMODE2	2

static StrText labelModeCheckBox[] = {
	{LABEL_TYPE_SLEEPMODE,		N_("Use Sleep Mode")},
	{LABEL_TYPE_POWERSAVEMODE,	N_("Enter Power Save Mode after Fixed Period")},
	{LABEL_TYPE_SLEEPMODE2,	N_("Enter Sleep Mode after Fixed Period")},
	{-1 ,NULL}
};

static StrText labelModeComboBox[] = {
	{LABEL_TYPE_SLEEPMODE,		N_("Time to Enter Sleep Mode:")},
	{LABEL_TYPE_POWERSAVEMODE,	N_("Time to Enter Power Save Mode:")},
	{LABEL_TYPE_SLEEPMODE2,	N_("Time to Enter Sleep Mode:")},
	{-1 ,NULL}
};

static StrText labelModeCaption[] = {
	{LABEL_TYPE_SLEEPMODE,		N_("Sleep Settings")},
	{LABEL_TYPE_POWERSAVEMODE,	N_("Power Save Settings")},
	{LABEL_TYPE_SLEEPMODE2,	N_("Sleep Settings")},
	{-1 ,NULL}
};

static char* GetStrText(StrText* list, int type)
{
	int loop = 0;

	for(loop = 0; list[loop].type != -1; loop++){
		if(type == list[loop].type){
			break;
		}
	}

	return _(list[loop].labeltext);
}

static void SetLabel(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->sleeps_dlg)->window;
	int model = wnd->nModel;
	int type = 0;
	char* checkboxtext = NULL;
	char* comboboxtext = NULL;
	char* captiontext = NULL;

	switch(model){
	case MODEL_LBP9100:
	case MODEL_LBP6000:
	case MODEL_LBP6200:
		type = LABEL_TYPE_POWERSAVEMODE;
		break;
	case MODEL_LBP7010:
	case MODEL_LBP9200:
	case MODEL_LBP6310:
	case MODEL_LBP6340:
	case MODEL_LBP6020:
		type = LABEL_TYPE_SLEEPMODE2;
		break;
	default:
		type = LABEL_TYPE_SLEEPMODE;
		break;
	}

	checkboxtext = GetStrText(labelModeCheckBox, type);
	comboboxtext = GetStrText(labelModeComboBox, type);
	captiontext = GetStrText(labelModeCaption, type);

	if(checkboxtext != NULL && comboboxtext != NULL){
		SetButtonLabel(window, "SleepSDlg_Use_checkbutton", checkboxtext);
		SetTextToLabel(window, "label157", comboboxtext);
		SetDialogTitle(window, _(captiontext));
	}
}

UISleepSettingDlg* CreateSleepSettingDlg(UIDialog *parent)
{
	UISleepSettingDlg *dialog;

	dialog = (UISleepSettingDlg *)CreateDialog(sizeof(UISleepSettingDlg), parent);

	UI_DIALOG(dialog)->window = create_SleepS_dialog();
	ComboSignalConnect(UI_DIALOG(dialog)->window, "SleepSDlg_Time_combo", GTK_SIGNAL_FUNC(on_SleepSDlg_Time_combo_popwin_event));

	return dialog;
}

void ShowSleepSettingDlg(UIStatusWnd *wnd)
{
	unsigned short timer;

	switch(wnd->nIFVersion){
	case CCPD_IF_VERSION_110:
		if(GetSleepTime2(wnd, &timer))
			return;
		break;
	case CCPD_IF_VERSION_100:
	default:
		if(GetSleepTime(wnd, &timer))
			return;
		break;
	}

	SigDisable();
	InitSleepSettingDlgWidgets(wnd, timer);
	SigEnable();

	ShowDialog((UIDialog *)wnd->sleeps_dlg, NULL);
}

void HideSleepSettingDlg(UIStatusWnd *wnd)
{
	HideDialog((UIDialog *)wnd->sleeps_dlg);
}

void SleepSettingDlgOK(UIStatusWnd *wnd)
{
	int use_sleep;
	unsigned short time = 30;
	char *ptime = NULL;

	GtkWidget *window = UI_DIALOG(wnd->sleeps_dlg)->window;
	use_sleep = GetToggleButtonActive(window, "SleepSDlg_Use_checkbutton");
	ptime = GetCurrComboText(window, "SleepSDlg_Time_combo_entry");

	if(ptime != NULL)
		time = atoi(ptime);

	if(use_sleep == FALSE)
		time = time | SLEEPSDLG_NOT_USE_SLEEP;

	HideSleepSettingDlg(wnd);

	switch(wnd->nIFVersion){
	case CCPD_IF_VERSION_100:
	        if(cnsktSetReqLong(wnd->pCnskt, SLEEPTIMER_DATA_LENGTH) < 0)
        	        goto error;
        	if(cnsktSetReqShort(wnd->pCnskt, FL_DATAID_SLEEP_TIMER) < 0)
			goto error;
		if(cnsktSetReqShort(wnd->pCnskt, time) < 0)
			goto error;

		if(SendRequest(wnd, CCPD_REQ_SET_FL_DATA) < 0)
			goto error;
		break;
	case CCPD_IF_VERSION_110:
	{
		unsigned long dwTimer = (unsigned long)time;
	        if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG * 2) < 0)
        	        goto error;
        	if(cnsktSetReqLong(wnd->pCnskt, DREQ_SET_SLEEPTIMER) < 0)
			goto error;
		if(cnsktSetReqLong(wnd->pCnskt, dwTimer) < 0)
			goto error;

		if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
			goto error;
		break;
	}
	default:
		goto error;
	}

        return;
error:
        ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);


}

void UpdateSleepSettingDlgWidgets(UIStatusWnd *wnd, int use_sleep)
{
	GtkWidget *window = UI_DIALOG(wnd->sleeps_dlg)->window;
	SetWidgetSensitive(window, "hbox61", use_sleep);
}

static void InitSleepSettingDlgWidgets(UIStatusWnd *wnd, unsigned short use_sleep)
{
	GtkWidget *window = UI_DIALOG(wnd->sleeps_dlg)->window;
	GList *glist = NULL;
	char cur[32];
	int active = 0;
	int i = 0;
	int starttblidx = 0;

	memset(cur, 0, 32);

	if(use_sleep & SLEEPSDLG_NOT_USE_SLEEP){
		int value = use_sleep - SLEEPSDLG_NOT_USE_SLEEP;
		if(value < 0)
			strcpy(cur, "30");
		else
			snprintf(cur, 31, "%d", value);
	}else{
		snprintf(cur, 31, "%d", use_sleep);
		active = 1;
	}

	SetLabel(wnd);

	switch(wnd->nModel){
	case MODEL_LBP9100:
	case MODEL_LBP6000:
	case MODEL_LBP6200:
	case MODEL_LBP7010:
	case MODEL_LBP9200:
	case MODEL_LBP6020:
		starttblidx = 0;
		break;
	default:
		starttblidx = 1;
		break;
	}

	switch(wnd->nModel){
	case MODEL_LBP5300:
	case MODEL_LBP3500:
	case MODEL_LBP5100:
	case MODEL_LBP5050:
	case MODEL_LBP7200:
	case MODEL_LBP9100:
	case MODEL_LBP6000:
	case MODEL_LBP6200:
	case MODEL_LBP7010:
	case MODEL_LBP9200:
	case MODEL_LBP7210:
	case MODEL_LBP6310:
	case MODEL_LBP6340:
	case MODEL_LBP6020:
		for(i = starttblidx; SleepTimeTbl[i] != NULL; i++){
			glist = g_list_append(glist, SleepTimeTbl[i]);
		}
		break;
	default:
		for(i = 0; wnd->pSleepTimeList[i] != NULL; i++){
			glist = g_list_append(glist, wnd->pSleepTimeList[i]);
		}
	}

	SetGListToCombo(window, glist, "SleepSDlg_Time_combo", cur);
	g_list_free(glist);

	SetActiveCheckButton(window, "SleepSDlg_Use_checkbutton", active);
	SetWidgetSensitive(window, "hbox61", active);
}

static int GetSleepTime(UIStatusWnd *wnd, unsigned short *timer)
{
	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_SHORT) < 0)
		goto err;

	if(cnsktSetReqShort(wnd->pCnskt, FL_DATAID_SLEEP_TIMER) < 0)
		goto err;

	if(SendRequest(wnd, CCPD_REQ_GET_FL_DATA) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, timer, READ_TYPE_SHORT, -1) < 0)
		goto err;


	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;

}

static int GetSleepTime2(UIStatusWnd *wnd, unsigned short *timer)
{
	unsigned long value = 0;
	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;

	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_SLEEPTIMER) < 0)
		goto err;

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
		goto err;

	*timer = (unsigned short)value;

	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;

}











