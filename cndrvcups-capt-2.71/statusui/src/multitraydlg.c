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
#include "multitraydlg.h"
#include "data_process.h"
#include "callbacks.h"


static void InitMultiTrayDlgWidgets(UIStatusWnd *wnd);
static int GetMultiTrayDlgData(UIStatusWnd *wnd);



UIMultiTrayDlg* CreateMultiTrayDlg(UIDialog *parent)
{
	UIMultiTrayDlg *dialog;

	dialog = (UIMultiTrayDlg *)CreateDialog(sizeof(UIMultiTrayDlg), parent);

	UI_DIALOG(dialog)->window = create_MultiTrayDlg_dialog();

	return dialog;
}

void ShowMultiTrayDlg(UIStatusWnd *wnd)
{
	switch(wnd->nIFVersion){
	case CCPD_IF_VERSION_110:
		{
			if(GetMultiTrayDlgData(wnd))
				return;
			SigDisable();
			InitMultiTrayDlgWidgets(wnd);
			SigEnable();
		}
		break;
	case CCPD_IF_VERSION_100:
	default:
		break;
	}
	ShowDialog((UIDialog *)wnd->multitray_dlg, NULL);
}

void HideMultiTrayDlg(UIStatusWnd *wnd)
{
	HideDialog((UIDialog *)wnd->multitray_dlg);
}

void MultiTrayDlgOK(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->multitray_dlg)->window;

	long flag = 0;
	gboolean enable = FALSE;

	enable = GetToggleButtonActive(window, "MultiTrayDlg_Prioritize_checkbutton");
	if(enable != FALSE){
		flag = TRUE;
	}else{
		flag = FALSE;
	}

	HideMultiTrayDlg(wnd);

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG*2) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_SET_MPTRAY_FIRST) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, flag) < 0)
		goto err;
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;
	return;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
}

static int GetMultiTrayDlgData(UIStatusWnd *wnd)
{
	long flag = 0;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_MPTRAY_FIRST) < 0)
		goto err;
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;
	if(cnsktGetResData(wnd->pCnskt, &flag, READ_TYPE_LONG, -1) < 0)
		goto err;

	wnd->multitray_dlg->flag = flag;
	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;
}

static void InitMultiTrayDlgWidgets(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->multitray_dlg)->window;

	gboolean enable = FALSE;

	if(wnd->multitray_dlg->flag){
		enable = TRUE;
	}else{
		enable = FALSE;
	}

	SetActiveCheckButton(window, "MultiTrayDlg_Prioritize_checkbutton", enable);
}

