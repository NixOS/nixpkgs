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

#ifndef _UIMAIN
#define _UIMAIN

#include "dialog.h"
#include "cnsktmodule.h"
#include "ppapdlg.h"
#include "devdlg.h"
#include "msgdlg.h"
#include "ccinfodlg.h"
#include "regipaperdlg.h"
#include "sleepsdlg.h"
#include "networksdlg.h"
#include "cancelkeydlg.h"
#include "asstprtsdlg.h"
#include "startupsettingsdlg.h"
#include "cassetteset2dlg.h"
#include "multitraydlg.h"
#include "ppavhdlg.h"
#include "resetunitdlg.h"
#include "cleaningdlg.h"
#include "tonerreplacementdlg.h"
#include "calibrationsettingsdlg.h"

#ifdef _UI_DEBUG
#define UI_DEBUG(fmt, args...) fprintf( stderr,"UI >> " fmt, ##args)
#else
#define UI_DEBUG(fmt, args...)
#endif

typedef struct{
	UIDialog dialog;
	char *host_name;
	int socket_fd;
	int mode;
	time_t time;
	int exit;
	int retry;

	int cleaning;
	int ppap;
	UIPPAPDlg *ppap_dlg;
	int dev;
	UIDevDlg *dev_dlg;
	int cas_num;
	int dplx;
	UIMsgDlg *msg_dlg;

	char *tocode;
	char *fromcode;
	char *text1;
	char *text2;
	char *tmp_text2;
	CnsktModule *pCnskt;
	gboolean enableJobOperate;

	int nConsumableCounters;
	UICCInfoDlg *ccinfo_dlg;

	int nCalibration;

	guint32 nRegiPapersize;
	char **pRegiPaperList;
	UIRegiPaperDlg *regipaper_dlg;

	gint32 nSleepSetting;
	char **pSleepTimeList;
	UISleepSettingDlg *sleeps_dlg;

	int nCancelJobKey;
	UICancelJobKeyDlg *cancelkey_dlg;

	int nNetworkSettings;
	UINetWorkSDlg *networks_dlg;

	int nModel;
	int nic_flag;
	int bMenuDisable;
	int nIFVersion;
	int nLangType;
	char *data_path;
	char pAlertCode[128];
	int isJobDisable;

	gint32 nAsstPrtSetting;
	char **pModeList;
	UIAsstPrtSDlg *asstprts_dlg;

	UIStartupSettingsDlg *startupsettings_dlg;
	int nControlKeyFlag;

	UICassetteSet2Dlg *cassetteset2_dlg;
	UIMultiTrayDlg *multitray_dlg;
	UIPPAVHDlg *ppavh_dlg;
	UIResetUnitDlg *resetunit_dlg;
	UITonerReplacementDlg *toner_replacement_dlg;
	UICleaningDlg *cleaning_dlg;
	UICalibrationSettingsDlg *calibration_Settings_dlg;
}UIStatusWnd;

UIStatusWnd *g_status_window;

enum {
	ID_STR_UNKNOWN_ERROR,
	ID_STR_NOPRINTER,
	ID_STR_PRINTER_ERROR,
	ID_STR_FIFO_ERROR,
	ID_STR_PRINTER_ENTRY,
	ID_STR_DEVICE_PATH,
	ID_STR_DEVICE_URI,
};

#define	REQ_SHOWDLG		0x8000
#define	REQ_SHOWDLG_REGIPAPER	0x8001
#define	REQ_SHOWDLG_SLEEPS		0x8002U
#define	REQ_SHOWDLG_CCINFO		0x8003U
#define	REQ_SHOWDLG_CANCELJOB	0x8004
#define	REQ_SHOWDLG_NETWORKS	0x8005
#define	REQ_SHOWDLG_ASSTPRT	0x8006
#define	REQ_SHOWDLG_STARTUPSET	0x8007
#define	REQ_SHOWDLG_CASSETTESET2	0x8008
#define	REQ_SHOWDLG_MULTITRAY	0x8009
#define	REQ_SHOWDLG_PPAVH	0x800A
#define	REQ_SHOWDLG_RESETUNIT	0x800B
#define	REQ_SHOWDLG_PPAP	0x800C
#define	REQ_SHOWDLG_CLEANING	0x800DU
#define	REQ_SHOWDLG_CALIBRATIONSETTINGS	0x800EU
#define	REQ_SHOWDLG_CONSUMABLESINFO	0x800FU
#define	REQ_SHOWDLG_COUNTERSINFO	0x8010U

#define	REQ_UPDATE_CONSUMABLESINFO_OF_TONERREPLACEMENT 0x8100U

#define	OPEREQ_COMMAND	0x7000
#define	OPEREQ_PAUSE	0x7001
#define	OPEREQ_RESUME	0x7002
#define	OPEREQ_CANCEL	0x7003

#define	PRINTER_INFO_NIC_CHECK	0x100
#define	PRINTER_INFO_NIC_ON	0x101
#define	PRINTER_INFO_NIC_OFF	0x102

