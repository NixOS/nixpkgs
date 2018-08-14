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
#include "asstprtsdlg.h"
#include "data_process.h"
#include "callbacks.h"
#include "support.h"

#define	ASSTPRTSDLG_USE_MODE	0x0100
#define	ASSTPRTSDLG_MODE_DEFAULT_LBP5300	2
#define	ASSTPRTSDLG_MODE_DEFAULT_LBP5100	5
#define	ASSTPRTSDLG_REDUCE_STREAKS	0x0200
#define	ASSTPRTSDLG_REDUCE_STREAKS_DEFAULT	0x8D

#define	ASSTPRTSDLG_ENABLE_PREVENTQUALITY   0x0400
#define	ASSTPRTSDLG_ENABLE_CLEANPER2SHEETS	0x0800

#define	ASSTPRTSDLG_ENABLE_HEAT_CONDITION	0x1000

static char *AsstPrtModeTbl_Type1[] = {
	N_("Mode 1"),
	N_("Mode 2"),
	N_("Mode 3"),
	NULL,
};

static char *AsstPrtModeTbl_Type2[] = {
	N_("Auto"),
	N_("Low"),
	N_("High"),
	NULL,
};

static char *AsstPrtModeTbl_Type3[] = {
	N_("Off"),
	N_("Mode 1"),
	N_("Mode 2"),
	N_("Mode 3"),
	NULL,
};

static int GetAsstPrtSetting(UIStatusWnd *wnd, unsigned long *dwMode);
static void InitAsstPrtSDlgWidgets(UIStatusWnd *wnd, unsigned long dwMode);
static unsigned long SetAsstPrtMode_LBP5300(UIStatusWnd * wnd);
static unsigned long SetAsstPrtMode_LBP5100(UIStatusWnd * wnd);
static void InitAsstPrtSDlgWidgets_LBP5300(UIStatusWnd * wnd,unsigned long mode);
static void InitAsstPrtSDlgWidgets_LBP5100(UIStatusWnd * wnd,unsigned long mode);

static unsigned long SetAsstPrtMode_LBP5050(UIStatusWnd * wnd);
static unsigned long SetAsstPrtMode_LBP7200(UIStatusWnd * wnd);
static void InitAsstPrtSDlgWidgets_LBP5050(UIStatusWnd * wnd,unsigned long mode);
static void InitAsstPrtSDlgWidgets_LBP7200(UIStatusWnd * wnd,unsigned long mode);

static unsigned long SetAsstPrtMode_LBP6300(UIStatusWnd * wnd);
static unsigned long SetAsstPrtMode_LBP9100(UIStatusWnd * wnd);
static void InitAsstPrtSDlgWidgets_LBP6300(UIStatusWnd * wnd);
static void InitAsstPrtSDlgWidgets_LBP9100(UIStatusWnd * wnd,unsigned long mode);

static void SetAsstPrtSetting(UIStatusWnd *wnd, unsigned long mode);
static void SetAsstPrtSetting_LBP6300(UIStatusWnd *wnd);
static int GetAsstPrtSetting_LBP6300(UIStatusWnd *wnd);

static unsigned long SetAsstPrtMode_LBP6200(const UIStatusWnd * const wnd);
static void InitAsstPrtSDlgWidgets_LBP6200(const UIStatusWnd * const wnd, const unsigned long mode);

static int GetAsstPrtSetting_LBP9200(UIStatusWnd *const wnd, unsigned long *const mode);
static void InitAsstPrtSDlgWidgets_LBP9200(const UIStatusWnd *const wnd, const unsigned long mode);
static unsigned long SetAsstPrtMode_LBP9200(const UIStatusWnd *const wnd);
static void SetAsstPrtSetting_LBP9200(UIStatusWnd *const wnd, const unsigned long mode);

