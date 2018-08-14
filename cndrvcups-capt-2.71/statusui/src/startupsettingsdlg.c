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
#include "startupsettingsdlg.h"
#include "data_process.h"
#include "callbacks.h"
#include "support.h"

#define	STARTUPSETTINGSDLG_USE_MODE	0x0100
#define	STARTUPSETTINGSDLG_QUALITYCORR_DEFAULT_LBP5050	1
#define	STARTUPSETTINGSDLG_QUALITYCORR_DEFAULT_LBP7200	1
#define	STARTUPSETTINGSDLG_QUALITYCORR_DEFAULT_LBP9100	1

#define QUALITY_CORRECT_LATER	1
#define QUALITY_CORRECT_LEVEL1	2
#define QUALITY_CORRECT_LEVEL2	3

static char *StartupSettingsQualityCorrTbl_Type1[] = {
	N_("Execute Later"),
	N_("Execute Immediately (Level 1)"),
	N_("Execute Immediately (Level 2)"),
	NULL,
};

static int GetStartupSettingsSetting(UIStatusWnd *wnd, unsigned long *dwMode);
static void InitStartupSettingsDlgWidgets(UIStatusWnd *wnd, unsigned long dwMode);
static unsigned long SetStartupSettingsQualityCorr_LBP5050(UIStatusWnd * wnd);
static unsigned long SetStartupSettingsQualityCorr_LBP7200(UIStatusWnd * wnd);
static void InitStartupSettingsDlgWidgets_LBP5050(UIStatusWnd * wnd,unsigned long mode);
static void InitStartupSettingsDlgWidgets_LBP7200(UIStatusWnd * wnd,unsigned long mode);
static unsigned long SetStartupSettingsQualityCorr_LBP9100(UIStatusWnd * wnd);
static void InitStartupSettingsDlgWidgets_LBP9100(UIStatusWnd * wnd,unsigned long mode);

UIStartupSettingsDlg* CreateStartupSettingsDlg(UIDialog *parent)
{
	UIStartupSettingsDlg *dialog;

	dialog = (UIStartupSettingsDlg *)CreateDialog(sizeof(UIStartupSettingsDlg), parent);

	UI_DIALOG(dialog)->window = create_StartupSettingsDlg_dialog();
	ComboSignalConnect(UI_DIALOG(dialog)->window, "StartupSettingsDlg_QualityCorr_combo", GTK_SIGNAL_FUNC(on_StartupSettingsDlg_QualityCorr_combo_popwin_event));

	return dialog;
}

void ShowStartupSettingsDlg(UIStatusWnd *wnd)
{
	unsigned long mode = 0;

	switch(wnd->nIFVersion){
	case CCPD_IF_VERSION_110:
		if(GetStartupSettingsSetting(wnd, &mode))
			return;
		break;
	case CCPD_IF_VERSION_100:
	default:
		return;
	}

	SigDisable();
	InitStartupSettingsDlgWidgets(wnd, mode);
	SigEnable();

	ShowDialog((UIDialog *)wnd->startupsettings_dlg, NULL);
}

void HideStartupSettingsDlg(UIStatusWnd *wnd)
{
	HideDialog((UIDialog *)wnd->startupsettings_dlg);
}

void StartupSettingsDlgOK(UIStatusWnd *wnd)
{
	unsigned long mode = 0;

	switch(wnd->nModel){
		case MODEL_LBP5050:
			mode = SetStartupSettingsQualityCorr_LBP5050(wnd);
			break;
		case MODEL_LBP7200:
		case MODEL_LBP7210:
			mode = SetStartupSettingsQualityCorr_LBP7200(wnd);
			break;
		case MODEL_LBP9100:
		case MODEL_LBP9200:
			mode = SetStartupSettingsQualityCorr_LBP9100(wnd);
			break;
		default:
			break;
	}

	HideStartupSettingsDlg(wnd);

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG * 2) < 0)
                goto error;
        if(cnsktSetReqLong(wnd->pCnskt, DREQ_SET_STARTUPSET) < 0)
		goto error;
	if(cnsktSetReqLong(wnd->pCnskt, mode) < 0)
		goto error;

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto error;

        return;
error:
        ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);


}


static void InitStartupSettingsDlgWidgets(UIStatusWnd *wnd, unsigned long mode)
{
	switch(wnd->nModel){
	case MODEL_LBP5050:
		InitStartupSettingsDlgWidgets_LBP5050(wnd,mode);
		break;
	case MODEL_LBP7200:
	case MODEL_LBP7210:
		InitStartupSettingsDlgWidgets_LBP7200(wnd,mode);
		break;
	case MODEL_LBP9100:
	case MODEL_LBP9200:
		InitStartupSettingsDlgWidgets_LBP9100(wnd,mode);
		break;
	default:
		break;
	}

	return;
}

static int GetStartupSettingsSetting(UIStatusWnd *wnd, unsigned long *mode)
{
	unsigned long value = 0;
	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;

	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_STARTUPSET) < 0)
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

static unsigned long
SetStartupSettingsQualityCorr_LBP5050(
UIStatusWnd * wnd
){
	unsigned long mode = 0;

	GtkWidget *window = UI_DIALOG(wnd->startupsettings_dlg)->window;


	char *pQualityCorr = NULL;
	int i = 0;

	pQualityCorr = GetCurrComboText(window,"StartupSettingsDlg_QualityCorr_combo_entry");
	for(i = 0; _(StartupSettingsQualityCorrTbl_Type1[i]) != NULL; i++){
	  if( strcmp( pQualityCorr, _(StartupSettingsQualityCorrTbl_Type1[i]) ) == 0 ){
	    mode = i + 1;
	  }

	}


	return mode;
}


