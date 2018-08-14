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
#include <unistd.h>
#include <asm/errno.h>

#include <iconv.h>
#include <libxml/parser.h>
#include <libxml/tree.h>

#include "uimain.h"
#include "widgets.h"
#include "support.h"

#define ELEMENT_NONE		0
#define ELEMENT_DESCRIPT	1

#define POLLING_NOREQ	0
#define	POLLING_WRITE	1
#define POLLING_READ	2
#define POLLING_DONOT	3


#define	RETRY_COUNT	10

static int g_polling_status = POLLING_NOREQ;
static int g_job_num = 0;

static char *err_str = N_("Unknown Error");
static char *fifo_open_err = N_("Cannot Open FIFO");
static char *no_printer_str = N_("No Specified Printer");
static char *printer_err = N_("Printer Error");
static char *printer_entry = N_("Check the <Printer ***> of /etc/ccpd.conf");
static char *device_path = N_("Check the DevicePath of /etc/ccpd.conf");
static char *device_uri = N_("Check the fifo path\n - ccp:/var/ccpd/fifo<*>");

static int XmlToText(UIStatusWnd *wnd, char *src);
static void conv_iconv(UIStatusWnd *wnd, char *value);
void ExitDataProcess(void);
char* SetErrorString(int id);
static void ShowStatusWndDlgs(UIStatusWnd *wnd, int dlgnum);

int StatusRequest(gpointer data)
{
UI_DEBUG("StatusRequest %d\n", g_job_num);
	if(g_polling_status == POLLING_NOREQ){
		if(g_job_num == 0)
			g_job_num = CCPD_REQ_STATUS;
		g_polling_status = POLLING_WRITE;
UI_DEBUG("StatusRequest %d\n", g_job_num);
	}
	return TRUE;
}

void JobRequest(long job_num)
{
	g_job_num = job_num;
	if(g_polling_status == POLLING_NOREQ)
		g_polling_status = POLLING_WRITE;
}

void ExitDataProcess(void)
{
	DisposeStatusWnd();
	gtk_main_quit();
}

