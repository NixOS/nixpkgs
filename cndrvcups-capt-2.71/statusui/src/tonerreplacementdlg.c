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
#include <pthread.h>

#include "uimain.h"
#include "widgets.h"
#include "interface.h"
#include "tonerreplacementdlg.h"
#include "data_process.h"
#include "callbacks.h"
#include "support.h"

#define TONER_K			0x0001
#define TONER_Y			0x0002
#define TONER_M			0x0004
#define TONER_C			0x0008
#define RET_NORMAL		0
#define RET_ERROR 		-1
#define ALERTSTAT_ERROR	-1
#define TIMER_INTERVAL	1000

enum{
	MAIN_MES_REPLACEABLE,
	MAIN_MES_ROTATING,
	MAIN_MES_WAIT_MOMENT,
	SUB_MES_C,
	SUB_MES_M,
	SUB_MES_Y,
	SUB_MES_K,
	SUB_MES_ROTATING
};

static char *MessageStr[] = {
	N_("If you click the button of the color of the toner cartridge, the cartridge will rotate to the replacement position."),
	N_("Do not open the top cover while the toner cartridges are rotating.\nWhen the rotation stops, open the top cover and replace the toner cartridge."),
	N_("Wait a moment."),
	N_("Cyan"),
	N_("Magenta"),
	N_("Yellow"),
	N_("Black"),
	N_("Rotating..."),
	NULL
};

enum{
	CRT_STR_AVAILABLE,
	CRT_STR_SOON,
	CRT_STR_REPLACE,
	CRT_STR_INSERT,
	CRT_STR_UNKNOWN
};

static char *CartridgeStr[] = {
	N_("Available"),
	N_("Replacement Needed Soon"),
	N_("Replace Cartridge"),
	N_("Insert Cartridge"),
	N_("Unknown"),
	NULL
};

