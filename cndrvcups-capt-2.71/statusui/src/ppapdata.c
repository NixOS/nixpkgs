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

#include <cups/cups.h>
#include "uimain.h"
#include "cnsktmodule.h"

enum {
	ARROW_POSITION_LONG,
	ARROW_POSITION_SHORT,
};

enum {
	SOURCE_MANUAL = 0,
	SOURCE_CAS1,
	SOURCE_CAS2,
	SOURCE_CAS3,
	SOURCE_CAS4,
};

typedef struct{
	int num;
	char *value;
}SourceValueTable;

SourceValueTable SourceValueTbl[] = {
	{SOURCE_MANUAL, "Manual"},
	{SOURCE_CAS1, "Cas1"},
	{SOURCE_CAS2, "Cas2"},
	{SOURCE_CAS3, "Cas3"},
	{SOURCE_CAS4, "Cas4"},
	{-1, NULL},
};

typedef struct{
	int num;
	char *value;
	int arrow_position;
}PaperValueTable;

PaperValueTable PaperValueTbl[] = {
	{PAPER_UNKNOWN, "A4", ARROW_POSITION_LONG},
	{PAPER_A3, "A3", ARROW_POSITION_SHORT},
	{PAPER_A4, "A4", ARROW_POSITION_LONG},
	{PAPER_A5, "A5", ARROW_POSITION_LONG},
	{PAPER_B4, "B4", ARROW_POSITION_SHORT},
	{PAPER_B5, "B5", ARROW_POSITION_LONG},
	{PAPER_EXECTIVE, "Executive", ARROW_POSITION_LONG},
	{PAPER_LEDGER, "Ledger", ARROW_POSITION_SHORT},
	{PAPER_LEGAL, "Legel", ARROW_POSITION_SHORT},
	{PAPER_LETTER, "Letter", ARROW_POSITION_LONG},
	{-1, NULL, -1},
};

PaperValueTable PaperValueTbl_2[] = {
	{PAPERID_UNKNOWN, "A4", ARROW_POSITION_LONG},
	{PAPERID_A3, "A3", ARROW_POSITION_SHORT},
	{PAPERID_A4, "A4", ARROW_POSITION_LONG},
	{PAPERID_A5, "A5", ARROW_POSITION_LONG},
	{PAPERID_B4, "B4", ARROW_POSITION_SHORT},
	{PAPERID_B5, "B5", ARROW_POSITION_LONG},
	{PAPERID_EXECUTIVE, "Executive", ARROW_POSITION_LONG},
	{PAPERID_LEDGER, "Ledger", ARROW_POSITION_SHORT},
	{PAPERID_LEGAL, "Legel", ARROW_POSITION_SHORT},
	{PAPERID_LETTER, "Letter", ARROW_POSITION_LONG},
	{PAPERID_16K, "16K", ARROW_POSITION_LONG},
	{PAPERID_8K, "8K", ARROW_POSITION_LONG},
	{-1, NULL, -1},
};

#define	PPAP_TMPDATA_PATH	"/tmp/cnppap_data_%d.ps"

#define	COMMENT "%%!PS-Adobe-3.0\n%%%%BoundingBox: 0 0 %d %d\n%%%%Creator: captstatusui\n%%%%Title: Printing Position Adjustment Print\n%%%%LanguageLevel: 2\n%%%%PageOrder: Ascend\n%%%%Pages: %d\n%%%%EndComments\n"

#define	PAGE_SETUP "%%%%Page: %d %d\n%%%%BeginPageSetup\n%%%%BeginPageFeature: *PageSize %s\n<</PageSize[%d %d]>>setpagedevice\n%%%%EndFeature\n%%%%EndPageSetup\n0.4 setlinewidth\n"

#define	TA "gsave\n/ta {newpath\n0 0 moveto\n28 0 lineto\n28 28 lineto\n0 28 lineto\nclosepath\n0 14 moveto\n28 14 lineto\n14 0 moveto\n14 28 lineto\n}def\n%.3f %.3f translate\nta stroke\n%.3f 0 translate\nta stroke\n%.3f 0 translate\nta stroke\n0 %.3f translate\nta stroke\n0 %.3f translate\nta stroke\n-%.3f 0 translate\nta stroke\n-%.3f 0 translate\nta stroke\n0 -%.3f translate\nta stroke\n"