int DataProcess(gpointer user_data)
{
	UIStatusWnd *wnd;
	int max_fd;
	int result;
	struct timeval timeout;
	wnd = g_status_window;
	max_fd = wnd->pCnskt->socket_fd + 1;
	timeout.tv_sec = 0;
	timeout.tv_usec = 0;
UI_DEBUG("DataProcess %d\n", g_polling_status);

	if(wnd->retry == RETRY_COUNT){
		ExitDataProcess();
		return FALSE;
	}

	if(g_polling_status == POLLING_WRITE){
		fd_set writefd;

		if(wnd->exit){
			ExitDataProcess();
			return FALSE;
		}

		FD_ZERO(&writefd);
		FD_SET(wnd->pCnskt->socket_fd, &writefd);
		result = select(max_fd, NULL, &writefd, NULL, &timeout);
UI_DEBUG("DataProcess Write %d\n", g_polling_status);
		if(result < 0){
			UI_DEBUG("select error\n");
			return TRUE;
		}else if(result == 0){
			return TRUE;
		}
		if(g_job_num > REQ_SHOWDLG){
			g_polling_status = POLLING_DONOT;
			ShowStatusWndDlgs(wnd, g_job_num);
			return TRUE;
		}
		if(FD_ISSET(wnd->pCnskt->socket_fd, &writefd)){
			if(cnsktWrite(wnd->pCnskt, g_job_num) < 0){
				wnd->retry++;
				UI_DEBUG("WRITE ERROR retry %d\n", wnd->retry);
			}else{
				g_polling_status = POLLING_READ;
				UI_DEBUG("WRITE SUCESS\n");
				wnd->retry = 0;
			}
			g_job_num = 0;
		}
	}else if(g_polling_status == POLLING_READ){
		fd_set readfd;

		if(wnd->exit > 0){
UI_DEBUG("wnd->exit %d\n", wnd->exit);
			if(wnd->exit > RETRY_COUNT){
				ExitDataProcess();
				return FALSE;
			}
			wnd->exit++;
		}

		FD_ZERO(&readfd);
		FD_SET(wnd->pCnskt->socket_fd, &readfd);
		result = select(max_fd, &readfd, NULL, NULL, &timeout);
UI_DEBUG("DataProcess Read %d\n", g_polling_status);
		if(result < 0){
			UI_DEBUG("select error\n");
			return TRUE;
		}else if(result == 0){
			return TRUE;
		}
		if(FD_ISSET(wnd->pCnskt->socket_fd, &readfd)){
			int res = 0;
			res = cnsktRead(wnd->pCnskt);

			if(res < 0){
				wnd->retry++;
				UI_DEBUG("Read ERROR retry %d\n", wnd->retry);
				if(wnd->exit){
					ExitDataProcess();
					return FALSE;
				}
				return TRUE;
			}else if(res == 0){
				UI_DEBUG("RESPONSE ERROR\n");
				wnd->retry = 0;
				if(wnd->pCnskt->response_code == CCPD_RES_NOPRINTER){
					wnd->text1 = SetErrorString(ID_STR_NOPRINTER);
					wnd->text2 = SetErrorString(ID_STR_PRINTER_ENTRY);
UI_DEBUG("Read response_code No printer\n");
				}else if(wnd->pCnskt->response_code == CCPD_RES_PRINTER_ERR){
					wnd->text1 = SetErrorString(ID_STR_PRINTER_ERROR);
					wnd->text2 = SetErrorString(ID_STR_DEVICE_PATH);
UI_DEBUG("Read response_code Printer err\n");
				}else if(wnd->pCnskt->response_code == CCPD_RES_FIFO_ERROR){
					wnd->text1 = SetErrorString(ID_STR_FIFO_ERROR);
					wnd->text2 = SetErrorString(ID_STR_DEVICE_URI);
UI_DEBUG("Read response_code fifo err\n");
				}else{
					wnd->text1 = SetErrorString(ID_STR_UNKNOWN_ERROR);
					wnd->text2 = NULL;
				}

				if(wnd->exit){
					ExitDataProcess();
					return FALSE;
				}
				switch(wnd->pCnskt->req_command){
				case CCPD_REQ_STATUS:
					if(g_job_num == 0){
						SigDisable();
						UpdateWidgets(wnd);
						SigEnable();
					}
					break;
				case CCPD_REQ_SET_FLASH:
					if(wnd->pCnskt->response_code
							 == CCPD_RES_OK){
						HideDevDlg(wnd);
					}else{
						ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR);
					}
					break;
				case CCPD_REQ_CALIBRATION:
					if(wnd->pCnskt->response_code
							!= CCPD_RES_OK)
						ShowMsgDlg(wnd, MSG_TYPE_PERFORM_CALIB_ERR);
					break;
				}
			}else{
				if(wnd->exit){
					ExitDataProcess();
					return FALSE;
				}
UI_DEBUG("Read Size %ld\n", wnd->pCnskt->total_length);
				UI_DEBUG("RESPONSE COMPLETE\n");
				if(wnd->pCnskt->req_command == CCPD_REQ_STATUS
				&& g_job_num == 0){
					char *data = NULL;
					data = cnsktGetStatusData(wnd->pCnskt);
UI_DEBUG("Data %s\n", data);
					XmlToText(wnd, data);
					SigDisable();
					UpdateWidgets(wnd);
					SigEnable();
				}
				if(wnd->pCnskt->req_command == CCPD_REQ_PRT_INFO){
					if(wnd->ppap)
						ShowPPAPDlg(wnd);
					else if(wnd->dev)
						ShowDevDlg(wnd);
					SetWidgetSensitive(UI_DIALOG(wnd)->window, "menubar1", TRUE);
					SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", TRUE);
				}
			}
			g_polling_status = POLLING_NOREQ;
		}
	}
	return TRUE;
}

xmlNode* FindPrtEntryChildren(xmlNode *pRoot, char *table_name, char *entry_name)
{
	xmlNode *pMib;

	for(pMib = pRoot; pMib != NULL; pMib = pMib->next){
		if(pMib->type == XML_ELEMENT_NODE && strcmp(pMib->name, "Printer-MIB") == 0){
			xmlNode *pTable;
			for(pTable = pMib->children; pTable != NULL; pTable = pTable->next){
				if(pTable->type == XML_ELEMENT_NODE && strcmp(pTable->name, table_name) == 0){
					xmlNode *pEntry;
					for(pEntry = pTable->children; pEntry != NULL; pEntry = pEntry->next){
						if(pEntry->type == XML_ELEMENT_NODE && strcmp(pEntry->name, entry_name) == 0){
							return pEntry->children;
						}
					}
				}
			}
		}
	}
	return NULL;
}

