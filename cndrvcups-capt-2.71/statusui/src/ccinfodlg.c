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

#include "support.h"
#include "uimain.h"
#include "widgets.h"
#include "interface.h"
#include "ccinfodlg.h"
#include "data_process.h"

enum{
	CRT_STR_AVAILABLE,
	CRT_STR_SOON,
	CRT_STR_CHECK,
	CRT_STR_REPLACE,
	CRT_STR_INSERT,
	CRT_STR_UNKNOWN,
};

static char *CartridgeStr[] = {
	N_("Available"),
	N_("Replacement Needed Soon"),
	N_("Check Cartridge"),
	N_("Replace Cartridge"),
	N_("Insert Cartridge"),
	N_("Unknown"),
	NULL,
};

static char *ContainerStr[] = {
	N_("Available"),
	N_("Replacement Needed Soon"),
	N_("Check Container"),
	N_("Replace Container"),
	N_("Insert Container"),
	N_("Unknown"),
	NULL,
};

static const char* const PagesStr = N_("pages");
static const char* const SheetsStr = N_("sheets");
static const char* const JobsStr = N_("jobs");
#define MAX_LINESTRINGS	32

static void InitCCInfoDlgWidgets(UIStatusWnd *wnd, long mono, long color, long *status);
static int GetCCInfoData(UIStatusWnd *wnd, long *mono, long *color, long *status);

static void InitCCInfoDlgWidgets2(UIStatusWnd *wnd);
static void InitCCInfoDlgWidgets2_Consumable(UIStatusWnd* const wnd);
static void InitCCInfoDlgWidgets2_Counter(UIStatusWnd* const wnd);
static int GetCCInfoData2_Consumable(UIStatusWnd* const wnd);
static int GetCCInfoData2_Counter(UIStatusWnd* const wnd);

static void InitCCInfoDlgWidgets2_LBP9100(UIStatusWnd *wnd);
static void InitConsumablesInfoDlgWidgets2_LBP7010(UIStatusWnd *const wnd);
static void InitCountersInfoDlgWidgets2_LBP7010(UIStatusWnd *const wnd);
static void InitConsumablesInfoDlgWidgets2_LBP9200(UIStatusWnd *const wnd);
static void InitCountersInfoDlgWidgets2_LBP9200(const UIStatusWnd *const wnd);
static void InitConsumablesInfoDlgWidgets2_LBP7210(UIStatusWnd *const wnd);

UICCInfoDlg* CreateCCInfoDlg(UIDialog *parent)
{
	UICCInfoDlg *dialog;

	dialog = (UICCInfoDlg *)CreateDialog(sizeof(UICCInfoDlg), parent);

	UI_DIALOG(dialog)->window = create_ConsumablesCounters_dialog();

	return dialog;
}

void ShowCCInfoDlg(UIStatusWnd *wnd)
{
	long mono, color;
	long status[9];

	switch(wnd->nIFVersion){
	case CCPD_IF_VERSION_110:
		switch(wnd->nModel){
		case MODEL_LBP6000:
		case MODEL_LBP6300:
		case MODEL_LBP6200:
		case MODEL_LBP6020:
		case MODEL_LBP6310:
		case MODEL_LBP6340:
		case MODEL_LBP7210:
			if(GetCCInfoData2_Counter(wnd) != 0){
				return;
			}
			break;
		default:
			if(GetCCInfoData2_Consumable(wnd) != 0){
				return;
			}
			if(GetCCInfoData2_Counter(wnd) != 0){
				return;
			}
			break;
		}
		SigDisable();
		switch(wnd->nModel){
		case MODEL_LBP9100:
			InitCCInfoDlgWidgets2_LBP9100(wnd);
			break;
		default:
			InitCCInfoDlgWidgets2(wnd);
			break;
		}
		SigEnable();
		break;
	case CCPD_IF_VERSION_100:
	default:
		if(GetCCInfoData(wnd, &mono, &color, status))
			return;
		SigDisable();
		InitCCInfoDlgWidgets(wnd, mono, color, status);
		SigEnable();
		break;
	}

	ShowDialog((UIDialog *)wnd->ccinfo_dlg, NULL);
}

void ShowConsumablesInfoDlg(UIStatusWnd *const wnd)
{
	if(wnd != NULL){
		switch(wnd->nIFVersion){
			case CCPD_IF_VERSION_110:
				if(GetCCInfoData2_Consumable(wnd) != 0){
					return;
				}
				SigDisable();
				switch(wnd->nModel){
					case MODEL_LBP7010:
						InitConsumablesInfoDlgWidgets2_LBP7010(wnd);
						break;
					case MODEL_LBP9200:
						InitConsumablesInfoDlgWidgets2_LBP9200(wnd);
						break;
					case MODEL_LBP7210:
						InitConsumablesInfoDlgWidgets2_LBP7210(wnd);
						break;
					default:
						SigEnable();
						return;
				}
				SigEnable();
				break;
			default:
					return;
		}

		ShowDialog((UIDialog *)wnd->ccinfo_dlg, NULL);
	}
}

