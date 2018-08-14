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
#include "regipaperdlg.h"
#include "data_process.h"
#include "callbacks.h"

#define	REGIPAPER_DATA_LENGTH	8
#define	REGIPAPER_CAS1	1
#define	REGIPAPER_CAS2	3
#define	REGIPAPER_CAS3	2
#define	REGIPAPER_CAS4	264
#define	DREQ_REGIPAPER_SET_LENGTH	24

#define	TITLEID_REGIPAPER	0
#define TITLEID_CASSET1		1
#define	TITLEID_CASSET		2
#define	TITLEID_DRAWER1		3
#define	TITLEID_DRAWER		4
#define TITLEID_DEFAULT		TITLEID_REGIPAPER

#define IDX_DEFUALT_PAPER_LETTER	0
#define IDX_DEFAULT_PAPER_A4		7

static char* tTitleTbl[] = {
	N_("Register Paper Size in Cassettes"),
	N_("Cassette Settings 1"),
	N_("Cassette Settings"),
	N_("Drawer Settings 1"),
	N_("Drawer Settings"),
	NULL,
};

static void InitRegiPaperDlgWidgets(UIStatusWnd *wnd, unsigned char *data);
static int GetRegiPaperData(UIStatusWnd *wnd, unsigned char *elem);
static void SetToRegiPaperGList(UIStatusWnd *wnd, unsigned char *data);
static int GetRegiPaperData2(UIStatusWnd *wnd);
static void InitRegiPaperDlgWidgets2(UIStatusWnd *wnd);
static void InitRegiPaperDlgWidgets2_LBP9100(UIStatusWnd *wnd, long region);

typedef struct {
	int id;
	char *str;
}PaperSizeTbl;

static PaperSizeTbl tPaperSizeTbl[] ={
	{PAPER_LETTER, N_("Letter")},
	{PAPER_LEGAL, N_("Legal")},
	{PAPER_LEDGER, N_("Ledger")},
	{PAPER_STATEMENT, N_("Statement")},
	{PAPER_EXECTIVE, N_("Executive")},
	{PAPER_A3, N_("A3")},
	{PAPER_B4, N_("B4")},
	{PAPER_A4, N_("A4")},
	{PAPER_B5, N_("B5")},
	{PAPER_A5, N_("A5")},
	{PAPER_POSTCARD, N_("Postcard")},
	{PAPER_DBL_POSTCARD, N_("Relay Postcard")},
	{PAPER_4X1_POSTCARD, N_("4 on 1 Postcard")},
	{PAPER_ENV_YOU4, N_("Envelope YOUGATA4")},
	{PAPER_ENV_YOU2, N_("Envelope YOUGATA2")},
	{PAPER_ENV_MONARCH, N_("Envelope Monarch")},
	{PAPER_ENV_COM10, N_("Envelope COM10")},
	{PAPER_ENV_C5, N_("Envelope C5")},
	{PAPER_ENV_DL, N_("Envelope DL")},
	{PAPER_ENV_B5, N_("Envelope B5")},
	{PAPER_INDEX3X5, N_("Index Card")},
	{PAPER_16K, N_("16K")},
	{PAPER_12x18, N_("12x18")},
	{-1, NULL},
};

static PaperSizeTbl tPaperIDTbl[] ={
	{PAPERID_LETTER, N_("Letter")},
	{PAPERID_LEGAL, N_("Legal")},
	{PAPERID_LEDGER, N_("Ledger")},
	{PAPERID_STATEMENT, N_("Statement")},
	{PAPERID_EXECUTIVE, N_("Executive")},
	{PAPERID_A3, N_("A3")},
	{PAPERID_B4, N_("B4")},
	{PAPERID_A4, N_("A4")},
	{PAPERID_B5, N_("B5")},
	{PAPERID_A5, N_("A5")},
	{PAPERID_POSTCARD, N_("Postcard")},
	{PAPERID_DBL_POSTCARD, N_("Relay Postcard")},
	{PAPERID_4X1_POSTCARD, N_("4 on 1 Postcard")},
	{PAPERID_ENV_YOU4, N_("Envelope YOUGATA4")},
	{PAPERID_ENV_YOU2, N_("Envelope YOUGATA2")},
	{PAPERID_ENV_MONARCH, N_("Envelope Monarch")},
	{PAPERID_ENV_COM10, N_("Envelope COM10")},
	{PAPERID_ENV_C5, N_("Envelope C5")},
	{PAPERID_ENV_DL, N_("Envelope DL")},
	{PAPERID_ENV_B5, N_("Envelope B5")},
	{PAPERID_INDEX3X5, N_("Index Card")},
	{PAPERID_16K, N_("16K")},
	{PAPERID_12X18, N_("12x18")},
	{PAPERID_ENV_KAKU2, N_("Envelope KAKUGATA2")},
	{PAPERID_8K, N_("8K")},
	{PAPERID_FOOLSCAP, N_("Foolscap")},
	{-1, NULL},
};

