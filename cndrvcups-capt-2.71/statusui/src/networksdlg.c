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

#include "uimain.h"
#include "support.h"
#include "widgets.h"
#include "interface.h"
#include "networksdlg.h"
#include "data_process.h"
#include "callbacks.h"

static int GetNICParamData(UIStatusWnd *wnd, char *param);
static void InitNetWorkSDlgWidgets(UIStatusWnd *wnd, char *param);

static int GetNICParamData2(UIStatusWnd *wnd, char *param);

static char *IPSettingStr[] = {
	N_("Auto Detect"),
	N_("Manual Settings"),
	NULL,
};

static char *pIPStr = " IP Address : %d.%d.%d.%d \n";
static char *pSubStr = " Subnet Mask : %d.%d.%d.%d \n";
static char *pGateStr = " Gateway Address : %d.%d.%d.%d \n";
static char *pDHCP = " DHCP : %s \n";
static char *pRARP = " RARP : %s \n";
static char *pBOOTP = " BOOTP : %s \n";
static char *pPWDStr = " ROOT_PWD. :%s \n";
static char *pPWDStrNULL = " ROOT_PWD. : \n";

typedef struct {
	int bSetting;
	char *pIP[4];
	char *pSub[4];
	char *pGate[4];
	int bRARP;
	int bDHCP;
	int bBOOTP;
}NetWorks;

UINetWorkSDlg* CreateNetworkSDlg(UIDialog *parent)
{
	UINetWorkSDlg *dialog;

	dialog = (UINetWorkSDlg *)CreateDialog(sizeof(UINetWorkSDlg), parent);

	UI_DIALOG(dialog)->window = create_NetworkSDlg_dialog();

	ComboSignalConnect(UI_DIALOG(dialog)->window, "NetworkSDlg_IPSetting_combo", GTK_SIGNAL_FUNC(on_NetworkSDlg_IPSetting_combo_popwin_event));

	return dialog;
}

void ShowNetWorkSDlg(UIStatusWnd *wnd)
{
	char param[1024];
	memset(param, 0, 1024);

	switch(wnd->nIFVersion){
	case CCPD_IF_VERSION_110:
		GetNICParamData2(wnd, param);
		break;
	case CCPD_IF_VERSION_100:
	default:
		GetNICParamData(wnd, param);
		break;
	}

	SigDisable();
	InitNetWorkSDlgWidgets(wnd, param);
	SigEnable();

	ShowDialog((UIDialog *)wnd->networks_dlg, NULL);
}

void HideNetWorkSDlg(UIStatusWnd *wnd)
{
	HideDialog((UIDialog *)wnd->networks_dlg);
}


static int GetNetTextToInt(GtkWidget *window, gchar *name)
{
	char *pValue;
	int nValue, len, i;
	if((pValue = GetTextEntry(window, name)) == NULL)
		return -1;
	if((len = strlen(pValue)) == 0)
		return -1;
	for(i = 0; i < len; i++){
		if(!(isdigit(pValue[i])))
			return -1;
	}
	nValue = atoi(pValue);
	if(nValue < 0 || nValue > 255)
		return -1;
	return nValue;
}

static int CheckIPAddress(GtkWidget *window, int *aIP)
{
	int nIP1, nIP2, nIP3, nIP4;
	if((nIP1 = GetNetTextToInt(window, "NetworkSDlg_IP1_entry")) < 0)
		return -1;
	if(nIP1 == 0 || nIP1 == 127 || (nIP1 >= 224 && nIP1 <= 255))
		return -1;

	if((nIP2 = GetNetTextToInt(window, "NetworkSDlg_IP2_entry")) < 0)
		return -1;

	if((nIP3 = GetNetTextToInt(window, "NetworkSDlg_IP3_entry")) < 0)
		return -1;

	if((nIP4 = GetNetTextToInt(window, "NetworkSDlg_IP4_entry")) < 0)
		return -1;
	if(nIP4 == 0)
		return -1;

	if(nIP4 == 255){
		if(nIP1 >= 192 && nIP1 <= 223)
			return -1;
		if(nIP3 == 255){
			if(nIP1 >= 128 && nIP1 <= 191)
				return -1;
			if(nIP2 == 255){
				if(nIP1 >= 1 && nIP1 <= 126)
					return -1;
			}
		}
	}

	aIP[0] = nIP1;
	aIP[1] = nIP2;
	aIP[2] = nIP3;
	aIP[3] = nIP4;

	return 0;
}