static TonerCrgRepStatusInfo TonerCrgRepStatusInfoTable[] = {
	{"PrinterReadyToPrint"		, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNPrinting"					, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNPaused"					, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNSleep"					, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNCheckPaper"				, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNPrintCanceled"			, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNCleaning"					, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNCleaningPaper"			, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNWaitCleaning"			, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNPrinterPortBusy"			, FALSE	, TRUE		, FALSE	, FALSE	},
	{"CNErrorToServer"			, FALSE	, TRUE		, FALSE	, FALSE	},
	{"CNCheckingStatus"			, FALSE	, TRUE		, FALSE	, FALSE	},
	{"CNFirmUpdate"				, FALSE	, TRUE		, FALSE	, FALSE	},
	{"CNIncompatiblePrinter"	, FALSE	, TRUE		, FALSE	, FALSE	},
	{"CNDiskFull"					, FALSE	, TRUE		, FALSE	, FALSE	},
	{"CNServiceError"			, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNJam"						, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNJam2"						, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNNoDrum"					, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNNoWaste"					, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNWasteFull"				, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNTonerOut"					, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNDrumOut"					, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNDataXferError"			, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNChangePaperSize"			, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNInputMediaSupplyEmpty"	, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNInputMediaSupplyEmpty2"	, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNOutputTrayFull"			, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNNoMemory"					, FALSE	, TRUE		, FALSE	, FALSE	},
	{"CNCalibError"				, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNRegistError"				, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNAdapterCommError"		, FALSE	, TRUE		, FALSE	, FALSE	},
	{"CNPrinterCommError"		, FALSE	, TRUE		, FALSE	, FALSE	},
	{"CNWaiting"					, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNIPBlock"					, FALSE	, TRUE		, FALSE	, FALSE	},
	{"CNIllegalConnection"		, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNIllegalConnection2"		, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNCassetteOpen"			, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNMissPrint"				, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNNoTonerCartridge"		, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNCoverOpen"				, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNCoverOpen2"				, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNRotateTonerOpen"			, FALSE	, FALSE	, TRUE		, TRUE		},
	{"CNRotateTonerClose"		, FALSE	, FALSE	, FALSE	, TRUE		},
	{"CNFuserError"				, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNTonnerError"				, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNZiplockError"			, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNPaperInMFS"				, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNPrinterNotReady"			, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNInvalidPrinter"			, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNInvalidPort"				, FALSE	, TRUE		, FALSE	, FALSE	},
	{"CNShutDown"					, FALSE	, TRUE		, FALSE	, FALSE	},
	{"CNITBError"					, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNCoverOpen3"				, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNOutputOpen"				, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNOutputClose"				, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNFuCoverOpen"				, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNCoolDown"					, FALSE	, FALSE	, FALSE	, FALSE	},
	{"CNReadyTonerOpenC"			, TRUE		, FALSE	, TRUE		, TRUE		},
	{"CNReadyTonerOpenK"			, TRUE		, FALSE	, TRUE		, TRUE		},
	{"CNReadyTonerOpenM"			, TRUE		, FALSE	, TRUE		, TRUE		},
	{"CNReadyTonerOpenY"			, TRUE		, FALSE	, TRUE		, TRUE		},
	{"CNReadyTonerCloseC"		, TRUE		, FALSE	, FALSE	, TRUE		},
	{"CNReadyTonerCloseK"		, TRUE		, FALSE	, FALSE	, TRUE		},
	{"CNReadyTonerCloseM"		, TRUE		, FALSE	, FALSE	, TRUE		},
	{"CNReadyTonerCloseY"		, TRUE		, FALSE	, FALSE	, TRUE		},
	{"CNWrongTonerC"				, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNWrongTonerK"				, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNWrongTonerM"				, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNWrongTonerY"				, TRUE		, FALSE	, FALSE	, FALSE	},
	{"CNWaitPrinting"			, FALSE	, FALSE	, FALSE	, FALSE	},
	{NULL							, FALSE	, FALSE	, FALSE	, FALSE	}
};

unsigned int g_timer_tag;

static void InitTonerReplacementDlgWidgets(UIStatusWnd *wnd);
static TonerCrgRepStatusInfo GetTonerCrgRepStatusInfoAtAlertCode(const char *const alertCode);
static int GetPossibleChangeValueAtAlertCode(const char *const alertCode);
static int GetIsReplaceModeValueAtAlertCode(const char *const alertCode);
static int GetIsCoverOpenValueAtAlertCode(const char *const alertCode);
static void ChangeToTonerReplaceMode(UIStatusWnd *wnd, pthread_t *thread);
void *ModeChangeThread(void *const param);
static int UpdateTimerFunc(UIStatusWnd *wnd);
static void UpdateButtonEnable(const UIStatusWnd *const wnd, const int enable);
static void UpdateDialogPosition(UIStatusWnd *const wnd);

UITonerReplacementDlg* CreateTonerReplacementDlg(UIDialog *parent)
{
	UITonerReplacementDlg *dialog;

	dialog = (UITonerReplacementDlg *)CreateDialog(sizeof(UITonerReplacementDlg), parent);

	UI_DIALOG(dialog)->window = create_TonerReplacementDlg_dialog();

	return dialog;
}

static TonerCrgRepStatusInfo GetTonerCrgRepStatusInfoAtAlertCode(const char *const alertCode)
{
	TonerCrgRepStatusInfo ret = {NULL, FALSE, FALSE, FALSE, FALSE};
	int index = 0;

	if(alertCode != NULL){
		for(index = 0; TonerCrgRepStatusInfoTable[index].alertCode != NULL; index++){
			if(!(strcmp(alertCode, TonerCrgRepStatusInfoTable[index].alertCode))){
				ret = TonerCrgRepStatusInfoTable[index];
				break;
			}
		}
	}
	return ret;
}

static int GetPossibleChangeValueAtAlertCode(const char *const alertCode)
{
	int ret = FALSE;
	TonerCrgRepStatusInfo tonerCrgRepStatusInfo = {NULL, FALSE, FALSE, FALSE, FALSE};

	if(alertCode != NULL){
		tonerCrgRepStatusInfo = GetTonerCrgRepStatusInfoAtAlertCode(alertCode);
		if(tonerCrgRepStatusInfo.alertCode != NULL){
			ret = tonerCrgRepStatusInfo.possibleChange;
		}
	}
	return ret;
}

static int GetIsReplaceModeValueAtAlertCode(const char *const alertCode)
{
	int ret = ALERTSTAT_ERROR;
	TonerCrgRepStatusInfo tonerCrgRepStatusInfo = {NULL, FALSE, FALSE, FALSE, FALSE};

	if(alertCode != NULL){
		tonerCrgRepStatusInfo = GetTonerCrgRepStatusInfoAtAlertCode(alertCode);
		if(tonerCrgRepStatusInfo.alertCode != NULL){
			ret = tonerCrgRepStatusInfo.isReplaceMode;
		}
	}
	return ret;
}

static int GetIsCoverOpenValueAtAlertCode(const char *const alertCode)
{
	int ret = ALERTSTAT_ERROR;
	TonerCrgRepStatusInfo tonerCrgRepStatusInfo = {NULL, FALSE, FALSE, FALSE, FALSE};

	if(alertCode != NULL){
		tonerCrgRepStatusInfo = GetTonerCrgRepStatusInfoAtAlertCode(alertCode);
		if(tonerCrgRepStatusInfo.alertCode != NULL){
			ret = tonerCrgRepStatusInfo.isCoverOpen;
		}
	}
	return ret;
}

int UpdateConsumableInfo(UIStatusWnd* const wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->toner_replacement_dlg)->window;
	int res = 0;
	int index = 0;
	int setValue = 0;
	long warning1 = 0;
	long warning2 = 0;
	long warning3 = 0;
	long warning4 = 0;
	long absent = 0;
	long misplas = 0;
	long memerror = 0;
	long mounterror = 0;
	long sealedrror = 0;

	struct consumableBitInfoTable{
		long partsBit;
		char *uiName;
	}const consumableInfo[] = {
		{TONER_K, "TonerReplacementDlg_Black_label"},
		{TONER_Y, "TonerReplacementDlg_Yellow_label"},
		{TONER_M, "TonerReplacementDlg_Magenta_label"},
		{TONER_C, "TonerReplacementDlg_Cyan_label"},
		{-1, NULL}
	};

	if((wnd == NULL) || (wnd->pCnskt == NULL)){
		res = -1;
	}

	if(res == 0){
		res = cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG);
	}
	if(res == 0){
		res = cnsktSetReqLong(wnd->pCnskt, DREQ_GET_CONSUMABLE);
	}
	if(res == 0){
		res = SendRequest(wnd, CCPD_DEVICE_REQUEST);
	}

	if(res == 0){
		res = cnsktGetResData(wnd->pCnskt, &warning1, READ_TYPE_LONG, -1);
	}
	if(res == 0){
		res = cnsktGetResData(wnd->pCnskt, &warning2, READ_TYPE_LONG, -1);
	}
	if(res == 0){
		res = cnsktGetResData(wnd->pCnskt, &warning3, READ_TYPE_LONG, -1);
	}
	if(res == 0){
		res = cnsktGetResData(wnd->pCnskt, &warning4, READ_TYPE_LONG, -1);
	}
	if(res == 0){
		res = cnsktGetResData(wnd->pCnskt, &absent, READ_TYPE_LONG, -1);
	}
	if(res == 0){
		res = cnsktGetResData(wnd->pCnskt, &misplas, READ_TYPE_LONG, -1);
	}
	if(res == 0){
		res = cnsktGetResData(wnd->pCnskt, &memerror, READ_TYPE_LONG, -1);
	}
	if(res == 0){
		res = cnsktGetResData(wnd->pCnskt, &mounterror, READ_TYPE_LONG, -1);
	}
	if(res == 0){
		res = cnsktGetResData(wnd->pCnskt, &sealedrror, READ_TYPE_LONG, -1);
	}

	if(res < 0){
		for(index = 0; consumableInfo[index].partsBit != -1; index++){
			SetTextToLabel(window, consumableInfo[index].uiName, _(CartridgeStr[CRT_STR_UNKNOWN]));
		}
	}else{
		for(index = 0; consumableInfo[index].partsBit != -1; index++){
			if(absent & consumableInfo[index].partsBit){
				setValue = CRT_STR_INSERT;
			}
			else if(misplas & consumableInfo[index].partsBit){
				setValue = CRT_STR_INSERT;
			}
			else if(warning3 & consumableInfo[index].partsBit){
				setValue = CRT_STR_REPLACE;
			}
			else if(warning2 & consumableInfo[index].partsBit){
				setValue = CRT_STR_REPLACE;
			}
			else if(warning4 & consumableInfo[index].partsBit){
				setValue = CRT_STR_REPLACE;
			}
			else if(memerror & consumableInfo[index].partsBit){
				setValue = CRT_STR_REPLACE;
			}
			else if(mounterror & consumableInfo[index].partsBit){
				setValue = CRT_STR_REPLACE;
			}
			else if(sealedrror & consumableInfo[index].partsBit){
				setValue = CRT_STR_REPLACE;
			}
			else if(warning1 & consumableInfo[index].partsBit){
				setValue = CRT_STR_SOON;
			}
			else{
				setValue = CRT_STR_AVAILABLE;
			}
			SetTextToLabel(window, consumableInfo[index].uiName, _(CartridgeStr[setValue]));
		}
		res = 0;
	}
	return res;
}

void *ModeChangeThread(void *const param)
{
	UIStatusWnd *wnd = (UIStatusWnd*)param;

	wnd->toner_replacement_dlg->isModeChangeThreadActive = TRUE;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0){
		goto error;
	}
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_CHG_CARTRIDGEMODE_ON) < 0){
		goto error;
	}
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0){
		goto error;
	}

	wnd->toner_replacement_dlg->isModeChangeThreadActive = FALSE;
	return NULL;
error:
	wnd->toner_replacement_dlg->modeChangeRetCode = RET_ERROR;
	wnd->toner_replacement_dlg->isModeChangeThreadActive = FALSE;
	return NULL;
}

