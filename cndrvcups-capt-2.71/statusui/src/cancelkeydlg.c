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
#include "cancelkeydlg.h"
#include "data_process.h"

#define USER_MODE_FLAGS_CERR	(1 << 6)
#define USER_MODE_FLAGS_CNOERR	(1 << 5)


static int GetCancelJobKeyData(UIStatusWnd *wnd);
static void InitCancelJobKeyDlgWidgets(UIStatusWnd *wnd);
static int GetCancelJobKeyData2(UIStatusWnd *wnd);
static void InitCancelJobKeyDlgWidgets2(UIStatusWnd *wnd);

UICancelJobKeyDlg* CreateCancelJobKeyDlg(UIDialog *parent)
{
	UICancelJobKeyDlg *dialog;

	dialog = (UICancelJobKeyDlg *)CreateDialog(sizeof(UICancelJobKeyDlg), parent);

	UI_DIALOG(dialog)->window = create_CancelJobKeyDlg_dialog();

	return dialog;
}

void ShowCancelJobKeyDlg(UIStatusWnd *wnd)
{
	switch(wnd->nIFVersion){
	case CCPD_IF_VERSION_110:
		if(GetCancelJobKeyData2(wnd))
			return;
		SigDisable();
		InitCancelJobKeyDlgWidgets2(wnd);
		SigEnable();
		break;
	case CCPD_IF_VERSION_100:
	default:
		if(GetCancelJobKeyData(wnd))
			return;
		SigDisable();
		InitCancelJobKeyDlgWidgets(wnd);
		SigEnable();
		break;
	}

	ShowDialog((UIDialog *)wnd->cancelkey_dlg, NULL);
}

void HideCancelJobKeyDlg(UIStatusWnd *wnd)
{
	HideDialog((UIDialog *)wnd->cancelkey_dlg);
}

#define	CANCELJOBKEY_DATA_LENGTH	4

void CancelJobKeyDlgOK(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->cancelkey_dlg)->window;
	int err = 0;
	int noerr = 0;
	unsigned short elem = 0, bits = 0;
	int i;

	err = GetToggleButtonActive(window, "CJKDlg_ErrorJob_checkbutton");
	noerr = GetToggleButtonActive(window, "CJKDlg_PrintJob_checkbutton");

	switch(wnd->nIFVersion){
	case CCPD_IF_VERSION_110:
		goto v110;
	case CCPD_IF_VERSION_100:
	default:
		break;
	}

	for(i = 0; i < 16; i++){
		bits = (1 << i);
		if(bits == USER_MODE_FLAGS_CERR){
			if(!err)
				elem |= USER_MODE_FLAGS_CERR;
		}else if(bits == USER_MODE_FLAGS_CNOERR){
			if(!noerr)
				elem |= USER_MODE_FLAGS_CNOERR;
		}else{
			elem |= (wnd->cancelkey_dlg->elem & bits);
		}
	}

	HideDialog((UIDialog *)wnd->cancelkey_dlg);

	if(cnsktSetReqLong(wnd->pCnskt, CANCELJOBKEY_DATA_LENGTH) < 0)
		goto error;
	if(cnsktSetReqShort(wnd->pCnskt, FL_DATAID_USERFLAG) < 0)
		goto error;
	if(cnsktSetReqShort(wnd->pCnskt, elem) < 0)
		goto error;

	if(SendRequest(wnd, CCPD_REQ_SET_FL_DATA) < 0)
		goto error;

	return;

v110:
	{
		unsigned long dwJobCancel = 0;
		if(!err)
			dwJobCancel |= DREQ_DISABLE_CANCEL_WHILE_ERROR;
		if(!noerr)
			dwJobCancel |= DREQ_DISABLE_CANCEL_WHILE_NOERROR;

		HideDialog((UIDialog *)wnd->cancelkey_dlg);

		if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG * 2) < 0)
			goto error;
		if(cnsktSetReqLong(wnd->pCnskt, DREQ_SET_JOBCANCEL) < 0)
			goto error;
		if(cnsktSetReqLong(wnd->pCnskt, dwJobCancel) < 0)
			goto error;

		if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
			goto error;

		return;
	}
error:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
}

void UpdateCancelJobKeyDlgWidgets(UIStatusWnd *wnd, int errcancel)
{
	GtkWidget *window = UI_DIALOG(wnd->cancelkey_dlg)->window;
	SetWidgetSensitive(window, "CJKDlg_PrintJob_checkbutton", errcancel);

	if(!errcancel)
		SetActiveCheckButton(window, "CJKDlg_PrintJob_checkbutton" , errcancel);
}

static void InitCancelJobKeyDlgWidgets(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->cancelkey_dlg)->window;
	int errcancel = 1;
	int noerrcancel = 1;

	errcancel = !(wnd->cancelkey_dlg->elem & USER_MODE_FLAGS_CERR);
	noerrcancel = !(wnd->cancelkey_dlg->elem & USER_MODE_FLAGS_CNOERR);

	SetActiveCheckButton(window, "CJKDlg_ErrorJob_checkbutton" , errcancel);
	SetWidgetSensitive(window, "CJKDlg_PrintJob_checkbutton", errcancel);
	if(errcancel){
		SetActiveCheckButton(window, "CJKDlg_PrintJob_checkbutton" , noerrcancel);
	}else{
		SetActiveCheckButton(window, "CJKDlg_PrintJob_checkbutton" , errcancel);
	}
}

static int GetCancelJobKeyData(UIStatusWnd *wnd)
{
	unsigned short elem;
	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_SHORT) < 0)
		goto err;

	if(cnsktSetReqShort(wnd->pCnskt, FL_DATAID_USERFLAG) < 0)
		goto err;

	if(SendRequest(wnd, CCPD_REQ_GET_FL_DATA) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &elem, READ_TYPE_SHORT, -1) < 0)
		goto err;

	wnd->cancelkey_dlg->elem = elem;

	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;

}

static void InitCancelJobKeyDlgWidgets2(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->cancelkey_dlg)->window;
	int errcancel = 1;
	int noerrcancel = 1;

	errcancel = !(wnd->cancelkey_dlg->dwJobCancel
		& DREQ_DISABLE_CANCEL_WHILE_ERROR);
	noerrcancel = !(wnd->cancelkey_dlg->dwJobCancel
		& DREQ_DISABLE_CANCEL_WHILE_NOERROR);

	SetActiveCheckButton(window, "CJKDlg_ErrorJob_checkbutton" , errcancel);
	SetWidgetSensitive(window, "CJKDlg_PrintJob_checkbutton", errcancel);
	if(errcancel){
		SetActiveCheckButton(window, "CJKDlg_PrintJob_checkbutton" , noerrcancel);
	}else{
		SetActiveCheckButton(window, "CJKDlg_PrintJob_checkbutton" , errcancel);
	}
}

static int GetCancelJobKeyData2(UIStatusWnd *wnd)
{
	unsigned long elem;
	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;

	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_JOBCANCEL) < 0)
		goto err;

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &elem, READ_TYPE_LONG, -1) < 0)
		goto err;

	wnd->cancelkey_dlg->dwJobCancel = elem;

	return 0;

err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;
}