static int CheckSubnet(GtkWidget *window, int *aSub)
{
	int nSub1, nSub2, nSub3, nSub4;

	if((nSub1 = GetNetTextToInt(window, "NetworkSDlg_Sub1_entry")) < 0)
		return -1;

	if((nSub2 = GetNetTextToInt(window, "NetworkSDlg_Sub2_entry")) < 0)
		return -1;

	if((nSub3 = GetNetTextToInt(window, "NetworkSDlg_Sub3_entry")) < 0)
		return -1;

	if((nSub4 = GetNetTextToInt(window, "NetworkSDlg_Sub4_entry")) < 0)
		return -1;

	if(nSub1 == 255 && nSub2 == 255 && nSub3 == 255 && nSub4 == 255)
		return -1;

	aSub[0] = nSub1;
	aSub[1] = nSub2;
	aSub[2] = nSub3;
	aSub[3] = nSub4;

	return 0;
}

static int CheckGateway(GtkWidget *window, int *aGate)
{
	int nGate1, nGate2, nGate3, nGate4;

	if((nGate1 = GetNetTextToInt(window, "NetworkSDlg_Gate1_entry")) < 0)
		return -1;
	if(nGate1 == 127 || (nGate1 >= 224 && nGate1 <= 255))
		return -1;

	if((nGate2 = GetNetTextToInt(window, "NetworkSDlg_Gate2_entry")) < 0)
		return -1;

	if((nGate3 = GetNetTextToInt(window, "NetworkSDlg_Gate3_entry")) < 0)
		return -1;

	if((nGate4 = GetNetTextToInt(window, "NetworkSDlg_Gate4_entry")) < 0)
		return -1;

	if(nGate1 == 0){
	        if(nGate2 != 0 || nGate3 != 0 || nGate4 != 0)
		        return -1;
	}

	if(nGate4 == 0){
		if(nGate1 != 0 || nGate2 != 0 || nGate3 != 0)
			return -1;
	}

	if(nGate4 == 255){
		if(nGate1 >= 192 && nGate1 <= 223)
			return -1;
		if(nGate3 == 255){
			if(nGate1 >= 128 && nGate1 <= 191)
				return -1;
			if(nGate2 == 255){
				if(nGate1 >= 1 && nGate1 <= 126)
					return -1;
			}
		}
	}

	aGate[0] = nGate1;
	aGate[1] = nGate2;
	aGate[2] = nGate3;
	aGate[3] = nGate4;

	return 0;
}

static int CheckPassword(GtkWidget *window, char *pass)
{
	char *tmp = NULL;
	int len = 0, i;
	if(pass == NULL)
		return 0;

	len = strlen(pass);
	tmp = pass;

	for(i = 0; i < len; i++){
		if(*tmp >= 0x20 && *tmp <= 0x7E)
			tmp++;
		else
			return -1;
	}
	return 0;
}

static char* GetNetPWD(GtkWidget *window)
{
	char *pValue;
	if((pValue = GetTextEntry(window, "NetworkSDlg_Password_entry")) == NULL)
		return NULL;
	if(strlen(pValue) == 0)
		return NULL;

	return pValue;
}