char* SetErrorString(int id)
{
	char *str = NULL, *ret = NULL;
	int size;

	switch(id){
	case ID_STR_NOPRINTER:
		str = _(no_printer_str);
		break;
	case ID_STR_PRINTER_ERROR:
		str = _(printer_err);
		break;
	case ID_STR_FIFO_ERROR:
		str = _(fifo_open_err);
		break;
	case ID_STR_PRINTER_ENTRY:
		str = _(printer_entry);
		break;
	case ID_STR_DEVICE_PATH:
		str = _(device_path);
		break;
	case ID_STR_DEVICE_URI:
		str = _(device_uri);
		break;
	case ID_STR_UNKNOWN_ERROR:
	default:
		str = _(err_str);
		break;
	}
	size = strlen(str) + 1;
	ret = (char *)malloc(size);
	strcpy(ret, str);
	return ret;
}

static int XmlToText(UIStatusWnd *wnd, char *src)
{
	xmlDoc *pDoc;
	xmlNode *pRoot;
	xmlNode *pEntryChildren;
	xmlNode *pDesc;
	static char desc[MAX_BUFF_SIZE];

UI_DEBUG("XmlToText\n");
	pDoc = xmlParseMemory(src, wnd->pCnskt->total_length);
	pRoot = xmlDocGetRootElement(pDoc);
	pEntryChildren = FindPrtEntryChildren(pRoot, "PrtAlertTable", "PrtAlertEntry");

	desc[0] = '\0';

	if(pEntryChildren == NULL)
		UI_DEBUG("XmlToText Error\n");

	for(pDesc = pEntryChildren; pDesc != NULL; pDesc = pDesc->next){
		if(pDesc->type == XML_ELEMENT_NODE && strcmp(pDesc->name, "PrtAlertDescription") == 0){
			if(pDesc->children){
				if(pDesc->children->content){
					memset(desc, 0, sizeof(desc));
					strncpy(desc, pDesc->children->content, sizeof(desc) - 1);
				}
			}
		}

		if(pDesc->type == XML_ELEMENT_NODE
		&& strcmp(pDesc->name, "PrtAlertCode") == 0){
			if(pDesc->children){
				if(pDesc->children->content){
					memset(wnd->pAlertCode, 0, sizeof(wnd->pAlertCode));
					strncpy(wnd->pAlertCode, pDesc->children->content, sizeof(wnd->pAlertCode) - 1);
				}
			}
		}
	}
	if(pDoc != NULL)
		xmlFreeDoc(pDoc);


	conv_iconv(wnd, desc);

	return 0;
}

