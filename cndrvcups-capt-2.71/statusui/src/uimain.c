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
#include "data_process.h"
#include <cups/cups.h>
#define	MAX_WORD_SIZE	512

#define LOCALE_STRING_JA	"ja_JP.UTF-8"
#define LOCALE_STRING_EN	"en_GB.UTF-8"
#ifdef OLD_GTK
#define	ICONV_TOCODE_JA		"EUC-JP"
#else
#define	ICONV_TOCODE_JA		"UTF-8"
#endif
#define	ICONV_TOCODE_EN		"ISO-8859-1"
#define	ICONV_FROMCODE		"UTF-8"
#define	CCPD_CONF_PATH		"/etc/ccpd.conf"
#define	MAX_BUF_SIZE	255
#define	CCPD_SKT_PORT	59787

static int GetPPDData(UIStatusWnd *wnd, char *printer_name);
static char* SetLocaleString(UIStatusWnd *wnd);
static char** SetComboListString(char *pstr);
static void GetDeviceLang(UIStatusWnd* const wnd);

UIStatusWnd *CreateStatusWnd(char *printer_name, int mode)
{
	UIStatusWnd *wnd = NULL;
	char *locale = NULL;

	wnd = (UIStatusWnd *)CreateDialog(sizeof(UIStatusWnd), NULL);

	memset(wnd, 0, sizeof(UIStatusWnd));
	UI_DIALOG(wnd)->window = create_CaptStatusMonitorWnd();

	if(GetPPDData(wnd, printer_name) < 0){
		fprintf(stderr, "*** captstatusui Error: No Specified Printer ***\n");
		return NULL;
	}

	locale = SetLocaleString(wnd);

	wnd->pCnskt = cnsktNew(printer_name, locale, NULL, CCPD_SKT_PORT);

	if(wnd->pCnskt == NULL){
		fprintf(stderr, "*** captstatusui Socket Error ***\n");
		return NULL;
	}
UI_DEBUG("CreateStatusWnd:nModel [%d]\n",wnd->nModel);

	GetDeviceLang(wnd);

	switch(wnd->nModel){
	case MODEL_LBP5300:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP5300(wnd);
		break;
	case MODEL_LBP3500:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP3500(wnd);
		break;
	case MODEL_LBP5100:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP5100(wnd);
		break;
	case MODEL_LBP5050:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP5050(wnd);
		break;
	case MODEL_LBP7200:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP7200(wnd);
		break;
	case MODEL_LBP3310:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP3310(wnd);
		break;
	case MODEL_LBP3250:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP3250(wnd);
		break;
	case MODEL_LBP3100:
	case MODEL_LBP3050:
	        wnd->nIFVersion = CCPD_IF_VERSION_110;
	        CreateStatusWidgets_LBP3100(wnd);
	        break;
	case MODEL_LBP9100:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP9100(wnd);
		break;

	case MODEL_LBP6300:
	case MODEL_LBP6300N:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP6300(wnd);
		break;

	case MODEL_LBP6000:
	        wnd->nIFVersion = CCPD_IF_VERSION_110;
	        CreateStatusWidgets_LBP6000(wnd);
	        break;

	case MODEL_LBP6200:
	        wnd->nIFVersion = CCPD_IF_VERSION_110;
	        CreateStatusWidgets_LBP6200(wnd);
	        break;
	case MODEL_LBP7010:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP7010(wnd);
		break;
	case MODEL_LBP9200:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP9200(wnd);
		break;
	case MODEL_LBP6020:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP6020(wnd);
		break;
	case MODEL_LBP6310:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP6310(wnd);
		break;
	case MODEL_LBP6340:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP6340(wnd);
		break;
	case MODEL_LBP7210:
		wnd->nIFVersion = CCPD_IF_VERSION_110;
		CreateStatusWidgets_LBP7210(wnd);
		break;

	default:
		wnd->nIFVersion = CCPD_IF_VERSION_100;
		CreateStatusWidgets(wnd);
		break;
	}

	wnd->exit = 0;
	wnd->mode = mode;
	wnd->time = 0;
	wnd->text1 = NULL;
	wnd->text2 = NULL;
	wnd->ppap = 0;
	wnd->dev = 0;
	wnd->cas_num = 0;
	wnd->dplx = 0;
	SetDialogTitle(UI_DIALOG(wnd)->window, printer_name);
	return wnd;
}