void ShowCountersInfoDlg(UIStatusWnd *const wnd)
{
	if(wnd != NULL){
		switch(wnd->nIFVersion){
			case CCPD_IF_VERSION_110:
				if(GetCCInfoData2_Counter(wnd) != 0){
					return;
				}
				SigDisable();
				switch(wnd->nModel){
					case MODEL_LBP7010:
						InitCountersInfoDlgWidgets2_LBP7010(wnd);
						break;
					case MODEL_LBP9200:
						InitCountersInfoDlgWidgets2_LBP9200(wnd);
						break;
					default:
						SigEnable();
						return;
				}
				SigEnable();
				break;
			default:
					return;
		}

		ShowDialog((UIDialog *)wnd->ccinfo_dlg, NULL);
	}
}

void HideCCInfoDlg(UIStatusWnd *wnd)
{
	HideDialog((UIDialog *)wnd->ccinfo_dlg);
}

void CCInfoDlgOK(UIStatusWnd *wnd)
{
	HideCCInfoDlg(wnd);
}

static char* GetCrtStr(int index)
{
	if(index < CRT_STR_AVAILABLE || index > CRT_STR_UNKNOWN)
		return NULL;

	return _(CartridgeStr[index]);
}

static char* GetCrtStrContainer(int index)
{
	if(index < CRT_STR_AVAILABLE || index > CRT_STR_UNKNOWN)
		return NULL;

	return _(ContainerStr[index]);
}

static void InitCCInfoDlgWidgets(UIStatusWnd *wnd, long mono, long color, long *status)
{
	GtkWidget *window = UI_DIALOG(wnd->ccinfo_dlg)->window;
	char ColorCnt[32];
	char MonoCnt[32];
	int i;

	for(i = 0; i < 4; i++){
		int nBit = 1 << i;
		char *str = NULL;

#if 0
		if(status[2] & nBit)
			str = GetCrtStr(CRT_STR_REPLACE);
		else if(status[1] & nBit)
			str = GetCrtStr(CRT_STR_CHECK);
		else if(status[0] & nBit)
			str = GetCrtStr(CRT_STR_SOON);
		else
			str = GetCrtStr(CRT_STR_AVAILABLE);
#else
		if(status[4] & nBit){
			str = GetCrtStr(CRT_STR_INSERT);
		}
		else if(status[5] & nBit){
			str = GetCrtStr(CRT_STR_INSERT);
		}
		else if(status[2] & nBit){
			str = GetCrtStr(CRT_STR_REPLACE);
		}
		else if(status[1] & nBit){
			str = GetCrtStr(CRT_STR_UNKNOWN);
		}
		else if(status[3] & nBit){
			str = GetCrtStr(CRT_STR_UNKNOWN);
		}
		else if(status[6] & nBit){
			str = GetCrtStr(CRT_STR_UNKNOWN);
		}
		else if(status[7] & nBit){
			str = GetCrtStr(CRT_STR_UNKNOWN);
		}
		else if(status[8] & nBit){
			str = GetCrtStr(CRT_STR_UNKNOWN);
		}
		else if(status[0] & nBit){
			str = GetCrtStr(CRT_STR_SOON);
		}
		else{
			str = GetCrtStr(CRT_STR_AVAILABLE);
		}
#endif
		switch(i){
		case 0:
			SetTextToLabel(window, "CCDlg_Black_label", str);
			break;
		case 1:
			SetTextToLabel(window, "CCDlg_Cyan_label", str);
			break;
		case 2:
			SetTextToLabel(window, "CCDlg_Magenta_label", str);
			break;
		case 3:
			SetTextToLabel(window, "CCDlg_Yellow_label", str);
			break;
		}
	}

	memset(MonoCnt, 0, 32);
	snprintf(MonoCnt, 31, "%d %s", mono, _(PagesStr));
	SetTextToLabel(window, "CCDlg_Mono_Cnt_label", MonoCnt);

	memset(ColorCnt, 0, 32);
	snprintf(ColorCnt, 31, "%d %s", color, _(PagesStr));
	SetTextToLabel(window, "CCDlg_Color_Cnt_label", ColorCnt);

}

static int GetCCInfoData(UIStatusWnd *wnd, long *mono, long *color, long *status)
{
	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_SHORT) < 0)
		goto err;
	if(cnsktSetReqShort(wnd->pCnskt, COUNTER_ID_MONO) < 0)
		goto err;
	if(SendRequest(wnd, CCPD_REQ_COUNTER) < 0)
		goto err;
	if(cnsktGetResData(wnd->pCnskt, mono, READ_TYPE_LONG, -1) < 0)
		goto err;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_SHORT) < 0)
		goto err;
	if(cnsktSetReqShort(wnd->pCnskt, COUNTER_ID_COLOR) < 0)
		goto err;
	if(SendRequest(wnd, CCPD_REQ_COUNTER) < 0)
		goto err;
	if(cnsktGetResData(wnd->pCnskt, color, READ_TYPE_LONG, -1) < 0)
		goto err;

	if(SendRequest(wnd, CCPD_REQ_CRG_STATUS) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &status[0], READ_TYPE_LONG, -1) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &status[1], READ_TYPE_LONG, -1) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &status[2], READ_TYPE_LONG, -1) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &status[3], READ_TYPE_LONG, -1) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &status[4], READ_TYPE_LONG, -1) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &status[5], READ_TYPE_LONG, -1) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &status[6], READ_TYPE_LONG, -1) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &status[7], READ_TYPE_LONG, -1) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &status[8], READ_TYPE_LONG, -1) < 0)
		goto err;

	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_CCINFO_GET_ERR);
	return 1;
}