static void conv_iconv(UIStatusWnd *wnd, char *code)
{
	iconv_t cd;
	size_t ret, outbyteleft = 0, inputbyteleft = 0;
	char *outbuf,  *optr, *value;
	char* ptr[7];
	int outbufsize = 0, code_size = 0, i = 0 ;
UI_DEBUG("conv_iconv\n");

	if( wnd ){
		wnd->enableJobOperate = FALSE;
	}
	if(code == NULL){
UI_DEBUG("iconv error code NULL\n");
		wnd->text1 = SetErrorString(ID_STR_UNKNOWN_ERROR);
		wnd->text2 = NULL;
		return;
	}else if(strlen(code) == 0){
UI_DEBUG("iconv error code size 0\n");
		wnd->text1 = SetErrorString(ID_STR_UNKNOWN_ERROR);
		wnd->text2 = NULL;
		return;
	}


	if(wnd->tocode != NULL && wnd->fromcode != NULL){
UI_DEBUG("<%s> <%s>\n", wnd->tocode, wnd->fromcode);
		if((cd = iconv_open(wnd->tocode, wnd->fromcode)) < 0){
			wnd->text1 = SetErrorString(ID_STR_UNKNOWN_ERROR);
			wnd->text2 = NULL;
			UI_DEBUG("iconv_open error\n");
			return;
		}
		code_size = strlen(code);
UI_DEBUG("%d [%d]\n",(int) cd, code_size);

		inputbyteleft = (size_t)code_size;
		outbyteleft = (size_t)code_size * 3;
		outbuf = (char *)malloc(outbyteleft + 1);
		optr = outbuf;

		ret = iconv(cd, &code, &inputbyteleft, &optr, &outbyteleft);

		if(ret == -1 || ret == E2BIG){
UI_DEBUG("iconv error %d\n", ret);
			wnd->text1 = SetErrorString(ID_STR_UNKNOWN_ERROR);
			wnd->text2 = NULL;
			mem_free(outbuf);
			iconv_close(cd);
			return;
		}
		*optr = '\0';
		outbufsize = (code_size * 3) - outbyteleft;
UI_DEBUG("size[%d]\n", outbufsize);
UI_DEBUG("<%s>\n", outbuf);
UI_DEBUG("iconv .\n");

		for (i = 0, optr = outbuf; (value = strtok(optr, "\t")) != NULL; i++) {
			optr = NULL;
			ptr[i] = value;
		}

		wnd->text1 = NULL;
		if (i > 0) {
			wnd->text1 = (char *)malloc(outbufsize + 1);
			strncpy(wnd->text1, ptr[0], outbufsize);
			wnd->text1[outbufsize] = '\0';
		}

		wnd->text2 = NULL;
		if (i > 1) {
			wnd->text2 = (char *)malloc(outbufsize + 1);
			strncpy(wnd->text2, ptr[1], outbufsize);
			wnd->text2[outbufsize] = '\0';
		}


		if (i > 5) {
			if (!strcmp(ptr[5], "Enable")) {
				wnd->enableJobOperate = TRUE;
			}
			else {
				wnd->enableJobOperate = FALSE;
			}
		}

UI_DEBUG("iconv .\n");
		mem_free(outbuf);
		iconv_close(cd);
	}
UI_DEBUG("conv_iconv\n");
}




static void ShowStatusWndDlgs(UIStatusWnd *wnd, int dlgnum)
{
	switch(dlgnum){
	case REQ_SHOWDLG_REGIPAPER:
		ShowRegiPaperDlg(wnd);
		break;
	case REQ_SHOWDLG_SLEEPS:
		ShowSleepSettingDlg(wnd);
		break;
	case REQ_SHOWDLG_CCINFO:
		ShowCCInfoDlg(wnd);
		break;
	case REQ_SHOWDLG_CANCELJOB:
		ShowCancelJobKeyDlg(wnd);
		break;
	case REQ_SHOWDLG_NETWORKS:
		ShowNetWorkSDlg(wnd);
		break;
	case REQ_SHOWDLG_CASSETTESET2:
		ShowCassetteSet2Dlg(wnd);
		break;
	case REQ_SHOWDLG_MULTITRAY:
		ShowMultiTrayDlg(wnd);
		break;
	case REQ_SHOWDLG_PPAVH:
		ShowPPAVHDlg(wnd);
		break;
	case REQ_SHOWDLG_RESETUNIT:
		ShowResetUnitDlg(wnd);
		break;
	case REQ_SHOWDLG_PPAP:
		ShowPPAPDlg(wnd);
		break;
	}
	SetWidgetSensitive(UI_DIALOG(wnd)->window, "menubar1", TRUE);
	SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", TRUE);
	wnd->bMenuDisable = 0;
	g_polling_status = POLLING_NOREQ;
	g_job_num = 0;
}

int SendRequest(UIStatusWnd *wnd, int command)
{
	if(cnsktWrite(wnd->pCnskt, command) < 0)
		return -1;

	if(cnsktRead(wnd->pCnskt) < 0)
		return -1;

	if(wnd->pCnskt->response_code != CCPD_RES_OK)
		return -2;

	return 0;
}


static int XmlToText2(UIStatusWnd *wnd, char *code)
{
	int ret = 0;

	wnd->isJobDisable = FALSE;

	ret = XmlToText(wnd, code);
	if(wnd->text2){
		char *ptr = NULL;
		char *tmp = wnd->text2;
		int i;
		for(i = 0; ((ptr = strchr(tmp, '\t')) != NULL); i++){
			ptr++;
			if(i == 0){
				int size = ptr - wnd->text2 - 1;
				wnd->text2[size] = '\0';
			}else if(i == 3){
				if(strcmp(ptr, "Disable") == 0){
					wnd->isJobDisable = TRUE;
				}else{
					wnd->isJobDisable = FALSE;
				}
			}
			tmp = ptr;
UI_DEBUG("Info [%d][%s]\n", i, ptr);
		}
	}
	return ret;
}