static PaperSizeTbl tPaperIDTbl_2[] ={
	{PAPERID_UNKNOWN, N_("Auto")},
	{PAPERID_LETTER, N_("Letter")},
	{PAPERID_LEGAL, N_("Legal")},
	{PAPERID_LEDGER, N_("Ledger")},
	{PAPERID_STATEMENT, N_("Statement")},
	{PAPERID_EXECUTIVE, N_("Executive")},
	{PAPERID_A3, N_("A3")},
	{PAPERID_B4, N_("B4")},
	{PAPERID_A4, N_("A4")},
	{PAPERID_B5, N_("B5")},
	{PAPERID_A5, N_("A5")},
	{PAPERID_A6, N_("A6")},
	{PAPERID_POSTCARD, N_("Postcard")},
	{PAPERID_DBL_POSTCARD, N_("Relay Postcard")},
	{PAPERID_4X1_POSTCARD, N_("4 on 1 Postcard")},
	{PAPERID_ENV_YOU4, N_("Envelope YOUGATA4")},
	{PAPERID_ENV_YOU2, N_("Envelope YOUGATA2")},
	{PAPERID_ENV_CHOU3, N_("Envelope NAGAGATA3")},
	{PAPERID_ENV_YOU_CHOU3, N_("Envelope YOUGATANAGA3")},
	{PAPERID_ENV_MONARCH, N_("Envelope Monarch")},
	{PAPERID_ENV_COM10, N_("Envelope COM10")},
	{PAPERID_ENV_C5, N_("Envelope C5")},
	{PAPERID_ENV_DL, N_("Envelope DL")},
	{PAPERID_ENV_B5, N_("Envelope B5")},
	{PAPERID_INDEX3X5, N_("Index Card")},
	{PAPERID_16K, N_("16K")},
	{PAPERID_12X18, N_("12x18")},
	{PAPERID_ENV_KAKU2, N_("Envelope KAKUGATA2")},
	{PAPERID_8K, N_("8K")},
	{PAPERID_FOOLSCAP, N_("Foolscap")},
	{-1, NULL},
};


static int tPaperIDTbl_LBP5300JP[] = {
	PAPERID_LETTER,
	PAPERID_LEGAL,
	PAPERID_EXECUTIVE,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	-1,
};

static int tPaperIDTbl_LBP5300UK[] = {
	PAPERID_LETTER,
	PAPERID_LEGAL,
	PAPERID_EXECUTIVE,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	PAPERID_FOOLSCAP,
	-1,
};

static int tPaperIDTbl_LBP3500JP[] = {
	PAPERID_LETTER,
	PAPERID_LEDGER,
	PAPERID_LEGAL,
	PAPERID_EXECUTIVE,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	PAPERID_B4,
	PAPERID_A3,
	-1,
};

static int tPaperIDTbl_LBP3500UK[] = {
	PAPERID_LETTER,
	PAPERID_LEDGER,
	PAPERID_LEGAL,
	PAPERID_EXECUTIVE,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	PAPERID_B4,
	PAPERID_A3,
	PAPERID_16K,
	-1,
};

static int tPaperIDTbl_LBP5100JP[] = {
	PAPERID_LETTER,
	PAPERID_LEGAL,
	PAPERID_EXECUTIVE,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	PAPERID_POSTCARD,
	PAPERID_DBL_POSTCARD,
	PAPERID_4X1_POSTCARD,
	PAPERID_ENV_YOU4,
	PAPERID_ENV_YOU2,
	-1,
};

static int tPaperIDTbl_LBP5100UK[] = {
	PAPERID_LETTER,
	PAPERID_LEGAL,
	PAPERID_STATEMENT,
	PAPERID_EXECUTIVE,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	PAPERID_ENV_MONARCH,
	PAPERID_ENV_COM10,
	PAPERID_ENV_DL,
	PAPERID_ENV_C5,
	PAPERID_ENV_B5,
	PAPERID_FOOLSCAP,
	PAPERID_INDEX3X5,
	PAPERID_16K,
	-1,
};

static int tPaperIDTbl_LBP5050JP[] = {
	PAPERID_LETTER,
	PAPERID_LEGAL,
	PAPERID_EXECUTIVE,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	PAPERID_POSTCARD,
	PAPERID_DBL_POSTCARD,
	PAPERID_4X1_POSTCARD,
	PAPERID_ENV_YOU4,
	PAPERID_ENV_YOU2,
	-1,
};

static int tPaperIDTbl_LBP5050UK[] = {
	PAPERID_LETTER,
	PAPERID_LEGAL,
	PAPERID_STATEMENT,
	PAPERID_EXECUTIVE,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	PAPERID_ENV_MONARCH,
	PAPERID_ENV_COM10,
	PAPERID_ENV_DL,
	PAPERID_ENV_C5,
	PAPERID_ENV_B5,
	PAPERID_FOOLSCAP,
	PAPERID_INDEX3X5,
	PAPERID_16K,
	-1,
};


static int tPaperIDTbl_LBP7200JP[] = {
	PAPERID_LETTER,
	PAPERID_LEGAL,
	PAPERID_EXECUTIVE,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	PAPERID_POSTCARD,
	PAPERID_DBL_POSTCARD,
	PAPERID_4X1_POSTCARD,
	PAPERID_ENV_CHOU3,
	PAPERID_ENV_YOU_CHOU3,
	-1,
};

static int tPaperIDTbl_LBP7200UK[] = {
	PAPERID_LETTER,
	PAPERID_LEGAL,
	PAPERID_STATEMENT,
	PAPERID_EXECUTIVE,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	PAPERID_ENV_COM10,
	PAPERID_ENV_DL,
	PAPERID_ENV_C5,
	PAPERID_ENV_B5,
	PAPERID_FOOLSCAP,
	PAPERID_16K,
	-1,
};

static int tPaperIDTbl_LBP7210UK[] = {
	PAPERID_LETTER,
	PAPERID_LEGAL,
	PAPERID_STATEMENT,
	PAPERID_EXECUTIVE,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	PAPERID_ENV_COM10,
	PAPERID_ENV_DL,
	PAPERID_ENV_C5,
	PAPERID_ENV_B5,
	PAPERID_FOOLSCAP,
	-1,
};