#define MODEL_LANG_JP   1000
#define MODEL_LANG_UK   2000
#define MODEL_LANG_US   3000
#define	MODEL_VER_100	0
#define	MODEL_LBP3000	1
#define	MODEL_LBP3210	2
#define	MODEL_LBP3600	3
#define	MODEL_LBP5000	4
#define	MODEL_LBP3300	5
#define	MODEL_LBP5300	7
#define	MODEL_LBP5100	8
#define	MODEL_LBP3500	9
#define	MODEL_LBP3310	11
#define MODEL_LBP3100   12
#define MODEL_LBP3050   13
#define	MODEL_LBP5050	14
#define	MODEL_LBP3250	15
#define	MODEL_LBP7200	16
#define	MODEL_LBP9100	17
#define	MODEL_LBP6300	18
#define	MODEL_LBP6000	19
#define	MODEL_LBP6200	20
#define	MODEL_LBP7010 21
#define	MODEL_LBP9200 22
#define	MODEL_LBP6300N 23
#define	MODEL_LBP6020 24
#define	MODEL_LBP6310 25
#define	MODEL_LBP6340 (MODEL_LBP6310 + MODEL_LANG_JP)
#define	MODEL_LBP7210 26

#define	CCPD_IF_VERSION_100	0
#define	CCPD_IF_VERSION_110	1

#define	LANG_TYPE_JP	1
#define	LANG_TYPE_UK	2
#define	LANG_TYPE_US	3
#define LANG_TYPE_US_STR	"US"

#define	PAPERID_LETTER				1
#define	PAPERID_LEDGER				3
#define	PAPERID_LEGAL				5
#define	PAPERID_STATEMENT			6
#define	PAPERID_EXECUTIVE			7
#define	PAPERID_A3				8
#define	PAPERID_A4				9
#define	PAPERID_A5				11
#define	PAPERID_B4				12
#define	PAPERID_B5				13
#define PAPERID_A6				70
#define	PAPERID_POSTCARD		43
#define	PAPERID_DBL_POSTCARD	82
#define	PAPERID_4X1_POSTCARD		4300
#define	PAPERID_ENV_YOU4			91
#define	PAPERID_ENV_YOU2			262
#define	PAPERID_ENV_CHOU3			73
#define	PAPERID_ENV_YOU_CHOU3		4620
#define	PAPERID_ENV_KAKU2			71
#define	PAPERID_ENV_MONARCH			37
#define	PAPERID_ENV_COM10			20
#define	PAPERID_ENV_C5				28
#define	PAPERID_ENV_DL				27
#define	PAPERID_ENV_B5				34
#define	PAPERID_12X18				4446
#define	PAPERID_INDEX3X5			4600
#define	PAPERID_16K				4328
#define	PAPERID_FOOLSCAP			14
#define	PAPERID_8K				4327
#define PAPERID_UNKNOWN				0

#define	max(a,b)	(((a)>(b))?(a):(b))

typedef struct{
	long nNameSize;
	char *pName;
	long nNumCas;
	long nUnit;
	long nFirm;
	long nNic;
	long nPort;
	long nDFlag;
}DREQPrtInfo;

typedef struct {
	long Region;
}DREQPrinterInfo;

UIStatusWnd *CreateStatusWnd(char *printer_name, int mode);
void UpdateWidgets(UIStatusWnd *wnd);
void UpdateWidgets2(UIStatusWnd *wnd);
void DataProc(gpointer data);
void DisposeStatusWnd(void);
void mem_free(void *pointer);

void CreateStatusWidgets(UIStatusWnd *wnd);
void ShowPPAPDlg(UIStatusWnd *wnd);
void HidePPAPDlg(UIStatusWnd *wnd);
void PPAPDlgOK(UIStatusWnd *wnd);
void PPAPDlgCancel(UIStatusWnd *wnd);

void ShowDevDlg(UIStatusWnd *wnd);
void HideDevDlg(UIStatusWnd *wnd);
void DevDlgOK(UIStatusWnd *wnd);
void DevDlgCancel(UIStatusWnd *wnd);

void ShowMsgDlg(UIStatusWnd *wnd, int type);
void HideMsgDlg(UIStatusWnd *wnd);
void MsgDlgOK(UIStatusWnd *wnd);
void MsgDlgCancel(UIStatusWnd *wnd);

int UpdateJob(long job_num);
void HideMonitor(UIStatusWnd *wnd);

int SendRequest(UIStatusWnd *wnd, int command);

void ShowRegiPaperDlg(UIStatusWnd *wnd);
void HideRegiPaperDlg(UIStatusWnd *wnd);
void RegiPaperDlgOK(UIStatusWnd *wnd);

void ShowSleepSettingDlg(UIStatusWnd *wnd);
void HideSleepSettingDlg(UIStatusWnd *wnd);
void SleepSettingDlgOK(UIStatusWnd *wnd);
void UpdateSleepSettingDlgWidgets(UIStatusWnd *wnd, int use_sleep);

void ShowCCInfoDlg(UIStatusWnd *wnd);
void HideCCInfoDlg(UIStatusWnd *wnd);
void CCInfoDlgOK(UIStatusWnd *wnd);
void ShowConsumablesInfoDlg(UIStatusWnd *const wnd);
void ShowCountersInfoDlg(UIStatusWnd *const wnd);