static void WriteDeviceRequest(UIStatusWnd *wnd, int reqtype)
{
	switch(reqtype){
	case REQ_SHOWDLG_REGIPAPER:
		ShowRegiPaperDlg(wnd);
		break;
	case REQ_SHOWDLG_SLEEPS:
		ShowSleepSettingDlg(wnd);
		break;
	case REQ_SHOWDLG_CCINFO:
		ShowCCInfoDlg(wnd);
		break;
	case REQ_SHOWDLG_CANCELJOB:
		ShowCancelJobKeyDlg(wnd);
		break;
	case REQ_SHOWDLG_NETWORKS:
		ShowNetWorkSDlg(wnd);
		break;
	case REQ_SHOWDLG_ASSTPRT:
		ShowAsstPrtSDlg(wnd);
		break;
	case REQ_SHOWDLG_STARTUPSET:
		ShowStartupSettingsDlg(wnd);
		break;
	case REQ_SHOWDLG_PPAP:
		ShowPPAPDlg(wnd);
		break;
	case REQ_SHOWDLG_CASSETTESET2:
		ShowCassetteSet2Dlg(wnd);
		break;
	case REQ_SHOWDLG_MULTITRAY:
		ShowMultiTrayDlg(wnd);
		break;
	case REQ_SHOWDLG_PPAVH:
		ShowPPAVHDlg(wnd);
		break;
	case REQ_SHOWDLG_RESETUNIT:
		ShowResetUnitDlg(wnd);
		break;
	case REQ_SHOWDLG_CLEANING:
		ShowCleaningDlg(wnd);
		break;
	case REQ_SHOWDLG_CALIBRATIONSETTINGS:
		ShowCalibrationSettingsDlg(wnd);
		break;
	case REQ_SHOWDLG_CONSUMABLESINFO:
		ShowConsumablesInfoDlg(wnd);
		break;
	case REQ_SHOWDLG_COUNTERSINFO:
		ShowCountersInfoDlg(wnd);
		break;
	case REQ_UPDATE_CONSUMABLESINFO_OF_TONERREPLACEMENT:
		UpdateConsumableInfo(wnd);
		break;
	default:
		break;
	}
	SetWidgetSensitive(UI_DIALOG(wnd)->window, "menubar1", TRUE);
	SetWidgetSensitive(UI_DIALOG(g_status_window)->window, "CAPTStatusUIHide_button", TRUE);
	wnd->bMenuDisable = 0;
	g_polling_status = POLLING_NOREQ;
	g_job_num = 0;
}

static int SetDeviceRequest(UIStatusWnd *wnd, int reqtype)
{
	long jobid = 0;
	int ret = -1;

	cnsktResetReqData(wnd->pCnskt);

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG * 2) < 0)
		return -1;

	switch(reqtype){
	case OPEREQ_PAUSE:
		if(cnsktSetReqLong(wnd->pCnskt, DREQ_PAUSE) < 0)
			return -1;
		ret = CCPD_DEVICE_REQUEST;
		break;
	case OPEREQ_RESUME:
		if(cnsktSetReqLong(wnd->pCnskt, DREQ_RESUME) < 0)
			return -1;
		ret = CCPD_DEVICE_REQUEST;
		break;
	case OPEREQ_CANCEL:
		if(cnsktSetReqLong(wnd->pCnskt, DREQ_CANCEL) < 0)
			return -1;
		ret = CCPD_DEVICE_REQUEST;
		break;
	default:
		break;
	}
	if(cnsktSetReqLong(wnd->pCnskt, jobid) < 0)
		return -1;

	return ret;
}

static int CnsktWrite(UIStatusWnd *wnd)
{
	int req = 0;
UI_DEBUG("CnsktWrite g_job_num = [0x%x]\n", g_job_num);
	if(g_job_num > REQ_SHOWDLG){
		g_polling_status = POLLING_DONOT;
		WriteDeviceRequest(wnd, g_job_num);
		return 0;
	}

	if(g_job_num > OPEREQ_COMMAND){
		if((req = SetDeviceRequest(wnd, g_job_num)) < 0)
			return -1;
		g_job_num = req;
	}

	if(cnsktWrite(wnd->pCnskt, g_job_num) < 0){
		wnd->retry++;
	}else{
		g_polling_status = POLLING_READ;
		wnd->retry = 0;
	}
	g_job_num = 0;

	return 0;
}