static void ChangeToTonerReplaceMode(UIStatusWnd *wnd, pthread_t *thread)
{
	int isReplaceMode = ALERTSTAT_ERROR;

	if(wnd != NULL){
		if(GetPossibleChangeValueAtAlertCode(wnd->pAlertCode) == TRUE){
			isReplaceMode = GetIsReplaceModeValueAtAlertCode(wnd->pAlertCode);
			if(isReplaceMode == TRUE){
				wnd->toner_replacement_dlg->modeChangeRetCode = RET_NORMAL;
			}else{
				wnd->toner_replacement_dlg->isModeChangeThreadActive = TRUE;
				wnd->toner_replacement_dlg->modeChangeRetCode = RET_NORMAL;

				if(pthread_create(thread, NULL, ModeChangeThread, wnd) != 0){
					wnd->toner_replacement_dlg->isModeChangeThreadActive = FALSE;
					wnd->toner_replacement_dlg->modeChangeRetCode = RET_ERROR;
				}
			}
		}
	}
}

static void UpdateButtonEnable(const UIStatusWnd *const wnd, const int enable)
{
	if(wnd != NULL){
		GtkWidget *window = UI_DIALOG(wnd->toner_replacement_dlg)->window;

		SetWidgetSensitive(window, "TonerReplacementDlg_Cyan_button", enable);
		SetWidgetSensitive(window, "TonerReplacementDlg_Magenta_button", enable);
		SetWidgetSensitive(window, "TonerReplacementDlg_Yellow_button", enable);
		SetWidgetSensitive(window, "TonerReplacementDlg_Black_button", enable);
		SetWidgetSensitive(window, "TonerReplacementDlg_Finish_button", enable);

		if(enable == TRUE){
			if(wnd->toner_replacement_dlg->buttonEnableOld == FALSE){
				SetFocus(window, "TonerReplacementDlg_Cyan_button");
			}
		}else{
			if(wnd->toner_replacement_dlg->buttonEnableOld == TRUE){
				SetFocus(window, "TonerReplacementDlg_text");
			}
		}

		wnd->toner_replacement_dlg->buttonEnableOld = enable;
	}
}

