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
#include "ppapdlg.h"
#include "data_process.h"
#include "ppapdata.h"
#include "support.h"

const char *cas_radio_widget_table[] = {
	"PPAPDlg_Cas1_radiobutton",
	"PPAPDlg_Cas2_radiobutton",
	"PPAPDlg_Cas3_radiobutton",
	"PPAPDlg_Cas4_radiobutton",
	NULL,
};

void UpdatePPAPDlgWidgets(UIStatusWnd *wnd);

typedef struct {
	int type;
	char* labeltext;
}StrText;

#define	LABEL_TYPE_DEVICE_SET		0
#define	LABEL_TYPE_ADJUST_VERHOR	1
#define	LABEL_TYPE_CASSETTE		100
#define	LABEL_TYPE_DRAWER		101

static StrText labelDialog[] = {
	{LABEL_TYPE_DEVICE_SET,		N_("Print a pattern for Printing Position Adjustment.\nSelect the paper source to check and click [OK].\nWhen adjusting the printing position after printing,\nadjust it in the [Device Settings] dialog in the [Option] menu.\n")},
	{LABEL_TYPE_ADJUST_VERHOR,	N_("Prints a pattern for Printing Position Adjustment.\nSelect the paper source to check and click [OK].\nAfter printing the pattern, adjust the printing position in [Options] - [Device Settings] - [Printing Position Adjustment].\n")},
	{-1 ,NULL}
};

static StrText labelRadioMulti[] = {
	{LABEL_TYPE_CASSETTE, N_("Multi-purpose Tray")},
	{LABEL_TYPE_DRAWER, N_("Multi-purpose Tray ")},
	{-1 ,NULL}
};

static StrText labelRadioCassette1[] = {
	{LABEL_TYPE_CASSETTE, N_("Cassette 1")},
	{LABEL_TYPE_DRAWER, N_("Drawer 1")},
	{-1 ,NULL}
};

static StrText labelRadioCassette2[] = {
	{LABEL_TYPE_CASSETTE, N_("Cassette 2")},
	{LABEL_TYPE_DRAWER, N_("Drawer 2")},
	{-1 ,NULL}
};

static StrText labelRadioCassette3[] = {
	{LABEL_TYPE_CASSETTE, N_("Cassette 3")},
	{LABEL_TYPE_DRAWER, N_("Drawer 3")},
	{-1 ,NULL}
};

static StrText labelRadioCassette4[] = {
	{LABEL_TYPE_CASSETTE, N_("Cassette 4")},
	{LABEL_TYPE_DRAWER, N_("Drawer 4")},
	{-1 ,NULL}
};

typedef struct {
	StrText* labeltext;
	char* labelname;
}LabelText;

static LabelText LabelTextList[] = {
	{labelRadioMulti, "PPAPDlg_MltT_radiobutton"},
	{labelRadioCassette1, "PPAPDlg_Cas1_radiobutton"},
	{labelRadioCassette2, "PPAPDlg_Cas2_radiobutton"},
	{labelRadioCassette3, "PPAPDlg_Cas3_radiobutton"},
	{labelRadioCassette4, "PPAPDlg_Cas4_radiobutton"},
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
	GtkWidget *window = UI_DIALOG(wnd->ppap_dlg)->window;
	int model = wnd->nModel;
	int type = 0;
	char* text = NULL;
	int type2 = 0;
	int i = 0;

	switch(model){
	case MODEL_LBP9100:
		type = LABEL_TYPE_ADJUST_VERHOR;
		type2 = LABEL_TYPE_CASSETTE;
		break;
	case MODEL_LBP9200:
		type = LABEL_TYPE_ADJUST_VERHOR;
		type2 = LABEL_TYPE_DRAWER;
		break;
	default:
		type = LABEL_TYPE_DEVICE_SET;
		type2 = LABEL_TYPE_CASSETTE;
		break;
	}

	text = GetStrText(labelDialog, type);

	if(text != NULL){
		SetTextToLabel(window, "label123", text);
	}

	for(i = 0; LabelTextList[i].labeltext != NULL; i++){
		text = GetStrText(LabelTextList[i].labeltext, type2);
		if(text != NULL){
			SetButtonLabel(window, LabelTextList[i].labelname, text);
		}
	}
}

static int GetPPAPDataLBP3600(UIStatusWnd *wnd)
{
	char value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->ppap_dlg->printer_flag = (int)value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->ppap_dlg->num_cassette = (int)value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->ppap_dlg->size_tray = (int)value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->ppap_dlg->size_cas1 = (int)value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->ppap_dlg->size_cas2 = (int)value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->ppap_dlg->size_cas3 = (int)value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) == 0)
		wnd->ppap_dlg->size_cas4 = (int)value;
	return 0;
}