#define	TONER_K	0x0001
#define	TONER_Y	0x0002
#define	TONER_M	0x0004
#define	TONER_C	0x0008
#define	DRUM_K	0x0010
#define	DRUM_Y	0x0020
#define	DRUM_M	0x0040
#define	DRUM_C	0x0080
#define	DRUM_OPC 0x1000
#define	WASTE_TONER	0x0100
#define	FUSER	0x0200

static int DataToInfo(UIStatusWnd *wnd, long typebit)
{
#if 0
	if(wnd->ccinfo_dlg->warning & typebit)
		return CRT_STR_SOON;
	else if(wnd->ccinfo_dlg->out & typebit)
		return CRT_STR_REPLACE;
	else if(wnd->ccinfo_dlg->absent & typebit)
		return CRT_STR_INSERT;
	else
		return CRT_STR_AVAILABLE;
#else
	switch(wnd->nModel){
		case MODEL_LBP7010:
		case MODEL_LBP9200:
		case MODEL_LBP7210:
			if(wnd->ccinfo_dlg->absent & typebit){
				return CRT_STR_INSERT;
			}
			else if(wnd->ccinfo_dlg->misplas & typebit){
				return CRT_STR_INSERT;
			}
			else if(wnd->ccinfo_dlg->warning3 & typebit){
				return CRT_STR_REPLACE;
			}
			else if(wnd->ccinfo_dlg->warning2 & typebit){
				return CRT_STR_REPLACE;
			}
			else if(wnd->ccinfo_dlg->warning4 & typebit){
				return CRT_STR_REPLACE;
			}
			else if(wnd->ccinfo_dlg->memerror & typebit){
				return CRT_STR_REPLACE;
			}
			else if(wnd->ccinfo_dlg->mounterror & typebit){
				return CRT_STR_REPLACE;
			}
			else if(wnd->ccinfo_dlg->sealedrror & typebit){
				return CRT_STR_REPLACE;
			}
			else if(wnd->ccinfo_dlg->warning1 & typebit){
				return CRT_STR_SOON;
			}
			else{
				return CRT_STR_AVAILABLE;
			}
		default:
			if(wnd->ccinfo_dlg->absent & typebit){
				return CRT_STR_INSERT;
			}
			else if(wnd->ccinfo_dlg->misplas & typebit){
				return CRT_STR_INSERT;
			}
			else if(wnd->ccinfo_dlg->warning3 & typebit){
				return CRT_STR_REPLACE;
			}
			else if(wnd->ccinfo_dlg->warning2 & typebit){
				return CRT_STR_UNKNOWN;
			}
			else if(wnd->ccinfo_dlg->warning4 & typebit){
				return CRT_STR_UNKNOWN;
			}
			else if(wnd->ccinfo_dlg->memerror & typebit){
				return CRT_STR_UNKNOWN;
			}
			else if(wnd->ccinfo_dlg->mounterror & typebit){
				return CRT_STR_UNKNOWN;
			}
			else if(wnd->ccinfo_dlg->sealedrror & typebit){
				return CRT_STR_UNKNOWN;
			}
			else if(wnd->ccinfo_dlg->warning1 & typebit){
				return CRT_STR_SOON;
			}
			else{
				return CRT_STR_AVAILABLE;
			}
	}
#endif
}

static void InitCCInfoDlgWidgets2_Consumable(UIStatusWnd* const wnd)
{
	GtkWidget *window = NULL;
	int index;
	char *str = NULL;

	if( wnd == NULL ){
		return;
	}
	window = wnd->ccinfo_dlg->dialog.window;
	if( window == NULL ){
		return;
	}

	index = DataToInfo(wnd, TONER_K);
	str = GetCrtStr(index);
	SetTextToLabel(window, "CCDlg_Black_label", str);

	str = NULL;
	index = DataToInfo(wnd, TONER_Y);
	str = GetCrtStr(index);
	SetTextToLabel(window, "CCDlg_Yellow_label", str);

	str = NULL;
	index = DataToInfo(wnd, TONER_M);
	str = GetCrtStr(index);
	SetTextToLabel(window, "CCDlg_Magenta_label", str);

	str = NULL;
	index = DataToInfo(wnd, TONER_C);
	str = GetCrtStr(index);
	SetTextToLabel(window, "CCDlg_Cyan_label", str);
}

