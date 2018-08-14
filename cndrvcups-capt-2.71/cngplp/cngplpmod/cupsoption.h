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

#ifndef	_CUPSOPTION
#define	_CUPSOPTION

#ifdef __cplusplus
extern "C" {
#endif

#include "cngplpmod.h"

#define DEFOPT_PAGESEL	0
#define	DEFOPT_REVERSE	0
#define	DEFOPT_ORIENT	3
#define	DEFOPT_NUP	0
#define	DEFOPT_BRIGHT	100
#define	DEFOPT_GAMMA	1000
#define	DEFOPT_BANNER_S	0
#define	DEFOPT_BANNER_E	0
#define	DEFOPT_FILTER	0
#define	DEFOPT_IMG_HUE	0
#define	DEFOPT_IMG_SATU	100
#define	DEFOPT_IMG_RESO	128
#define	DEFOPT_IMG_POSI	4
#define	DEFOPT_IMG_SCL	100
#define	DEFOPT_TXT_CPI	10
#define	DEFOPT_TXT_LPI	6
#define	DEFOPT_TXT_CLMN	1
#define	DEFOPT_HPGL_BP	0
#define	DEFOPT_HPGL_FP	0
#define	DEFOPT_HPGL_PW	1000

extern char *g_filter_options[];
extern char *g_banner_option[];
extern CupsOptionTxtVal NupTextValue_table[];

void InitCupsOptions(CupsOptions *cups_opt);
void ResetCupsOptions(cngplpData *data);
void FreeCupsOptVal(CupsOptVal *option);
void FreeCupsOptions(CupsOptions *cups_opt);
CupsOptVal* GetCupsOptVal(CupsOptVal *option, char *key);
int SetCupsOption(cngplpData *data, CupsOptVal *option, char *key, char *value);
int AddCupsOption(CupsOptVal *option, char *key, char *value);
int GetCupsValueInt(CupsOptVal *option, char *key);
char* GetCupsValueChar(CupsOptVal *option, char *key);

char* GetCupsValue(CupsOptVal *option, char *key);
char* IDtoCommonOption(int index);
char* IDtoImageOption(int index);
char* IDtoTextOption(int index);
char* IDtoHPGLOption(int index);
int CreateCupsOptions(cngplpData *data);
void DeleteCupsOptions(CupsOptions *cups_opt);

#ifdef __cplusplus
}
#endif

#endif