UIAsstPrtSDlg* CreateAsstPrtSDlg(UIDialog *parent)
{
	UIAsstPrtSDlg *dialog;

	dialog = (UIAsstPrtSDlg *)CreateDialog(sizeof(UIAsstPrtSDlg), parent);

	UI_DIALOG(dialog)->window = create_AsstPrtSDlg_dialog();
	ComboSignalConnect(UI_DIALOG(dialog)->window, "AsstPrtSDlg_mode_combo", GTK_SIGNAL_FUNC(on_AsstPrtSDlg_mode_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "AsstPrtSDlg_colormisfrequency_combo", GTK_SIGNAL_FUNC(on_AsstPrtSDlg_colormisfrequency_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "AsstPrtSDlg_paperjamreduction_combo", GTK_SIGNAL_FUNC(on_AsstPrtSDlg_paperjamreduction_combo_popwin_event));

	return dialog;
}

void ShowAsstPrtSDlg(UIStatusWnd *wnd)
{
	unsigned long mode = 0;

	switch(wnd->nIFVersion){
	case CCPD_IF_VERSION_110:
		switch(wnd->nModel){
		case MODEL_LBP6300:
		case MODEL_LBP6300N:
		case MODEL_LBP6310:
			if(GetAsstPrtSetting_LBP6300(wnd))
				return;
			break;
		case MODEL_LBP9200:
			if(GetAsstPrtSetting_LBP9200(wnd, &mode))
				return;
			break;
		default:
			if(GetAsstPrtSetting(wnd, &mode))
				return;
			break;
		}
		break;
	case CCPD_IF_VERSION_100:
	default:
		return;
	}

	SigDisable();
	InitAsstPrtSDlgWidgets(wnd, mode);
	SigEnable();

	ShowDialog((UIDialog *)wnd->asstprts_dlg, NULL);
}

void HideAsstPrtSDlg(UIStatusWnd *wnd)
{
	HideDialog((UIDialog *)wnd->asstprts_dlg);
}

void AsstPrtSDlgOK(UIStatusWnd *wnd)
{
	unsigned long mode = 0;

	switch(wnd->nModel){
		case MODEL_LBP5300:
			mode = SetAsstPrtMode_LBP5300(wnd);
			break;
		case MODEL_LBP5100:
			mode = SetAsstPrtMode_LBP5100(wnd);
			break;
		case MODEL_LBP5050:
			mode = SetAsstPrtMode_LBP5050(wnd);
			break;
		case MODEL_LBP7200:
		case MODEL_LBP7210:
			mode = SetAsstPrtMode_LBP7200(wnd);
			break;
		case MODEL_LBP6300:
		case MODEL_LBP6300N:
		case MODEL_LBP6310:
			mode = SetAsstPrtMode_LBP6300(wnd);
			break;
		case MODEL_LBP9100:
			mode = SetAsstPrtMode_LBP9100(wnd);
			break;
		case MODEL_LBP6200:
			mode = SetAsstPrtMode_LBP6200(wnd);
			break;
		case MODEL_LBP9200:
			mode = SetAsstPrtMode_LBP9200(wnd);
			break;
		default:
			break;
	}

	HideAsstPrtSDlg(wnd);

	switch(wnd->nModel){
	case MODEL_LBP6300:
	case MODEL_LBP6300N:
	case MODEL_LBP6310:
		SetAsstPrtSetting_LBP6300(wnd);
		break;
	case MODEL_LBP9200:
		SetAsstPrtSetting_LBP9200(wnd, mode);
		break;
	default:
		SetAsstPrtSetting(wnd, mode);
		break;
	}
}

static void SetAsstPrtSetting(UIStatusWnd *wnd, unsigned long mode)
{
	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG * 2) < 0)
                goto error;
        if(cnsktSetReqLong(wnd->pCnskt, DREQ_SET_PRINTMODE) < 0)
		goto error;
	if(cnsktSetReqLong(wnd->pCnskt, mode) < 0)
		goto error;

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto error;

        return;
error:
        ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
}

static void SetAsstPrtSetting_LBP6300(UIStatusWnd *wnd)
{
	int loop = 0;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG + (DATA_LENGTH_BYTE * 10)) < 0)
                goto error;
        if(cnsktSetReqLong(wnd->pCnskt, DREQ_SET_SPECIALPRINT) < 0)
		goto error;

	for(loop = 0; loop < 10; loop++){
		if(cnsktSetReqByte(wnd->pCnskt, wnd->asstprts_dlg->spPrintMode[loop]) < 0){
			goto error;
		}
	}

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto error;

        return;