void DisposeStatusWnd(void)
{
	mem_free(g_status_window->tocode);
	mem_free(g_status_window->fromcode);
	mem_free(g_status_window->tmp_text2);
	if(g_status_window->pSleepTimeList){
		int i = 0;
		for(i = 0; g_status_window->pSleepTimeList[i] != NULL; i++){
			mem_free(g_status_window->pSleepTimeList[i]);
		}
		mem_free(g_status_window->pSleepTimeList);
	}
	if(g_status_window->pRegiPaperList){
		int i = 0;
		for(i = 0; g_status_window->pRegiPaperList[i] != NULL; i++){
			mem_free(g_status_window->pRegiPaperList[i]);
		}
		mem_free(g_status_window->pRegiPaperList);
	}
	if(g_status_window->ppap_dlg)
		DisposeDialog((UIDialog *)g_status_window->ppap_dlg);
	if(g_status_window->dev_dlg)
		DisposeDialog((UIDialog *)g_status_window->dev_dlg);
	if(g_status_window->ccinfo_dlg)
		DisposeDialog((UIDialog *)g_status_window->ccinfo_dlg);
	if(g_status_window->regipaper_dlg)
		DisposeDialog((UIDialog *)g_status_window->regipaper_dlg);
	if(g_status_window->sleeps_dlg)
		DisposeDialog((UIDialog *)g_status_window->sleeps_dlg);
	if(g_status_window->cancelkey_dlg)
		DisposeDialog((UIDialog *)g_status_window->cancelkey_dlg);
	if(g_status_window->networks_dlg)
		DisposeDialog((UIDialog *)g_status_window->networks_dlg);
	if(g_status_window->asstprts_dlg)
		DisposeDialog((UIDialog *)g_status_window->asstprts_dlg);
	if(g_status_window->cassetteset2_dlg)
		DisposeDialog((UIDialog *)g_status_window->cassetteset2_dlg);
	if(g_status_window->ppavh_dlg)
		DisposeDialog((UIDialog *)g_status_window->ppavh_dlg);
	if(g_status_window->resetunit_dlg)
		DisposeDialog((UIDialog *)g_status_window->resetunit_dlg);
	if(g_status_window->toner_replacement_dlg != NULL){
		DisposeDialog((UIDialog *)g_status_window->toner_replacement_dlg);
	}
	if(g_status_window->cleaning_dlg != NULL){
		DisposeDialog((UIDialog *)g_status_window->cleaning_dlg);
	}
	if(g_status_window->calibration_Settings_dlg != NULL){
		DisposeDialog((UIDialog *)g_status_window->calibration_Settings_dlg);
	}
	cnsktDestroy(g_status_window->pCnskt);
}

static char* SetLocaleString(UIStatusWnd *wnd)
{
	char *lang = NULL;
	char *locale_string = NULL;

	if((lang = getenv("LC_CTYPE")) == NULL)
		lang = getenv("LANG");
UI_DEBUG("locale %s\n", lang);

	if(lang == NULL){
		locale_string = strdup(LOCALE_STRING_EN);
		wnd->tocode = strdup(ICONV_FROMCODE);
	}else{
		if(strncmp("ja", lang, 2) == 0){
			locale_string = strdup(LOCALE_STRING_JA);
			if(strstr(lang, "UTF-8") != NULL)
				wnd->tocode = strdup(ICONV_FROMCODE);
			else
				wnd->tocode = strdup(ICONV_TOCODE_JA);
		}else{
			locale_string = strdup(LOCALE_STRING_EN);
			wnd->tocode = strdup(ICONV_FROMCODE);
		}
	}
	wnd->fromcode = strdup(ICONV_FROMCODE);
UI_DEBUG("locale <%s> <%s>\n", wnd->tocode, wnd->fromcode);
	return locale_string;
}


#if 0
int GetValue(char *buff, char *value_name)
{
	char *ptr;

	ptr = buff;

	ptr += strlen(value_name);

	while(1){
		if(*ptr == '\0' || *ptr == '\n')
			break;
		else if(*ptr == '\t' || *ptr == ' ')
			ptr++;
		if(isdigit(*ptr))
			return atoi(ptr);
	}
	return -1;
}

#define	MAX_BUF_SIZE	255