static int CnsktRead(UIStatusWnd *wnd)
{
	int ret = 0;
	short res_code = 0;
	int req_cmd = 0;

	ret = cnsktRead(wnd->pCnskt);

	if(ret < 0){
		wnd->retry++;
		if(wnd->exit){
			ExitDataProcess();
			return FALSE;
		}
		return TRUE;
	}else if(ret == 0){
		res_code = cnsktGetResCode(wnd->pCnskt);
		req_cmd = cnsktGetReqCommand(wnd->pCnskt);
		wnd->retry = 0;
		switch(res_code){
		case CCPD_RES_NOPRINTER:
			wnd->text1 = SetErrorString(ID_STR_NOPRINTER);
			wnd->text2 = SetErrorString(ID_STR_PRINTER_ENTRY);
			break;
		case CCPD_RES_PRINTER_ERR:
			wnd->text1 = SetErrorString(ID_STR_PRINTER_ERROR);
			wnd->text2 = SetErrorString(ID_STR_DEVICE_PATH);
			break;
		case CCPD_RES_FIFO_ERROR:
			wnd->text1 = SetErrorString(ID_STR_FIFO_ERROR);
			wnd->text2 = SetErrorString(ID_STR_DEVICE_URI);
			break;
		default:
			wnd->text1 = SetErrorString(ID_STR_UNKNOWN_ERROR);
			wnd->text2 = NULL;
			break;
		}

		if(wnd->exit){
			ExitDataProcess();
			return FALSE;
		}

		switch(req_cmd){
		case CCPD_REQ_STATUS:
			if(g_job_num == 0){
				SigDisable();
				UpdateWidgets2(wnd);
				SigEnable();
			}
			break;
		case CCPD_DEVICE_REQUEST:
			break;
		default:
			break;
		}
	}else{
		if(wnd->exit){
			ExitDataProcess();
			return FALSE;
		}
		res_code = cnsktGetResCode(wnd->pCnskt);
		req_cmd = cnsktGetReqCommand(wnd->pCnskt);

		if(req_cmd == CCPD_REQ_STATUS && g_job_num == 0){
			char *data = NULL;
			data = cnsktGetStatusData(wnd->pCnskt);
			XmlToText2(wnd, data);
			SigDisable();
			UpdateWidgets2(wnd);
			SigEnable();
		}
	}
	g_polling_status = POLLING_NOREQ;
	return TRUE;
}

int DataProcess2(gpointer user_data)
{
	UIStatusWnd *wnd;
	int max_fd;
	int result;
	int skt_fd;
	struct timeval timeout;
	wnd = g_status_window;
	skt_fd = cnsktGetSocketFD(g_status_window->pCnskt);
	max_fd = skt_fd + 1;
	timeout.tv_sec = 0;
	timeout.tv_usec = 0;

	if(wnd->retry == RETRY_COUNT){
		ExitDataProcess();
		return FALSE;
	}

	if(g_polling_status == POLLING_WRITE){
		fd_set writefd;

		if(wnd->exit){
			ExitDataProcess();
			return FALSE;
		}

		FD_ZERO(&writefd);
		FD_SET(skt_fd, &writefd);
		result = select(max_fd, NULL, &writefd, NULL, &timeout);

		if(result < 0){
			return TRUE;
		}else if(result == 0){
			return TRUE;
		}

		if(FD_ISSET(skt_fd, &writefd)){
			CnsktWrite(wnd);
		}
	}else if(g_polling_status == POLLING_READ){
		fd_set readfd;
		if(wnd->exit > 0){
			if(wnd->exit > RETRY_COUNT){
				ExitDataProcess();
				return FALSE;
			}
			wnd->exit++;
		}

		FD_ZERO(&readfd);
		FD_SET(skt_fd, &readfd);
		result = select(max_fd, &readfd, NULL, NULL, &timeout);

		if(result < 0){
			return TRUE;
		}else if(result == 0){
			return TRUE;
		}

		if(FD_ISSET(skt_fd, &readfd)){
			CnsktRead(wnd);
			return TRUE;
		}
	}
	return TRUE;
}