error:
        ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
}

static void SetAsstPrtSetting_LBP9200(UIStatusWnd *const wnd, const unsigned long mode)
{
	int loop = 0;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG + (DATA_LENGTH_BYTE * 10)) < 0)
	{
                goto error;
	}
       if(cnsktSetReqLong(wnd->pCnskt, DREQ_SET_SPECIALPRINT) < 0)
	{
		goto error;
	}

	for(loop = 0; loop < 10; loop++){
		if(cnsktSetReqByte(wnd->pCnskt, wnd->asstprts_dlg->spPrintMode[loop]) < 0){
			goto error;
		}
	}

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
	{
		goto error;
	}

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG * 2) < 0)
	{
              goto error;
	}
       if(cnsktSetReqLong(wnd->pCnskt, DREQ_SET_PRINTMODE) < 0)
	{
		goto error;
	}
	if(cnsktSetReqLong(wnd->pCnskt, mode) < 0)
	{
		goto error;
	}

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
	{
		goto error;
	}

       return;
error:
       ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
}

void UpdateAsstPrtSDlgWidgets(UIStatusWnd *wnd, int use_mode)
{
	GtkWidget *window = UI_DIALOG(wnd->asstprts_dlg)->window;

	switch(wnd->nModel){
		case MODEL_LBP5300:
			SetWidgetSensitive(window, "hbox64", use_mode);
			break;
		case MODEL_LBP5100:
			break;
		default:
			break;
	}

	return;
}


static void InitAsstPrtSDlgWidgets(UIStatusWnd *wnd, unsigned long mode)
{
	switch(wnd->nModel){
	case MODEL_LBP5300:
		InitAsstPrtSDlgWidgets_LBP5300(wnd,mode);
		break;
	case MODEL_LBP5100:
		InitAsstPrtSDlgWidgets_LBP5100(wnd,mode);
		break;
	case MODEL_LBP5050:
		InitAsstPrtSDlgWidgets_LBP5050(wnd,mode);
		break;
	case MODEL_LBP7200:
	case MODEL_LBP7210:
		InitAsstPrtSDlgWidgets_LBP7200(wnd,mode);
		break;
	case MODEL_LBP6300:
	case MODEL_LBP6300N:
	case MODEL_LBP6310:
		InitAsstPrtSDlgWidgets_LBP6300(wnd);
		break;
	case MODEL_LBP9100:
		InitAsstPrtSDlgWidgets_LBP9100(wnd,mode);
		break;
	case MODEL_LBP6200:
		InitAsstPrtSDlgWidgets_LBP6200(wnd,mode);
		break;
	case MODEL_LBP9200:
		InitAsstPrtSDlgWidgets_LBP9200(wnd,mode);
		break;
	default:
		break;
	}

	return;
}

static int GetAsstPrtSetting(UIStatusWnd *wnd, unsigned long *mode)
{
	unsigned long value = 0;
	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;

	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_PRINTMODE) < 0)
		goto err;

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
		goto err;

	*mode = (unsigned short)value;

	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;

}

static int GetAsstPrtSetting_LBP6300(UIStatusWnd *wnd)
{
	char value = 0;
	int loop = 0;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;

	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_SPECIALPRINT) < 0)
		goto err;

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;

	for(loop = 0; loop < 10; loop++){
		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) < 0){
			goto err;
		}
		wnd->asstprts_dlg->spPrintMode[loop] = value;
	}

	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;

}

static int GetAsstPrtSetting_LBP9200(UIStatusWnd *const wnd, unsigned long *const mode)
{
	char value = 0;
	int loop = 0;
	unsigned long value2 = 0;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
	{
		goto err;
	}

	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_SPECIALPRINT) < 0)
	{
		goto err;
	}

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
	{
		goto err;
	}

	for(loop = 0; loop < 10; loop++){
		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_BYTE, -1) < 0){
			goto err;
		}
		wnd->asstprts_dlg->spPrintMode[loop] = value;
	}

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
	{
		goto err;
	}

	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_PRINTMODE) < 0)
	{
		goto err;
	}

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
	{
		goto err;
	}

	if(cnsktGetResData(wnd->pCnskt, &value2, READ_TYPE_LONG, -1) < 0)
	{
		goto err;
	}

	*mode = (unsigned short)value2;

	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;
}

