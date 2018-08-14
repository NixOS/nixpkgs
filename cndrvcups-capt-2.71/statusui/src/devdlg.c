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
#include "devdlg.h"
#include "data_process.h"

#define	SET_FLASH_DATA_SIZE	7

void UpdateDevDlgWidgets(UIStatusWnd *wnd);

UIDevDlg* CreateDevDlg(UIDialog *parent)
{
	UIDevDlg *dialog;

	dialog = (UIDevDlg *)CreateDialog(sizeof(UIDevDlg), parent);

	UI_DIALOG(dialog)->window = create_DevS_dialog();

	return dialog;
}

static int GetDevDlgLBP3600(UIStatusWnd *wnd)
{
	char value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->dev_dlg->printer_flag = (int)value;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->dev_dlg->num_cassette = (int)value;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->dev_dlg->size_tray = (int)value;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->dev_dlg->size_cas1 = (int)value;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->dev_dlg->size_cas2 = (int)value;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->dev_dlg->size_cas3 = (int)value;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->dev_dlg->size_cas4 = (int)value;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->dev_dlg->user_flag = (int)value;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->dev_dlg->mask_tray = (int)value;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->dev_dlg->mask_cas1 = (int)value;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->dev_dlg->mask_cas2 = (int)value;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->dev_dlg->mask_cas3 = (int)value;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->dev_dlg->mask_cas4 = (int)value;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->dev_dlg->mask_dplx = (int)value;
	return 0;
}


void ShowDevDlg(UIStatusWnd *wnd)
{
	if(GetDevDlgLBP3600(wnd))
		return;

	SigDisable();
	UpdateDevDlgWidgets(wnd);
	SigEnable();

	gtk_widget_show(UI_DIALOG(wnd->dev_dlg)->window);
}

void HideDevDlg(UIStatusWnd *wnd)
{
	gtk_widget_hide(UI_DIALOG(wnd->dev_dlg)->window);
	wnd->dev = FALSE;
}

void DevDlgOK(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->dev_dlg)->window;
	int active = 0;
	int user_flag = 0;

	active = GetToggleButtonActive(window, "DevDlg_2Mode_checkbutton");
	if(active)
		user_flag |= USER_MODE_FLAGS_DUPLEX;

	active = GetToggleButtonActive(window, "DevDlg_GraMode_checkbutton");
	if(active)
		user_flag |= USER_MODE_FLAGS_GRAPHIC;

	active = GetToggleButtonActive(window, "DevDlg_FlkMode_checkbutton");
	if(active)
		user_flag |= USER_MODE_FLAGS_FLICKER;

	wnd->dev_dlg->user_flag = user_flag;
	wnd->dev_dlg->mask_tray
		= GetSpinButtonValue(window, "DevDlg_MltT_spinbutton", 10);
	wnd->dev_dlg->mask_cas1
		= GetSpinButtonValue(window, "DevDlg_Cas1_spinbutton", 10);
	wnd->dev_dlg->mask_cas2
		= GetSpinButtonValue(window, "DevDlg_Cas2_spinbutton", 10);
	wnd->dev_dlg->mask_cas3
		= GetSpinButtonValue(window, "DevDlg_Cas3_spinbutton", 10);
	wnd->dev_dlg->mask_cas4
		= GetSpinButtonValue(window, "DevDlg_Cas4_spinbutton", 10);
	wnd->dev_dlg->mask_dplx
		= GetSpinButtonValue(window, "DevDlg_Dplx_spinbutton", 10);

	if(cnsktSetReqLong(wnd->pCnskt, SET_FLASH_DATA_SIZE) < 0)
		goto err;
	if(cnsktSetReqByte(wnd->pCnskt, user_flag) < 0)
		goto err;
	if(cnsktSetReqByte(wnd->pCnskt, wnd->dev_dlg->mask_tray) < 0)
		goto err;
	if(cnsktSetReqByte(wnd->pCnskt, wnd->dev_dlg->mask_cas1) < 0)
		goto err;
	if(cnsktSetReqByte(wnd->pCnskt, wnd->dev_dlg->mask_cas2) < 0)
		goto err;
	if(cnsktSetReqByte(wnd->pCnskt, wnd->dev_dlg->mask_cas3) < 0)
		goto err;
	if(cnsktSetReqByte(wnd->pCnskt, wnd->dev_dlg->mask_cas4) < 0)
		goto err;
	if(cnsktSetReqByte(wnd->pCnskt, wnd->dev_dlg->mask_dplx) < 0)
		goto err;

	UpdateJob(CCPD_REQ_SET_FLASH);
err:
	HideDevDlg(wnd);
	return;
}

void DevDlgCancel(UIStatusWnd *wnd)
{
	HideDevDlg(wnd);
}

const char *hbox_widget_table[] = {
	"DevDlg_Cas1_hbox",
	"DevDlg_Cas2_hbox",
	"DevDlg_Cas3_hbox",
	"DevDlg_Cas4_hbox",
	NULL,
};

void UpdateDevDlgWidgets(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->dev_dlg)->window;
	int dplx, cas, i = 0, sensi = 0;
	int usr_flag;
	int check;
	float value;

	cas = wnd->dev_dlg->num_cassette;
	while(hbox_widget_table[i] != NULL){
		sensi = (i < cas) ? TRUE : FALSE;
		SetWidgetSensitive(window, (char *)hbox_widget_table[i], sensi);
		i++;
	}
	value = (float)wnd->dev_dlg->mask_tray / 10.0;
	SetSpinButtonFloat(window, "DevDlg_MltT_spinbutton", value);
	value = (float)wnd->dev_dlg->mask_cas1 / 10.0;
	SetSpinButtonFloat(window, "DevDlg_Cas1_spinbutton", value);
	value = (float)wnd->dev_dlg->mask_cas2 / 10.0;
	SetSpinButtonFloat(window, "DevDlg_Cas2_spinbutton", value);
	value = (float)wnd->dev_dlg->mask_cas3 / 10.0;
	SetSpinButtonFloat(window, "DevDlg_Cas3_spinbutton", value);
	value = (float)wnd->dev_dlg->mask_cas4 / 10.0;
	SetSpinButtonFloat(window, "DevDlg_Cas4_spinbutton", value);
	value = (float)wnd->dev_dlg->mask_dplx / 10.0;
	SetSpinButtonFloat(window, "DevDlg_Dplx_spinbutton", value);

	dplx = wnd->dev_dlg->printer_flag;
	sensi = (dplx & PRINTER_FLAGS_SB_DUPLEX) ? TRUE : FALSE;
	SetWidgetSensitive(window, "DevDlg_Dplx_hbox", sensi);

	usr_flag = wnd->dev_dlg->user_flag;
	check = (usr_flag & USER_MODE_FLAGS_DUPLEX) ? TRUE : FALSE;
	SetActiveCheckButton(window, "DevDlg_2Mode_checkbutton", check);
	check = (usr_flag & USER_MODE_FLAGS_GRAPHIC) ? TRUE : FALSE;
	SetActiveCheckButton(window, "DevDlg_GraMode_checkbutton", check);
	check = (usr_flag & USER_MODE_FLAGS_FLICKER) ? TRUE : FALSE;
	SetActiveCheckButton(window, "DevDlg_FlkMode_checkbutton", check);
}