static int tPaperIDTbl_LBP3310JP[] = {
	PAPERID_LETTER,
	PAPERID_LEGAL,
	PAPERID_EXECUTIVE,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	-1,
};

static int tPaperIDTbl_LBP3310UK[] = {
	PAPERID_LETTER,
	PAPERID_LEGAL,
	PAPERID_STATEMENT,
	PAPERID_EXECUTIVE,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	PAPERID_16K,
	-1,
};

static int tPaperIDTbl_LBP9100JP[] = {
	PAPERID_UNKNOWN,
	-1,
};


static int tPaperIDTbl_LBP9100UK2[] = {
	PAPERID_UNKNOWN,
	PAPERID_16K,
	PAPERID_8K,
	-1,
};

static int tPaperIDTbl_LBP9100UK3[] = {
	PAPERID_UNKNOWN,
	PAPERID_EXECUTIVE,
	-1,
};

static int tPaperIDTbl_LBP6300JP[] = {
	PAPERID_LETTER,
	PAPERID_LEGAL,
	PAPERID_EXECUTIVE,
	PAPERID_A6,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	-1,
};

static int tPaperIDTbl_LBP6300UK[] = {
	PAPERID_LETTER,
	PAPERID_LEGAL,
	PAPERID_EXECUTIVE,
	PAPERID_A6,
	PAPERID_A5,
	PAPERID_B5,
	PAPERID_A4,
	PAPERID_16K,
	-1,
};

static int tPaperIDTbl_LBP9200JPUK[] = {
	PAPERID_UNKNOWN,
	-1,
};

typedef struct {
	int type;
	char* labeltext;
}StrText;

#define	LABEL_TYPE_CASSETTE		100
#define	LABEL_TYPE_DRAWER		101

static StrText labelCassette1[] = {
	{LABEL_TYPE_CASSETTE, N_("Cassette 1:")},
	{LABEL_TYPE_DRAWER, N_("Paper Size in Drawer 1:")},
	{-1 ,NULL}
};

static StrText labelCassette2[] = {
	{LABEL_TYPE_CASSETTE, N_("Cassette 2:")},
	{LABEL_TYPE_DRAWER, N_("Paper Size in Drawer 2:")},
	{-1 ,NULL}
};

static StrText labelCassette3[] = {
	{LABEL_TYPE_CASSETTE, N_("Cassette 3:")},
	{LABEL_TYPE_DRAWER, N_("Paper Size in Drawer 3:")},
	{-1 ,NULL}
};

static StrText labelCassette4[] = {
	{LABEL_TYPE_CASSETTE, N_("Cassette 4:")},
	{LABEL_TYPE_DRAWER, N_("Paper Size in Drawer 4:")},
	{-1 ,NULL}
};

typedef struct {
	StrText* labeltext;
	char* labelname;
}LabelText;

static LabelText LabelTextList[] = {
	{labelCassette1, "label140"},
	{labelCassette2, "label143"},
	{labelCassette3, "label235"},
	{labelCassette4, "label237"},
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
	GtkWidget *window = UI_DIALOG(wnd->regipaper_dlg)->window;
	int model = wnd->nModel;
	int type = 0;
	char* text = NULL;
	int i = 0;

	switch(model){
		case MODEL_LBP9200:
		case MODEL_LBP7210:
		case MODEL_LBP6310:
		case MODEL_LBP6340:
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

UIRegiPaperDlg* CreateRegiPaperDlg(UIDialog *parent)
{
	UIRegiPaperDlg *dialog;

	dialog = (UIRegiPaperDlg *)CreateDialog(sizeof(UIRegiPaperDlg), parent);

	UI_DIALOG(dialog)->window = create_RegiPaper_dialog();

	ComboSignalConnect(UI_DIALOG(dialog)->window, "RegiPaper_Cas1_combo", GTK_SIGNAL_FUNC(on_RegiPaper_Cas1_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "RegiPaper_Cas2_combo", GTK_SIGNAL_FUNC(on_RegiPaper_Cas2_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "RegiPaper_Cas3_combo", GTK_SIGNAL_FUNC(on_RegiPaper_Cas3_combo_popwin_event));
	ComboSignalConnect(UI_DIALOG(dialog)->window, "RegiPaper_Cas4_combo", GTK_SIGNAL_FUNC(on_RegiPaper_Cas4_combo_popwin_event));

	return dialog;
}

void ShowRegiPaperDlg(UIStatusWnd *wnd)
{
  	DREQPrinterInfo info;

	switch(wnd->nIFVersion){
	case CCPD_IF_VERSION_110:
		{
			if(GetRegiPaperData2(wnd))
				return;
			SigDisable();
			switch(wnd->nModel){
			case MODEL_LBP9100:
			case MODEL_LBP9200:
              if( GetDREQPrinterInfo( wnd, &info ) != 0 ){
                  ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
				    return;
				}
				InitRegiPaperDlgWidgets2_LBP9100(wnd, info.Region);
				break;
			default:
				InitRegiPaperDlgWidgets2(wnd);
				break;
			}
			SigEnable();
		}
		break;
	case CCPD_IF_VERSION_100:
	default:
		{
			unsigned char data[5];
			if(GetRegiPaperData(wnd, data))
				return;
			SigDisable();
			InitRegiPaperDlgWidgets(wnd, data);
			SigEnable();
		}
		break;
	}
	ShowDialog((UIDialog *)wnd->regipaper_dlg, NULL);
}

void HideRegiPaperDlg(UIStatusWnd *wnd)
{
	HideDialog((UIDialog *)wnd->regipaper_dlg);
}

int GetPaperSizeID(char *paper)
{
	int i;
	if(paper == NULL)
		return PAPER_A4;

	for(i = 0; tPaperSizeTbl[i].str != NULL; i++){
		char *text = _(tPaperSizeTbl[i].str);
		if(text != NULL){
			if(strcasecmp(paper, text) == 0)
				return tPaperSizeTbl[i].id;
		}
	}
	return PAPER_A4;
}

int Show3300MsgDlg(UIStatusWnd *wnd, int cas1, int cas2)
{
	if(cas1 == PAPER_A4){
		if(cas2 == PAPER_LETTER)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_A4_LTR);
		else if(cas2 == PAPER_LEGAL)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_A4_LGL);
		else
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_A4);
	}else if(cas1 == PAPER_LETTER){
		if(cas2 == PAPER_A4)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_A4_LTR);
		else if(cas2 == PAPER_LEGAL)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_LTR_LGL);
		else
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_LTR);
	}else if(cas1 == PAPER_LEGAL){
		if(cas2 == PAPER_A4)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_A4_LGL);
		else if(cas2 == PAPER_LETTER)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_LTR_LGL);
		else
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_LGL);
	}else{
		if(cas2 == PAPER_A4)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_A4);
		if(cas2 == PAPER_LETTER)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_LTR);
		if(cas2 == PAPER_LEGAL)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_LGL);
	}
	return 1;
}