static unsigned long
SetAsstPrtMode_LBP5300(
UIStatusWnd * wnd
){
	unsigned long mode = 0;
	int use = 0;

	GtkWidget *window = UI_DIALOG(wnd->asstprts_dlg)->window;
	use = GetToggleButtonActive(window,"AsstPrtSDlg_highspeed_checkbutton");

	if( use != 0 ){
		char *pMode = NULL;
		int index = 0;
		int i = 0;

		pMode = GetCurrComboText(window,"AsstPrtSDlg_mode_combo_entry");
        	for(i = 0; _(AsstPrtModeTbl_Type1[i]) != NULL; i++){
			if( strcmp( pMode, _(AsstPrtModeTbl_Type1[i]) ) == 0 ){
				index = i + 1;
			}
			mode = ASSTPRTSDLG_USE_MODE;
			mode |= index;
        	}
	}

	return mode;
}


static unsigned long
SetAsstPrtMode_LBP5100(
UIStatusWnd * wnd
){
	unsigned long mode = 0;
	gboolean use = FALSE;

	GtkWidget *window = UI_DIALOG(wnd->asstprts_dlg)->window;
	use = GetToggleButtonActive(window,"AsstPrtSDlg_highspeed_checkbutton");

	if( use != FALSE ){
		mode |= ASSTPRTSDLG_USE_MODE;
	}

	window = UI_DIALOG(wnd->asstprts_dlg)->window;
	use = GetToggleButtonActive(window,"AsstPrtSDlg_ReduceStreaks_checkbutton");

	if( use != FALSE ){
		mode |= ASSTPRTSDLG_REDUCE_STREAKS;
	}

	if( use != wnd->asstprts_dlg->ReduceStreaks_state ){
        	ShowMsgDlg(wnd, MSG_TYPE_PERFORM_REDUCE_STREAKS);
		wnd->asstprts_dlg->ReduceStreaks_state = use;
	}

	return mode;
}

static unsigned long
SetAsstPrtMode_LBP5050(
UIStatusWnd * wnd
){
	unsigned long mode = 0;
	gboolean use = FALSE;

	GtkWidget *window = UI_DIALOG(wnd->asstprts_dlg)->window;
	use = GetToggleButtonActive(window,"AsstPrtSDlg_highspeed_checkbutton");

	if( use != FALSE ){
		mode |= ASSTPRTSDLG_USE_MODE;
	}

	window = UI_DIALOG(wnd->asstprts_dlg)->window;
	use = GetToggleButtonActive(window,"AsstPrtSDlg_preventpoorquality_checkbutton");

	if( use != FALSE ){
		mode |= ASSTPRTSDLG_ENABLE_PREVENTQUALITY;
	}


	use = GetToggleButtonActive(window,"AsstPrtSDlg_cleanevery2sheets_checkbutton");

	if( use != FALSE ){
		mode |= ASSTPRTSDLG_ENABLE_CLEANPER2SHEETS;
	}


	return mode;


}


static unsigned long
SetAsstPrtMode_LBP7200(
UIStatusWnd * wnd
){
	unsigned long mode = 0;
	gboolean use = FALSE;

	GtkWidget *window = UI_DIALOG(wnd->asstprts_dlg)->window;
	use = GetToggleButtonActive(window,"AsstPrtSDlg_highspeed_checkbutton");

	if( use != FALSE ){
		mode |= ASSTPRTSDLG_USE_MODE;
	}


	return mode;


}

