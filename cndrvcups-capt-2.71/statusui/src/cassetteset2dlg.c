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
#include "cassetteset2dlg.h"
#include "data_process.h"
#include "callbacks.h"



static void InitCassetteSet2DlgWidgets(UIStatusWnd *wnd);
static int GetCassetteSet2DlgData(UIStatusWnd *wnd);

typedef struct {
	long flag;
	char* widgetname;
} CheckTbl;

static CheckTbl chk_tbl[] = {
	{DREQ_ENABLE_CASSETTE1, "CassetteSet2Dlg_Cas1_checkbutton"},
	{DREQ_ENABLE_CASSETTE2, "CassetteSet2Dlg_Cas2_checkbutton"},
	{DREQ_ENABLE_CASSETTE3, "CassetteSet2Dlg_Cas3_checkbutton"},
	{DREQ_ENABLE_CASSETTE4, "CassetteSet2Dlg_Cas4_checkbutton"},
	{0, NULL},
};

#define TITLEID_CASSETTE2	0
#define TITLEID_DRAWER2	1
#define LABEL_TYPE_CASSETTE		100
#define LABEL_TYPE_DRAWER		101

static char* tTitleTbl[] = {
	N_("Cassette Settings 2"),
	N_("Drawer Settings 2"),
	NULL,
};

typedef struct {
	int type;
	char* labeltext;
}StrText;

static StrText labelCassette1[] = {
	{LABEL_TYPE_CASSETTE, N_("Use Cassette 1 as Target of Auto Select")},
	{LABEL_TYPE_DRAWER, N_("Use Drawer 1 as Target of Auto Select")},
	{-1 ,NULL}
};

static StrText labelCassette2[] = {
	{LABEL_TYPE_CASSETTE, N_("Use Cassette 2 as Target of Auto Select")},
	{LABEL_TYPE_DRAWER, N_("Use Drawer 2 as Target of Auto Select")},
	{-1 ,NULL}
};

static StrText labelCassette3[] = {
	{LABEL_TYPE_CASSETTE, N_("Use Cassette 3 as Target of Auto Select")},
	{LABEL_TYPE_DRAWER, N_("Use Drawer 3 as Target of Auto Select")},
	{-1 ,NULL}
};

static StrText labelCassette4[] = {
	{LABEL_TYPE_CASSETTE, N_("Use Cassette 4 as Target of Auto Select")},
	{LABEL_TYPE_DRAWER, N_("Use Drawer 4 as Target of Auto Select")},
	{-1 ,NULL}
};

typedef struct {
	StrText* labeltext;
	char* labelname;
}LabelText;

static LabelText LabelTextList[] = {
	{labelCassette1, "CassetteSet2Dlg_Cas1_checkbutton"},
	{labelCassette2, "CassetteSet2Dlg_Cas2_checkbutton"},
	{labelCassette3, "CassetteSet2Dlg_Cas3_checkbutton"},
	{labelCassette4, "CassetteSet2Dlg_Cas4_checkbutton"},
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
	GtkWidget *window = UI_DIALOG(wnd->cassetteset2_dlg)->window;
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

UICassetteSet2Dlg* CreateCassetteSet2Dlg(UIDialog *parent)
{
	UICassetteSet2Dlg *dialog;

	dialog = (UICassetteSet2Dlg *)CreateDialog(sizeof(UICassetteSet2Dlg), parent);

	UI_DIALOG(dialog)->window = create_CassetteSet2Dlg_dialog();

	return dialog;
}

void ShowCassetteSet2Dlg(UIStatusWnd *wnd)
{
	switch(wnd->nIFVersion){
	case CCPD_IF_VERSION_110:
		{
			if(GetCassetteSet2DlgData(wnd))
				return;
			SigDisable();
			InitCassetteSet2DlgWidgets(wnd);
			SigEnable();
		}
		break;
	case CCPD_IF_VERSION_100:
	default:
		break;
	}
	ShowDialog((UIDialog *)wnd->cassetteset2_dlg, NULL);
}

void HideCassetteSet2Dlg(UIStatusWnd *wnd)
{
	HideDialog((UIDialog *)wnd->cassetteset2_dlg);
}

void CassetteSet2DlgOK(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->cassetteset2_dlg)->window;

	long flag = 0;
	int loop = 0;
	gboolean enable = FALSE;

	flag = wnd->cassetteset2_dlg->flag;

	while(chk_tbl[loop].widgetname != NULL){
		enable = GetToggleButtonActive(window, chk_tbl[loop].widgetname);
		if(loop < wnd->cas_num){
			if(enable){
				if(flag & chk_tbl[loop].flag){
					flag = flag - chk_tbl[loop].flag;
				}
			}else{
				flag |= chk_tbl[loop].flag;
			}
		}
		loop++;
	}

	HideCassetteSet2Dlg(wnd);

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG * 2) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_SET_CASSET_FLAG) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, flag) < 0)
		goto err;
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;
	return;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
}

static int GetCassetteSet2DlgData(UIStatusWnd *wnd)
{
	long flag = 0;
	DREQPrtInfo info;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_CASSET_FLAG) < 0)
		goto err;
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;
	if(cnsktGetResData(wnd->pCnskt, &flag, READ_TYPE_LONG, -1) < 0)
		goto err;

	wnd->cassetteset2_dlg->flag = flag;

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

static void InitCassetteSet2DlgWidgets(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->cassetteset2_dlg)->window;

	int loop = 0;
	gboolean enable = FALSE;

	int model = wnd->nModel;
	int title = TITLEID_CASSETTE2;

	while(chk_tbl[loop].widgetname != NULL){
		if(wnd->cassetteset2_dlg->flag & chk_tbl[loop].flag){
			enable = FALSE;
		}else{
			enable = TRUE;
		}

		SetActiveCheckButton(window, chk_tbl[loop].widgetname, enable);

		if(loop >= wnd->cas_num){
			SetWidgetSensitive(window, chk_tbl[loop].widgetname, FALSE);
			SetActiveCheckButton(window, chk_tbl[loop].widgetname, FALSE);
		}

		loop++;
	}

	SetLabel(wnd);

	switch(model){
		case MODEL_LBP9200:
			title = TITLEID_DRAWER2;
			break;
		default:
			title = TITLEID_CASSETTE2;
			break;
	}

	SetDialogTitle(window, _(tTitleTbl[title]));

	return;
}

