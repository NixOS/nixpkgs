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
#include "ppavhdlg.h"
#include "data_process.h"
#include "callbacks.h"



static void InitPPAVHDlgWidgets(UIStatusWnd *wnd);
static int GetPPAVHDlgData(UIStatusWnd *wnd);

#define VERTICAL_ADJUSTMENT	1
#define HORIZONTAL_ADJUSTMENT	2

#define VERLIST_LBP9100		"-2.00,-1.80,-1.60,-1.40,-1.20,-1.00,-0.80,-0.60,-0.40,-0.20,0.00,0.20,0.40,0.60,0.80,1.00,1.20,1.40,1.60,1.80,2.00"
#define HORLIST_LBP9100		"-2.22,-1.97,-1.72,-1.48,-1.23,-0.99,-0.74,-0.49,-0.25,0.00,0.25,0.49,0.74,0.99,1.23,1.48,1.72,1.97,2.22"

static float* verList = NULL;
static float* horList = NULL;

static char* verStr = NULL;
static char* horStr = NULL;

static int verMaxCount = 0;
static int horMaxCount = 0;

typedef struct {
	int type;
	char* labeltext;
}StrText;

#define	LABEL_TYPE_CASSETTE		100
#define	LABEL_TYPE_DRAWER		101

static StrText labelVertMulti[] = {
	{LABEL_TYPE_CASSETTE, N_("Vertical Adjustment with Multi-purpose Tray:")},
	{LABEL_TYPE_DRAWER, N_("Vertical Adjustment with Multi-purpose Tray: ")},
	{-1 ,NULL}
};

static StrText labelVertCassette1[] = {
	{LABEL_TYPE_CASSETTE, N_("Vertical Adjustment with Cassette 1:")},
	{LABEL_TYPE_DRAWER, N_("Vertical Adjustment with Drawer 1:")},
	{-1 ,NULL}
};

static StrText labelVertCassette2[] = {
	{LABEL_TYPE_CASSETTE, N_("Vertical Adjustment with Cassette 2:")},
	{LABEL_TYPE_DRAWER, N_("Vertical Adjustment with Drawer 2:")},
	{-1 ,NULL}
};

static StrText labelVertCassette3[] = {
	{LABEL_TYPE_CASSETTE, N_("Vertical Adjustment with Cassette 3:")},
	{LABEL_TYPE_DRAWER, N_("Vertical Adjustment with Drawer 3:")},
	{-1 ,NULL}
};

static StrText labelVertCassette4[] = {
	{LABEL_TYPE_CASSETTE, N_("Vertical Adjustment with Cassette 4:")},
	{LABEL_TYPE_DRAWER, N_("Vertical Adjustment with Drawer 4:")},
	{-1 ,NULL}
};

static StrText labelHoriMulti[] = {
	{LABEL_TYPE_CASSETTE, N_("Horizontal Adjustment with Multi-purpose Tray:")},
	{LABEL_TYPE_DRAWER, N_("Horizontal Adjustment with Multi-purpose Tray: ")},
	{-1 ,NULL}
};

static StrText labelHoriCassette1[] = {
	{LABEL_TYPE_CASSETTE, N_("Horizontal Adjustment with Cassette 1:")},
	{LABEL_TYPE_DRAWER, N_("Horizontal Adjustment with Drawer 1:")},
	{-1 ,NULL}
};

static StrText labelHoriCassette2[] = {
	{LABEL_TYPE_CASSETTE, N_("Horizontal Adjustment with Cassette 2:")},
	{LABEL_TYPE_DRAWER, N_("Horizontal Adjustment with Drawer 2:")},
	{-1 ,NULL}
};

static StrText labelHoriCassette3[] = {
	{LABEL_TYPE_CASSETTE, N_("Horizontal Adjustment with Cassette 3:")},
	{LABEL_TYPE_DRAWER, N_("Horizontal Adjustment with Drawer 3:")},
	{-1 ,NULL}
};

static StrText labelHoriCassette4[] = {
	{LABEL_TYPE_CASSETTE, N_("Horizontal Adjustment with Cassette 4:")},
	{LABEL_TYPE_DRAWER, N_("Horizontal Adjustment with Drawer 4:")},
	{-1 ,NULL}
};

typedef struct {
	StrText* labeltext;
	char* labelname;
}LabelText;