static unsigned long
SetAsstPrtMode_LBP6300(UIStatusWnd * wnd)
{
	unsigned long mode = 0;
	gboolean use = FALSE;

	GtkWidget *window = UI_DIALOG(wnd->asstprts_dlg)->window;
	use = GetToggleButtonActive(window,"AsstPrtSDlg_adjust16k_checkbutton");

	if( use != FALSE ){
		wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_A] |= DREQ_SPECIAL_MODE_3;
	}else{
		wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_A] &= ~DREQ_SPECIAL_MODE_3;
	}

	return mode;
}

static unsigned long
SetAsstPrtMode_LBP9100(UIStatusWnd * wnd)
{
	unsigned long mode = 0;
	gboolean use = FALSE;

	GtkWidget *window = UI_DIALOG(wnd->asstprts_dlg)->window;
	use = GetToggleButtonActive(window,"AsstPrtSDlg_adjusttemp_checkbutton");

	if( use != FALSE ){
		mode |= ASSTPRTSDLG_ENABLE_HEAT_CONDITION;
	}

	return mode;
}

static unsigned long SetAsstPrtMode_LBP6200(const UIStatusWnd * const wnd)
{
	unsigned long mode = 0;
	gboolean use = FALSE;

	GtkWidget *window = NULL;
	if( (wnd != NULL) && (wnd->asstprts_dlg != NULL) ){
		window = wnd->asstprts_dlg->dialog.window;

		if( window != NULL ){
			use = GetToggleButtonActive(window,"AsstPrtSDlg_quietmode_checkbutton");

			if( use != FALSE ){
				mode |= DREQ_ENABLE_QUIET_MODE;
			}
		}
	}

	return mode;
}

static unsigned long SetAsstPrtMode_LBP9200(const UIStatusWnd *const wnd)
{
	GtkWidget *window = NULL;
	unsigned long mode = 0;
	gboolean use = FALSE;
	gboolean bUpdateMode = TRUE;
	int i = 0;
	char *colMisMode = NULL;
	int indexColMis = -1;
	char *paperJamMode = NULL;
	int indexPaperJam = 0;
	gboolean bMode4 = FALSE;
	gboolean bMode5 = FALSE;
	gboolean bMode6 = FALSE;
	gboolean bMode7 = FALSE;

	if(wnd != NULL){
		if(wnd->asstprts_dlg != NULL){
			window = UI_DIALOG(wnd->asstprts_dlg)->window;
			use = GetToggleButtonActive(window,"AsstPrtSDlg_adjusttemp_checkbutton");
			if( use != FALSE ){
				mode |= ASSTPRTSDLG_ENABLE_HEAT_CONDITION;
			}

			colMisMode = GetCurrComboText(window,"AsstPrtSDlg_colormisfrequency_combo_entry");
			for(i = 0; _(AsstPrtModeTbl_Type2[i]) != NULL; i++){
				if(strcmp(colMisMode, _(AsstPrtModeTbl_Type2[i])) == 0){
					indexColMis = i;
					break;
				}
			}

			switch(indexColMis){
				case 0:
					bMode4 = TRUE;
					bMode5 = FALSE;
					break;
				case 2:
					bMode4 = FALSE;
					bMode5 = TRUE;
					break;
				case 1:
					bMode4 = FALSE;
					bMode5 = FALSE;
					break;
				default:
					bUpdateMode = FALSE;
					break;
			}
			if(bUpdateMode != FALSE){
				if(bMode4 != FALSE){
					wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] |= DREQ_SPECIAL_MODE_4;
				}else{
					wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] &= (~DREQ_SPECIAL_MODE_4);
				}
				if(bMode5 != FALSE){
					wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] |= DREQ_SPECIAL_MODE_5;
				}else{
					wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] &= (~DREQ_SPECIAL_MODE_5);
				}
			}else{
				bUpdateMode = TRUE;
			}

			paperJamMode = GetCurrComboText(window,"AsstPrtSDlg_paperjamreduction_combo_entry");
			for(i = 0; _(AsstPrtModeTbl_Type3[i]) != NULL; i++){
				if(strcmp(paperJamMode, _(AsstPrtModeTbl_Type3[i])) == 0){
					indexPaperJam = i;
					break;
				}
			}

			switch(indexPaperJam){
				case 1:
					bMode6 = TRUE;
					bMode7 = FALSE;
					break;
				case 2:
					bMode6 = FALSE;
					bMode7 = FALSE;
					break;
				case 3:
					bMode6 = TRUE;
					bMode7 = TRUE;
					break;
				case 0:
					bMode6 = FALSE;
					bMode7 = TRUE;
					break;
				default:
					bUpdateMode = FALSE;
					break;
			}
			if(bUpdateMode != FALSE){
				if(bMode6 != FALSE){
					wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] |= DREQ_SPECIAL_MODE_6;
				}else{
					wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] &= (~DREQ_SPECIAL_MODE_6);
				}
				if(bMode7 != FALSE){
					wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] |= DREQ_SPECIAL_MODE_7;
				}else{
					wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] &= (~DREQ_SPECIAL_MODE_7);
				}
			}
		}
	}

	return mode;
}

