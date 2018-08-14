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
#include "msgdlg.h"
#include "support.h"
#include "ppapdata.h"

void UpdateMsgDlgWidgets(UIStatusWnd *wnd, int type);
static int SendRegiClrRequest(UIStatusWnd *wnd);
static int SendCalibRequest(UIStatusWnd *wnd);
int PerformCleaning(UIStatusWnd *wnd);

typedef struct{
	int type;
	char *message;
	char *title;
	int btn_type;
}MsgTable;

static MsgTable msg_table[] = {
	{MSG_TYPE_CLEANING1, N_("Performs Cleaning 1."), N_("Cleaning 1"), BTN_TYPE_OKCANCEL},
	{MSG_TYPE_CLEANING2, N_("Performs Cleaning 2."), N_("Cleaning 2"), BTN_TYPE_OKCANCEL},
	{MSG_TYPE_PRINT_PPAP, N_("Printing <Print position adjustment>"), N_("Printing"), BTN_TYPE_NONE},
	{MSG_TYPE_COMMUNICATION_ERR, N_("A communication error has occured."), N_("Printer Infomation"), BTN_TYPE_OK},
	{MSG_TYPE_HIDE_MONITOR, N_("Hides Statusmonitor window."), N_("Hide Status Monitor"), BTN_TYPE_OKCANCEL},
	{MSG_TYPE_CLEANING, N_("Performs Cleaning."), N_("Cleaning"), BTN_TYPE_OKCANCEL},
	{MSG_TYPE_COMMUNICATION_ERR_SET, N_("Could not set information to printer."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_COMMUNICATION_ERR_GET, N_("Could not get printer information."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_PERFORM_CALIB_ERR, N_("Could not perform calibration."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_CCINFO_GET_ERR, N_("Could not get counter information or information about remaining amount of consumables."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_CONSUMABLEINFO_GET_ERR, N_("Could not get information about remaining amount of consumables."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_COUNTERINFO_GET_ERR, N_("Could not get print counter information."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_CALIBRATION, N_("Performs Calibration."), N_("Calibration"), BTN_TYPE_OKCANCEL},
	{MSG_TYPE_IP_INCORRECT, N_("The entered IP address is incorrect."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_GATE_INCORRECT, N_("The entered gateway address is incorrect."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_SUB_INCORRECT, N_("The entered subnet mask is incorrect."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_PWD_INCORRECT, N_("The password is incorrect. Enter the password again."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_CLEANING_3300, N_("Performs Cleaning.\nLoad A4 (or Letter) paper in the paper source."), N_("Cleaning"), BTN_TYPE_OKCANCEL},
	{MSG_TYPE_REGIPAPER_3300_A4, N_("To use A4 paper for 2-sided printing, set the paper size switch lever on the back of the printer correctly.\nFailure to do so may result in paper jams.\nSee the instruction manual for more information."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_REGIPAPER_3300_LTR, N_("To use Letter paper for 2-sided printing, set the paper size switch lever on the back of the printer correctly.\nFailure to do so may result in paper jams.\nSee the instruction manual for more information."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_REGIPAPER_3300_LGL, N_("To use Legal paper for 2-sided printing, set the paper size switch lever on the back of the printer correctly.\nFailure to do so may result in paper jams.\nSee the instruction manual for more information."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_REGIPAPER_3300_A4_LTR, N_("To use A4 or Letter paper for 2-sided printing, set the paper size switch lever on the back of the printer correctly.\nFailure to do so may result in paper jams.\nSee the instruction manual for more information."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_REGIPAPER_3300_A4_LGL, N_("To use A4 or Legal paper for 2-sided printing, set the paper size switch lever on the back of the printer correctly.\nFailure to do so may result in paper jams.\nSee the instruction manual for more information."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_REGIPAPER_3300_LTR_LGL, N_("To use Letter or Legal paper for 2-sided printing, set the paper size switch lever on the back of the printer correctly.\nFailure to do so may result in paper jams.\nSee the instruction manual for more information."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_CLEANING_DATA, N_("Performs Cleaning."), N_("Cleaning"), BTN_TYPE_OKCANCEL},
	{MSG_TYPE_DEVREQ_REGICLR, N_("Performs out-of-register colors correction.        "), N_("Out-of-Register Colors Correction"), BTN_TYPE_OKCANCEL},
	{MSG_TYPE_DEVREQ_CALIB, N_("Performs Calibration."), N_("Calibration"), BTN_TYPE_OKCANCEL},
	{MSG_TYPE_PERFORM_REGICLR_ERR, N_("Could not perform Out-of-Register Colors Correction."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_PERFORM_CLEANING_ERR, N_("Could not perform cleaning.\nCheck the connection to the printer and the printer status, and then try again."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_PERFORM_REDUCE_STREAKS, N_("To make the changed setting in [Reduce Vertical Streaks on Outputs] effective,\nyou need to turn the printer off, and then back on again."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_CLEANING1_DATA, N_("Performs Cleaning 1."), N_("Cleaning 1"), BTN_TYPE_OKCANCEL},
	{MSG_TYPE_CLEANING2_CMD, N_("Performs Cleaning 2."), N_("Cleaning 2"), BTN_TYPE_OKCANCEL},
	{MSG_TYPE_DEVICE_REBOOT, N_("To make the change of network settings effective, you need to turn off the printer and then turn it back on again after a moment."), N_("Warning"), BTN_TYPE_OK},
	{MSG_TYPE_RESET_UNIT, N_("Part counters will be reset. Are you sure you want to reset them?"), N_("Reset Part Counters"), BTN_TYPE_OKCANCEL},
	{MSG_TYPE_DEVREQ_CLRMIS, N_("Performs Color Mismatch Correction."), N_("Color Mismatch Correction"), BTN_TYPE_OKCANCEL},
	{-1, NULL, NULL, -1},
};

UIMsgDlg* CreateMsgDlg(UIDialog *parent)
{
	UIMsgDlg *dialog;

	dialog = (UIMsgDlg *)CreateDialog(sizeof(UIMsgDlg), parent);

	UI_DIALOG(dialog)->window = create_Msg_dialog();

	return dialog;
}

void ShowMsgDlg(UIStatusWnd *wnd, int type)
{
	wnd->msg_dlg = CreateMsgDlg(UI_DIALOG(wnd));

	SigDisable();
	UpdateMsgDlgWidgets(wnd, type);
	SigEnable();

	gtk_window_set_transient_for(
		GTK_WINDOW(UI_DIALOG(wnd->msg_dlg)->window),
		GTK_WINDOW(UI_DIALOG(wnd->msg_dlg)->parent->window));

	switch(type){
	case MSG_TYPE_PRINT_PPAP:
		gtk_widget_show(UI_DIALOG(wnd->msg_dlg)->window);
		break;
	default:
		ShowDialog((UIDialog *)wnd->msg_dlg, NULL);
		break;
	}
}

void MsgDlgOK(UIStatusWnd *wnd)
{
	int ret = 0;

	switch(wnd->msg_dlg->type){
	case MSG_TYPE_CLEANING1:
		UpdateJob(CCPD_REQ_CLEANING2);
		break;
	case MSG_TYPE_CLEANING2:
		UpdateJob(CCPD_REQ_CLEANING);
		break;
	case MSG_TYPE_HIDE_MONITOR:
		HideMonitor(wnd);
		break;
	case MSG_TYPE_CLEANING:
		if( wnd->nModel == MODEL_LBP3250 ||
		    wnd->nModel == MODEL_LBP3100 ||
		    wnd->nModel == MODEL_LBP3050 ||
		    wnd->nModel == MODEL_LBP6200 ||
		    wnd->nModel == MODEL_LBP6000 ||
		    wnd->nModel == MODEL_LBP6020 ){
			ret = ExecuteCleaning( wnd );
		} else {
			UpdateJob(CCPD_REQ_CLEANING3);
		}
		break;
	case MSG_TYPE_CLEANING2_CMD:
		if( wnd->nModel == MODEL_LBP5050 ||
		    wnd->nModel == MODEL_LBP7210 ||
		    wnd->nModel == MODEL_LBP7200 ){
			ret = ExecuteCleaning( wnd );
		} else {
			UpdateJob(CCPD_REQ_CLEANING3);
		}
		break;
	case MSG_TYPE_CALIBRATION:
		ret = UpdateJob(CCPD_REQ_CALIBRATION);
		if ( ret == 2 ){
		        HideMsgDlg(wnd);
			ShowMsgDlg(wnd, MSG_TYPE_PERFORM_CALIB_ERR);
		}else{
		        ret = 0;
		}
		break;
	case MSG_TYPE_CLEANING_3300:
		UpdateJob(CCPD_REQ_CLEANING);
		break;
	case MSG_TYPE_CLEANING_DATA:
		ret = PerformCleaning(wnd);
		break;
	case MSG_TYPE_CLEANING1_DATA:
		ret = PerformCleaning(wnd);
		break;
	case MSG_TYPE_DEVREQ_REGICLR:
	case MSG_TYPE_DEVREQ_CLRMIS:
		ret = SendRegiClrRequest(wnd);
		break;
	case MSG_TYPE_DEVREQ_CALIB:
		ret = SendCalibRequest(wnd);
		break;
	case MSG_TYPE_RESET_UNIT:
		wnd->resetunit_dlg->setdata = TRUE;
		break;
	}
	if( ret == 0 )
	{
		HideMsgDlg(wnd);
	}
}

void MsgDlgCancel(UIStatusWnd *wnd)
{
	HideMsgDlg(wnd);
}

void HideMsgDlg(UIStatusWnd *wnd)
{
	switch(wnd->msg_dlg->type){
	case MSG_TYPE_PRINT_PPAP:
		gtk_widget_hide(UI_DIALOG(wnd->msg_dlg)->window);
		break;
	default:
		HideDialog((UIDialog *)wnd->msg_dlg);
		break;
	}
	DisposeDialog((UIDialog *)wnd->msg_dlg);
	wnd->msg_dlg = NULL;
}

void UpdateMsgDlgWidgets(UIStatusWnd *wnd, int type)
{
	GtkWidget *window = UI_DIALOG(wnd->msg_dlg)->window;
	int i = 0;

	while(msg_table[i].type != -1){
		if(type == msg_table[i].type){
			SetDialogTitle(window, _(msg_table[i].title));
			SetTextToLabel(window, "MsgDlg_label", _(msg_table[i].message));
			switch(msg_table[i].btn_type){
			case BTN_TYPE_NONE:
				HideWidget(window, "MsgDlg_OK_button");
				HideWidget(window, "MsgDlg_Cancel_button");
				break;
			case BTN_TYPE_OK:
				HideWidget(window, "MsgDlg_Cancel_button");
				break;
			case BTN_TYPE_CANCEL:
				HideWidget(window, "MsgDlg_OK_button");
				break;
			}
			wnd->msg_dlg->type = type;
			break;
		}
		i++;
	}

}



static int SendRegiClrRequest(UIStatusWnd *wnd)
{
	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
	  	goto err;

  	if(wnd->nControlKeyFlag == 1){
    	if(cnsktSetReqLong(wnd->pCnskt, DREQ_REGISTRATION2) < 0)
      	goto err;

  	}else {
    	if(cnsktSetReqLong(wnd->pCnskt, DREQ_REGISTRATION) < 0)
      	goto err;
  	}

  	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
    	goto err;

	return 0;
err:
	HideMsgDlg(wnd);
	ShowMsgDlg(wnd, MSG_TYPE_PERFORM_REGICLR_ERR);
	return 1;
}


static int SendCalibRequest(UIStatusWnd *wnd)
{
	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_CALIBRATION) < 0)
		goto err;

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;

	return 0;
err:
	HideMsgDlg(wnd);
	ShowMsgDlg(wnd, MSG_TYPE_PERFORM_CALIB_ERR);
	return 1;
}

#define	CLEANING_DATA_PATH	"/usr/share/ccpd"
#define	CLEANING_DATA_LBP5300	"CNAC5CL.BIN"
#define	CLEANING_DATA_LBP3500	"cnab6cl.bin"
#define	CLEANING_DATA_LBP5100	"CNAC6CL.BIN"
#define	CLEANING_DATA_LBP3310	"CNAB7CL.BIN"
#define	CLEANING_DATA_LBP5050	"CNAC8CL.BIN"
#define	CLEANING_DATA_LBP7200	"CNAC9CL.BIN"
#define	CLEANING_DATA_LBP9100	"CNACACL.BIN"
#define	CLEANING_DATA_LBP6300	"CNABBCL.BIN"
#define	CLEANING_DATA_LBP7010	"CNACBCL.BIN"

#define	CLEANING_DATA_LBP7200_US	"CNAC9CLS.BIN"
#define	CLEANING_DATA_LBP6300_US	"CNABBCLS.BIN"
#define	CLEANING_DATA_LBP9200	"CNACCCL.BIN"
#define	CLEANING_DATA_LBP6300N	"CNABECL.BIN"

#define	CLEANING_DATA_LBP7210	"CNACDCL.BIN"
#define	CLEANING_DATA_LBP6310	"CNABGCL.BIN"

#define	CLEANING_DATA_LBP5000	"CNAC4CL.BIN"

static char* GetCleaningData(UIStatusWnd *wnd)
{
	char *data = NULL;
	int size = 0;
	char* filename = NULL;

	size = strlen(CLEANING_DATA_PATH);

	switch(wnd->nModel){
	case MODEL_LBP5300:
		size += strlen(CLEANING_DATA_LBP5300) + 2;
		if((data = (char *)malloc(size)) != NULL){
			memset(data, 0, size);
			strcpy(data, CLEANING_DATA_PATH);
			strcat(data, "/");
			strcat(data, CLEANING_DATA_LBP5300);
		}
		break;
	case MODEL_LBP3500:
		size += strlen(CLEANING_DATA_LBP3500) + 2;
		if((data = (char *)malloc(size)) != NULL){
			memset(data, 0, size);
			strcpy(data, CLEANING_DATA_PATH);
			strcat(data, "/");
			strcat(data, CLEANING_DATA_LBP3500);
		}
		break;
	case MODEL_LBP5100:
		size += strlen(CLEANING_DATA_LBP5100) + 2;
		if((data = (char *)malloc(size)) != NULL){
			memset(data, 0, size);
			strcpy(data, CLEANING_DATA_PATH);
			strcat(data, "/");
			strcat(data, CLEANING_DATA_LBP5100);
		}
		break;
	case MODEL_LBP5000:
		size += strlen(CLEANING_DATA_LBP5000) + 2;
		if((data = (char *)malloc(size)) != NULL){
			memset(data, 0, size);
			strcpy(data, CLEANING_DATA_PATH);
			strcat(data, "/");
			strcat(data, CLEANING_DATA_LBP5000);
		}
		break;
	case MODEL_LBP5050:
		size += strlen(CLEANING_DATA_LBP5050) + 2;
		if((data = (char *)malloc(size)) != NULL){
			memset(data, 0, size);
			strcpy(data, CLEANING_DATA_PATH);
			strcat(data, "/");
			strcat(data, CLEANING_DATA_LBP5050);
		}
		break;
	case MODEL_LBP7200:
		if( IsUS(wnd) == TRUE ){
			filename = CLEANING_DATA_LBP7200_US;
		} else {
			filename = CLEANING_DATA_LBP7200;
		}
		size += strlen(filename) + 2;
		if((data = (char *)malloc(size)) != NULL){
			memset(data, 0, size);
			strcpy(data, CLEANING_DATA_PATH);
			strcat(data, "/");
			strcat(data, filename);
		}
		break;
	case MODEL_LBP7210:
		size += strlen(CLEANING_DATA_LBP7210) + 2;
		if((data = (char *)malloc(size)) != NULL){
			memset(data, 0, size);
			strcpy(data, CLEANING_DATA_PATH);
			strcat(data, "/");
			strcat(data, CLEANING_DATA_LBP7210);
		}
		break;

	case MODEL_LBP3310:
		size += strlen(CLEANING_DATA_LBP3310) + 2;
		if((data = (char *)malloc(size)) != NULL){
			memset(data, 0, size);
			strcpy(data, CLEANING_DATA_PATH);
			strcat(data, "/");
			strcat(data, CLEANING_DATA_LBP3310);
		}
		break;
	case MODEL_LBP9100:
		size += strlen(CLEANING_DATA_LBP9100) + 2;
		if((data = (char *)malloc(size)) != NULL){
			memset(data, 0, size);
			strcpy(data, CLEANING_DATA_PATH);
			strcat(data, "/");
			strcat(data, CLEANING_DATA_LBP9100);
		}
		break;
	case MODEL_LBP6300:
		if( IsUS(wnd) == TRUE ){
			filename = CLEANING_DATA_LBP6300_US;
		} else {
			filename = CLEANING_DATA_LBP6300;
		}
		size += strlen(filename) + 2;
		if((data = (char *)malloc(size)) != NULL){
			memset(data, 0, size);
			strcpy(data, CLEANING_DATA_PATH);
			strcat(data, "/");
			strcat(data, filename);
		}
		break;
	case MODEL_LBP6310:
	case MODEL_LBP6340:
		size += strlen(CLEANING_DATA_LBP6310) + 2;
		if((data = (char *)malloc(size)) != NULL){
			memset(data, 0, size);
			strcpy(data, CLEANING_DATA_PATH);
			strcat(data, "/");
			strcat(data, CLEANING_DATA_LBP6310);
		}
		break;
	case MODEL_LBP7010:
		size += strlen(CLEANING_DATA_LBP7010) + 2;
		if((data = (char *)malloc(size)) != NULL){
			memset(data, 0, size);
			strcpy(data, CLEANING_DATA_PATH);
			strcat(data, "/");
			strcat(data, CLEANING_DATA_LBP7010);
		}
		break;
	case MODEL_LBP9200:
		size += strlen(CLEANING_DATA_LBP9200) + 2;
		if((data = (char *)malloc(size)) != NULL){
			memset(data, 0, size);
			strcpy(data, CLEANING_DATA_PATH);
			strcat(data, "/");
			strcat(data, CLEANING_DATA_LBP9200);
		}
		break;
	case MODEL_LBP6300N:
		size += strlen(CLEANING_DATA_LBP6300N) + 2;
		if((data = (char *)malloc(size)) != NULL){
			memset(data, 0, size);
			strcpy(data, CLEANING_DATA_PATH);
			strcat(data, "/");
			strcat(data, CLEANING_DATA_LBP6300N);
		}
		break;
	default:
		break;
	}
	return data;
}

int PerformCleaning(UIStatusWnd *wnd)
{
	char *data = NULL;
	char *printer = NULL;

	printer = wnd->pCnskt->printer;
	data = GetCleaningData(wnd);

	if(wnd->pCnskt->printer == NULL)
		goto err;

	if(data == NULL)
		goto err;

	PrintCleaning(printer, data);
	free(data);

	return 0;
err:
	HideMsgDlg(wnd);
	ShowMsgDlg(wnd, MSG_TYPE_PERFORM_CLEANING_ERR);
	free(data);
	return 1;
}