void NetWorkSDlgOK(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->networks_dlg)->window;
	char *str;
	int aIP[4], aSub[4], aGate[4];
	char *pPWD = NULL;
	int i, ret = 0;
	char param[1024];
	char tmp[128];
	int bRARP = 0;
	int bDHCP = 0;
	int bBOOTP = 0;

	memset(param, 0, 1024);

	aIP[0] = 192;
	aIP[1] = 168;
	aIP[2] = 0;
	aIP[3] = 215;

	aSub[0] = 0;
	aSub[1] = 0;
	aSub[2] = 0;
	aSub[3] = 0;

	aGate[0] = 0;
	aGate[1] = 0;
	aGate[2] = 0;
	aGate[3] = 0;

	str = GetCurrComboText(window, "NetworkSDlg_IPSetting_combo_entry");
	if(str){
		for(i = 0; IPSettingStr[i] != NULL; i++){
			if(strcmp(str, _(IPSettingStr[i])) == 0)
					break;
		}
		if(i == NETWORKSDLG_COMBO_AUTODETECT){
			bRARP = wnd->networks_dlg->bRARP;
			bDHCP = wnd->networks_dlg->bDHCP;
			bBOOTP = wnd->networks_dlg->bBOOTP;
			if(bRARP){
				if(CheckGateway(window, aGate) < 0){
					ShowMsgDlg(wnd, MSG_TYPE_GATE_INCORRECT);
					return;
				}
				if(CheckSubnet(window, aSub) < 0){
					ShowMsgDlg(wnd, MSG_TYPE_SUB_INCORRECT);
					return;
				}
			}else if(bDHCP == 0 && bBOOTP == 0){
				if(CheckIPAddress(window, aIP) < 0){
					ShowMsgDlg(wnd, MSG_TYPE_IP_INCORRECT);
					return;
				}
				if(CheckGateway(window, aGate) < 0){
					ShowMsgDlg(wnd, MSG_TYPE_GATE_INCORRECT);
					return;
				}
				if(CheckSubnet(window, aSub) < 0){
					ShowMsgDlg(wnd, MSG_TYPE_SUB_INCORRECT);
					return;
				}
			}
		}else if(i == NETWORKSDLG_COMBO_MANUALSETTING){
			if(CheckIPAddress(window, aIP) < 0){
				ShowMsgDlg(wnd, MSG_TYPE_IP_INCORRECT);
				return;
			}
			if(CheckSubnet(window, aSub) < 0){
				ShowMsgDlg(wnd, MSG_TYPE_SUB_INCORRECT);
				return;
			}
			if(CheckGateway(window, aGate) < 0){
				ShowMsgDlg(wnd, MSG_TYPE_GATE_INCORRECT);
				return;
			}
		}
	}

	memset(tmp, 0, 128);
	snprintf(tmp, 127, pIPStr, aIP[0], aIP[1], aIP[2], aIP[3]);
	strncpy(param, tmp, 1023);

	memset(tmp, 0, 128);
	snprintf(tmp, 127, pSubStr, aSub[0], aSub[1], aSub[2], aSub[3]);
	strncat(param, tmp, 1023 - strlen(param));

	memset(tmp, 0, 128);
	snprintf(tmp, 127, pGateStr, aGate[0], aGate[1], aGate[2], aGate[3]);
	strncat(param, tmp, 1023 - strlen(param));

	memset(tmp, 0, 128);
	snprintf(tmp, 127, pDHCP, (bDHCP) ? "ON" : "OFF");
	strncat(param, tmp, 1023 - strlen(param));

	memset(tmp, 0, 128);
	snprintf(tmp, 127, pRARP, (bRARP) ? "ON" : "OFF");
	strncat(param, tmp, 1023 - strlen(param));

	memset(tmp, 0, 128);
	snprintf(tmp, 127, pBOOTP, (bBOOTP) ? "ON" : "OFF");
	strncat(param, tmp, 1023 - strlen(param));

UI_DEBUG("NIC Param Size = [%d] [%s]\n", strlen(param), param);
	pPWD = GetNetPWD(window);

	if(CheckPassword(window, pPWD) < 0){
		ShowMsgDlg(wnd, MSG_TYPE_PWD_INCORRECT);
		return;
	}

	memset(tmp, 0, 128);
	snprintf(tmp, 127, pPWDStr, pPWD);
	if(pPWD != NULL){
		strncat(param, tmp, 1023 - strlen(param));
	}else{
		strncat(param, pPWDStrNULL, 1023 - strlen(param));
	}
