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

#include <ctype.h>

#include "support.h"
#include "uimain.h"
#include "widgets.h"
#include "interface.h"
#include "resetunitdlg.h"
#include "data_process.h"
#include "callbacks.h"



static void InitResetUnitDlgWidgets(UIStatusWnd *wnd);
static int GetResetUnitDlgData(UIStatusWnd *wnd);

typedef struct {
	long flag;
	char* widgetname;
} CheckTbl;

#define	LABEL_TYPE_CASSETTE		100
#define	LABEL_TYPE_DRAWER		101

typedef struct {
	int type;
	char* labeltext;
}StrText;

static StrText labelMulti[] = {
	{LABEL_TYPE_CASSETTE, N_("Paper Feed Roller (Multi-purpose Tray)")},
	{LABEL_TYPE_DRAWER, N_("Paper Feed Roller (Multi-purpose Tray) ")},
	{-1 ,NULL}
};

static StrText labelCassette1[] = {
	{LABEL_TYPE_CASSETTE, N_("Paper Feed Roller (Cassette 1)")},
	{LABEL_TYPE_DRAWER, N_("Paper Feed Roller (Drawer 1)")},
	{-1 ,NULL}
};

static StrText labelCassette2[] = {
	{LABEL_TYPE_CASSETTE, N_("Paper Feed Roller (Cassette 2)")},
	{LABEL_TYPE_DRAWER, N_("Paper Feed Roller (Drawer 2)")},
	{-1 ,NULL}
};

static StrText labelCassette3[] = {
	{LABEL_TYPE_CASSETTE, N_("Paper Feed Roller (Cassette 3)")},
	{LABEL_TYPE_DRAWER, N_("Paper Feed Roller (Drawer 3)")},
	{-1 ,NULL}
};

static StrText labelCassette4[] = {
	{LABEL_TYPE_CASSETTE, N_("Paper Feed Roller (Cassette 4)")},
	{LABEL_TYPE_DRAWER, N_("Paper Feed Roller (Drawer 4)")},
	{-1 ,NULL}
};

typedef struct {
	StrText* labeltext;
	char* labelname;
}LabelText;

static LabelText LabelTextList[] = {
	{labelMulti, "ResetUnitDlg_MultiTray_checkbutton"},
	{labelCassette1, "ResetUnitDlg_Cas1_checkbutton"},
	{labelCassette2, "ResetUnitDlg_Cas2_checkbutton"},
	{labelCassette3, "ResetUnitDlg_Cas3_checkbutton"},
	{labelCassette4, "ResetUnitDlg_Cas4_checkbutton"},
	{NULL, NULL}
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
	GtkWidget *window = UI_DIALOG(wnd->resetunit_dlg)->window;
	int model = wnd->nModel;
	int type = 0;
	char* text = NULL;
	int i = 0;

	switch(model){
		case MODEL_LBP9200:
			type = LABEL_TYPE_DRAWER;
			break;
		default:
			type = LABEL_TYPE_CASSETTE;
			break;
	}

	for(i = 0; LabelTextList[i].labeltext != NULL; i++){
		text = GetStrText(LabelTextList[i].labeltext, type);
		if(text != NULL){
			SetButtonLabel(window, LabelTextList[i].labelname, text);
		}
	}
}

static CheckTbl chk_tbl[] = {
	{DREQ_ENABLE_FUSER2, "ResetUnitDlg_FixingUnit_checkbutton"},
	{DREQ_ENABLE_ITBUNIT, "ResetUnitDlg_ITBUnit_checkbutton"},
	{DREQ_ENABLE_2NDTRANSROLLER, "ResetUnitDlg_SecondaryTrans_checkbutton"},
	{DREQ_ENABLE_FEEDROLLER_MULTI, "ResetUnitDlg_MultiTray_checkbutton"},
	{DREQ_ENABLE_FEEDROLLER_CAS1, "ResetUnitDlg_Cas1_checkbutton"},
	{DREQ_ENABLE_FEEDROLLER_CAS2, "ResetUnitDlg_Cas2_checkbutton"},
	{DREQ_ENABLE_FEEDROLLER_CAS3, "ResetUnitDlg_Cas3_checkbutton"},
	{DREQ_ENABLE_FEEDROLLER_CAS4, "ResetUnitDlg_Cas4_checkbutton"},
	{0, NULL},
};