static void UpdateDialogPosition(UIStatusWnd *const wnd)
{
	int mainX = 0;
	int mainY = 0;
	int mainWidth = 0;
	int mainHeight = 0;
	int tonerRepDlgX = 0;
	int tonerRepDlgY = 0;
	int tonerRepDlgWidth = 0;
	int tonerRepDlgHeight = 0;
	int screenWidth = 0;
	int screenHeight = 0;

	if(wnd != NULL){
		GtkWidget *mainWindow = UI_DIALOG(wnd)->window;
		GtkWidget *tonerRepDlg = UI_DIALOG(wnd->toner_replacement_dlg)->window;

		GetWindowPositionAndSize(mainWindow, &mainX, &mainY, &mainWidth, &mainHeight);

		GetWindowPositionAndSize(tonerRepDlg, &tonerRepDlgX, &tonerRepDlgY, &tonerRepDlgWidth, &tonerRepDlgHeight);

		GetScreenSize(mainWindow, &screenWidth, &screenHeight);

		if((mainX + mainWidth + tonerRepDlgWidth) <= screenWidth){
			tonerRepDlgX = mainX + mainWidth;
		}else if((mainX - tonerRepDlgWidth) >= 0){
			tonerRepDlgX = mainX - tonerRepDlgWidth;
		}else if((mainX + (mainWidth / 2)) < (screenWidth / 2)){
			tonerRepDlgX = screenWidth - tonerRepDlgWidth;
		}else{
			tonerRepDlgX = 0;
		}

		tonerRepDlgY = mainY;

		WindowMove(tonerRepDlg, tonerRepDlgX, tonerRepDlgY);
	}
}