int GetPortNum(void)
{
	FILE *fp;
	char buff[MAX_BUF_SIZE];
	int ports = CCPD_PORT_ID_CUPSMON;
	int ports_line = 0;

	if((fp = fopen(CCPD_CONF_PATH, "r")) == NULL){
		return ports;
	}

	while((fgets(buff, MAX_BUF_SIZE, fp)) != NULL){
		if(strncmp(buff, "<Ports>", strlen("<Ports>")) == 0){
			ports_line = 1;
		}else if(strncmp(buff, "</Ports>", strlen("</Ports>")) == 0){
			ports_line = 0;
		}else if(ports_line){
			int value;
			if((value = GetValue(buff, "UI_Port")) > 0)
				ports = value;
		}
	}
	fclose(fp);
	return ports;
}
#endif


void mem_free(void *pointer)
{
	if(pointer){
		free(pointer);
		pointer = NULL;
	}
}

static int GetDrvLang(UIStatusWnd *wnd, char *buff)
{
	if(strncmp(buff, "*ModelName",10) == 0){
		if(strstr(buff, "Japanese") != NULL)
			wnd->nLangType = LANG_TYPE_JP;
		else if(strstr(buff, "JP") != NULL)
			wnd->nLangType = LANG_TYPE_JP;
		else if(strstr(buff, "English") != NULL)
			wnd->nLangType = LANG_TYPE_UK;
		else if(strstr(buff, "UK") != NULL)
			wnd->nLangType = LANG_TYPE_UK;
		else if(strstr(buff, LANG_TYPE_US_STR) != NULL){
			wnd->nLangType = LANG_TYPE_US;
		}
		else
			wnd->nLangType = LANG_TYPE_JP;
		return 1;
	}

	return 0;
}

static void GetDeviceLang(UIStatusWnd* const wnd)
{
	DREQPrinterInfo info;
	int res = 0;

	if(wnd != NULL){
		switch(wnd->nModel){
		case MODEL_LBP6000:
		case MODEL_LBP6300:
		case MODEL_LBP7200:
			res = GetDREQPrinterInfo( wnd, &info );
			if( res == 0 ){
				switch(info.Region){
				case DREQ_REGION_USA:
					wnd->nLangType = LANG_TYPE_US;
					break;
				case DREQ_REGION_SOUTH_AMERICA:
					wnd->nLangType = LANG_TYPE_UK;
					break;
				case DREQ_REGION_JAPAN:
					wnd->nLangType = LANG_TYPE_JP;
					break;
				default:
					break;
				}
			}
			break;
		default:
			break;
		}
	}
}

static void GetStatusuiValue(UIStatusWnd *wnd, char *buff)
{
	int i = 0;
	int num = -1;
	char *ptr = NULL;
	char value[256], *pvalue = NULL;
	static char *table[] = {
		"*statusuiCleaning:",
		"*statusuiPPAPDlg:",
		"*statusuiDevDlg:",
		"*CNStatusuiCleaning:",
		"*CNStatusuiPPAPDlg:",
		"*CNStatusuiDevDlg:",
		"*CNStatusuiConsumableCounters:",
		"*CNStatusuiCalibration:",
		"*CNStatusuiRegiPaperSize:",
		"*CNStatusuiSleepSetting:",
		"*CNStatusuiCancelJobKey:",
		"*CNStatusuiNetworkSettings:",
		"*CNTblModel:",
		NULL,
	};
	memset(value, 0, 256);

	if(GetDrvLang(wnd, buff))
		return;

	while(table[i] != NULL){
		if(strncmp(table[i], buff, strlen(table[i])) == 0){
			if((ptr = strchr(buff, '"')) != NULL){
				pvalue = value;
				ptr++;
				while(1){
					if(*ptr == '\n' || *ptr == '\0')
						break;
					if(*ptr == '"'){
						*pvalue = '\0';
						num = atoi(value);
						break;
					}
					if(*ptr == ':'){
						*pvalue = '\0';
						num = atoi(value);
						ptr++;
						break;
					}
					if(pvalue - value == 255)
						break;
					*pvalue = *ptr;
					pvalue++;
					ptr++;
				}
			}
			break;

		}
		i++;
	}

	if(num == -1)
		return;

	switch(i){
	case 0:
		wnd->cleaning = num;
		break;
	case 1:
		wnd->ppap = num;
		break;
	case 2:
		wnd->dev = num;
		break;
	case 3:
		wnd->cleaning = num;
		break;
	case 4:
		wnd->ppap = num;
		break;
	case 5:
		wnd->dev = num;
		break;
	case 6:
		wnd->nConsumableCounters = num;
		break;
	case 7:
		wnd->nCalibration = num;
		break;
	case 8:
		wnd->nRegiPapersize = num;
		wnd->pRegiPaperList = SetComboListString(ptr);
		break;
	case 9:
		wnd->nSleepSetting = num;
		wnd->pSleepTimeList = SetComboListString(ptr);
		break;
	case 10:
		wnd->nCancelJobKey = num;
		break;
	case 11:
		wnd->nNetworkSettings = num;
		break;
	case 12:
		if(num == MODEL_LBP6310){
			if(wnd->nLangType == LANG_TYPE_JP){
				wnd->nModel = MODEL_LBP6340;
			}else{
				wnd->nModel = MODEL_LBP6310;
			}
		}else{
			wnd->nModel = num;
		}
		break;
	default:
		break;
	}
}