int Show3310MsgDlg(UIStatusWnd *wnd, int cas1, int cas2)
{
	if(cas1 == PAPERID_A4){
		if(cas2 == PAPERID_LETTER)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_A4_LTR);
		else if(cas2 == PAPERID_LEGAL)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_A4_LGL);
		else
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_A4);
	}else if(cas1 == PAPERID_LETTER){
		if(cas2 == PAPERID_A4)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_A4_LTR);
		else if(cas2 == PAPERID_LEGAL)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_LTR_LGL);
		else
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_LTR);
	}else if(cas1 == PAPERID_LEGAL){
		if(cas2 == PAPERID_A4)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_A4_LGL);
		else if(cas2 == PAPERID_LETTER)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_LTR_LGL);
		else
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_LGL);
	}else{
		if(cas2 == PAPERID_A4)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_A4);
		if(cas2 == PAPERID_LETTER)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_LTR);
		if(cas2 == PAPERID_LEGAL)
			ShowMsgDlg(wnd, MSG_TYPE_REGIPAPER_3300_LGL);
	}
	return 1;
}

void RegiPaperDlgOK(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->regipaper_dlg)->window;
	char *pstr = NULL;
	int id1 = PAPER_A4, cas = 0;
	int id2 = 0, id3 = 0, id4 = 0;

	for(cas = 0; cas < wnd->regipaper_dlg->cas_num; cas++){
		switch(cas){
		case 0:
			pstr = GetCurrComboText(window, "RegiPaper_Cas1_combo_entry");
			if(pstr != NULL){
				id1 = GetPaperSizeID(pstr);
			}
			break;
		case 1:
			pstr = GetCurrComboText(window, "RegiPaper_Cas2_combo_entry");
			if(pstr != NULL){
				id2 = GetPaperSizeID(pstr);
			}
			break;
		case 2:
		case 3:
			break;
		}
	}
	HideRegiPaperDlg(wnd);

	if(wnd->nModel == MODEL_LBP3300){
		Show3300MsgDlg(wnd, id1, id2);
	}

	for(cas = 0; cas < wnd->regipaper_dlg->cas_num; cas++){
		if(cnsktSetReqLong(wnd->pCnskt, REGIPAPER_DATA_LENGTH) < 0)
			goto err;
		if(cnsktSetReqShort(wnd->pCnskt, cas + 2) < 0)
			goto err;
		switch(cas){
		case 0:
			if(cnsktSetReqByte(wnd->pCnskt, id1) < 0)
				goto err;
			break;
		case 1:
			if(cnsktSetReqByte(wnd->pCnskt, id2) < 0)
				goto err;
			break;
		case 2:
			if(cnsktSetReqByte(wnd->pCnskt, id3) < 0)
				goto err;
			break;
		case 3:
			if(cnsktSetReqByte(wnd->pCnskt, id4) < 0)
				goto err;
			break;
		}
		if(cnsktSetReqByte(wnd->pCnskt, 0) < 0)
			goto err;
		if(cnsktSetReqShort(wnd->pCnskt, 0) < 0)
			goto err;
		if(cnsktSetReqShort(wnd->pCnskt, 0) < 0)
			goto err;
		if(SendRequest(wnd, CCPD_REQ_SET_FL_DATA) < 0)
			goto err;
	}

	return;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
}

static void InitRegiPaperDlgWidgets(UIStatusWnd *wnd, unsigned char *data)
{
	SetToRegiPaperGList(wnd, data);
}

int GetValue(char *ptr, int num)
{
	char buf[32];
	ptr = ptr + num;

	if(*ptr == '\0')
		return -1;

	memset(buf, 0, 32);
	memcpy(buf, ptr, 32);
	buf[1] = '\0';

	if(isdigit(buf[0]))
		return atoi(buf);
	else if(isalpha(buf[0])){
		switch(buf[0]){
		case 'a':
		case 'A':
			return 10;
		case 'b':
		case 'B':
			return 11;
		case 'c':
		case 'C':
			return 12;
		case 'd':
		case 'D':
			return 13;
		case 'e':
		case 'E':
			return 14;
		case 'f':
		case 'F':
			return 15;
		}
	}
	return -1;
}

