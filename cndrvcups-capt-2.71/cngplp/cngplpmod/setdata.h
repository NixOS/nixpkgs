/*
 *  Print Dialog for Canon LIPS/PS/LIPSLX/UFR2/CAPT Printer.
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


#ifndef	_SETDATA
#define	_SETDATA

#ifdef __cplusplus
extern "C" {
#endif

char* SetDataPPD(cngplpData *data, int id, char *value);
char* SetDataCommon(cngplpData *data, int id, char *value);
char* SetDataImage(cngplpData *data, int id, char *value);
char* SetDataText(cngplpData *data, int id, char *value);
char* SetDataHPGL(cngplpData *data, int id, char *value);
void BottomEvent(cngplpData *data, int id, char *value);
int CreateSaveOptions(cngplpData *data);
void DeleteSaveOptions(cngplpData *data);

#ifdef __cplusplus
}
#endif

#endif