static int GetPPDData(UIStatusWnd *wnd, char *printer_name)
{
	FILE *fp;
	char *ppd_filename;
	char buff[MAX_WORD_SIZE];

	if(printer_name == NULL)
		return -1;

	ppd_filename = (char *)cupsGetPPD(printer_name);
	if(ppd_filename == NULL)
		return -1;

	if((fp = fopen(ppd_filename, "r")) == NULL)
		return -1;

	while((fgets(buff, MAX_WORD_SIZE, fp)) != NULL){
		GetStatusuiValue(wnd, buff);
	}

	fclose(fp);
	unlink(ppd_filename);
	return 0;
}

static char** SetComboListString(char *pstr)
{
	char **plist;
	char *ptmp = pstr;
	char avalue[256];
	char *pvalue;
	int cnt = 1, i = 0;
	while(1){
		if(*ptmp == '\n' || *ptmp == '\0' || *ptmp == '"')
			break;
		if(*ptmp == ',')
			cnt++;
		ptmp++;
	}
	plist = (char **)malloc(sizeof(char **) * (cnt + 1));
	if(plist == NULL)
		return NULL;
	ptmp = pstr;
	pvalue = avalue;
	while(1){
		if(*ptmp == '\n' || *ptmp == '\0'){
			break;
		}
		if(*ptmp == '"'){
			*pvalue = '\0';
			plist[i] = strdup(avalue);
			i++;
			break;
		}
		if(*ptmp == ','){
			*pvalue = '\0';
			plist[i] = strdup(avalue);
			i++;
			pvalue = avalue;
			ptmp++;
		}
		*pvalue = *ptmp;
		ptmp++;
		pvalue++;
	}
	plist[i] = NULL;

	return plist;
}

int GetDREQPrtInfo(UIStatusWnd *wnd, DREQPrtInfo *info)
{
	long value = 0;
	short status_code = 0;

	if(wnd->pCnskt == NULL)
		return -1;

	status_code = wnd->pCnskt->status_code;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG))
		return -1;
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_DEVICEINFO))
		return -1;

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		return -1;

	wnd->pCnskt->status_code = status_code;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
		return -1;
	info->nNameSize = value;

	info->pName = (char *)malloc(value + 1);
	if(info->pName == NULL)
		return -1;
	memset(info->pName, 0, value + 1);
	if(cnsktGetResData(wnd->pCnskt, info->pName,
					READ_TYPE_ARRAY, value) < 0)
		goto err;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
		goto err;
	info->nNumCas = value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
		goto err;
	info->nUnit = value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
		goto err;
	info->nFirm = value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
		goto err;
	info->nNic = value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
		goto err;
	info->nPort = value;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
		goto err;
	info->nDFlag = value;

	return 0;

err:
	free(info->pName);
	return -1;
}

int GetDREQPrinterInfo(UIStatusWnd* const wnd, DREQPrinterInfo* const info)
{
	unsigned long value = 0;
	short status_code = 0;

	if((wnd == NULL) || (info == NULL)){
		return -1;
	}

	info->Region = DREQ_REGION_OTHER;

	if(wnd->pCnskt == NULL){
		return -1;
	}

	status_code = wnd->pCnskt->status_code;
	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0){
		return -1;
	}
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_PRINTERINFO) < 0){
		return -1;
	}
	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0){
		return -1;
	}
	wnd->pCnskt->status_code = status_code;

	value = 0;
	if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0){
		return -1;
	}
	info->Region = (value & DREQ_REGION_MASK);

	return 0;
}

gboolean IsUS(const UIStatusWnd* const wnd)
{
	gboolean isUS = FALSE;

	if(wnd != NULL){
		if( wnd->nLangType == LANG_TYPE_US ){
			isUS = TRUE;
		}
	}
	return isUS;
}