int IsSetPaper(int value, int num)
{
	int ret = 0;
	ret = value & (1 << num);
	return ret;
}

static void SetToRegiPaperGList(UIStatusWnd *wnd, unsigned char *data)
{
	GtkWidget *window = UI_DIALOG(wnd->regipaper_dlg)->window;
	GList *glist = NULL;
	char *str = NULL, *cur = NULL;
	int value = 0;
	int flag = 0;
	int i = 0, j = 0, cas = 0, k = 0;

	wnd->regipaper_dlg->cas_num = data[0];

	SetTextEntry(window, "RegiPaper_Cas1_combo_entry", _(tPaperSizeTbl[7].str));
	SetWidgetSensitive(window, "RegiPaper_Cas1_hbox", FALSE);
	SetTextEntry(window, "RegiPaper_Cas2_combo_entry", _(tPaperSizeTbl[7].str));
	SetWidgetSensitive(window, "RegiPaper_Cas2_hbox", FALSE);

	for(cas = 0; cas < data[0]; cas++){
		char *pvalue = wnd->pRegiPaperList[cas];
		glist = NULL;
		if(pvalue == NULL)
			break;
		j = 0;
		while(1){
			value = GetValue(pvalue, j);
			if(value == -1)
				break;
			for(i = 0; i < 4; i++){
				flag = IsSetPaper(value, i);
				if(flag == -1)
					break;
				else if(flag > 0){
					str = _(tPaperSizeTbl[i + (j * 4)].str);
					if(str)
						glist = g_list_append(glist, str);
				}
			}
			j++;
		}

		cur = _(tPaperSizeTbl[7].str);
		for(k = 0; tPaperSizeTbl[k].id != -1; k++){
			if(tPaperSizeTbl[k].id == data[cas + 1])
				cur = _(tPaperSizeTbl[k].str);
		}

		switch(cas){
		case 0:
			SetWidgetSensitive(window, "RegiPaper_Cas1_hbox", TRUE);
			SetGListToCombo(window, glist, "RegiPaper_Cas1_combo", cur);
			break;
		case 1:
			SetWidgetSensitive(window, "RegiPaper_Cas2_hbox", TRUE);
			SetGListToCombo(window, glist, "RegiPaper_Cas2_combo", cur);
			break;
		}
		g_list_free(glist);
	}
}


static int GetRegiPaperData(UIStatusWnd *wnd, unsigned char *elem)
{
	unsigned char elem1, elem2, elem3;
	int i, cnt = 0;

	if(SendRequest(wnd, CCPD_REQ_PRT_INFO2) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &elem1, READ_TYPE_BYTE, -1) < 0)
		elem2 = 1;
	if(cnsktGetResData(wnd->pCnskt, &elem2, READ_TYPE_BYTE, -1) < 0)
		elem2 = 1;
	if(cnsktGetResData(wnd->pCnskt, &elem3, READ_TYPE_BYTE, -1) < 0)
		elem3 = 1;

	if(elem2 > 0 && elem2 <= 4)
		elem[cnt++] = elem2;
	else
		elem[cnt++] = 1;

	for(i = 0; i < elem[0]; i++){
		int value = DATA_LENGTH_SHORT;
		short id = i + 2;

		if(cnsktSetReqLong(wnd->pCnskt, value) < 0)
			goto err;
		if(cnsktSetReqShort(wnd->pCnskt, id) < 0)
			goto err;

		if(SendRequest(wnd, CCPD_REQ_GET_FL_DATA) < 0)
			goto err;

		if(cnsktGetResData(wnd->pCnskt, &elem1, READ_TYPE_BYTE, -1) < 0)
			goto err;
		elem[cnt++] = elem1;
	}

	return 0;

err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;
}

static int GetRegiPaperData2(UIStatusWnd *wnd)
{
	long num = 0;
	long value = 0;
	long i = 0;

	if(cnsktSetReqLong(wnd->pCnskt, DATA_LENGTH_LONG) < 0)
		goto err;
	if(cnsktSetReqLong(wnd->pCnskt, DREQ_GET_INPUTINFO) < 0)
		goto err;

	if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
		goto err;

	if(cnsktGetResData(wnd->pCnskt, &num, READ_TYPE_LONG, -1) < 0)
		goto err;

	wnd->regipaper_dlg->cas_num = 0;
	for(i = 0; i < num; i++){
		long dwSourceID = 0;
		long dwPaperSize = 0;
		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
			goto err;
		dwSourceID = value;

		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
			goto err;
		dwPaperSize = value;

		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
			goto err;

		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
			goto err;

		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
			goto err;

		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
			goto err;

		value = 0;
		if(cnsktGetResData(wnd->pCnskt, &value, READ_TYPE_LONG, -1) < 0)
			goto err;

		switch(dwSourceID){
		case REGIPAPER_CAS1:
			wnd->regipaper_dlg->paper_cas1 = dwPaperSize;
			wnd->regipaper_dlg->cas_num++;
			break;
		case REGIPAPER_CAS2:
			wnd->regipaper_dlg->paper_cas2 = dwPaperSize;
			wnd->regipaper_dlg->cas_num++;
			break;
		case REGIPAPER_CAS3:
			wnd->regipaper_dlg->paper_cas3 = dwPaperSize;
			wnd->regipaper_dlg->cas_num++;
			break;
		case REGIPAPER_CAS4:
			wnd->regipaper_dlg->paper_cas4 = dwPaperSize;
			wnd->regipaper_dlg->cas_num++;
			break;
		default:
			break;
		}
	}

	return 0;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_GET);
	return 1;
}

