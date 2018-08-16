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


#ifndef	_CCINFODLG
#define	_CCINFODLG

#include "dialog.h"

typedef struct{
	UIDialog dialog;
	long warning1;
	long warning2;
	long warning3;
	long warning4;
	long absent;
	long misplas;
	long memerror;
	long mounterror;
	long sealedrror;
	long counterBWSmall;
	long counterBWLarge;
	long counterColorSmall;
	long counterColorLarge;
	long counterDuplexBWSmall;
	long counterDuplexBWLarge;
	long counterDuplexColorSmall;
	long counterDuplexColorLarge;
	long counterJobs;
}UICCInfoDlg;

UICCInfoDlg* CreateCCInfoDlg(UIDialog *parent);
#endif