static void InitCCInfoDlgWidgets2_Counter(UIStatusWnd* const wnd)
{
	GtkWidget *window = NULL;
	char ColorCnt[MAX_LINESTRINGS];
	char MonoCnt[MAX_LINESTRINGS];
	char TotalCnt[MAX_LINESTRINGS];
	char SheetCnt[MAX_LINESTRINGS];
	char JobCnt[MAX_LINESTRINGS];
	long mono = 0;
	long color = 0;
	long total = 0;
	long sheet = 0;
	long job = 0;

	if( wnd == NULL ){
		return;
	}
	window = wnd->ccinfo_dlg->dialog.window;

	if( window == NULL ){
		return;
	}

	mono = wnd->ccinfo_dlg->counterBWSmall + wnd->ccinfo_dlg->counterDuplexBWSmall;
	mono += wnd->ccinfo_dlg->counterBWLarge + wnd->ccinfo_dlg->counterDuplexBWLarge;
	color = wnd->ccinfo_dlg->counterColorSmall + wnd->ccinfo_dlg->counterDuplexColorSmall;
	color += wnd->ccinfo_dlg->counterColorLarge + wnd->ccinfo_dlg->counterDuplexColorLarge;
	total = mono + color;
	sheet = wnd->ccinfo_dlg->counterDuplexBWSmall + wnd->ccinfo_dlg->counterDuplexBWLarge + wnd->ccinfo_dlg->counterDuplexColorSmall + wnd->ccinfo_dlg->counterDuplexColorLarge;
	job = wnd->ccinfo_dlg->counterJobs;

	memset(MonoCnt, 0, sizeof(MonoCnt));
	snprintf(MonoCnt, sizeof(MonoCnt), "%d %s", (int)mono, _(PagesStr));
	SetTextToLabel(window, "CCDlg_Mono_Cnt_label", MonoCnt);

	memset(ColorCnt, 0, sizeof(ColorCnt));
	snprintf(ColorCnt, sizeof(ColorCnt), "%d %s", (int)color, _(PagesStr));
	SetTextToLabel(window, "CCDlg_Color_Cnt_label", ColorCnt);

	memset(TotalCnt, 0, sizeof(TotalCnt));
	snprintf(TotalCnt, sizeof(TotalCnt), "%d %s", (int)total, _(PagesStr));
	SetTextToLabel(window, "CCDlg_TotalPrint_Cnt_label", TotalCnt);

	memset(SheetCnt, 0, sizeof(SheetCnt));
	snprintf(SheetCnt, sizeof(SheetCnt), "%d %s", (int)sheet, _(SheetsStr));
	SetTextToLabel(window, "CCDlg_Duplex_Cnt_label", SheetCnt);

	memset(JobCnt, 0, sizeof(JobCnt));
	snprintf(JobCnt, sizeof(JobCnt), "%d %s", (int)job, _(JobsStr));
	SetTextToLabel(window, "CCDlg_Job_Cnt_label", JobCnt);
}

#define MAX_CCINFO_CTRL 21
static const char* const ccinfo_ctrl[MAX_CCINFO_CTRL] = {
	"frame51",
	"frame58",
	"frame52",
	"label149",
	"CCDlg_Mono_Cnt_label",
	"label150",
	"CCDlg_Color_Cnt_label",
	"label188",
	"CCDlg_MonoS_Cnt_label",
	"label189",
	"CCDlg_MonoL_Cnt_label",
	"label190",
	"CCDlg_ColorS_Cnt_label",
	"label191",
	"CCDlg_ColorL_Cnt_label",
	"label240",
	"CCDlg_TotalPrint_Cnt_label",
	"label241",
	"CCDlg_Duplex_Cnt_label",
	"label242",
	"CCDlg_Job_Cnt_label"
};

typedef struct ccinfo_tbl{
	long model;
	long lang;
	gboolean consumable;
	gboolean counter;
	gboolean ctrlflag[MAX_CCINFO_CTRL];
}CCINFO_TBL;

static const CCINFO_TBL ccinfotbl[] = {
	{MODEL_LBP7200, LANG_TYPE_US, TRUE, TRUE,
		{TRUE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE}},
	{MODEL_LBP6300, LANG_TYPE_US, FALSE, TRUE,
		{FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE}},
	{MODEL_LBP6000, LANG_TYPE_US, FALSE, TRUE,
		{FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE}},
	{MODEL_LBP6200, LANG_TYPE_JP, FALSE, TRUE,
		{FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE}},
	{MODEL_LBP6200, LANG_TYPE_UK, FALSE, TRUE,
		{FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE}},
	{MODEL_LBP6200, LANG_TYPE_US, FALSE, TRUE,
		{FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE}},
	{MODEL_LBP7210, LANG_TYPE_UK, FALSE, TRUE,
{FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE}},
	{MODEL_LBP6310, LANG_TYPE_UK, FALSE, TRUE,
		{FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE}},
	{MODEL_LBP6340, LANG_TYPE_JP, FALSE, TRUE,
		{FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE}},
	{MODEL_LBP6020, LANG_TYPE_UK, FALSE, TRUE,
		{FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE}},
	{-1, 0, TRUE, TRUE,
		{FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE}}
};

static void InitCCInfoDlgWidgets2(UIStatusWnd *wnd)
{
	GtkWidget *window = NULL;

	int type = 0;
	int ctrl = 0;
	gboolean isFound = FALSE;

	if( wnd == NULL || wnd->ccinfo_dlg == NULL ){
		return;
	}

	window = UI_DIALOG(wnd->ccinfo_dlg)->window;

	if( window == NULL ){
		return;
	}

	for( type=0; ccinfotbl[type].model != -1; type++ ){
		if( (wnd->nModel == ccinfotbl[type].model) && (wnd->nLangType == ccinfotbl[type].lang) ){
			isFound = TRUE;
			break;
		}
	}

	if( isFound == TRUE ){
		for( ctrl=0; ctrl<MAX_CCINFO_CTRL; ctrl++ ){
			if( ccinfotbl[type].ctrlflag[ctrl] == TRUE ){
				ShowWidget(window, ccinfo_ctrl[ctrl]);
			} else {
				HideWidget(window, ccinfo_ctrl[ctrl]);
			}
		}
	}

	switch(wnd->nModel){
	case MODEL_LBP6300:
	case MODEL_LBP6000:
		if(IsUS(wnd) == TRUE){
			SetDialogTitle(window, _("Counter Information"));
			SetTextToLabel(window, "Frame_label149", _("Counter"));
		}
		break;
	case MODEL_LBP6020:
	case MODEL_LBP6310:
	case MODEL_LBP6340:
		SetDialogTitle(window, _("Counter Information"));
		SetTextToLabel(window, "Frame_label149", _("Counter"));
		break;
	case MODEL_LBP7210:
		SetDialogTitle(window, _("Counter Information"));
		SetTextToLabel(window, "Frame_label149", _("Counter"));
		SetTextToLabel(window, "label150", _("Color Print Pages:"));
		SetTextToLabel(window, "label149", _("B&W Print Pages:"));
		break;
	case MODEL_LBP6200:
		SetDialogTitle(window, _("Counter Information"));
		SetTextToLabel(window, "Frame_label149", _("Counter"));
		break;
	case MODEL_LBP7200:
		if(IsUS(wnd) == TRUE){
			SetTextToLabel(window, "Frame_label149", _("Counter"));
		}
		break;
	default:
		break;
	}

	if( ccinfotbl[type].consumable == TRUE ){
		InitCCInfoDlgWidgets2_Consumable( wnd );
	}
	if( ccinfotbl[type].counter == TRUE ){
		InitCCInfoDlgWidgets2_Counter( wnd );
	}
}