static void
InitAsstPrtSDlgWidgets_LBP5300(
UIStatusWnd * wnd,
unsigned long mode
){
	GtkWidget *window = UI_DIALOG(wnd->asstprts_dlg)->window;
        GList *glist = NULL;

        int cur;
        int active = 0;
        int i = 0;

        if(mode & ASSTPRTSDLG_USE_MODE){
        	cur = mode - ASSTPRTSDLG_USE_MODE - 1;
                active = TRUE;
        }else{
                cur = ASSTPRTSDLG_MODE_DEFAULT_LBP5300;
        }

        for(i = 0; _(AsstPrtModeTbl_Type1[i]) != NULL; i++){
        	glist = g_list_append(glist, _(AsstPrtModeTbl_Type1[i]));
        }

        SetGListToCombo(window, glist,
        	"AsstPrtSDlg_mode_combo", _(AsstPrtModeTbl_Type1[cur]));
        g_list_free(glist);

        SetActiveCheckButton(window, "AsstPrtSDlg_highspeed_checkbutton", active);

	ShowWidget(window, "hbox64");
        HideWidget(window, "AsstPrtSDlg_ReduceStreaks_checkbutton");
        SetWidgetSensitive(window, "hbox64", active);

	return;
}


static void
InitAsstPrtSDlgWidgets_LBP5100(
UIStatusWnd * wnd,
unsigned long mode
){
	GtkWidget *window = UI_DIALOG(wnd->asstprts_dlg)->window;

        gboolean active = FALSE;

        if(mode & ASSTPRTSDLG_USE_MODE){
                active = TRUE;
        }else{
                active = FALSE;
        }

        SetActiveCheckButton(window, "AsstPrtSDlg_highspeed_checkbutton", active);

        if(mode & ASSTPRTSDLG_REDUCE_STREAKS){
                active = TRUE;
        }else{
                active = FALSE;
        }

	SetActiveCheckButton(window, "AsstPrtSDlg_ReduceStreaks_checkbutton", active);
	wnd->asstprts_dlg->ReduceStreaks_state = active;

        HideWidget(window, "hbox64");

	return;
}

static void
InitAsstPrtSDlgWidgets_LBP5050(
			       UIStatusWnd * wnd,
			       unsigned long mode
			       ){
	GtkWidget *window = UI_DIALOG(wnd->asstprts_dlg)->window;

  	gboolean active = FALSE;

	if(mode & ASSTPRTSDLG_USE_MODE){
    	active = TRUE;
  	}else{
    	active = FALSE;
  	}

  	SetActiveCheckButton(window, "AsstPrtSDlg_highspeed_checkbutton", active);

  	if(mode & ASSTPRTSDLG_ENABLE_PREVENTQUALITY){
    	active = TRUE;
  	}else{
    	active = FALSE;
	}

  	SetActiveCheckButton(window, "AsstPrtSDlg_preventpoorquality_checkbutton", active);
  	wnd->asstprts_dlg->EnablePreventQuality_state = active;


  	if(mode & ASSTPRTSDLG_ENABLE_CLEANPER2SHEETS){
		active = TRUE;
  	}else{
    	active = FALSE;
  	}

  	SetActiveCheckButton(window, "AsstPrtSDlg_cleanevery2sheets_checkbutton", active);
  	wnd->asstprts_dlg->EnableCleanPer2Sheets_state = active;


	HideWidget(window, "hbox64");
	HideWidget(window, "AsstPrtSDlg_ReduceStreaks_checkbutton");

	return;
}