#define	YOKOYA "grestore\ngsave\n/yokoya{\n0 0 moveto\n29 -23.5 lineto\n29 23.5 lineto\nclosepath\n29 10 moveto\n29 -10 lineto\n56 -10 lineto\n56 10 lineto\nclosepath\n}def\n%.3f %.3f translate\nyokoya fill\n"

#define TATEYA "grestore\ngsave\n/tateya{\n0 0 moveto\n-23.5 -29 lineto\n23.5 -29 lineto\nclosepath\n-10 -29 moveto\n10 -29 lineto\n10 -56 lineto\n-10 -56 lineto\n}def\n%.3f %.3f translate\ntateya fill\n"

#define	PAGE_END "showpage\n%%PageTrailer\n"

#define	ENDOFFILE "%%Trailer\n%%EOF\n\n"

static int MakePPAData(FILE *fp, ppd_size_t *size, char *paper, int duplex);
static int PrintFile(char *printer, char *tmp_file, char *src, int duplex);

char* GetSourceValue(int num)
{
	int i = 0;
	while(SourceValueTbl[i].num != -1){
		if(SourceValueTbl[i].num == num)
			return SourceValueTbl[i].value;
		i++;
	}
	return NULL;
}

char* GetPaperValue(int num, int model)
{
	int i = 0;

	PaperValueTable* tbl = NULL;
	switch(model){
	case MODEL_LBP9100:
	case MODEL_LBP9200:
		tbl = PaperValueTbl_2;
		break;
	default:
		tbl = PaperValueTbl;
		break;
	}
	while(tbl[i].num != -1){
		if(tbl[i].num == num)
			return tbl[i].value;
		i++;
	}
	return NULL;
}

int GetArrowPosition(char *paper)
{
	int i = 0;
	if(paper == NULL)
		return 0;

	while(PaperValueTbl[i].num != -1){
		if(strcmp(PaperValueTbl[i].value, paper) == 0)
			return PaperValueTbl[i].arrow_position;
		i++;
	}
	return 0;
}

int PrintPPAData(char *printer, int inputslot, int pagesize, int duplex, int model)
{
	FILE *fp;
	char *src, *paper;
	char tmp_file[512];
	char *ppdfile;
	pid_t pid = 0;
	ppd_file_t *ppd;
	ppd_size_t *size;

	if(printer == NULL)
		return -1;

	src = GetSourceValue(inputslot);
	if(src == NULL)
		return -1;

	paper = GetPaperValue(pagesize, model);
	if(paper == NULL)
		return -1;

	ppdfile = (char *)cupsGetPPD(printer);
	ppd = ppdOpenFile(ppdfile);
	size = ppdPageSize(ppd, paper);

	pid = getpid();
	snprintf(tmp_file, 512, PPAP_TMPDATA_PATH, (int)pid);

	if((fp = fopen(tmp_file, "w+")) == NULL)
		return -1;

	if(MakePPAData(fp, size, paper, duplex) < 0)
		return -1;

	PrintFile(printer, tmp_file, src, duplex);
	unlink(tmp_file);
	unlink(ppdfile);
	return 0;
}


static int PrintFile(char *printer, char *tmp_file, char *src, int duplex)
{
	int opt_num = 0;
	int jobid = 0;
	cups_option_t *options;
	opt_num = cupsAddOption("InputSlot", src, opt_num, &options);
	if(duplex)
		opt_num = cupsAddOption("Duplex", "DuplexNoTumble", opt_num, &options);
	opt_num = cupsAddOption("CNPPAPrint", "1", opt_num, &options);

	jobid = cupsPrintFile(printer, tmp_file, NULL, opt_num, options);
	cupsFreeOptions(opt_num, options);
	unlink(tmp_file);
	return jobid;
}

static int WriteComment(FILE *fp, ppd_size_t *size, int pages)
{
	int width = size->width;
	int height = size->length;
	char buf[1024];
	memset(buf, 0, 1024);

	snprintf(buf, 1023, COMMENT, width, height, pages);
	fwrite(buf, strlen(buf), 1, fp);
	return 0;
}