static int GetPPAPDataLBP9100(UIStatusWnd *wnd)
{
	long num = 0;
	long value = 0;
	long i = 0;
	DREQPrtInfo info;

	memset(&info, 0, sizeof(DREQPrtInfo));
	if(GetDREQPrtInfo(wnd, &info) == 0){
		wnd->cas_num = info.nNumCas;
		wnd->dplx = info.nUnit;
	}
	if(info.pName){
		free(info.pName);
	}

	wnd->ppap_dlg->printer_flag = wnd->dplx;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_INPUTINFO) < 0)
		goto err;

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &num, READ_TYPE_LONG, -1) < 0)
		goto err;

	wnd->ppap_dlg->num_cassette = wnd->cas_num;

	for(i = 0; i < num; i++){
		long dwPaperSize = 0;
		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
			goto err;

		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
			goto err;
		dwPaperSize = value;

		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
			goto err;

		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
			goto err;

		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
			goto err;

		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
			goto err;

		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
			goto err;

		switch(i){
		case 0:
			wnd->ppap_dlg->size_tray = dwPaperSize;
			break;
		case 1:
			wnd->ppap_dlg->size_cas1 = dwPaperSize;
			break;
		case 2:
			wnd->ppap_dlg->size_cas2 = dwPaperSize;
			break;
		case 3:
			wnd->ppap_dlg->size_cas3 = dwPaperSize;
			break;
		case 4:
			wnd->ppap_dlg->size_cas4 = dwPaperSize;
			break;
		default:
			break;
		}
	}

	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;
}

UIPPAPDlg* CreatePPAPDlg(UIDialog *parent)
{
	UIPPAPDlg *dialog;

	dialog = (UIPPAPDlg *)CreateDialog(sizeof(UIPPAPDlg), parent);

	UI_DIALOG(dialog)->window = create_PPAP_dialog();

	return dialog;
}

void ShowPPAPDlg(UIStatusWnd *wnd)
{
	int ret = 0;

	switch(wnd->nModel){
	case MODEL_LBP9100:
	case MODEL_LBP9200:
		ret = GetPPAPDataLBP9100(wnd);
		break;
	default:
		ret = GetPPAPDataLBP3600(wnd);
		break;
	}

	if(ret){
		return;
	}

	SigDisable();
	UpdatePPAPDlgWidgets(wnd);
	SigEnable();

	ShowDialog((UIDialog *)wnd->ppap_dlg, NULL);
}

void HidePPAPDlg(UIStatusWnd *wnd)
{
	HideDialog((UIDialog *)wnd->ppap_dlg);
	wnd->ppap = FALSE;
}

void PPAPDlgOK(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->ppap_dlg)->window;
	int i = 0;
	int slot = 0, page = 0, duplex = 0;

	while(cas_radio_widget_table[i] != NULL){
		if(GetToggleButtonActive(window, (char *)cas_radio_widget_table[i])){
			slot = i + 1;
			break;
		}
		i++;
	}

	switch(slot){
	case 0:
		page = wnd->ppap_dlg->size_tray;
		break;
	case 1:
		page = wnd->ppap_dlg->size_cas1;
		break;
	case 2:
		page = wnd->ppap_dlg->size_cas2;
		break;
	case 3:
		page = wnd->ppap_dlg->size_cas3;
		break;
	case 4:
		page = wnd->ppap_dlg->size_cas4;
		break;
	}

	duplex = GetToggleButtonActive(window, "CheckDuplexUnit_checkbutton");

	HidePPAPDlg(wnd);
	ShowMsgDlg(wnd, MSG_TYPE_PRINT_PPAP);
	if(PrintPPAData(wnd->pCnskt->printer, slot, page, duplex, wnd->nModel) < 0)
		HideMsgDlg(wnd);
}

void PPAPDlgCancel(UIStatusWnd *wnd)
{
	HidePPAPDlg(wnd);
}

void UpdatePPAPDlgWidgets(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->ppap_dlg)->window;
	int dplx, cas, i = 0, sensi = 0;

	cas = wnd->ppap_dlg->num_cassette;
	while(cas_radio_widget_table[i] != NULL){
		sensi = (i < cas) ? TRUE : FALSE;
		SetWidgetSensitive(window, (char *)cas_radio_widget_table[i], sensi);
		i++;
	}

	dplx = wnd->ppap_dlg->printer_flag;

	switch(wnd->nModel){
	case MODEL_LBP9100:
	case MODEL_LBP9200:
		sensi = (dplx) ? TRUE : FALSE;
		break;
	default:
		sensi = (dplx & PRINTER_FLAGS_SB_DUPLEX) ? TRUE : FALSE;
		break;
	}
	SetWidgetSensitive(window, "CheckDuplexUnit_checkbutton", sensi);

	SetLabel(wnd);
}


