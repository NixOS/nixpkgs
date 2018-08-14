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

#ifndef	_MSGDLG
#define	_MSGDLG

#include "dialog.h"

enum{
	MSG_TYPE_CLEANING1,
	MSG_TYPE_CLEANING2,
	MSG_TYPE_PRINT_PPAP,
	MSG_TYPE_COMMUNICATION_ERR,
	MSG_TYPE_HIDE_MONITOR,
	MSG_TYPE_CLEANING,
	MSG_TYPE_COMMUNICATION_ERR_SET,
	MSG_TYPE_COMMUNICATION_ERR_GET,
	MSG_TYPE_PERFORM_CALIB_ERR,
	MSG_TYPE_CCINFO_GET_ERR,
	MSG_TYPE_CONSUMABLEINFO_GET_ERR,
	MSG_TYPE_COUNTERINFO_GET_ERR,
	MSG_TYPE_CALIBRATION,
	MSG_TYPE_IP_INCORRECT,
	MSG_TYPE_GATE_INCORRECT,
	MSG_TYPE_SUB_INCORRECT,
	MSG_TYPE_PWD_INCORRECT,
	MSG_TYPE_CLEANING_3300,
	MSG_TYPE_REGIPAPER_3300_A4,
	MSG_TYPE_REGIPAPER_3300_LTR,
	MSG_TYPE_REGIPAPER_3300_LGL,
	MSG_TYPE_REGIPAPER_3300_A4_LTR,
	MSG_TYPE_REGIPAPER_3300_A4_LGL,
	MSG_TYPE_REGIPAPER_3300_LTR_LGL,
	MSG_TYPE_CLEANING_DATA,
	MSG_TYPE_DEVREQ_REGICLR,
	MSG_TYPE_DEVREQ_CALIB,
	MSG_TYPE_PERFORM_REGICLR_ERR,
	MSG_TYPE_PERFORM_CLEANING_ERR,
	MSG_TYPE_PERFORM_REDUCE_STREAKS,
	MSG_TYPE_CLEANING1_DATA,
	MSG_TYPE_CLEANING2_CMD,
	MSG_TYPE_DEVICE_REBOOT,
	MSG_TYPE_RESET_UNIT,
	MSG_TYPE_DEVREQ_CLRMIS,
};

enum{
	BTN_TYPE_NONE,
	BTN_TYPE_OK,
	BTN_TYPE_CANCEL,
	BTN_TYPE_OKCANCEL,
};


typedef struct{
	UIDialog dialog;
	int type;
}UIMsgDlg;

#endif