#if 0
static void InitCCInfoDlgWidgets2(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->ccinfo_dlg)->window;
	char ColorCnt[32];
	char MonoCnt[32];
	int index;
	char *str = NULL;
	long mono = 0;
	long color = 0;

	index = DataToInfo(wnd, TONER_K);
	str = GetCrtStr(index);
	SetTextToLabel(window, "CCDlg_Black_label", str);

	str = NULL;
	index = DataToInfo(wnd, TONER_Y);
	str = GetCrtStr(index);
	SetTextToLabel(window, "CCDlg_Yellow_label", str);

	str = NULL;
	index = DataToInfo(wnd, TONER_M);
	str = GetCrtStr(index);
	SetTextToLabel(window, "CCDlg_Magenta_label", str);

	str = NULL;
	index = DataToInfo(wnd, TONER_C);
	str = GetCrtStr(index);
	SetTextToLabel(window, "CCDlg_Cyan_label", str);

	mono = wnd->ccinfo_dlg->counterBWSmall + wnd->ccinfo_dlg->counterDuplexBWSmall;
	mono += wnd->ccinfo_dlg->counterBWLarge + wnd->ccinfo_dlg->counterDuplexBWLarge;
	color = wnd->ccinfo_dlg->counterColorSmall + wnd->ccinfo_dlg->counterDuplexColorSmall;
	color += wnd->ccinfo_dlg->counterColorLarge + wnd->ccinfo_dlg->counterDuplexColorLarge;

	memset(MonoCnt, 0, 32);
	snprintf(MonoCnt, 31, "%d %s", mono, _(PagesStr));
	SetTextToLabel(window, "CCDlg_Mono_Cnt_label", MonoCnt);

	memset(ColorCnt, 0, 32);
	snprintf(ColorCnt, 31, "%d %s", color, _(PagesStr));
	SetTextToLabel(window, "CCDlg_Color_Cnt_label", ColorCnt);
}
#endif

static void InitCCInfoDlgWidgets2_LBP9100(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->ccinfo_dlg)->window;
	char ColorCnt[32];
	char MonoCnt[32];
	int index;
	long monoL = 0;
	long monoS = 0;
	long colorL = 0;
	long colorS = 0;
	char *str = NULL;

	index = DataToInfo(wnd, TONER_K);
	str = GetCrtStr(index);
	SetTextToLabel(window, "CCDlg_Black_label", str);

	str = NULL;
	index = DataToInfo(wnd, TONER_Y);
	str = GetCrtStr(index);
	SetTextToLabel(window, "CCDlg_Yellow_label", str);

	str = NULL;
	index = DataToInfo(wnd, TONER_M);
	str = GetCrtStr(index);
	SetTextToLabel(window, "CCDlg_Magenta_label", str);

	str = NULL;
	index = DataToInfo(wnd, TONER_C);
	str = GetCrtStr(index);
	SetTextToLabel(window, "CCDlg_Cyan_label", str);

	ShowWidget(window, "frame58");

	str = NULL;
	index = DataToInfo(wnd, WASTE_TONER);
	str = GetCrtStrContainer(index);
	SetTextToLabel(window, "CCDlg_WasteToner_label", str);

	ShowWidget(window, "label188");
	ShowWidget(window, "CCDlg_MonoS_Cnt_label");
	ShowWidget(window, "label189");
	ShowWidget(window, "CCDlg_MonoL_Cnt_label");
	ShowWidget(window, "label190");
	ShowWidget(window, "CCDlg_ColorS_Cnt_label");
	ShowWidget(window, "label191");
	ShowWidget(window, "CCDlg_ColorL_Cnt_label");
	HideWidget(window, "label149");
	HideWidget(window, "CCDlg_Mono_Cnt_label");
	HideWidget(window, "label150");
	HideWidget(window, "CCDlg_Color_Cnt_label");

	monoS = wnd->ccinfo_dlg->counterBWSmall + wnd->ccinfo_dlg->counterDuplexBWSmall;
	monoL = wnd->ccinfo_dlg->counterBWLarge + wnd->ccinfo_dlg->counterDuplexBWLarge;
	colorS = wnd->ccinfo_dlg->counterColorSmall + wnd->ccinfo_dlg->counterDuplexColorSmall;
	colorL = wnd->ccinfo_dlg->counterColorLarge + wnd->ccinfo_dlg->counterDuplexColorLarge;

	memset(MonoCnt, 0, 32);
	snprintf(MonoCnt, 31, "%d %s", monoS, _(PagesStr));
	SetTextToLabel(window, "CCDlg_MonoS_Cnt_label", MonoCnt);

	memset(MonoCnt, 0, 32);
	snprintf(MonoCnt, 31, "%d %s", monoL, _(PagesStr));
	SetTextToLabel(window, "CCDlg_MonoL_Cnt_label", MonoCnt);

	memset(ColorCnt, 0, 32);
	snprintf(ColorCnt, 31, "%d %s", colorL, _(PagesStr));
	SetTextToLabel(window, "CCDlg_ColorL_Cnt_label", ColorCnt);

	memset(ColorCnt, 0, 32);
	snprintf(ColorCnt, 31, "%d %s", colorS, _(PagesStr));
	SetTextToLabel(window, "CCDlg_ColorS_Cnt_label", ColorCnt);
}