static int WritePageEnd(FILE *fp)
{
	fwrite(PAGE_END, 1, strlen(PAGE_END), fp);
	return 0;
}

static int WriteFileEnd(FILE *fp)
{
	fwrite(ENDOFFILE, 1, strlen(ENDOFFILE), fp);
	return 0;
}


static int WritePageSetup(FILE *fp, ppd_size_t *size, int page, char *paper)
{
	int width = size->width;
	int height = size->length;
	char buf[1024];
	memset(buf, 0, 1024);

	snprintf(buf, 1023, PAGE_SETUP, page, page, paper, width, height);
	fwrite(buf, strlen(buf), 1, fp);
	return 0;
}

static int WriteTaData(FILE *fp, ppd_size_t *size)
{
	float left = size->left;
	float bottom = size->bottom;
	float x = size->width / 2 - left - 14;
	float y = size->length / 2 - bottom - 14;
	char buf[1024];
	memset(buf, 0, 1024);

	snprintf(buf, 1023, TA, left, bottom, x, x, y, y, x, x, y);
	fwrite(buf, strlen(buf), 1, fp);
	return 0;
}

static int WriteYokoyaData(FILE *fp, ppd_size_t *size)
{
	float x = size->left + 47.0;
	float y = size->length / 2.0;
	char buf[1024];
	memset(buf, 0, 1024);

	snprintf(buf, 1023, YOKOYA, x, y);
	fwrite(buf, strlen(buf), 1, fp);
	return 0;
}

static int WriteTateyaData(FILE *fp, ppd_size_t *size)
{
	float x = size->width / 2.0;
	float y = size->top - 47.0;
	char buf[1024];
	memset(buf, 0, 1024);

	snprintf(buf, 1023, TATEYA, x, y);
	fwrite(buf, strlen(buf), 1, fp);
	return 0;
}


static int MakePPAData(FILE *fp, ppd_size_t *size, char *paper, int duplex)
{
	int i = 0;
	int pages = duplex ? 2 : 1;

	WriteComment(fp, size, pages);

	for(i = 0; i < pages; i++){
		WritePageSetup(fp, size, i + 1, paper);
		WriteTaData(fp, size);
		if(GetArrowPosition(paper))
			WriteTateyaData(fp, size);
		else
			WriteYokoyaData(fp, size);
		WritePageEnd(fp);
	}

	WriteFileEnd(fp);

	fclose(fp);
	return 0;
}

int PrintCleaning(char *printer, char *data)
{
	int opt_num = 0;
	int jobid = 0;
	cups_option_t *options;

	opt_num = cupsAddOption("raw", "True", opt_num, &options);

	jobid = cupsPrintFile(printer, data, NULL, opt_num, options);
	cupsFreeOptions(opt_num, options);
	return jobid;
}

int ExecuteCleaning(UIStatusWnd *wnd)
{
	if( cnsktSetReqLong(wnd->pCnskt,  DATA_LENGTH_LONG * 2) < 0 )
		goto error;
	if( cnsktSetReqLong(wnd->pCnskt, DREQ_CLEANING) < 0 )
		goto error;
	if( cnsktSetReqLong(wnd->pCnskt, DREQ_CLEANING_MODE1) < 0 )
		goto error;
	if( SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0 )
		goto error;

	return 0;

error:
	HideMsgDlg(wnd);
	ShowMsgDlg( wnd, MSG_TYPE_PERFORM_CLEANING_ERR );
	return -1;
}

int ExecuteCleaning2(UIStatusWnd *const wnd, const long command)
{
	int ret = 0;
	if(wnd != NULL){
		if( cnsktSetReqLong(wnd->pCnskt,  DATA_LENGTH_LONG) < 0 ){
			ret = -1;
		}
		if( cnsktSetReqLong(wnd->pCnskt, command) < 0 ){
			ret = -1;
		}
		if( SendRequest(wnd, CCPD_DEVICE_REQUEST) < 0 ){
			ret = -1;
		}
	}

	return ret;
}