void ShowCancelJobKeyDlg(UIStatusWnd *wnd);
void HideCancelJobKeyDlg(UIStatusWnd *wnd);
void CancelJobKeyDlgOK(UIStatusWnd *wnd);
void UpdateCancelJobKeyDlgWidgets(UIStatusWnd *wnd, int errcancel);

void ShowNetWorkSDlg(UIStatusWnd *wnd);
void HideNetWorkSDlg(UIStatusWnd *wnd);
void NetWorkSDlgOK(UIStatusWnd *wnd);
void UpdateNetWorkSDlgWidgets(UIStatusWnd *wnd, int widget);
void CheckNetIPEntry(UIStatusWnd *wnd, gchar *name);

void CreateStatusWidgets_LBP3500(UIStatusWnd *wnd);
void CreateStatusWidgets_LBP5300(UIStatusWnd *wnd);

void RegiPaperDlgOK2(UIStatusWnd *wnd);

void ShowAsstPrtSDlg(UIStatusWnd *wnd);
void HideAsstPrtSDlg(UIStatusWnd *wnd);
void AsstPrtSDlgOK(UIStatusWnd *wnd);
void UpdateAsstPrtSDlgWidgets(UIStatusWnd *wnd, int use_mode);

int GetDREQPrtInfo(UIStatusWnd *wnd, DREQPrtInfo *info);

void CreateStatusWidgets_LBP5100(UIStatusWnd *wnd);

void CreateStatusWidgets_LBP3310(UIStatusWnd *wnd);

void CreateStatusWidgets_LBP3250(UIStatusWnd *wnd);

void CreateStatusWidgets_LBP3100(UIStatusWnd *wnd);

void CreateStatusWidgets_LBP5050(UIStatusWnd *wnd);
void CreateStatusWidgets_LBP7200(UIStatusWnd *wnd);
void ShowStartupSettingsDlg(UIStatusWnd *wnd);
void HideStartupSettingsDlg(UIStatusWnd *wnd);
void StartupSettingsDlgOK(UIStatusWnd *wnd);

void CreateStatusWidgets_LBP9100(UIStatusWnd *wnd);
void CreateStatusWidgets_LBP6300(UIStatusWnd *wnd);

void ShowCassetteSet2Dlg(UIStatusWnd *wnd);
void ShowMultiTrayDlg(UIStatusWnd *wnd);
void ShowPPAVHDlg(UIStatusWnd *wnd);
void ShowResetUnitDlg(UIStatusWnd *wnd);

void HideCassetteSet2Dlg(UIStatusWnd *wnd);
void HideMultiTrayDlg(UIStatusWnd *wnd);
void HidePPAVHDlg(UIStatusWnd *wnd);
void HideResetUnitDlg(UIStatusWnd *wnd);

void CassetteSet2DlgOK(UIStatusWnd *wnd);
void MultiTrayDlgOK(UIStatusWnd *wnd);
void PPAVHDlgOK(UIStatusWnd *wnd);
void ResetUnitDlgOK(UIStatusWnd *wnd);

void ShowPPAPDlg(UIStatusWnd *wnd);

void CreateStatusWidgets_LBP6000(UIStatusWnd* const wnd);

void CreateStatusWidgets_LBP6200(UIStatusWnd* const wnd);

int GetDREQPrinterInfo(UIStatusWnd* const wnd, DREQPrinterInfo* const info);
gboolean IsUS(const UIStatusWnd* const wnd);
void CreateStatusWidgets_LBP7010(UIStatusWnd* const wnd);

void ShowTonerReplacementDlg(UIStatusWnd *wnd);
void HideTonerReplacementDlg(UIStatusWnd *wnd);
void TonerReplacementDlgFinish(UIStatusWnd *wnd);
void TonerReplacementDlgCancel(UIStatusWnd *wnd);
void RequestRotate(UIStatusWnd *wnd, const long requestCode);
int UpdateConsumableInfo(UIStatusWnd* const wnd);

void ShowCleaningDlg(const UIStatusWnd *const wnd);
void HideCleaningDlg(const UIStatusWnd *const wnd);
void CleaningDlgOK(UIStatusWnd *const wnd);

void ShowCalibrationSettingsDlg(UIStatusWnd *wnd);
void HideCalibrationSettingsDlg(const UIStatusWnd *const wnd);
void UpdateCalibrationSettingsDlgWidgets(const UIStatusWnd *const wnd, const int use_timer);
void CalibrationSettingsDlgOK(UIStatusWnd *wnd);
void CreateStatusWidgets_LBP9200(UIStatusWnd* const wnd);

void CreateStatusWidgets_LBP7210(UIStatusWnd* const wnd);
void CreateStatusWidgets_LBP6310(UIStatusWnd* const wnd);
void CreateStatusWidgets_LBP6020(UIStatusWnd* const wnd);

void CreateStatusWidgets_LBP6340(UIStatusWnd* const wnd);

#endif