static int startCasPos = 4;

UIResetUnitDlg* CreateResetUnitDlg(UIDialog *parent)
{
	UIResetUnitDlg *dialog;

	dialog = (UIResetUnitDlg *)CreateDialog(sizeof(UIResetUnitDlg), parent);

	UI_DIALOG(dialog)->window = create_ResetUnitDlg_dialog();

	return dialog;
}

void ShowResetUnitDlg(UIStatusWnd *wnd)
{
	switch(wnd->nIFVersion){
	case CCPD_IF_VERSION_110:
		{
			if(GetResetUnitDlgData(wnd))
				return;
			SigDisable();
			InitResetUnitDlgWidgets(wnd);
			SigEnable();
		}
		break;
	case CCPD_IF_VERSION_100:
	default:
		break;
	}
	ShowDialog((UIDialog *)wnd->resetunit_dlg, NULL);
}

void HideResetUnitDlg(UIStatusWnd *wnd)
{
	HideDialog((UIDialog *)wnd->resetunit_dlg);
}

void ResetUnitDlgOK(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->resetunit_dlg)->window;

	long flag = 0;
	int loop = 0;
	gboolean enable = FALSE;
	gboolean changesettings = FALSE;

	while(chk_tbl[loop].widgetname != NULL){
		enable = GetToggleButtonActive(window, chk_tbl[loop].widgetname);
		if(enable != FALSE){
			flag |= chk_tbl[loop].flag;
			if(changesettings == FALSE){
				changesettings = TRUE;
			}
		}
		loop++;
	}
	wnd->resetunit_dlg->flag = flag;

	wnd->resetunit_dlg->setdata = FALSE;

	if(changesettings != FALSE){
		ShowMsgDlg(wnd, MSG_TYPE_RESET_UNIT);
	}else{
		HideResetUnitDlg(wnd);
	}

	if(wnd->resetunit_dlg->setdata){
		HideResetUnitDlg(wnd);

		if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG * 2) < 0)
			goto err;
		if(cnsktSetReqLong(wnd->pCnskt, DREQ_SET_PARTSRESET) < 0)
			goto err;
		if(cnsktSetReqLong(wnd->pCnskt, wnd->resetunit_dlg->flag) < 0)
			goto err;
		if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
			goto err;
	}
	return;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
}

static int GetResetUnitDlgData(UIStatusWnd *wnd)
{
	long flag = 0;
	DREQPrtInfo info;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_PARTSLIST) < 0)
		goto err;
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;
	if(cnsktGetResData(wnd->pCnskt, &flag, READ_TYPE_LONG, -1) < 0)
		goto err;

	wnd->resetunit_dlg->flag = flag;

	memset(&info, 0, sizeof(DREQPrtInfo));
	if(GetDREQPrtInfo(wnd, &info) == 0){
		wnd->cas_num = info.nNumCas;
		wnd->dplx = info.nUnit;
	}
	if(info.pName){
		free(info.pName);
	}
	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;
}

static void InitResetUnitDlgWidgets(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->resetunit_dlg)->window;

	int loop = 0;
	gboolean enable = FALSE;

	while(chk_tbl[loop].widgetname != NULL){
		if(wnd->resetunit_dlg->flag & chk_tbl[loop].flag){
			enable = FALSE;
		}else{
			enable = TRUE;
		}

		SetActiveCheckButton(window, chk_tbl[loop].widgetname, enable);

		if(loop >= startCasPos && loop <= startCasPos + 4){
			if(loop - startCasPos >= wnd->cas_num){
				SetWidgetSensitive(window, chk_tbl[loop].widgetname, FALSE);
				SetActiveCheckButton(window, chk_tbl[loop].widgetname, FALSE);
			}
		}

		loop++;
	}

	SetLabel(wnd);
}