static char* IDtoStr(int model,int id)
{
	int i = 0;
	PaperSizeTbl * pTbl_adr = NULL;

	switch(model){
	case MODEL_LBP3500:
	case MODEL_LBP5300:
		pTbl_adr = tPaperIDTbl;
		break;
	case MODEL_LBP5100:
	case MODEL_LBP3310:
	case MODEL_LBP5050:
	case MODEL_LBP7200:
	case MODEL_LBP9100:
	case MODEL_LBP6300:
	case MODEL_LBP9200:
	case MODEL_LBP6300N:
	case MODEL_LBP7210:
	case MODEL_LBP6310:
	case MODEL_LBP6340:
		pTbl_adr = tPaperIDTbl_2;
		break;
	default:
		pTbl_adr = tPaperIDTbl;
	}

	for(i = 0; pTbl_adr[i].id != -1; i++){
		if(id == pTbl_adr[i].id)
			return _(pTbl_adr[i].str);
	}
	return NULL;
}

static int GetPaperID(int model,char *paper)
{
	int i = 0;
	PaperSizeTbl * pTbl_adr = NULL;

	switch(model){
	case MODEL_LBP3500:
	case MODEL_LBP5300:
		pTbl_adr = tPaperIDTbl;
		break;
	case MODEL_LBP5100:
	case MODEL_LBP3310:
	case MODEL_LBP5050:
	case MODEL_LBP7200:
	case MODEL_LBP9100:
	case MODEL_LBP6300:
	case MODEL_LBP9200:
	case MODEL_LBP6300N:
	case MODEL_LBP7210:
	case MODEL_LBP6310:
	case MODEL_LBP6340:
		pTbl_adr = tPaperIDTbl_2;
		break;
	default:
		pTbl_adr = tPaperIDTbl;
	}

	if(paper == NULL)
		return PAPERID_A4;

	for(i = 0; pTbl_adr[i].str != NULL; i++){
		char *text = _(pTbl_adr[i].str);
		if(strncasecmp(paper, text,
				max(strlen(paper), strlen(text))) == 0)
			return pTbl_adr[i].id;
	}
	return PAPERID_A4;
}

static GList* IDListToGList(int model,int *idlist)
{
	GList *glist = NULL;
	int i;
	char *str;

	for(i = 0; idlist[i] != -1; i++){
		str = IDtoStr(model,idlist[i]);
		if(str)
			glist = g_list_append(glist, str);
	}
	return glist;
}

static int* GetIDList(int model, int lang, int cas, long region)
{
	switch(model){
	case MODEL_LBP3500:
		if(lang == LANG_TYPE_UK)
			return tPaperIDTbl_LBP3500UK;
		else
			return tPaperIDTbl_LBP3500JP;
		break;
	case MODEL_LBP5300:
		if(lang == LANG_TYPE_UK)
			return tPaperIDTbl_LBP5300UK;
		else
			return tPaperIDTbl_LBP5300JP;
		break;
	case MODEL_LBP5100:
		if(lang == LANG_TYPE_UK)
			return tPaperIDTbl_LBP5100UK;
		else
			return tPaperIDTbl_LBP5100JP;
		break;
	case MODEL_LBP5050:
		if(lang == LANG_TYPE_UK)
			return tPaperIDTbl_LBP5050UK;
		else
			return tPaperIDTbl_LBP5050JP;
		break;
	case MODEL_LBP7200:
		if((lang == LANG_TYPE_UK) || (lang == LANG_TYPE_US)){
			return tPaperIDTbl_LBP7200UK;
		} else {
			return tPaperIDTbl_LBP7200JP;
		}
		break;
	case MODEL_LBP3310:
		if(lang == LANG_TYPE_UK)
			return tPaperIDTbl_LBP3310UK;
		else
			return tPaperIDTbl_LBP3310JP;
		break;
	case MODEL_LBP6300:
	case MODEL_LBP6300N:
	case MODEL_LBP6310:
	case MODEL_LBP6340:
		if((lang == LANG_TYPE_UK) || (lang == LANG_TYPE_US)){
			return tPaperIDTbl_LBP6300UK;
		}else{
			return tPaperIDTbl_LBP6300JP;
		}
		break;
	case MODEL_LBP9100:
		if( region != -1 ){
			switch( region ){
			case DREQ_REGION_CHINA:
			    if( cas == 0 ){
			        return tPaperIDTbl_LBP9100UK3;
			    } else {
			        return tPaperIDTbl_LBP9100UK2;
			     }
			    break;
			case DREQ_REGION_ASIA:
    	        return tPaperIDTbl_LBP9100UK2;
    	        break;
			default:
			    return tPaperIDTbl_LBP9100JP;
			    break;
			}
		}
		break;
	case MODEL_LBP9200:
		return tPaperIDTbl_LBP9200JPUK;
		break;
	case MODEL_LBP7210:
		return tPaperIDTbl_LBP7210UK;
		break;
	default:
		break;
	}
	return NULL;
}