static LabelText LabelTextList[] = {
	{labelVertMulti, "PPAVHDlg_Vertical_Multi_label"},
	{labelVertCassette1, "PPAVHDlg_Vertical_Cas1_label"},
	{labelVertCassette2, "PPAVHDlg_Vertical_Cas2_label"},
	{labelVertCassette3, "PPAVHDlg_Vertical_Cas3_label"},
	{labelVertCassette4, "PPAVHDlg_Vertical_Cas4_label"},
	{labelHoriMulti, "PPAVHDlg_Horizontal_Multi_label"},
	{labelHoriCassette1, "PPAVHDlg_Horizontal_Cas1_label"},
	{labelHoriCassette2, "PPAVHDlg_Horizontal_Cas2_label"},
	{labelHoriCassette3, "PPAVHDlg_Horizontal_Cas3_label"},
	{labelHoriCassette4, "PPAVHDlg_Horizontal_Cas4_label"},
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
	GtkWidget *window = UI_DIALOG(wnd->ppavh_dlg)->window;
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
			SetTextToLabel(window, LabelTextList[i].labelname, text);
		}
	}
}

static void ChangeString2Float(const char* list, int way)
{
	char* pos = NULL;
	char* worklist = NULL;
	float* adjustmentlist = NULL;
	int count = 0;
	int loop = 0;
	int length = strlen(list);
	char* changestr = NULL;

	changestr = malloc(length + 2);
	memset(changestr, 0, length + 2);
	strcpy(changestr, list);
	for(loop = 0; loop < length; loop++){
		if(changestr[loop] == ','){
			changestr[loop] = '\0';
		}
	}

	worklist = strdup(list);
	pos = strtok(worklist, ",");
	while(pos != NULL){
		count++;
		pos = strtok(NULL, ",");
	}
	free(worklist);

	adjustmentlist = (float*)malloc(sizeof(float) * count);

	worklist = strdup(list);
	pos = strtok(worklist, ",");
	for(loop=0; loop < count; loop++){
		sscanf(pos, "%f", &adjustmentlist[loop]);
		pos = strtok(NULL, ",");
	}
	free(worklist);

	if(way == VERTICAL_ADJUSTMENT){
		verMaxCount = count;
		verList = adjustmentlist;
		verStr = changestr;
	}else{
		horMaxCount = count;
		horList = adjustmentlist;
		horStr = changestr;
	}
}

static int GetPPAVHData(UIStatusWnd* wnd, long request, ImageShift* imageshift)
{
	char	value = 0;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, request) < 0)
		goto err;
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) < 0)
		goto err;
	imageshift->shiftTray = value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) < 0)
		goto err;
	imageshift->shiftCassette1 = value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) < 0)
		goto err;
	imageshift->shiftCassette2 = value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) < 0)
		goto err;
	imageshift->shiftCassette3 = value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) < 0)
		goto err;
	imageshift->shiftCassette4 = value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) < 0)
		goto err;
	imageshift->shiftDuplexUnit = value;

	return 0;
err:
	return 1;
}

static int SetPPAVHData(UIStatusWnd* wnd, long request, ImageShift* imageshift)
{
	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG + DATA_LENGTH_BYTE * 6) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, request) < 0)
		goto err;

	if(cnsktSetReqByte(wnd->pCnskt, imageshift->shiftTray) < 0)
		goto err;
	if(cnsktSetReqByte(wnd->pCnskt, imageshift->shiftCassette1) < 0)
		goto err;
	if(cnsktSetReqByte(wnd->pCnskt, imageshift->shiftCassette2) < 0)
		goto err;
	if(cnsktSetReqByte(wnd->pCnskt, imageshift->shiftCassette3) < 0)
		goto err;
	if(cnsktSetReqByte(wnd->pCnskt, imageshift->shiftCassette4) < 0)
		goto err;
	if(cnsktSetReqByte(wnd->pCnskt, imageshift->shiftDuplexUnit) < 0)
		goto err;

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;
	return 0;
err:
	return 1;
}

static int ChangeUIIndex2DeviceIndex(int uiindex, int way)
{
	int index = 0;
	int retindex = 0;

	if(way == VERTICAL_ADJUSTMENT){
		index = verMaxCount;
	}else{
		index = horMaxCount;
	}

	retindex = uiindex - (index / 2);

	return retindex;
}

static int ChangeDeviceIndex2UIIndex(int deviceindex, int way)
{
	int index = 0;
	int retindex = 0;

	if(way == VERTICAL_ADJUSTMENT){
		index = verMaxCount;
	}else{
		index = horMaxCount;
	}

	retindex = (index / 2) + deviceindex;

	if(retindex < 0 || retindex > index){
		retindex = index / 2;
	}

	return retindex;
}