static void
InitAsstPrtSDlgWidgets_LBP7200(
			       UIStatusWnd * wnd,
			       unsigned long mode
			       ){
  	GtkWidget *window = UI_DIALOG(wnd->asstprts_dlg)->window;

  	gboolean active = FALSE;

  	if(mode & ASSTPRTSDLG_USE_MODE){
    	active = TRUE;
  	}else{
    	active = FALSE;
  	}

  	SetActiveCheckButton(window, "AsstPrtSDlg_highspeed_checkbutton", active);


    HideWidget(window, "hbox64");
    HideWidget(window, "AsstPrtSDlg_ReduceStreaks_checkbutton");
    HideWidget(window, "AsstPrtSDlg_preventpoorquality_checkbutton");
    HideWidget(window, "AsstPrtSDlg_cleanevery2sheets_checkbutton");


  	return;
}

static void
InitAsstPrtSDlgWidgets_LBP6300(UIStatusWnd * wnd)
{
  	GtkWidget *window = UI_DIALOG(wnd->asstprts_dlg)->window;

  	gboolean active = FALSE;

	if(wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_A] & DREQ_SPECIAL_MODE_3){
    		active = TRUE;
  	}else{
    		active = FALSE;
  	}

	ShowWidget(window, "AsstPrtSDlg_adjust16k_checkbutton");
  	SetActiveCheckButton(window, "AsstPrtSDlg_adjust16k_checkbutton", active);

	HideWidget(window, "AsstPrtSDlg_highspeed_checkbutton");
	HideWidget(window, "hbox64");
	HideWidget(window, "AsstPrtSDlg_ReduceStreaks_checkbutton");
	HideWidget(window, "AsstPrtSDlg_preventpoorquality_checkbutton");
	HideWidget(window, "AsstPrtSDlg_cleanevery2sheets_checkbutton");

  	return;
}

static void
InitAsstPrtSDlgWidgets_LBP9100(UIStatusWnd * wnd, unsigned long mode)
{
  	GtkWidget *window = UI_DIALOG(wnd->asstprts_dlg)->window;

  	gboolean active = FALSE;

  	if(mode & ASSTPRTSDLG_ENABLE_HEAT_CONDITION){
    		active = TRUE;
  	}else{
    		active = FALSE;
  	}

	ShowWidget(window, "AsstPrtSDlg_adjusttemp_checkbutton");
  	SetActiveCheckButton(window, "AsstPrtSDlg_adjusttemp_checkbutton", active);

	HideWidget(window, "AsstPrtSDlg_highspeed_checkbutton");
	HideWidget(window, "hbox64");
	HideWidget(window, "AsstPrtSDlg_ReduceStreaks_checkbutton");
	HideWidget(window, "AsstPrtSDlg_preventpoorquality_checkbutton");
	HideWidget(window, "AsstPrtSDlg_cleanevery2sheets_checkbutton");

  	return;
}

static void
InitAsstPrtSDlgWidgets_LBP6200(const UIStatusWnd * const wnd, const unsigned long mode)
{
	GtkWidget *window = NULL;

	if( (wnd != NULL) && (wnd->asstprts_dlg != NULL) ){
		window = wnd->asstprts_dlg->dialog.window;

	  	gboolean active = FALSE;

		if((mode & DREQ_ENABLE_QUIET_MODE) != 0){
			active = TRUE;
		}else{
			active = FALSE;
		}

		if( window != NULL ){
			ShowWidget(window, "AsstPrtSDlg_quietmode_checkbutton");
			SetActiveCheckButton(window, "AsstPrtSDlg_quietmode_checkbutton", active);
			ShowWidget(window, "quietmode_label");

			HideWidget(window, "AsstPrtSDlg_adjusttemp_checkbutton");
			HideWidget(window, "AsstPrtSDlg_highspeed_checkbutton");
			HideWidget(window, "hbox64");
			HideWidget(window, "AsstPrtSDlg_ReduceStreaks_checkbutton");
			HideWidget(window, "AsstPrtSDlg_preventpoorquality_checkbutton");
			HideWidget(window, "AsstPrtSDlg_cleanevery2sheets_checkbutton");
		}
	}

  	return;
}

