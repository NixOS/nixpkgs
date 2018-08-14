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
#include "cleaningdlg.h"
#include "data_process.h"
#include "callbacks.h"
#include "support.h"
#include "ppapdata.h"
#include "msgdlg.h"

extern int PerformCleaning(UIStatusWnd *wnd);
static void InitCleaningDlgWidgets(const UIStatusWnd *const wnd);

UICleaningDlg* CreateCleaningDlg(UIDialog *parent)
{
	UICleaningDlg *dialog;

	dialog = (UICleaningDlg *)CreateDialog(sizeof(UICleaningDlg), parent);

	UI_DIALOG(dialog)->window = create_CleaningDlg_dialog();

	return dialog;
}

void ShowCleaningDlg(const UIStatusWnd *const wnd)
{
	if(wnd != NULL){
		SigDisable();
		InitCleaningDlgWidgets(wnd);
		SigEnable();

		ShowDialog((UIDialog *)wnd->cleaning_dlg, NULL);
	}
}

static void InitCleaningDlgWidgets(const UIStatusWnd *const wnd)
{
	if(wnd != NULL){
		GtkWidget *window = UI_DIALOG(wnd->cleaning_dlg)->window;

		if(!(strcmp(wnd->pAlertCode, "CNWaitCleaning"))){
			SetWidgetSensitive(window, "CleaningDlg_FixingUnitCleaning2_radiobutton", FALSE);
			SetWidgetSensitive(window, "CleaningDlg_DrumCleaning1_radiobutton", FALSE);
			SetWidgetSensitive(window, "CleaningDlg_DrumCleaning2_radiobutton", FALSE);
		}
	}
}

void HideCleaningDlg(const UIStatusWnd *const wnd)
{
	if(wnd != NULL){
		HideDialog((UIDialog *)wnd->cleaning_dlg);
	}
}

void CleaningDlgOK(UIStatusWnd *const wnd)
{
	if(wnd != NULL){
		int ret = 0;
		int cleaningType = 0;

		if(GetToggleButtonActive(UI_DIALOG(wnd->cleaning_dlg)->window, "CleaningDlg_FixingUnitCleaning1_radiobutton") == TRUE){
			cleaningType = FIXING_UNIT_CLEANING1;
		}else if(GetToggleButtonActive(UI_DIALOG(wnd->cleaning_dlg)->window, "CleaningDlg_FixingUnitCleaning2_radiobutton") == TRUE){
			cleaningType = FIXING_UNIT_CLEANING2;
		}else if(GetToggleButtonActive(UI_DIALOG(wnd->cleaning_dlg)->window, "CleaningDlg_DrumCleaning1_radiobutton") == TRUE){
			cleaningType = DRUM_CLEANING1;
		}else if(GetToggleButtonActive(UI_DIALOG(wnd->cleaning_dlg)->window, "CleaningDlg_DrumCleaning2_radiobutton") == TRUE){
			cleaningType = DRUM_CLEANING2;
		}else{
		}

		switch(cleaningType){
			case FIXING_UNIT_CLEANING1:
				ret = ExecuteCleaning2(wnd, DREQ_CLEANING2);
				break;
			case FIXING_UNIT_CLEANING2:
				ret = PerformCleaning(wnd);
				break;
			case DRUM_CLEANING1:
				ret = ExecuteCleaning2(wnd, DREQ_CLEANING);
				break;
			case DRUM_CLEANING2:
				ret = ExecuteCleaning2(wnd, DREQ_CLEANING3);
				break;
			default:
				ret = 1;
				break;
		}
		HideCleaningDlg(wnd);
	}
}