static void InitRegiPaperDlgWidgets2(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->regipaper_dlg)->window;
	int i = 0;
	int title = TITLEID_DEFAULT;
	int model = wnd->nModel;
	int index = IDX_DEFAULT_PAPER_A4;

	if( wnd != NULL ){
		if( IsUS(wnd) == TRUE ){
			index = IDX_DEFUALT_PAPER_LETTER;
		}
	}
	SetTextEntry(window,
		"RegiPaper_Cas1_combo_entry", _(tPaperSizeTbl[index].str));
	SetWidgetSensitive(window, "RegiPaper_Cas1_hbox", FALSE);
	SetTextEntry(window,
		"RegiPaper_Cas2_combo_entry", _(tPaperSizeTbl[index].str));
	SetWidgetSensitive(window, "RegiPaper_Cas2_hbox", FALSE);

	for(i = 0; i < wnd->regipaper_dlg->cas_num; i++){
		GList *glist = NULL;
		int *idlist = NULL;
		int lang = wnd->nLangType;
		char *cur = NULL, *tmp_cur = NULL;
		int id = 0;

		idlist = GetIDList(model, lang, i, -1);

		glist = IDListToGList(model,idlist);
		if( IsUS(wnd) == TRUE ){
			cur = IDtoStr(model,PAPERID_LETTER);
		} else {
			cur = IDtoStr(model,PAPERID_A4);
		}

		switch(i){
		case 0:
			if((id = wnd->regipaper_dlg->paper_cas1) != 0)
			{
				if( (tmp_cur = IDtoStr(model,id)) != NULL )
				{
					cur = tmp_cur;
				}
			}
			SetWidgetSensitive(window, "RegiPaper_Cas1_hbox", TRUE);
			SetGListToCombo(window, glist, "RegiPaper_Cas1_combo", cur);
			break;
		case 1:
			if((id = wnd->regipaper_dlg->paper_cas2) != 0)
			{
				if( (tmp_cur = IDtoStr(model,id)) != NULL )
				{
					cur = tmp_cur;
				}
			}
			SetWidgetSensitive(window, "RegiPaper_Cas2_hbox", TRUE);
			SetGListToCombo(window, glist, "RegiPaper_Cas2_combo", cur);
		default:
			break;
		}
		g_list_free(glist);
	}

	switch(model){
	case MODEL_LBP6300:
	case MODEL_LBP6300N:
		title = TITLEID_CASSET;
		break;
	case MODEL_LBP6310:
	case MODEL_LBP6340:
	case MODEL_LBP7210:
		title = TITLEID_DRAWER;
		SetLabel(wnd);
		break;
	default:
		title = TITLEID_DEFAULT;
		break;
	}
	SetDialogTitle(window, _(tTitleTbl[title]));
}

void RegiPaperDlgOK2(UIStatusWnd *wnd)
{
	GtkWidget *window = UI_DIALOG(wnd->regipaper_dlg)->window;
	char *pstr = NULL;
	int cas1 = 0, cas2 = 0;
	int cas3 = 0, cas4 = 0;
	int i = 0;
	int model = wnd->nModel;

UI_DEBUG("\n");
UI_DEBUG("RegiPaperDlgOK");
UI_DEBUG("\n");

	for(i = 0; i < wnd->regipaper_dlg->cas_num; i++){
		switch(i){
		case 0:
			pstr = GetCurrComboText(window, "RegiPaper_Cas1_combo_entry");
			if(pstr != NULL){
				cas1 = GetPaperID(model,pstr);
			}
			break;
		case 1:
			pstr = GetCurrComboText(window, "RegiPaper_Cas2_combo_entry");
			if(pstr != NULL){
				cas2 = GetPaperID(model,pstr);
			}
			break;
		case 2:
			pstr = GetCurrComboText(window, "RegiPaper_Cas3_combo_entry");
			if(pstr != NULL){
				cas3 = GetPaperID(model,pstr);
			}
			break;
		case 3:
			pstr = GetCurrComboText(window, "RegiPaper_Cas4_combo_entry");
			if(pstr != NULL){
				cas4 = GetPaperID(model,pstr);
			}
			break;
		default:
			break;
		}

	}
	HideRegiPaperDlg(wnd);

	switch(wnd->nModel){
	case MODEL_LBP3310:
	case MODEL_LBP6300:
	case MODEL_LBP6310:
	case MODEL_LBP6340:
UI_DEBUG("\n");
UI_DEBUG("Register Paper LBP3310");
UI_DEBUG("\n");
		Show3310MsgDlg(wnd, cas1, cas2);
		break;
	}

	for(i = 0; i < wnd->regipaper_dlg->cas_num; i++){
		if(cnsktSetReqLong(wnd->pCnskt, DREQ_REGIPAPER_SET_LENGTH) < 0)
			goto err;
		if(cnsktSetReqLong(wnd->pCnskt, DREQ_SET_INPUTINFO) < 0)
			goto err;
		switch(i){
		case 0:
			if(cnsktSetReqLong(wnd->pCnskt, REGIPAPER_CAS1) < 0)
				goto err;
			if(cnsktSetReqLong(wnd->pCnskt, cas1) < 0)
				goto err;
			break;
		case 1:
			if(cnsktSetReqLong(wnd->pCnskt, REGIPAPER_CAS2) < 0)
				goto err;
			if(cnsktSetReqLong(wnd->pCnskt, cas2) < 0)
				goto err;
			break;
		case 2:
			if(cnsktSetReqLong(wnd->pCnskt, REGIPAPER_CAS3) < 0)
				goto err;
			if(cnsktSetReqLong(wnd->pCnskt, cas3) < 0)
				goto err;
			break;
		case 3:
			if(cnsktSetReqLong(wnd->pCnskt, REGIPAPER_CAS4) < 0)
				goto err;
			if(cnsktSetReqLong(wnd->pCnskt, cas4) < 0)
				goto err;
			break;
		default:
			if(cnsktSetReqLong(wnd->pCnskt, 0) < 0)
				goto err;
			if(cnsktSetReqLong(wnd->pCnskt, PAPERID_A4) < 0)
				goto err;
			break;
		}
		if(cnsktSetReqLong(wnd->pCnskt, 0) < 0)
			goto err;
		if(cnsktSetReqLong(wnd->pCnskt, 0) < 0)
			goto err;
		if(cnsktSetReqLong(wnd->pCnskt, 0) < 0)
			goto err;

		if(SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0)
			goto err;
	}
	return;
err:
	ShowMsgDlg(wnd, MSG_TYPE_COMMUNICATION_ERR_SET);
}

