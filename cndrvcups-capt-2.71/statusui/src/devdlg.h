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


#ifndef	_DEVDLG
#define	_DEVDLG

#include "dialog.h"

typedef struct{
	UIDialog dialog;
	int printer_flag;
	int num_cassette;
	int size_tray;
	int size_cas1;
	int size_cas2;
	int size_cas3;
	int size_cas4;
	int user_flag;
	int mask_tray;
	int mask_cas1;
	int mask_cas2;
	int mask_cas3;
	int mask_cas4;
	int mask_dplx;
}UIDevDlg;

UIDevDlg* CreateDevDlg(UIDialog *parent);
#endif