static void InitConsumablesInfoDlgWidgets2_LBP7010(UIStatusWnd *const wnd)
{
	if(wnd != NULL){
		GtkWidget *window = UI_DIALOG(wnd->ccinfo_dlg)->window;
		int index = 0;
		char *str = NULL;

		InitCCInfoDlgWidgets2_Consumable(wnd);

		index = DataToInfo(wnd, DRUM_OPC);
		str = GetCrtStr(index);
		SetTextToLabel(window, "CCDlg_DrumCartridge_label", str);

		SetDialogTitle(window, _("Consumables Information"));

		ShowWidget(window, "frame51");
		ShowWidget(window, "frame65");
		HideWidget(window, "frame52");
	}
}

static void InitCountersInfoDlgWidgets2_LBP7010(UIStatusWnd *const wnd)
{
	if(wnd != NULL){
		GtkWidget *window = UI_DIALOG(wnd->ccinfo_dlg)->window;

		InitCCInfoDlgWidgets2_Counter(wnd);

		SetDialogTitle(window, _("Counter Information"));
		SetTextToLabel(window, "Frame_label149", _("Counter"));

		ShowWidget(window, "label240");
		ShowWidget(window, "CCDlg_TotalPrint_Cnt_label");
		ShowWidget(window, "label242");
		ShowWidget(window, "CCDlg_Job_Cnt_label");
		ShowWidget(window, "frame52");
		HideWidget(window, "frame51");
		HideWidget(window, "frame65");
	}
}

static void InitConsumablesInfoDlgWidgets2_LBP9200(UIStatusWnd *const wnd)
{
	if(wnd != NULL){
		GtkWidget *window = UI_DIALOG(wnd->ccinfo_dlg)->window;
		int index = 0;
		char *str = NULL;

		if( window == NULL ){
			return;
		}

		SetDialogTitle(window, _("Consumables Information"));

		InitCCInfoDlgWidgets2_Consumable(wnd);

		index = DataToInfo(wnd, WASTE_TONER);
		str = GetCrtStrContainer(index);
		SetTextToLabel(window, "CCDlg_WasteToner_label", str);

		ShowWidget(window, "frame51");
		ShowWidget(window, "frame58");
		HideWidget(window, "frame65");
		HideWidget(window, "frame52");
	}
}