UI_DEBUG("NIC Param Size = [%d] [%s]\n", strlen(param), param);

	switch(wnd->nIFVersion){
	case CCPD_IF_VERSION_110:
		{
			int size = strlen(param) + DATA_LENGTH_LONG;
			if(cnsktSetReqLong(wnd->pCnskt, size) < 0)
				goto error;
			if(cnsktSetReqLong(wnd->pCnskt, DREQ_SET_NIC_PARAM) < 0)
				goto error;
			if(cnsktSetReqData(wnd->pCnskt, param, strlen(param)) < 0)
				goto error;

			ret = SendRequest(wnd, CCPD_DEVICE_REQUEST);
		}
		break;
	case CCPD_IF_VERSION_100:
	default:
		if(cnsktSetReqLong(wnd->pCnskt, strlen(param)) < 0)
			goto error;
		if(cnsktSetReqData(wnd->pCnskt, param, strlen(param)) < 0)
			goto error;

		ret = SendRequest(wnd, CCPD_REQ_SET_NIC);
	}

	if(ret == -1)
		goto error;
	else if(ret == -2)
		goto error2;
	else{
		ShowMsgDlg(wnd, MSG_TYPE_DEVICE_REBOOT);
		HideNetWorkSDlg(wnd);
	}
		return;

error:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
	return;

error2:
	ShowMsgDlg(wnd, MSG_TYPE_PWD_INCORRECT);
	return;
}


static void SetNetCheckSensitive(GtkWidget *window, int bSens)
{
	SetWidgetSensitive(window, "NetworkSDlg_RARP_checkbutton", bSens);
	SetWidgetSensitive(window, "NetworkSDlg_BOOTP_checkbutton", bSens);
	SetWidgetSensitive(window, "NetworkSDlg_DHCP_checkbutton", bSens);
}

static void SetNetCheckActive(GtkWidget *window, int bRARP, int bDHCP, int bBOOTP)
{
	SetActiveCheckButton(window, "NetworkSDlg_RARP_checkbutton", bRARP);
	SetActiveCheckButton(window, "NetworkSDlg_BOOTP_checkbutton", bBOOTP);
	SetActiveCheckButton(window, "NetworkSDlg_DHCP_checkbutton", bDHCP);
}

static void SetNetHboxSensitive(GtkWidget *window, int bSens)
{
	SetWidgetSensitive(window, "NetworkSDlg_IP_hbox", bSens);
	SetWidgetSensitive(window, "NetworkSDlg_Sub_hbox", bSens);
	SetWidgetSensitive(window, "NetworkSDlg_Gate_hbox", bSens);
}

void UpdateNetWorkSDlgWidgets(UIStatusWnd *wnd, int widget)
{
	GtkWidget *window = UI_DIALOG(wnd->networks_dlg)->window;
	char *str;
	int i;
	int bRARP = wnd->networks_dlg->bRARP;
	int bDHCP = wnd->networks_dlg->bDHCP;
	int bBOOTP = wnd->networks_dlg->bBOOTP;

	switch(widget){
	case NETWORKSDLG_IPSETTING_COMBO:
		str = GetCurrComboText(window, "NetworkSDlg_IPSetting_combo_entry");
		if(str){
			for(i = 0; IPSettingStr[i] != NULL; i++){
				if(strcmp(str, _(IPSettingStr[i])) == 0)
					break;
			}
			if(i == NETWORKSDLG_COMBO_AUTODETECT){
				SetNetCheckSensitive(window, TRUE);
				SetNetHboxSensitive(window, TRUE);
				goto check;
			}else if(i == NETWORKSDLG_COMBO_MANUALSETTING){
				SetNetCheckSensitive(window, FALSE);
				SetNetHboxSensitive(window, TRUE);
			}
		}
		break;
	case NETWORKSDLG_RARP_CHECK:
	case NETWORKSDLG_DHCP_CHECK:
	case NETWORKSDLG_BOOTP_CHECK:
check:
		SetNetCheckActive(window, bRARP, bDHCP, bBOOTP);

		if(bRARP){
			SetWidgetSensitive(window, "NetworkSDlg_IP_hbox", 0);
			SetWidgetSensitive(window, "NetworkSDlg_Sub_hbox", 1);
			SetWidgetSensitive(window, "NetworkSDlg_Gate_hbox", 1);
		}else{
			SetWidgetSensitive(window, "NetworkSDlg_IP_hbox", 1);
			if(bDHCP || bBOOTP){
				SetNetHboxSensitive(window, FALSE);
			}else{
				SetNetHboxSensitive(window, TRUE);
			}
		}
		break;
	}
}