static int GetUIIndexFromEntryString(const char* entryvalue, int way)
{
	float*	list = NULL;
	char	value[32];
	int	loop = 0;
	int	loopmax = 0;

	memset(value, 0, sizeof(value));
	if(way == VERTICAL_ADJUSTMENT){
		loopmax = verMaxCount;
		list = verList;
	}else{
		loopmax = horMaxCount;
		list = horList;
	}

	for(loop=0; loop < loopmax; loop++){
		snprintf( value, sizeof(value), "%2.2f", list[loop]);

		if(strcmp(value, entryvalue) == 0){
			break;
		}
	}

	return loop;
}

static char* GetEntryStringFromUIIndex(int uiindex, int way)
{
	float*	list = NULL;
	char*	retvalue = NULL;
	char	value[32];
	int	max = 0;

	memset(value, 0, sizeof(value));
	if(way == VERTICAL_ADJUSTMENT){
		max = verMaxCount;
		list = verList;
	}else{
		max = horMaxCount;
		list = horList;
	}

	if(max > uiindex){
		snprintf( value, sizeof(value), "%2.2f", list[uiindex]);
		retvalue = strdup(value);
	}

	return retvalue;
}

UIPPAVHDlg* CreatePPAVHDlg(UIDialog *parent)
{
	UIPPAVHDlg *dialog;

	dialog = (UIPPAVHDlg *)CreateDialog(sizeof(UIPPAVHDlg), parent);

	UI_DIALOG(dialog)->window = create_PPAVHDlg_dialog();

	ComboSignalConnect(UI_DIALOG(dialog)->window, "PPAVHDlg_Vertical_Multi_combo", GTK_SIGNAL_FUNC(on_PPAVHDlg_Vertical_Multi_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "PPAVHDlg_Vertical_Cas1_combo", GTK_SIGNAL_FUNC(on_PPAVHDlg_Vertical_Cas1_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "PPAVHDlg_Vertical_Cas2_combo", GTK_SIGNAL_FUNC(on_PPAVHDlg_Vertical_Cas2_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "PPAVHDlg_Vertical_Cas3_combo", GTK_SIGNAL_FUNC(on_PPAVHDlg_Vertical_Cas3_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "PPAVHDlg_Vertical_Cas4_combo", GTK_SIGNAL_FUNC(on_PPAVHDlg_Vertical_Cas4_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "PPAVHDlg_Vertical_Duplex_combo", GTK_SIGNAL_FUNC(on_PPAVHDlg_Vertical_Duplex_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "PPAVHDlg_Horizontal_Multi_combo", GTK_SIGNAL_FUNC(on_PPAVHDlg_Horizontal_Multi_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "PPAVHDlg_Horizontal_Cas1_combo", GTK_SIGNAL_FUNC(on_PPAVHDlg_Horizontal_Cas1_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "PPAVHDlg_Horizontal_Cas2_combo", GTK_SIGNAL_FUNC(on_PPAVHDlg_Horizontal_Cas2_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "PPAVHDlg_Horizontal_Cas3_combo", GTK_SIGNAL_FUNC(on_PPAVHDlg_Horizontal_Cas3_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "PPAVHDlg_Horizontal_Cas4_combo", GTK_SIGNAL_FUNC(on_PPAVHDlg_Horizontal_Cas4_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "PPAVHDlg_Horizontal_Duplex_combo", GTK_SIGNAL_FUNC(on_PPAVHDlg_Horizontal_Duplex_combo_popwin_event));

	return dialog;
}

void ShowPPAVHDlg(UIStatusWnd *wnd)
{
	switch(wnd->nIFVersion){
	case CCPD_IF_VERSION_110:
		{
			if(GetPPAVHDlgData(wnd))
				return;
			SigDisable();
			InitPPAVHDlgWidgets(wnd);
			SigEnable();
		}
		break;
	case CCPD_IF_VERSION_100:
	default:
		break;
	}
	ShowDialog((UIDialog *)wnd->ppavh_dlg, NULL);
}

void HidePPAVHDlg(UIStatusWnd *wnd)
{
	HideDialog((UIDialog *)wnd->ppavh_dlg);

	free(verStr);
	free(horStr);

	free(verList);
	free(horList);
}

void PPAVHDlgOK(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->ppavh_dlg)->window;
	char* value = NULL;

	ImageShift* verShift = &wnd->ppavh_dlg->ver;
	ImageShift* horShift = &wnd->ppavh_dlg->hor;

	value = GetCurrComboText(window, "PPAVHDlg_Vertical_Multi_combo_entry");
	if(value != NULL){
		verShift->shiftTray = ChangeUIIndex2DeviceIndex(GetUIIndexFromEntryString(value, VERTICAL_ADJUSTMENT), VERTICAL_ADJUSTMENT);
	}

	value = GetCurrComboText(window, "PPAVHDlg_Horizontal_Multi_combo_entry");
	if(value != NULL){
		horShift->shiftTray = ChangeUIIndex2DeviceIndex(GetUIIndexFromEntryString(value, HORIZONTAL_ADJUSTMENT), HORIZONTAL_ADJUSTMENT);
	}

	if(wnd->cas_num > 0){
		value = GetCurrComboText(window, "PPAVHDlg_Vertical_Cas1_combo_entry");
		if(value != NULL){
			verShift->shiftCassette1 = ChangeUIIndex2DeviceIndex(GetUIIndexFromEntryString(value, VERTICAL_ADJUSTMENT), VERTICAL_ADJUSTMENT);
		}

		value = GetCurrComboText(window, "PPAVHDlg_Horizontal_Cas1_combo_entry");
		if(value != NULL){
			horShift->shiftCassette1 = ChangeUIIndex2DeviceIndex(GetUIIndexFromEntryString(value, HORIZONTAL_ADJUSTMENT), HORIZONTAL_ADJUSTMENT);
		}
	}

	if(wnd->cas_num > 1){
		value = GetCurrComboText(window, "PPAVHDlg_Vertical_Cas2_combo_entry");
		if(value != NULL){
			verShift->shiftCassette2 = ChangeUIIndex2DeviceIndex(GetUIIndexFromEntryString(value, VERTICAL_ADJUSTMENT), VERTICAL_ADJUSTMENT);
		}

		value = GetCurrComboText(window, "PPAVHDlg_Horizontal_Cas2_combo_entry");
		if(value != NULL){
			horShift->shiftCassette2 = ChangeUIIndex2DeviceIndex(GetUIIndexFromEntryString(value, HORIZONTAL_ADJUSTMENT), HORIZONTAL_ADJUSTMENT);
		}
	}

	if(wnd->cas_num > 2){
		value = GetCurrComboText(window, "PPAVHDlg_Vertical_Cas3_combo_entry");
		if(value != NULL){
			verShift->shiftCassette3 = ChangeUIIndex2DeviceIndex(GetUIIndexFromEntryString(value, VERTICAL_ADJUSTMENT), VERTICAL_ADJUSTMENT);
		}

		value = GetCurrComboText(window, "PPAVHDlg_Horizontal_Cas3_combo_entry");
		if(value != NULL){
			horShift->shiftCassette3 = ChangeUIIndex2DeviceIndex(GetUIIndexFromEntryString(value, HORIZONTAL_ADJUSTMENT), HORIZONTAL_ADJUSTMENT);
		}
	}

	if(wnd->cas_num > 3){
		value = GetCurrComboText(window, "PPAVHDlg_Vertical_Cas4_combo_entry");
		if(value != NULL){
			verShift->shiftCassette4 = ChangeUIIndex2DeviceIndex(GetUIIndexFromEntryString(value, VERTICAL_ADJUSTMENT), VERTICAL_ADJUSTMENT);
		}

		value = GetCurrComboText(window, "PPAVHDlg_Horizontal_Cas4_combo_entry");
		if(value != NULL){
			horShift->shiftCassette4 = ChangeUIIndex2DeviceIndex(GetUIIndexFromEntryString(value, HORIZONTAL_ADJUSTMENT), HORIZONTAL_ADJUSTMENT);
		}
	}

	if(wnd->dplx){
		value = GetCurrComboText(window, "PPAVHDlg_Vertical_Duplex_combo_entry");
		if(value != NULL){
			verShift->shiftDuplexUnit = ChangeUIIndex2DeviceIndex(GetUIIndexFromEntryString(value, VERTICAL_ADJUSTMENT), VERTICAL_ADJUSTMENT);
		}

		value = GetCurrComboText(window, "PPAVHDlg_Horizontal_Duplex_combo_entry");
		if(value != NULL){
			horShift->shiftDuplexUnit = ChangeUIIndex2DeviceIndex(GetUIIndexFromEntryString(value, HORIZONTAL_ADJUSTMENT), HORIZONTAL_ADJUSTMENT);
		}
	}

	HidePPAVHDlg(wnd);

	if(SetPPAVHData(wnd, DREQ_SET_IMAGESHIFT_VERT, &wnd->ppavh_dlg->ver) != 0){
		goto err;
	}
	if(SetPPAVHData(wnd, DREQ_SET_IMAGESHIFT, &wnd->ppavh_dlg->hor) != 0){
		goto err;
	}
	return;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
}

static int GetPPAVHDlgData(UIStatusWnd *wnd)
{
	DREQPrtInfo info;

	if(GetPPAVHData(wnd, DREQ_GET_IMAGESHIFT_VERT, &wnd->ppavh_dlg->ver) != 0){
		goto err;
	}
	if(GetPPAVHData(wnd, DREQ_GET_IMAGESHIFT, &wnd->ppavh_dlg->hor) != 0){
		goto err;
	}

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

static GList* IDListToGList(int way)
{
	GList *glist = NULL;
	float* list = NULL;
	int loop = 0;
	int loopmax = 0;
	char* pos = NULL;

	if(way == VERTICAL_ADJUSTMENT){
		list = verList;
		loopmax = verMaxCount;
		pos = verStr;
	}else{
		list = horList;
		loopmax = horMaxCount;
		pos = horStr;
	}

	for(loop = 0; loop < loopmax; loop++){
		glist = g_list_append(glist, pos);
		pos += (strlen(pos) + 1);
	}

	return glist;
}

typedef struct {
	char*	label;
	char*	combobox;
}CassetteEnable;

static CassetteEnable CassetteVerList[] = {
	{"PPAVHDlg_Vertical_Cas1_combo", "PPAVHDlg_Vertical_Cas1_label"},
	{"PPAVHDlg_Vertical_Cas2_combo", "PPAVHDlg_Vertical_Cas2_label"},
	{"PPAVHDlg_Vertical_Cas3_combo", "PPAVHDlg_Vertical_Cas3_label"},
	{"PPAVHDlg_Vertical_Cas4_combo", "PPAVHDlg_Vertical_Cas4_label"},
	{NULL, NULL}
};

static CassetteEnable CassetteHorList[] = {
	{"PPAVHDlg_Horizontal_Cas1_combo", "PPAVHDlg_Horizontal_Cas1_label"},
	{"PPAVHDlg_Horizontal_Cas2_combo", "PPAVHDlg_Horizontal_Cas2_label"},
	{"PPAVHDlg_Horizontal_Cas3_combo", "PPAVHDlg_Horizontal_Cas3_label"},
	{"PPAVHDlg_Horizontal_Cas4_combo", "PPAVHDlg_Horizontal_Cas4_label"},
	{NULL, NULL}
};

static void InitPPAVHDlgWidgets(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->ppavh_dlg)->window;
	GList* gverlist = NULL;
	GList* ghorlist = NULL;
	ImageShift* verShift = &wnd->ppavh_dlg->ver;
	ImageShift* horShift = &wnd->ppavh_dlg->hor;

	char* cur = NULL;
	int loop = 0;

	ChangeString2Float(VERLIST_LBP9100 ,VERTICAL_ADJUSTMENT);
	ChangeString2Float(HORLIST_LBP9100 ,HORIZONTAL_ADJUSTMENT);

	gverlist = IDListToGList(VERTICAL_ADJUSTMENT);
	ghorlist = IDListToGList(HORIZONTAL_ADJUSTMENT);

	cur = GetEntryStringFromUIIndex( ChangeDeviceIndex2UIIndex( verShift->shiftTray, VERTICAL_ADJUSTMENT), VERTICAL_ADJUSTMENT);
	SetGListToCombo(window, gverlist, "PPAVHDlg_Vertical_Multi_combo", cur);
	free(cur);

	cur = GetEntryStringFromUIIndex( ChangeDeviceIndex2UIIndex( horShift->shiftTray, HORIZONTAL_ADJUSTMENT), HORIZONTAL_ADJUSTMENT);
	SetGListToCombo(window, ghorlist, "PPAVHDlg_Horizontal_Multi_combo", cur);
	free(cur);

	if(wnd->cas_num > 0){
		cur = GetEntryStringFromUIIndex( ChangeDeviceIndex2UIIndex( verShift->shiftCassette1, VERTICAL_ADJUSTMENT), VERTICAL_ADJUSTMENT);
		SetGListToCombo(window, gverlist, "PPAVHDlg_Vertical_Cas1_combo", cur);
		free(cur);

		cur = GetEntryStringFromUIIndex( ChangeDeviceIndex2UIIndex( horShift->shiftCassette1, HORIZONTAL_ADJUSTMENT), HORIZONTAL_ADJUSTMENT);
		SetGListToCombo(window, ghorlist, "PPAVHDlg_Horizontal_Cas1_combo", cur);
		free(cur);
	}

	if(wnd->cas_num > 1){
		cur = GetEntryStringFromUIIndex( ChangeDeviceIndex2UIIndex( verShift->shiftCassette2, VERTICAL_ADJUSTMENT), VERTICAL_ADJUSTMENT);
		SetGListToCombo(window, gverlist, "PPAVHDlg_Vertical_Cas2_combo", cur);
		free(cur);

		cur = GetEntryStringFromUIIndex( ChangeDeviceIndex2UIIndex( horShift->shiftCassette2, HORIZONTAL_ADJUSTMENT), HORIZONTAL_ADJUSTMENT);
		SetGListToCombo(window, ghorlist, "PPAVHDlg_Horizontal_Cas2_combo", cur);
		free(cur);
	}

	if(wnd->cas_num > 2){
		cur = GetEntryStringFromUIIndex( ChangeDeviceIndex2UIIndex( verShift->shiftCassette3, VERTICAL_ADJUSTMENT), VERTICAL_ADJUSTMENT);
		SetGListToCombo(window, gverlist, "PPAVHDlg_Vertical_Cas3_combo", cur);
		free(cur);

		cur = GetEntryStringFromUIIndex( ChangeDeviceIndex2UIIndex( horShift->shiftCassette3, HORIZONTAL_ADJUSTMENT), HORIZONTAL_ADJUSTMENT);
		SetGListToCombo(window, ghorlist, "PPAVHDlg_Horizontal_Cas3_combo", cur);
		free(cur);
	}

	if(wnd->cas_num > 3){
		cur = GetEntryStringFromUIIndex( ChangeDeviceIndex2UIIndex( verShift->shiftCassette4, VERTICAL_ADJUSTMENT), VERTICAL_ADJUSTMENT);
		SetGListToCombo(window, gverlist, "PPAVHDlg_Vertical_Cas4_combo", cur);
		free(cur);

		cur = GetEntryStringFromUIIndex( ChangeDeviceIndex2UIIndex( horShift->shiftCassette4, HORIZONTAL_ADJUSTMENT), HORIZONTAL_ADJUSTMENT);
		SetGListToCombo(window, ghorlist, "PPAVHDlg_Horizontal_Cas4_combo", cur);
		free(cur);
	}

	if(wnd->dplx){
		cur = GetEntryStringFromUIIndex( ChangeDeviceIndex2UIIndex( verShift->shiftDuplexUnit, VERTICAL_ADJUSTMENT), VERTICAL_ADJUSTMENT);
		SetGListToCombo(window, gverlist, "PPAVHDlg_Vertical_Duplex_combo", cur);
		free(cur);

		cur = GetEntryStringFromUIIndex( ChangeDeviceIndex2UIIndex( horShift->shiftDuplexUnit, HORIZONTAL_ADJUSTMENT), HORIZONTAL_ADJUSTMENT);
		SetGListToCombo(window, ghorlist, "PPAVHDlg_Horizontal_Duplex_combo", cur);
		free(cur);
	}

	for(loop = 0; CassetteVerList[loop].label != NULL; loop++){
		if(loop >= wnd->cas_num){
			SetWidgetSensitive(window, CassetteVerList[loop].label, FALSE);
			SetWidgetSensitive(window, CassetteVerList[loop].combobox, FALSE);
			SetWidgetSensitive(window, CassetteHorList[loop].label, FALSE);
			SetWidgetSensitive(window, CassetteHorList[loop].combobox, FALSE);
		}
	}
	if(!(wnd->dplx)){
		SetWidgetSensitive(window, "PPAVHDlg_Vertical_Duplex_combo", FALSE);
		SetWidgetSensitive(window, "PPAVHDlg_Vertical_Duplex_label", FALSE);
		SetWidgetSensitive(window, "PPAVHDlg_Horizontal_Duplex_combo", FALSE);
		SetWidgetSensitive(window, "PPAVHDlg_Horizontal_Duplex_label", FALSE);
	}

	SetLabel(wnd);

	g_list_free(gverlist);
	g_list_free(ghorlist);
}