static void InitCountersInfoDlgWidgets2_LBP9200(const UIStatusWnd *const wnd)
{
	if(wnd != NULL){
		GtkWidget *window = UI_DIALOG(wnd->ccinfo_dlg)->window;
		char MonoSCnt[MAX_LINESTRINGS];
		char MonoLCnt[MAX_LINESTRINGS];
		char ColorSCnt[MAX_LINESTRINGS];
		char ColorLCnt[MAX_LINESTRINGS];
		char TotalCnt[MAX_LINESTRINGS];
		char SheetCnt[MAX_LINESTRINGS];
		char JobCnt[MAX_LINESTRINGS];
		long monoL = 0;
		long monoS = 0;
		long colorL = 0;
		long colorS = 0;
		long total = 0;
		long sheet = 0;
		long job = 0;

		if( window == NULL ){
			return;
		}

		SetDialogTitle(window, _("Counter Information"));
		SetTextToLabel(window, "Frame_label149", _("Counter"));
		SetTextToLabel(window, "label188", _("B&W S Print Pages:"));
		SetTextToLabel(window, "label189", _("B&W L Print Pages:"));
		SetTextToLabel(window, "label190", _("Color S Print Pages:"));
		SetTextToLabel(window, "label191", _("Color L Print Pages:"));

		monoS = wnd->ccinfo_dlg->counterBWSmall + wnd->ccinfo_dlg->counterDuplexBWSmall;
		monoL = wnd->ccinfo_dlg->counterBWLarge + wnd->ccinfo_dlg->counterDuplexBWLarge;
		colorS = wnd->ccinfo_dlg->counterColorSmall + wnd->ccinfo_dlg->counterDuplexColorSmall;
		colorL = wnd->ccinfo_dlg->counterColorLarge + wnd->ccinfo_dlg->counterDuplexColorLarge;
		total = monoS + monoL + colorS + colorL;
		sheet = wnd->ccinfo_dlg->counterDuplexBWSmall + wnd->ccinfo_dlg->counterDuplexBWLarge +
			wnd->ccinfo_dlg->counterDuplexColorSmall + wnd->ccinfo_dlg->counterDuplexColorLarge;
		job = wnd->ccinfo_dlg->counterJobs;

		memset(MonoSCnt, 0, sizeof(MonoSCnt));
		snprintf(MonoSCnt, sizeof(MonoSCnt), "%d %s", (int)monoS, _(PagesStr));
		SetTextToLabel(window, "CCDlg_MonoS_Cnt_label", MonoSCnt);

		memset(MonoLCnt, 0, sizeof(MonoLCnt));
		snprintf(MonoLCnt, sizeof(MonoLCnt), "%d %s", (int)monoL, _(PagesStr));
		SetTextToLabel(window, "CCDlg_MonoL_Cnt_label", MonoLCnt);

		memset(ColorSCnt, 0, sizeof(ColorSCnt));
		snprintf(ColorSCnt, sizeof(ColorSCnt), "%d %s", (int)colorS, _(PagesStr));
		SetTextToLabel(window, "CCDlg_ColorS_Cnt_label", ColorSCnt);

		memset(ColorLCnt, 0, sizeof(ColorLCnt));
		snprintf(ColorLCnt, sizeof(ColorLCnt), "%d %s", (int)colorL, _(PagesStr));
		SetTextToLabel(window, "CCDlg_ColorL_Cnt_label", ColorLCnt);

		memset(TotalCnt, 0, sizeof(TotalCnt));
		snprintf(TotalCnt, sizeof(TotalCnt), "%d %s", (int)total, _(PagesStr));
		SetTextToLabel(window, "CCDlg_TotalPrint_Cnt_label", TotalCnt);

		memset(SheetCnt, 0, sizeof(SheetCnt));
		snprintf(SheetCnt, sizeof(SheetCnt), "%d %s", (int)sheet, _(SheetsStr));
		SetTextToLabel(window, "CCDlg_Duplex_Cnt_label", SheetCnt);

		memset(JobCnt, 0, sizeof(JobCnt));
		snprintf(JobCnt, sizeof(JobCnt), "%d %s", (int)job, _(JobsStr));
		SetTextToLabel(window, "CCDlg_Job_Cnt_label", JobCnt);

		ShowWidget(window, "label188");
		ShowWidget(window, "CCDlg_MonoS_Cnt_label");
		ShowWidget(window, "label189");
		ShowWidget(window, "CCDlg_MonoL_Cnt_label");
		ShowWidget(window, "label190");
		ShowWidget(window, "CCDlg_ColorS_Cnt_label");
		ShowWidget(window, "label191");
		ShowWidget(window, "CCDlg_ColorL_Cnt_label");

		HideWidget(window, "label149");
		HideWidget(window, "CCDlg_Mono_Cnt_label");
		HideWidget(window, "label150");
		HideWidget(window, "CCDlg_Color_Cnt_label");

		ShowWidget(window, "label240");
		ShowWidget(window, "CCDlg_TotalPrint_Cnt_label");
		ShowWidget(window, "label241");
		ShowWidget(window, "CCDlg_Duplex_Cnt_label");
		ShowWidget(window, "label242");
		ShowWidget(window, "CCDlg_Job_Cnt_label");

		ShowWidget(window, "frame52");
		HideWidget(window, "frame51");
		HideWidget(window, "frame58");
		HideWidget(window, "frame65");
	}
}
static void InitConsumablesInfoDlgWidgets2_LBP7210(UIStatusWnd *const wnd)
{
	if(wnd != NULL){
		GtkWidget *window = UI_DIALOG(wnd->ccinfo_dlg)->window;
		int index = 0;
		char *str = NULL;

		if( window == NULL ){
			return;
		}

		SetDialogTitle(window, _("Consumables Information"));

		InitCCInfoDlgWidgets2_Consumable(wnd);

		ShowWidget(window, "frame51");
		HideWidget(window, "frame58");
		HideWidget(window, "frame65");
		HideWidget(window, "frame52");
	}
}


static int GetCCInfoData2_Consumable(UIStatusWnd* const wnd)
{
	int res = 0;

	if( (wnd == NULL) || (wnd->pCnskt == NULL) ){
		res = -1;
	}

	if( res == 0 ){
		res = cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG);
	}
	if( res == 0 ){
		res = cnsktSetReqLong(wnd->pCnskt, DREQ_GET_CONSUMABLE);
	}
	if( res == 0 ){
		res = SendRequest(wnd, CCPD_DEVICE_REQUEST);
	}

	if( res == 0 ){
		res = cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->warning1), READ_TYPE_LONG, -1);
	}
	if( res == 0 ){
		res = cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->warning2), READ_TYPE_LONG, -1);
	}
	if( res == 0 ){
		res = cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->warning3), READ_TYPE_LONG, -1);
	}
	if( res == 0 ){
		res = cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->warning4), READ_TYPE_LONG, -1);
	}
	if( res == 0 ){
		res = cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->absent), READ_TYPE_LONG, -1);
	}
	if( res == 0 ){
		res = cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->misplas), READ_TYPE_LONG, -1);
	}
	if( res == 0 ){
		res = cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->memerror), READ_TYPE_LONG, -1);
	}
	if( res == 0 ){
		res = cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->mounterror), READ_TYPE_LONG, -1);
	}
	if( res == 0 ){
		res = cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->sealedrror), READ_TYPE_LONG, -1);
	}
	if( res < 0 ){
		switch(wnd->nModel){
			case MODEL_LBP7010:
			case MODEL_LBP9200:
			case MODEL_LBP7210:
				ShowMsgDlg(wnd, MSG_TYPE_CONSUMABLEINFO_GET_ERR);
				break;
			default:
				ShowMsgDlg(wnd, MSG_TYPE_CCINFO_GET_ERR);
				break;
		}
		return 1;
	}
	return 0;
}