void CheckNetIPEntry(UIStatusWnd *wnd, gchar *name)
{
	GtkWidget *window = UI_DIALOG(wnd->networks_dlg)->window;
	char *pValue;
	int nValue, len = 0;

	if((pValue = GetTextEntry(window, name)) == NULL)
		return;

	if((len = strlen(pValue)) == 0)
		return;

	nValue = atoi(pValue);
	if(nValue < 0)
		SetTextEntry(window, name, "0");
	else if(nValue > 255)
		SetTextEntry(window, name, "255");
}



static void SetIPSettingToGList(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->networks_dlg)->window;
	GList *glist = NULL;
	int i;

	for(i = 0; IPSettingStr[i] != NULL; i++){
		char *str = _(IPSettingStr[i]);
		if(str)
			glist = g_list_append(glist, str);
	}
	SetGListToCombo(window, glist, "NetworkSDlg_IPSetting_combo", _(IPSettingStr[0]));
	g_list_free(glist);
}

static void GetAddress(char *param, char **array)
{
	int i = 0;
	char avalue[32], *pvalue, *tmp;
	tmp = param;
	while(1){
		if(*tmp == '\n')
			break;
		if(isdigit(*tmp)){
			pvalue = avalue;
			while(1){
				if(*tmp == '.'){
					*pvalue = '\0';
					break;
				}
				if(*tmp == 0x09
				|| *tmp == 0x0d
				|| *tmp == 0x20){
					*pvalue = '\0';
					break;
				}
				if(*tmp == '\n'){
					*pvalue = '\0';
					break;
				}
				*pvalue = *tmp;
				tmp++;
				pvalue++;
			}
			array[i] = strdup(avalue);
			i++;
			if(i == 4)
				break;
		}
		tmp++;
	}
}

static int GetBoolean(char *param)
{
	char aline[256], *pline, *tmp;

	pline = aline;
	tmp = param;
	while(1){
		if(*tmp == '\n'){
			*pline = '\0';
			break;
		}
		*pline = *tmp;
		tmp++;
		pline++;
	}
	if(strstr(aline, "ON") != NULL)
		return 1;
	else if(strstr(aline, "OFF") != NULL)
		return 0;
	return 0;
}

static void GetNetWorkSettings(UIStatusWnd *wnd, NetWorks *pNet, char *param)
{
	char *pNICParam = param;
	char *tmp;

UI_DEBUG("GetNetWorkSettings[\n%s]\n", param);
	if((tmp = strstr(pNICParam, "IP Address")) != NULL){
		GetAddress(tmp, pNet->pIP);
	}
	if((tmp = strstr(pNICParam, "Subnet Mask")) != NULL){
		GetAddress(tmp, pNet->pSub);
	}
	if((tmp = strstr(pNICParam, "Gateway Address")) != NULL){
		GetAddress(tmp, pNet->pGate);
	}

	if((tmp = strstr(pNICParam, "DHCP")) != NULL){
		pNet->bDHCP = GetBoolean(tmp);
	}

	if((tmp = strstr(pNICParam, "RARP")) != NULL){
		pNet->bRARP = GetBoolean(tmp);
	}

	if((tmp = strstr(pNICParam, "BOOTP")) != NULL){
		pNet->bBOOTP = GetBoolean(tmp);
	}
UI_DEBUG("GetNetWorkSettings[\n%s]\n", param);
}