static void InitAsstPrtSDlgWidgets_LBP9200(const UIStatusWnd *const wnd, const unsigned long mode)
{
	GtkWidget *window = NULL;
	GList *glistColMis = NULL;
	GList *glistPaperJam = NULL;
	int i = 0;
	int cur = 0;

	if(wnd != NULL){
		if(wnd->asstprts_dlg != NULL){
			window = UI_DIALOG(wnd->asstprts_dlg)->window;
			gboolean active = FALSE;

		  	if(mode & ASSTPRTSDLG_ENABLE_HEAT_CONDITION){
		    		active = TRUE;
		  	}else{
		    		active = FALSE;
		  	}

			ShowWidget(window, "AsstPrtSDlg_adjusttemp_checkbutton");
		  	SetActiveCheckButton(window, "AsstPrtSDlg_adjusttemp_checkbutton", active);

			for(i = 0; _(AsstPrtModeTbl_Type2[i]) != NULL; i++){
        			glistColMis = g_list_append(glistColMis, _(AsstPrtModeTbl_Type2[i]));
        		}

			if((wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] & DREQ_SPECIAL_MODE_4) && !(wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] & DREQ_SPECIAL_MODE_5)){
				SetGListToCombo(window, glistColMis, "AsstPrtSDlg_colormisfrequency_combo", _(AsstPrtModeTbl_Type2[0]));
			}else if(!(wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] & DREQ_SPECIAL_MODE_4) && (wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] & DREQ_SPECIAL_MODE_5)){
				SetGListToCombo(window, glistColMis, "AsstPrtSDlg_colormisfrequency_combo", _(AsstPrtModeTbl_Type2[2]));
			}else if(!(wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] & DREQ_SPECIAL_MODE_4) && !(wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] & DREQ_SPECIAL_MODE_5)){
				SetGListToCombo(window, glistColMis, "AsstPrtSDlg_colormisfrequency_combo", _(AsstPrtModeTbl_Type2[1]));
			}else{
				SetGListToCombo(window, glistColMis, "AsstPrtSDlg_colormisfrequency_combo", "");
			}

			for(i = 0; _(AsstPrtModeTbl_Type3[i]) != NULL; i++){
        			glistPaperJam = g_list_append(glistPaperJam, _(AsstPrtModeTbl_Type3[i]));
        		}

			if(!(wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] & DREQ_SPECIAL_MODE_6) && (wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] & DREQ_SPECIAL_MODE_7)){
				cur = 0;
			}else if((wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] & DREQ_SPECIAL_MODE_6) && !(wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] & DREQ_SPECIAL_MODE_7)){
				cur = 1;
			}else if(!(wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] & DREQ_SPECIAL_MODE_6) && !(wnd->asstprts_dlg->spPrintMode[DREQ_FUNCTION_F] & DREQ_SPECIAL_MODE_7)){
				cur = 2;
			}else{
				cur = 3;
			}

        		SetGListToCombo(window, glistPaperJam, "AsstPrtSDlg_paperjamreduction_combo", _(AsstPrtModeTbl_Type3[cur]));

			ShowWidget(window, "hbox83");
			ShowWidget(window, "hbox84");
			HideWidget(window, "AsstPrtSDlg_highspeed_checkbutton");
			HideWidget(window, "hbox64");
			HideWidget(window, "AsstPrtSDlg_ReduceStreaks_checkbutton");
			HideWidget(window, "AsstPrtSDlg_preventpoorquality_checkbutton");
			HideWidget(window, "AsstPrtSDlg_cleanevery2sheets_checkbutton");
		}
	}
	g_list_free(glistColMis);
	g_list_free(glistPaperJam);

	return;
}