static int GetCCInfoData2_Counter(UIStatusWnd* const wnd)
{
	int res = 0;
	long dummy = 0;

	if( (wnd == NULL) || (wnd->pCnskt == NULL) ){
		res = -1;
	}

	if(res == 0){
		res = cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG);
	}
	if(res == 0){
		res = cnsktSetReqLong(wnd->pCnskt, DREQ_GET_COUNTER);
	}
	if(res == 0){
		res = SendRequest(wnd, CCPD_DEVICE_REQUEST);
	}

	if(res == 0){
		dummy = 0;
		res = cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1);
	}
	wnd->ccinfo_dlg->counterBWSmall = dummy;

	if(res == 0){
		dummy = 0;
		res = cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1);
	}
	wnd->ccinfo_dlg->counterBWLarge = dummy;

	if(res == 0){
		dummy = 0;
		res = cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1);
	}
	wnd->ccinfo_dlg->counterColorSmall = dummy;

	if(res == 0){
		dummy = 0;
		res = cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1);
	}
	wnd->ccinfo_dlg->counterColorLarge = dummy;

	if(res == 0){
		dummy = 0;
		res = cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1);
	}
	wnd->ccinfo_dlg->counterDuplexBWSmall = dummy;

	if(res == 0){
		dummy = 0;
		res = cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1);
	}
	wnd->ccinfo_dlg->counterDuplexBWLarge = dummy;

	if(res == 0){
		dummy = 0;
		res = cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1);
	}
	wnd->ccinfo_dlg->counterDuplexColorSmall = dummy;

	if(res == 0){
		dummy = 0;
		res = cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1);
	}
	wnd->ccinfo_dlg->counterDuplexColorLarge = dummy;

	if(res == 0){
		dummy = 0;
		res = cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1);
	}
	wnd->ccinfo_dlg->counterJobs = dummy;

	if( res < 0 ){
		switch(wnd->nModel){
		case MODEL_LBP6200:
		case MODEL_LBP7010:
		case MODEL_LBP9200:
		case MODEL_LBP6020:
		case MODEL_LBP6310:
		case MODEL_LBP6340:
		case MODEL_LBP7210:
			ShowMsgDlg(wnd, MSG_TYPE_COUNTERINFO_GET_ERR);
			break;
		default:
			ShowMsgDlg(wnd, MSG_TYPE_CCINFO_GET_ERR);
			break;
		}
		return 1;
	}
	return 0;
}

#if 0
static int GetCCInfoData2(UIStatusWnd *wnd)
{
	long dummy = 0;
	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_CONSUMABLE) < 0)
		goto err;
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->warning1), READ_TYPE_LONG, -1) < 0)
		goto err;
	if(cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->warning2), READ_TYPE_LONG, -1) < 0)
		goto err;
	if(cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->warning3), READ_TYPE_LONG, -1) < 0)
		goto err;
	if(cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->warning4), READ_TYPE_LONG, -1) < 0)
		goto err;
	if(cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->absent), READ_TYPE_LONG, -1) < 0)
		goto err;
	if(cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->misplas), READ_TYPE_LONG, -1) < 0)
		goto err;
	if(cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->memerror), READ_TYPE_LONG, -1) < 0)
		goto err;
	if(cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->mounterror), READ_TYPE_LONG, -1) < 0)
		goto err;
	if(cnsktGetResData(wnd->pCnskt, &(wnd->ccinfo_dlg->sealedrror), READ_TYPE_LONG, -1) < 0)
		goto err;


	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_COUNTER) < 0)
		goto err;
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;

	dummy = 0;
	if(cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1) < 0)
		goto err;
	wnd->ccinfo_dlg->counterBWSmall = dummy;

	dummy = 0;
	if(cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1) < 0)
		goto err;
	wnd->ccinfo_dlg->counterBWLarge = dummy;

	dummy = 0;
	if(cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1) < 0)
		goto err;
	wnd->ccinfo_dlg->counterColorSmall = dummy;

	dummy = 0;
	if(cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1) < 0)
		goto err;
	wnd->ccinfo_dlg->counterColorLarge = dummy;

	dummy = 0;
	if(cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1) < 0)
		goto err;
	wnd->ccinfo_dlg->counterDuplexBWSmall = dummy;

	dummy = 0;
	if(cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1) < 0)
		goto err;
	wnd->ccinfo_dlg->counterDuplexBWLarge = dummy;

	dummy = 0;
	if(cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1) < 0)
		goto err;
	wnd->ccinfo_dlg->counterDuplexColorSmall = dummy;

	dummy = 0;
	if(cnsktGetResData(wnd->pCnskt, &dummy, READ_TYPE_LONG, -1) < 0)
		goto err;
	wnd->ccinfo_dlg->counterDuplexColorLarge = dummy;


	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_CCINFO_GET_ERR);
	return 1;
}
#endif