static void InitNetWorkSDlgWidgets(UIStatusWnd *wnd, char *param)
{
	GtkWidget *window = UI_DIALOG(wnd->networks_dlg)->window;
	NetWorks tNets;

	SetIPSettingToGList(wnd);

	memset(&tNets, 0, sizeof(NetWorks));
	GetNetWorkSettings(wnd, &tNets, param);

	if(tNets.pIP[0] != NULL && tNets.pIP[1] != NULL
	&& tNets.pIP[2] != NULL && tNets.pIP[3] != NULL){
		SetTextEntry(window, "NetworkSDlg_IP1_entry", tNets.pIP[0]);
		SetTextEntry(window, "NetworkSDlg_IP2_entry", tNets.pIP[1]);
		SetTextEntry(window, "NetworkSDlg_IP3_entry", tNets.pIP[2]);
		SetTextEntry(window, "NetworkSDlg_IP4_entry", tNets.pIP[3]);
	}

	if(tNets.pSub[0] != NULL && tNets.pSub[1] != NULL
	&& tNets.pSub[2] != NULL && tNets.pSub[3] != NULL){
		SetTextEntry(window, "NetworkSDlg_Sub1_entry", tNets.pSub[0]);
		SetTextEntry(window, "NetworkSDlg_Sub2_entry", tNets.pSub[1]);
		SetTextEntry(window, "NetworkSDlg_Sub3_entry", tNets.pSub[2]);
		SetTextEntry(window, "NetworkSDlg_Sub4_entry", tNets.pSub[3]);
	}

	if(tNets.pGate[0] != NULL && tNets.pGate[1] != NULL
	&& tNets.pGate[2] != NULL && tNets.pGate[3] != NULL){
		SetTextEntry(window, "NetworkSDlg_Gate1_entry", tNets.pGate[0]);
		SetTextEntry(window, "NetworkSDlg_Gate2_entry", tNets.pGate[1]);
		SetTextEntry(window, "NetworkSDlg_Gate3_entry", tNets.pGate[2]);
		SetTextEntry(window, "NetworkSDlg_Gate4_entry", tNets.pGate[3]);
	}

	SetActiveCheckButton(window, "NetworkSDlg_RARP_checkbutton" , tNets.bRARP);
	if(tNets.bRARP)
		SetWidgetSensitive(window, "NetworkSDlg_IP_hbox", 0);

	SetActiveCheckButton(window, "NetworkSDlg_BOOTP_checkbutton" , tNets.bBOOTP);
	SetActiveCheckButton(window, "NetworkSDlg_DHCP_checkbutton" , tNets.bDHCP);

	if(tNets.bBOOTP || tNets.bDHCP){
		SetWidgetSensitive(window, "NetworkSDlg_IP_hbox", 0);
		SetWidgetSensitive(window, "NetworkSDlg_Sub_hbox", 0);
		SetWidgetSensitive(window, "NetworkSDlg_Gate_hbox", 0);
	}

	wnd->networks_dlg->bRARP = tNets.bRARP;
	wnd->networks_dlg->bDHCP = tNets.bDHCP;
	wnd->networks_dlg->bBOOTP = tNets.bBOOTP;

	mem_free(tNets.pIP[0]);
	mem_free(tNets.pIP[1]);
	mem_free(tNets.pIP[2]);
	mem_free(tNets.pIP[3]);
	mem_free(tNets.pSub[0]);
	mem_free(tNets.pSub[1]);
	mem_free(tNets.pSub[2]);
	mem_free(tNets.pSub[3]);
	mem_free(tNets.pGate[0]);
	mem_free(tNets.pGate[1]);
	mem_free(tNets.pGate[2]);
	mem_free(tNets.pGate[3]);
}


static int GetNICParamData(UIStatusWnd *wnd, char *param)
{
	if(SendRequest(wnd, CCPD_REQ_NIC_PARAM) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, param, READ_TYPE_ALL, -1) < 0)
		goto err;
UI_DEBUG("GetNICParam[\n%s]\n", param);
	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;
}


static int GetNICParamData2(UIStatusWnd *wnd, char *param)
{
	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_NIC_PARAM) < 0)
		goto err;

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, param, READ_TYPE_ALL, -1) < 0)
		goto err;
UI_DEBUG("GetNICParam[\n%s]\n", param);
	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;
}