static int UpdateTimerFunc(UIStatusWnd *wnd)
{
	int ret = TRUE;
	int needQuit = TRUE;
	int doing = FALSE;
	int warningEnd = FALSE;
	int statusPossibleChange = ALERTSTAT_ERROR;
	int isReplaceMode = FALSE;
	int buttonEnable = FALSE;
	char *mainStatusString = NULL;
	char *subStatusString = NULL;

	if(wnd != NULL){
		GtkWidget *window = UI_DIALOG(wnd->toner_replacement_dlg)->window;

		if(wnd->toner_replacement_dlg->modeChangeRetCode != RET_NORMAL){
			warningEnd = TRUE;
		}else if((wnd->toner_replacement_dlg->isModeChangeThreadActive == FALSE) &&
					(wnd->toner_replacement_dlg->modeChangeRetCode == RET_NORMAL)){
			doing = TRUE;
		}

		if(doing == TRUE){
			statusPossibleChange = GetPossibleChangeValueAtAlertCode(wnd->pAlertCode);
			isReplaceMode = GetIsReplaceModeValueAtAlertCode(wnd->pAlertCode);
			if(statusPossibleChange != ALERTSTAT_ERROR){
				needQuit = FALSE;

				if(wnd->toner_replacement_dlg->isModeChanged == FALSE){
					if((statusPossibleChange == TRUE) && (isReplaceMode == TRUE)){
						wnd->toner_replacement_dlg->isModeChanged = TRUE;
						UpdateButtonEnable(wnd, TRUE);
					}
				}else{
					if(isReplaceMode != TRUE){
						needQuit = TRUE;
					}
				}
			}else{
				needQuit = TRUE;
			}

			if(needQuit == TRUE){
				HideTonerReplacementDlg(wnd);
				ret = FALSE;
			}else{
				mainStatusString = MessageStr[MAIN_MES_WAIT_MOMENT];

				if(!(strcmp(wnd->pAlertCode, "CNReadyTonerOpenC")) ||
					!(strcmp(wnd->pAlertCode, "CNReadyTonerCloseC")) ||
					!(strcmp(wnd->pAlertCode, "CNReadyTonerC"))){
					mainStatusString = MessageStr[MAIN_MES_REPLACEABLE];
					subStatusString = MessageStr[SUB_MES_C];
					buttonEnable = TRUE;

				}else if(!(strcmp(wnd->pAlertCode, "CNReadyTonerOpenM")) ||
					!(strcmp(wnd->pAlertCode, "CNReadyTonerCloseM")) ||
					!(strcmp(wnd->pAlertCode, "CNReadyTonerM"))){
					mainStatusString = MessageStr[MAIN_MES_REPLACEABLE];
					subStatusString = MessageStr[SUB_MES_M];
					buttonEnable = TRUE;

				}else if(!(strcmp(wnd->pAlertCode, "CNReadyTonerOpenY")) ||
					!(strcmp(wnd->pAlertCode, "CNReadyTonerCloseY")) ||
					!(strcmp(wnd->pAlertCode, "CNReadyTonerY"))){
					mainStatusString = MessageStr[MAIN_MES_REPLACEABLE];
					subStatusString = MessageStr[SUB_MES_Y];
					buttonEnable = TRUE;

				}else if(!(strcmp(wnd->pAlertCode, "CNReadyTonerOpenK")) ||
					!(strcmp(wnd->pAlertCode, "CNReadyTonerCloseK")) ||
					!(strcmp(wnd->pAlertCode, "CNReadyTonerK"))){
					mainStatusString = MessageStr[MAIN_MES_REPLACEABLE];
					subStatusString = MessageStr[SUB_MES_K];
					buttonEnable = TRUE;

				}else if(!(strcmp(wnd->pAlertCode, "CNRotateTonerOpen")) ||
					!(strcmp(wnd->pAlertCode, "CNRotateTonerClose"))){
					mainStatusString = MessageStr[MAIN_MES_ROTATING];
					subStatusString = MessageStr[SUB_MES_ROTATING];
					buttonEnable = FALSE;
				}

				SetTextToTextView(window, "TonerReplacementDlg_text", _(mainStatusString));
				SetTextToLabel(window, "TonerReplacementDlg_Replaceable_TonerColor_label", _(subStatusString));


				if(GetIsCoverOpenValueAtAlertCode(wnd->pAlertCode) == FALSE){
					UpdateButtonEnable(wnd, buttonEnable);
					if(wnd->toner_replacement_dlg->isCoverOpend == TRUE){
						UpdateJob(REQ_UPDATE_CONSUMABLESINFO_OF_TONERREPLACEMENT);
						wnd->toner_replacement_dlg->isCoverOpend = FALSE;
					}
				}else{
					wnd->toner_replacement_dlg->isCoverOpend = TRUE;
					if(!(strcmp(wnd->pAlertCode, "CNReadyTonerOpenC")) ||
						!(strcmp(wnd->pAlertCode, "CNReadyTonerOpenM")) ||
						!(strcmp(wnd->pAlertCode, "CNReadyTonerOpenY")) ||
						!(strcmp(wnd->pAlertCode, "CNReadyTonerOpenK")) ||
						!(strcmp(wnd->pAlertCode, "CNRotateTonerOpen"))){
						SetWidgetSensitive(window, "TonerReplacementDlg_Cyan_button", FALSE);
						SetWidgetSensitive(window, "TonerReplacementDlg_Magenta_button", FALSE);
						SetWidgetSensitive(window, "TonerReplacementDlg_Yellow_button", FALSE);
						SetWidgetSensitive(window, "TonerReplacementDlg_Black_button", FALSE);
						SetWidgetSensitive(window, "TonerReplacementDlg_Finish_button", TRUE);
						if(wnd->toner_replacement_dlg->buttonEnableOld == TRUE){
							SetFocus(window, "TonerReplacementDlg_text");
						}
						wnd->toner_replacement_dlg->buttonEnableOld = FALSE;
					}
				}
			}
		}else{
			if(warningEnd == TRUE){
				ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
				ret = FALSE;
			}
		}
	}else{
		HideTonerReplacementDlg(wnd);
		ret = FALSE;
	}
	return ret;
}