static unsigned long
SetStartupSettingsQualityCorr_LBP7200(
UIStatusWnd * wnd
){

	unsigned long mode = 0;

	GtkWidget *window = UI_DIALOG(wnd->startupsettings_dlg)->window;


	char *pQualityCorr = NULL;
	int i = 0;

	pQualityCorr = GetCurrComboText(window,"StartupSettingsDlg_QualityCorr_combo_entry");
	for(i = 0; _(StartupSettingsQualityCorrTbl_Type1[i]) != NULL; i++){
	  if( strcmp( pQualityCorr, _(StartupSettingsQualityCorrTbl_Type1[i]) ) == 0 ){
	    mode = i + 1;
	  }

	}


	return mode;

}


static void
InitStartupSettingsDlgWidgets_LBP7200(
UIStatusWnd * wnd,
unsigned long mode
){
	GtkWidget *window = UI_DIALOG(wnd->startupsettings_dlg)->window;
        GList *glist = NULL;

        int cur;
        int active = 0;
        int i = 0;

        if( QUALITY_CORRECT_LATER <= mode && mode <= QUALITY_CORRECT_LEVEL2 ){
	  cur = mode ;
	  active = TRUE;
        }else{
	  cur = STARTUPSETTINGSDLG_QUALITYCORR_DEFAULT_LBP7200;
        }

        for(i = 0; _(StartupSettingsQualityCorrTbl_Type1[i]) != NULL; i++){
        	glist = g_list_append(glist, _(StartupSettingsQualityCorrTbl_Type1[i]));
        }

        SetGListToCombo(window, glist,
        	"StartupSettingsDlg_QualityCorr_combo", _(StartupSettingsQualityCorrTbl_Type1[cur -1]));
        g_list_free(glist);

	ShowWidget(window, "hbox65");
	ShowWidget(window, "StartupSettingsDlg_QualityCorr_label");
        SetWidgetSensitive(window, "hbox65", active);

	return;
}


static void
InitStartupSettingsDlgWidgets_LBP5050(
UIStatusWnd * wnd,
unsigned long mode
){


	GtkWidget *window = UI_DIALOG(wnd->startupsettings_dlg)->window;
        GList *glist = NULL;

        int cur;
        int active = 0;
        int i = 0;

        if( QUALITY_CORRECT_LATER <= mode && mode <= QUALITY_CORRECT_LEVEL2 ){
	  cur = mode ;
	  active = TRUE;
        }else{
	  cur = STARTUPSETTINGSDLG_QUALITYCORR_DEFAULT_LBP5050;
        }

        for(i = 0; _(StartupSettingsQualityCorrTbl_Type1[i]) != NULL; i++){
        	glist = g_list_append(glist, _(StartupSettingsQualityCorrTbl_Type1[i]));
        }

        SetGListToCombo(window, glist,
        	"StartupSettingsDlg_QualityCorr_combo", _(StartupSettingsQualityCorrTbl_Type1[cur -1]));
        g_list_free(glist);

		ShowWidget(window, "hbox65");
		ShowWidget(window, "StartupSettingsDlg_QualityCorr_label");
		ShowWidget(window, "StartupSettingsDlg_QualityCorr_combo");
	        SetWidgetSensitive(window, "hbox65", active);

	return;


}

static unsigned long
SetStartupSettingsQualityCorr_LBP9100(
UIStatusWnd * wnd
){

	unsigned long mode = 0;

	GtkWidget *window = UI_DIALOG(wnd->startupsettings_dlg)->window;


	char *pQualityCorr = NULL;
	int i = 0;

	pQualityCorr = GetCurrComboText(window,"StartupSettingsDlg_QualityCorr_combo_entry");
	for(i = 0; _(StartupSettingsQualityCorrTbl_Type1[i]) != NULL; i++){
	  if( strcmp( pQualityCorr, _(StartupSettingsQualityCorrTbl_Type1[i]) ) == 0 ){
	    mode = i + 1;
	  }

	}


	return mode;

}

static void
InitStartupSettingsDlgWidgets_LBP9100(
UIStatusWnd * wnd,
unsigned long mode
){
	GtkWidget *window = UI_DIALOG(wnd->startupsettings_dlg)->window;
        GList *glist = NULL;

        int cur;
        int active = 0;
        int i = 0;

        if( QUALITY_CORRECT_LATER <= mode && mode <= QUALITY_CORRECT_LEVEL2 ){
	  cur = mode ;
	  active = TRUE;
        }else{
	  cur = STARTUPSETTINGSDLG_QUALITYCORR_DEFAULT_LBP9100;
        }

        for(i = 0; _(StartupSettingsQualityCorrTbl_Type1[i]) != NULL; i++){
        	glist = g_list_append(glist, _(StartupSettingsQualityCorrTbl_Type1[i]));
        }

        SetGListToCombo(window, glist,
        	"StartupSettingsDlg_QualityCorr_combo", _(StartupSettingsQualityCorrTbl_Type1[cur -1]));
        g_list_free(glist);

	ShowWidget(window, "hbox65");
	ShowWidget(window, "StartupSettingsDlg_QualityCorr_label");
        SetWidgetSensitive(window, "hbox65", active);

	return;
}