static gboolean CheckPaperIDfromPaperIDLIST( int model, int lang, int cas, int id, long region)
{
	int *idlist = GetIDList(model, lang, cas, region);
	gboolean ExitID = FALSE;
	int loop = 0;

	if(idlist != NULL)
	{
		for(loop = 0; idlist[loop] != -1; loop++){
			if(id == idlist[loop]){
				ExitID = TRUE;
				break;
			}
		}
	} else {
		ExitID = FALSE;
	}

	return ExitID;
}

static void InitRegiPaperDlgWidgets2_LBP9100(UIStatusWnd *wnd, long region)
{
	GtkWidget *window = UI_DIALOG(wnd->regipaper_dlg)->window;
	int i = 0;
	int model = wnd->nModel;
	int title = TITLEID_CASSET1;

	SetTextEntry(window, "RegiPaper_Cas1_combo_entry", _(tPaperIDTbl_2[0].str));
	SetWidgetSensitive(window, "RegiPaper_Cas1_hbox", FALSE);
	SetTextEntry(window, "RegiPaper_Cas2_combo_entry", _(tPaperIDTbl_2[0].str));
	SetWidgetSensitive(window, "RegiPaper_Cas2_hbox", FALSE);

	ShowWidget(window, "RegiPaper_Cas3_hbox");
	ShowWidget(window, "RegiPaper_Cas4_hbox");

	SetTextEntry(window, "RegiPaper_Cas3_combo_entry", _(tPaperIDTbl_2[0].str));
	SetWidgetSensitive(window, "RegiPaper_Cas3_hbox", FALSE);
	SetTextEntry(window, "RegiPaper_Cas4_combo_entry", _(tPaperIDTbl_2[0].str));
	SetWidgetSensitive(window, "RegiPaper_Cas4_hbox", FALSE);

	for(i = 0; i < wnd->regipaper_dlg->cas_num; i++){
		GList *glist = NULL;
		int *idlist = NULL;
		int lang = wnd->nLangType;
		char *cur = NULL, *tmp_cur = NULL;
		int id = 0;
		gboolean ExitID = FALSE;

		idlist = GetIDList(model, lang, i, region);
		glist = IDListToGList(model,idlist);
		cur = IDtoStr(model,PAPERID_UNKNOWN);

		switch(i){
		case 0:
			id = wnd->regipaper_dlg->paper_cas1;
			ExitID = CheckPaperIDfromPaperIDLIST(model, lang, i, id, region);
			if(ExitID != FALSE){
				if( (tmp_cur = IDtoStr(model,id)) != NULL )
				{
					cur = tmp_cur;
				}
			}
			SetWidgetSensitive(window, "RegiPaper_Cas1_hbox", TRUE);
			SetGListToCombo(window, glist, "RegiPaper_Cas1_combo", cur);
			break;
		case 1:
			id = wnd->regipaper_dlg->paper_cas2;
			ExitID = CheckPaperIDfromPaperIDLIST(model, lang, i, id, region);
			if(ExitID != FALSE){
				if( (tmp_cur = IDtoStr(model,id)) != NULL )
				{
					cur = tmp_cur;
				}
			}
			SetWidgetSensitive(window, "RegiPaper_Cas2_hbox", TRUE);
			SetGListToCombo(window, glist, "RegiPaper_Cas2_combo", cur);
			break;
		case 2:
			id = wnd->regipaper_dlg->paper_cas3;
			ExitID = CheckPaperIDfromPaperIDLIST(model, lang, i, id, region);
			if(ExitID != FALSE){
				if( (tmp_cur = IDtoStr(model,id)) != NULL ){
					cur = tmp_cur;
				}
			}
			SetWidgetSensitive(window, "RegiPaper_Cas3_hbox", TRUE);
			SetGListToCombo(window, glist, "RegiPaper_Cas3_combo", cur);
			break;
		case 3:
			id = wnd->regipaper_dlg->paper_cas4;
			ExitID = CheckPaperIDfromPaperIDLIST(model, lang, i, id, region);
			if(ExitID != FALSE){
				if( (tmp_cur = IDtoStr(model,id)) != NULL ){
					cur = tmp_cur;
				}
			}
			SetWidgetSensitive(window, "RegiPaper_Cas4_hbox", TRUE);
			SetGListToCombo(window, glist, "RegiPaper_Cas4_combo", cur);
			break;
		default:
			break;
		}
		g_list_free(glist);
	}

	SetLabel(wnd);

	switch(model){
		case MODEL_LBP9200:
			title = TITLEID_DRAWER1;
			break;
		default:
			title = TITLEID_CASSET1;
			break;
	}

	SetDialogTitle(window, _(tTitleTbl[title]));
}