void ShowTonerReplacementDlg(UIStatusWnd *wnd)
{
	pthread_t thread;

	if(wnd != NULL){
		SigDisable();
		InitTonerReplacementDlgWidgets(wnd);
		SigEnable();

		if(GetPossibleChangeValueAtAlertCode(wnd->pAlertCode) == TRUE){
			UpdateJob(REQ_UPDATE_CONSUMABLESINFO_OF_TONERREPLACEMENT);
			ChangeToTonerReplaceMode(wnd, &thread);

			g_timer_tag = gtk_timeout_add(TIMER_INTERVAL, (GtkFunction)UpdateTimerFunc, wnd);
			pthread_join(thread, NULL);
			if(wnd->toner_replacement_dlg->modeChangeRetCode == RET_NORMAL){
				ShowDialog((UIDialog *)wnd->toner_replacement_dlg, NULL);
			}
		}else{
			ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
		}
	}
}

static void InitTonerReplacementDlgWidgets(UIStatusWnd *wnd)
{
	if(wnd != NULL){
		GtkWidget *window = UI_DIALOG(wnd->toner_replacement_dlg)->window;

		wnd->toner_replacement_dlg->isCoverOpend = TRUE;
		wnd->toner_replacement_dlg->isModeChanged = FALSE;
		wnd->toner_replacement_dlg->isModeChangeThreadActive = FALSE;
		wnd->toner_replacement_dlg->modeChangeRetCode = RET_ERROR;

		SetTextToTextView(window, "TonerReplacementDlg_text", _(MessageStr[MAIN_MES_WAIT_MOMENT]));
		SetTextToLabel(window, "TonerReplacementDlg_Replaceable_TonerColor_label", "");
		UpdateButtonEnable(wnd, FALSE);
		wnd->toner_replacement_dlg->buttonEnableOld = FALSE;

		UpdateDialogPosition(wnd);
	}
}

void HideTonerReplacementDlg(UIStatusWnd *wnd)
{
	if(wnd != NULL){
		HideDialog((UIDialog *)wnd->toner_replacement_dlg);
		UpdateDialogPosition(wnd);
	}
}

void TonerReplacementDlgFinish(UIStatusWnd *wnd)
{
	if(g_timer_tag != 0){
		gtk_timeout_remove(g_timer_tag);
	}

	if(wnd == NULL){
		goto error;
	}

	if(wnd->toner_replacement_dlg->isModeChanged == TRUE){
		if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0){
			goto error;
		}
		if(cnsktSetReqLong(wnd->pCnskt, DREQ_CHG_CARTRIDGEMODE_OFF) < 0){
			goto error;
		}
		if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0){
			goto error;
		}
	}
	HideTonerReplacementDlg(wnd);
	return;
error:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
	HideTonerReplacementDlg(wnd);
	return;
}

void TonerReplacementDlgCancel(UIStatusWnd *wnd)
{
	if(g_timer_tag != 0){
		gtk_timeout_remove(g_timer_tag);
	}

	if(wnd == NULL){
		goto error;
	}

	if(wnd->pAlertCode != NULL){
		if((strcmp(wnd->pAlertCode, "CNRotateTonerClose")) && (wnd->toner_replacement_dlg->isModeChanged == TRUE)){
			if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0){
				goto error;
			}
			if(cnsktSetReqLong(wnd->pCnskt, DREQ_CHG_CARTRIDGEMODE_OFF) < 0){
				goto error;
			}
			if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0){
				goto error;
			}
		}
	}

	HideTonerReplacementDlg(wnd);
	return;
error:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
	HideTonerReplacementDlg(wnd);
	return;
}

void RequestRotate(UIStatusWnd *wnd, const long requestCode)
{
	if(wnd == NULL){
		goto error;
	}

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0){
		goto error;
	}
	if(cnsktSetReqLong(wnd->pCnskt, requestCode) < 0){
		goto error;
	}
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0){
		goto error;
	}
	return;
error:
	if(g_timer_tag != 0){
		gtk_timeout_remove(g_timer_tag);
	}
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
	HideTonerReplacementDlg(wnd);
	return;
}
