/*

Copyright (c) 2003-2004, AXE, Inc.  All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <string.h>
#include <sys/types.h>
#include <signal.h>
#include <sys/wait.h>
#include <unistd.h>
#include "opvp_02.h"
#include "opvp_rpc_client_02.h"
#include "opvp_rpc_core.h"
#include "opvp_rpc_reqno_02.h"

int errorno = OPVP_OK;

static pid_t serverPid = -1;

static  OPVP_api_procs  apiList;

static void *rpcHandle;

static void crpcMsg(char *form,...)
{
#ifndef DBG_USAKO
    va_list ap;

    va_start(ap,form);
    vfprintf(stderr,form,ap);
    va_end(ap);
#else
    FILE *fd = NULL;
    va_list ap;

    fd = fopen("/tmp/usako.log", "a+");
    va_start(ap,form);
    vfprintf(fd,form,ap);
    va_end(ap);
    fclose(fd);
#endif
}

#if 0
int _init(void)
{
#ifdef DEBUG
    crpcMsg("loading RPC DRIVER...\n");
    crpcMsg("  apiList address is %08X\n", &apiList);
#endif

    return 0;
}

int _fini(void)
{
#ifdef DEBUG
    crpcMsg("unloading RPC DRIVER...\n");
#endif
    return 0;
}
#endif

static void sigtermHandler(int sig)
{
    if (serverPid > 0) {
		kill(serverPid,SIGTERM);
		waitpid(serverPid,NULL,0);
    }

	exit(0);
}



static int oprpc_waitReady(void *hp)
{
    int req;

    if (oprpc_getPktStart(hp) < 0) {
	return -1;
    }
    if (oprpc_getPkt(hp,(char *)&req,sizeof(req)) < 0) {
	return -1;
    }
    if (req != RPCNO_READY) {
	return -1;
    }
    if (oprpc_getPktEnd(hp) < 0) {
	return -1;
    }
    return 0;
}

static int setApiList(int nApiEntry, char *apiFlags)
{
    int i;
    typedef int (*Funp)();
    Funp *p;

    apiList.OpenPrinter	= OpenPrinter;
    apiList.ClosePrinter	= CStubClosePrinter;
    apiList.StartJob	= CStubStartJob;
    apiList.EndJob		= CStubEndJob;
    apiList.StartDoc	= CStubStartDoc;
    apiList.EndDoc		= CStubEndDoc;
    apiList.StartPage	= CStubStartPage;
    apiList.EndPage		= CStubEndPage;
    apiList.ResetCTM	= CStubResetCTM;
    apiList.SetCTM		= CStubSetCTM;
    apiList.GetCTM		= CStubGetCTM;
    apiList.InitGS		= CStubInitGS;
    apiList.SaveGS		= CStubSaveGS;
    apiList.RestoreGS	= CStubRestoreGS;
    apiList.QueryColorSpace	= CStubQueryColorSpace;
    apiList.SetColorSpace	= CStubSetColorSpace;
    apiList.GetColorSpace	= CStubGetColorSpace;
    apiList.QueryROP	= CStubQueryROP;
    apiList.SetROP		= CStubSetROP;
    apiList.GetROP		= CStubGetROP;
    apiList.SetFillMode	= CStubSetFillMode;
    apiList.GetFillMode	= CStubGetFillMode;
    apiList.SetAlphaConstant= CStubSetAlphaConstant;
    apiList.GetAlphaConstant= CStubGetAlphaConstant;
    apiList.SetLineWidth	= CStubSetLineWidth;
    apiList.GetLineWidth	= CStubGetLineWidth;
    apiList.SetLineDash	= CStubSetLineDash;
    apiList.GetLineDash	= CStubGetLineDash;
    apiList.SetLineDashOffset= CStubSetLineDashOffset;
    apiList.GetLineDashOffset= CStubGetLineDashOffset;
    apiList.SetLineStyle	= CStubSetLineStyle;
    apiList.GetLineStyle	= CStubGetLineStyle;
    apiList.SetLineCap	= CStubSetLineCap;
    apiList.GetLineCap	= CStubGetLineCap;
    apiList.SetLineJoin	= CStubSetLineJoin;
    apiList.GetLineJoin	= CStubGetLineJoin;
    apiList.SetMiterLimit	= CStubSetMiterLimit;
    apiList.GetMiterLimit	= CStubGetMiterLimit;
    apiList.SetPaintMode	= CStubSetPaintMode;
    apiList.GetPaintMode	= CStubGetPaintMode;
    apiList.SetStrokeColor	= CStubSetStrokeColor;
    apiList.SetFillColor	= CStubSetFillColor;
    apiList.SetBgColor	= CStubSetBgColor;
    apiList.NewPath		= CStubNewPath;
    apiList.EndPath		= CStubEndPath;
    apiList.StrokePath	= CStubStrokePath;
    apiList.FillPath	= CStubFillPath;
    apiList.StrokeFillPath	= CStubStrokeFillPath;
    apiList.SetClipPath	= CStubSetClipPath;
    apiList.SetCurrentPoint	= CStubSetCurrentPoint;
    apiList.LinePath	= CStubLinePath;
    apiList.PolygonPath	= CStubPolygonPath;
    apiList.RectanglePath	= CStubRectanglePath;
    apiList.RoundRectanglePath= CStubRoundRectanglePath;
    apiList.BezierPath	= CStubBezierPath;
    apiList.ArcPath		= CStubArcPath;
    apiList.DrawBitmapText	= CStubDrawBitmapText;
    apiList.DrawImage	= CStubDrawImage;
    apiList.StartDrawImage	= CStubStartDrawImage;
    apiList.TransferDrawImage= CStubTransferDrawImage;
    apiList.EndDrawImage	= CStubEndDrawImage;
    apiList.StartScanline	= CStubStartScanline;
    apiList.Scanline	= CStubScanline;
    apiList.EndScanline	= CStubEndScanline;
    apiList.StartRaster	= CStubStartRaster;
    apiList.TransferRasterData= CStubTransferRasterData;
    apiList.SkipRaster	= CStubSkipRaster;
    apiList.EndRaster	= CStubEndRaster;
    apiList.StartStream	= CStubStartStream;
    apiList.TransferStreamData= CStubTransferStreamData;
    apiList.EndStream	= CStubEndStream;
#if (_PDAPI_VERSION_MAJOR_ > 0 || _PDAPI_VERSION_MINOR_ >= 2)
    apiList.QueryDeviceCapability = CStubQueryDeviceCapability;
    apiList.QueryDeviceInfo = CStubQueryDeviceInfo;
    apiList.ResetClipPath = CStubResetClipPath;
#endif

    p = (Funp *)&apiList;
    for (i = 0;i < nApiEntry;i++) {
	if (apiFlags[i] == 0) {
	    p[i] = NULL;
	}
    }

    return 0;
}

static int outPipe[2];
static int inPipe[2];

static int CStubDoSimple1(int reqNo, int printerContext)
{
    int seqNo;

    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, reqNo)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return seqNo;
}

static int CStubSimple1(int reqNo, int printerContext)
{
    return CStubDoSimple1(reqNo, printerContext) >= 0 ? OPVP_OK : -1;
}

static int CStubDoSimple2(int reqNo, int printerContext, int arg1)
{
    int seqNo;

    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, reqNo)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&arg1) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return seqNo;
}

static int CStubSimple2(int reqNo, int printerContext, int arg1)
{
    return CStubDoSimple2(reqNo,printerContext,arg1) >= 0 ? OPVP_OK:-1;
}

static int checkResponse(int seqNo, int reqNo)
{
    int rreqNo;
    int rseqNo;
    int err = 0;

reenter:
    if ((rseqNo = oprpc_getPktStart(rpcHandle)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if ((oprpc_getPkt(rpcHandle,(char *)&rreqNo,sizeof(rreqNo))) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (rreqNo < 0) {
	errorno = rreqNo;
	if ((oprpc_getPkt(rpcHandle,(char *)&rreqNo,sizeof(rreqNo))) < 0) {
	    errorno = OPVP_FATALERROR;
	    return -1;
	}
	fprintf(stderr,"Error Response:ReqNo=%d, SeqNo=%d,errorno=%d\n",
	   rreqNo,rseqNo,errorno);
	if (oprpc_getPktEnd(rpcHandle) < 0) {
	    errorno = OPVP_FATALERROR;
	    return -1;
	}
	err = -1;
	if (rseqNo != seqNo) {
	    goto reenter;
	}
	return -1;
    }
    if (rseqNo != seqNo) {
	errorno = OPVP_FATALERROR;
	err = -1;
    }
    if (rreqNo != reqNo) {
	errorno = OPVP_FATALERROR;
	err = -1;
    }
    if (err < 0) {
	oprpc_getPktEnd(rpcHandle);
    }
    return err;
}

static int CStubSimpleGet(int reqNo, int printerContext, int *parg)
{
    int seqNo;

    if ((seqNo = CStubDoSimple1(reqNo,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,reqNo) < 0) {
	return -1;
    }
    if (oprpc_getInt(rpcHandle,parg) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubOpenPrinter(int outputFD, char *printerModel, int *nApiEntry,
    OPVP_api_procs **apiEntry)
{
    char *apiFlags;
    int seqNo;
    int printerContext;

	crpcMsg("%s(%d)\n", __FUNCTION__, __LINE__);

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, RPCNO_OPENPRINTER)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&outputFD) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putStr(rpcHandle,printerModel) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_OPENPRINTER) < 0) {
	return -1;
    }

    if (oprpc_getInt(rpcHandle,nApiEntry) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getPktPointer(rpcHandle, (void **)&apiFlags,
	  *nApiEntry) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getPkt(rpcHandle, (char *)&printerContext,
       sizeof(printerContext)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (setApiList(*nApiEntry, apiFlags) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    *apiEntry = &apiList;
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return printerContext;
}

int OpenPrinter(int outputFD, char *printerModel, int *nApiEntry,
    OPVP_api_procs **apiEntry)
{
    char buf1[10];
    char buf2[10];
	struct	sigaction	act;

	crpcMsg("%s(%d)\n", __FUNCTION__, __LINE__);

    if (pipe(outPipe) < 0) {
	crpcMsg("Can't create pipe for output\n");
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (pipe(inPipe) < 0) {
	crpcMsg("Can't create pipe for input\n");
	errorno = OPVP_FATALERROR;
	return -1;
    }

    sprintf(buf1,"%d", outPipe[0]);
    sprintf(buf2,"%d", inPipe[1]);

    serverPid = fork();
    if (serverPid < 0) {
	crpcMsg("Can't fork\n");
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (serverPid == 0) {
	close(outPipe[1]);
	close(inPipe[0]);
	execlp(SERVERNAME,SERVERNAME,"-i",buf1,
	  "-o",buf2, DRVNAME,NULL);
	crpcMsg("Can't exec driver program\n");
	_exit(2);

    } else {
	close(outPipe[0]);
	close(inPipe[1]);
	close(outputFD);
    }

	act.sa_handler = sigtermHandler;
	sigemptyset(&act.sa_mask);
	act.sa_flags = 0;
	sigaction(SIGTERM, &act, 0);

    if ((rpcHandle = oprpc_init(inPipe[0],outPipe[1])) == NULL) {
	crpcMsg("rpc initialize error\n");
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_waitReady(rpcHandle) < 0) {
	crpcMsg("Can't receive READY message\n");
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return CStubOpenPrinter(outputFD, printerModel, nApiEntry, apiEntry);
}

static int CStubClosePrinter(int printerContext)
{
    int seqNo;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if ((seqNo = CStubDoSimple1(RPCNO_CLOSEPRINTER,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_CLOSEPRINTER) < 0) {
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (serverPid > 0) {
	kill(serverPid,SIGTERM);
	waitpid(serverPid,NULL,0);
    }
    return OPVP_OK;
}


static int CStubStartJob(int printerContext, char *jobInfo)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif

    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_STARTJOB) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putStr(rpcHandle,jobInfo) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubEndJob(int printerContext)
{
    int seqNo;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif

    if ((seqNo = CStubDoSimple1(RPCNO_ENDJOB,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_ENDJOB) < 0) {
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubStartDoc(int	printerContext, char *docInfo)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif

    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_STARTDOC) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putStr(rpcHandle,docInfo) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubEndDoc(int printerContext)
{
    int seqNo;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if ((seqNo = CStubDoSimple1(RPCNO_ENDDOC,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_ENDDOC) < 0) {
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubStartPage(int printerContext, char *pageInfo)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_STARTPAGE) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putStr(rpcHandle,pageInfo) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubEndPage(int printerContext)
{
    int seqNo;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if ((seqNo = CStubDoSimple1(RPCNO_ENDPAGE,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_ENDPAGE) < 0) {
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

#if (_PDAPI_VERSION_MAJOR_ > 0 || _PDAPI_VERSION_MINOR_ >= 2)
static int CStubQueryDeviceCapability(int printerContext, int queryflag,
   int buflen, char *infoBuf)
{
    int seqNo;
    char *info;
    int f;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, RPCNO_QUERYDEVICECAPABILITY)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&queryflag) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&buflen) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    f = (infoBuf == NULL);
    if (oprpc_putInt(rpcHandle,&f) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_QUERYDEVICECAPABILITY) < 0) {
	return -1;
    }
    if (oprpc_getStr(rpcHandle,(void **)&info) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (infoBuf != NULL && info != NULL) {
	int rlen = strlen(info);

	if (rlen > buflen-1) rlen = buflen-1;
	strncpy(infoBuf,info,rlen+1);
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubQueryDeviceInfo(int printerContext, int queryflag,
   int buflen, char *infoBuf)
{
    int seqNo;
    char *info;
    int f;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, RPCNO_QUERYDEVICEINFO)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&queryflag) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&buflen) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    f = (infoBuf == NULL);
    if (oprpc_putInt(rpcHandle,&f) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_QUERYDEVICEINFO) < 0) {
	return -1;
    }
    if (oprpc_getStr(rpcHandle,(void **)&info) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (infoBuf != NULL && info != NULL) {
	int rlen = strlen(info);

	if (rlen > buflen-1) rlen = buflen-1;
	strncpy(infoBuf,info,rlen+1);
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}
#endif


static int CStubResetCTM(int	printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_RESETCTM,printerContext);
}

static int CStubSetCTM(int printerContext, OPVP_CTM *pCTM)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETCTM) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,pCTM,sizeof(OPVP_CTM)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubGetCTM(int printerContext, OPVP_CTM *pCTM)
{
    int seqNo;
    OPVP_CTM *p;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if ((seqNo = CStubDoSimple1(RPCNO_GETCTM,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_GETCTM) < 0) {
	return -1;
    }
    if (oprpc_getPktPointer(rpcHandle,(void **)&p,sizeof(OPVP_CTM)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    *pCTM = *p;
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubInitGS(int printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_INITGS,printerContext);
}

static int CStubSaveGS(int printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_SAVEGS,printerContext);
}

static int CStubRestoreGS(int printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_RESTOREGS,printerContext);
}

static int CStubQueryColorSpace(int printerContext, OPVP_ColorSpace *pcspace,
    int *pnum)
{
    int seqNo;
    OPVP_ColorSpace *p;
    int rnum;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, RPCNO_QUERYCOLORSPACE)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (pcspace == NULL) *pnum = 0;
    if (oprpc_putInt(rpcHandle,pnum) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_QUERYCOLORSPACE) < 0) {
	return -1;
    }
    if (oprpc_getInt(rpcHandle,&rnum) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (rnum <= *pnum && pcspace != NULL && *pnum > 0) {
	if (oprpc_getPktPointer(rpcHandle,(void **)&p,
	      rnum*sizeof(OPVP_ColorSpace)) < 0) {
	    errorno = OPVP_FATALERROR;
	    return -1;
	}
	memcpy(pcspace,p,rnum*sizeof(OPVP_ColorSpace));
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (rnum > *pnum) {
	errorno = OPVP_PARAMERROR;
	return -1;
    }
    *pnum = rnum;
    return OPVP_OK;
}

static int CStubSetColorSpace(int printerContext, OPVP_ColorSpace cspace)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple2(RPCNO_SETCOLORSPACE,printerContext,cspace);
}

static int CStubGetColorSpace(int printerContext, OPVP_ColorSpace *pcspace)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimpleGet(RPCNO_GETCOLORSPACE,printerContext,(int *)pcspace);
}

static int CStubQueryROP(int printerContext, int *pnum, int *prop)
{
    int seqNo;
    int *p;
    int rnum;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, RPCNO_QUERYROP)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (prop == NULL) *pnum = 0;
    if (oprpc_putInt(rpcHandle,pnum) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_QUERYROP) < 0) {
	return -1;
    }
    if (oprpc_getInt(rpcHandle,&rnum) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (rnum <= *pnum && prop != NULL && *pnum > 0) {
	if (oprpc_getPktPointer(rpcHandle,(void **)&p,
	      rnum*sizeof(int)) < 0) {
	    errorno = OPVP_FATALERROR;
	    return -1;
	}
	memcpy(prop,p,rnum*sizeof(int));
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (prop != NULL && rnum > *pnum) {
	errorno = OPVP_PARAMERROR;
	return -1;
    }
    *pnum = rnum;
    return OPVP_OK;
}

static int CStubSetROP(int printerContext, int rop)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple2(RPCNO_SETROP,printerContext,rop);
}

static int CStubGetROP(int printerContext, int *prop)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimpleGet(RPCNO_GETROP,printerContext,prop);
}

static int CStubSetFillMode(int printerContext, OPVP_FillMode fillmode)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple2(RPCNO_SETFILLMODE,printerContext,fillmode);
}

static int CStubGetFillMode(int printerContext, OPVP_FillMode *pfillmode)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimpleGet(RPCNO_GETFILLMODE,printerContext,(int *)pfillmode);
}

static int CStubSetAlphaConstant(int	printerContext, float alpha)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETALPHACONSTANT) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&alpha,sizeof(alpha)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubGetAlphaConstant(int	printerContext, float *palpha)
{
    int seqNo;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if ((seqNo = CStubDoSimple1(RPCNO_GETALPHACONSTANT,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_GETALPHACONSTANT) < 0) {
	return -1;
    }
    if (oprpc_getPkt(rpcHandle,(char *)palpha,sizeof(float)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubSetLineWidth(int printerContext, OPVP_Fix width)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETLINEWIDTH) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&width,sizeof(width)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubGetLineWidth(int printerContext, OPVP_Fix *pwidth)
{
    int seqNo;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if ((seqNo = CStubDoSimple1(RPCNO_GETLINEWIDTH,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_GETLINEWIDTH) < 0) {
	return -1;
    }
    if (oprpc_getPkt(rpcHandle,(char *)pwidth,sizeof(OPVP_Fix)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubSetLineDash(int printerContext, OPVP_Fix pdash[],
    int num)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETLINEDASH) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&num) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,pdash,num*sizeof(OPVP_Fix)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubGetLineDash(int printerContext, OPVP_Fix pdash[], int *pnum)
{
    int seqNo;
    OPVP_Fix *p;
    int rnum;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, RPCNO_GETLINEDASH)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (pdash == NULL) *pnum = 0;
    if (oprpc_putInt(rpcHandle,pnum) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_GETLINEDASH) < 0) {
	return -1;
    }
    if (oprpc_getInt(rpcHandle,&rnum) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (rnum <= *pnum && pdash != NULL && *pnum > 0) {
	if (oprpc_getPktPointer(rpcHandle,(void **)&p,
	      rnum*sizeof(int)) < 0) {
	    errorno = OPVP_FATALERROR;
	    return -1;
	}
	memcpy(pdash,p,rnum*sizeof(OPVP_Fix));
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (rnum > *pnum) {
	errorno = OPVP_PARAMERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubSetLineDashOffset(int printerContext, OPVP_Fix offset)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETLINEDASHOFFSET) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&offset,sizeof(offset)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubGetLineDashOffset(int printerContext, OPVP_Fix *poffset)
{
    int seqNo;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if ((seqNo = CStubDoSimple1(RPCNO_GETLINEDASHOFFSET,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_GETLINEDASHOFFSET) < 0) {
	return -1;
    }
    if (oprpc_getPkt(rpcHandle,(char *)poffset,sizeof(OPVP_Fix)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubSetLineStyle(int printerContext, OPVP_LineStyle linestyle)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple2(RPCNO_SETLINESTYLE,printerContext,linestyle);
}

static int CStubGetLineStyle(int printerContext, OPVP_LineStyle *plinestyle)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimpleGet(RPCNO_GETLINESTYLE,printerContext,(int *)plinestyle);
}

static int CStubSetLineCap(int printerContext, OPVP_LineCap linecap)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple2(RPCNO_SETLINECAP,printerContext,linecap);
}

static int CStubGetLineCap(int printerContext, OPVP_LineCap *plinecap)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimpleGet(RPCNO_GETLINECAP,printerContext,(int *)plinecap);
}

static int CStubSetLineJoin(int printerContext, OPVP_LineJoin linejoin)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple2(RPCNO_SETLINEJOIN,printerContext,linejoin);
}

static int CStubGetLineJoin(int printerContext, OPVP_LineJoin *plinejoin)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimpleGet(RPCNO_GETLINEJOIN,printerContext,(int *)plinejoin);
}

static int CStubSetMiterLimit(int printerContext, OPVP_Fix miterlimit)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETMITERLIMIT) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&miterlimit,sizeof(miterlimit)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubGetMiterLimit(int printerContext, OPVP_Fix *pmiterlimit)
{
    int seqNo;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if ((seqNo = CStubDoSimple1(RPCNO_GETMITERLIMIT,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_GETMITERLIMIT) < 0) {
	return -1;
    }
    if (oprpc_getPkt(rpcHandle,(char *)pmiterlimit,sizeof(OPVP_Fix)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubSetPaintMode(int printerContext, OPVP_PaintMode paintmode)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple2(RPCNO_SETPAINTMODE,printerContext,paintmode);
}

static int CStubGetPaintMode(int printerContext, OPVP_PaintMode *ppaintmode)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimpleGet(RPCNO_GETPAINTMODE,printerContext,(int *)ppaintmode);
}

static int oprpc_putBrushData(OPVP_BrushData *pbd)
{
    int f;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    f = (pbd == NULL);
    if (oprpc_putPkt(rpcHandle,(char *)&f,
	sizeof(f)) < 0) {
	return -1;
    }
    if (f) return 0;
#if (_PDAPI_VERSION_MAJOR_ == 0 && _PDAPI_VERSION_MINOR_ < 2)
    if (oprpc_putPkt(rpcHandle,(char *)&(pbd->type),
        sizeof(OPVP_BrushDataType)) < 0) {
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&(pbd->width),
        sizeof(int)) < 0) {
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&(pbd->height),
        sizeof(int)) < 0) {
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&(pbd->pitch),
        sizeof(int)) < 0) {
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,pbd->data,
       pbd->pitch*pbd->height) < 0) {
	return -1;
    }
#else
    if (oprpc_putPktPointer(rpcHandle,pbd,
       sizeof(pbd->type)+sizeof(pbd->width)+
       sizeof(pbd->height)+sizeof(pbd->pitch)
       +pbd->pitch*pbd->height) < 0) {
	return -1;
    }
#endif
    return 0;
}

static int oprpc_putBrush(OPVP_Brush *pbrush)
{
    if (oprpc_putPkt(rpcHandle,(char *)&(pbrush->colorSpace),
        sizeof(OPVP_ColorSpace)) < 0) {
	    return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&(pbrush->color),
        sizeof(int)*4) < 0) {
	    return -1;
    }
#if (_PDAPI_VERSION_MAJOR_ == 0 && _PDAPI_VERSION_MINOR_ < 2)
    if (oprpc_putBrushData(pbrush->pbrush) < 0) {
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&(pbrush->xorg),
        sizeof(int)) < 0) {
	    return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&(pbrush->yorg),
        sizeof(int)) < 0) {
	    return -1;
    }
#else
    if (oprpc_putPkt(rpcHandle,(char *)&(pbrush->xorg),
        sizeof(int)) < 0) {
	    return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&(pbrush->yorg),
        sizeof(int)) < 0) {
	    return -1;
    }
    if (oprpc_putBrushData(pbrush->pbrush) < 0) {
	return -1;
    }
#endif
    return 0;
}

static int CStubSetStrokeColor(int printerContext, OPVP_Brush *brush)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETSTROKECOLOR) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putBrush(brush) < 0) {
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubSetFillColor(int printerContext, OPVP_Brush *brush)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETFILLCOLOR) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putBrush(brush) < 0) {
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubSetBgColor(int printerContext, OPVP_Brush *brush)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETBGCOLOR) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putBrush(brush) < 0) {
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}


static int CStubNewPath(int printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_NEWPATH,printerContext);
}

static int CStubEndPath(int printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_ENDPATH,printerContext);
}

static int CStubStrokePath(int printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_STROKEPATH,printerContext);
}

static int CStubFillPath(int printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_FILLPATH,printerContext);
}

static int CStubStrokeFillPath(int printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_STROKEFILLPATH,printerContext);
}

static int CStubSetClipPath(int printerContext, OPVP_ClipRule clipRule)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple2(RPCNO_SETCLIPPATH,printerContext,clipRule);
}

#if (_PDAPI_VERSION_MAJOR_ > 0 || _PDAPI_VERSION_MINOR_ >= 2)
static int CStubResetClipPath(int printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_RESETCLIPPATH,printerContext);
}
#endif

static int CStubSetCurrentPoint(int printerContext, OPVP_Fix x, OPVP_Fix y)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETCURRENTPOINT) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&x, sizeof(x)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&y, sizeof(y)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubLinePath(int printerContext, int flag, int npoints,
    OPVP_Point *points)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_LINEPATH) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&flag,sizeof(flag)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&npoints, sizeof(npoints)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,points,
        npoints*sizeof(OPVP_Point)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubPolygonPath(int printerContext, int npolygons, int *nvertexes,
    OPVP_Point *points)
{
    int n,i;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_POLYGONPATH) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&npolygons,sizeof(npolygons)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,nvertexes,
       npolygons*sizeof(int)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    n = 0;
    for (i = 0;i < npolygons;i++) {
	n += nvertexes[i];
    }

    if (oprpc_putPktPointer(rpcHandle,points,
        n*sizeof(OPVP_Point)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubRectanglePath(int printerContext, int nrectangles,
    OPVP_Rectangle *rectangles)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_RECTANGLEPATH) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&nrectangles,sizeof(nrectangles)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,rectangles,
        nrectangles*sizeof(OPVP_Rectangle)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubRoundRectanglePath(int printerContext, int nrectangles,
    OPVP_RoundRectangle *rectangles)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_ROUNDRECTANGLEPATH) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&nrectangles,sizeof(nrectangles)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,rectangles,
        nrectangles*sizeof(OPVP_RoundRectangle)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

#if (_PDAPI_VERSION_MAJOR_ == 0 && _PDAPI_VERSION_MINOR_ < 2)
static int CStubBezierPath(int printerContext, int *npoints, OPVP_Point *points)
{
    int n;
    int sum;

#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_BEZIERPATH) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    sum = 0;
    for (n = 0;npoints[n] != 0;n++) {
	sum += npoints[n];
    }
    if (oprpc_putPktPointer(rpcHandle,npoints,
       (n+1)*sizeof(int)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,points,
        sum*sizeof(OPVP_Point)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

#else
static int CStubBezierPath(int printerContext, int npoints, OPVP_Point *points)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_BEZIERPATH) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&npoints, sizeof(npoints)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,points,
        npoints*sizeof(OPVP_Point)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}
#endif
static int CStubArcPath(int printerContext, int kind, int dir,
    OPVP_Fix bbx0, OPVP_Fix bby0, OPVP_Fix bbx1, OPVP_Fix bby1,
    OPVP_Fix x0, OPVP_Fix y0, OPVP_Fix x1, OPVP_Fix y1)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_ARCPATH) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&kind) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&dir) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&bbx0, sizeof(bbx0)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&bby0, sizeof(bby0)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&bbx1, sizeof(bbx1)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&bby1, sizeof(bby1)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&x0, sizeof(x0)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&y0, sizeof(y0)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&x1, sizeof(x1)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&y1, sizeof(y1)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}


static int CStubDrawBitmapText(int printerContext, int width, int height,
    int pitch, void *fontdata)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_DRAWBITMAPTEXT) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&width) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&height) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&pitch) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,fontdata, pitch/8*height) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}


static int CStubDrawImage(int printerContext, int sourceWidth, int sourceHeight,
    int colorDepth, OPVP_ImageFormat imageFormat,
    OPVP_Rectangle destinationSize, int count, void *imagedata)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_DRAWIMAGE) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&sourceWidth) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&sourceHeight) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&colorDepth) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&imageFormat, sizeof(imageFormat)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&destinationSize,
         sizeof(destinationSize)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&count) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,imagedata, count) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubStartDrawImage(int printerContext, int sourceWidth,
    int sourceHeight, int colorDepth, OPVP_ImageFormat imageFormat,
    OPVP_Rectangle destinationSize)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_STARTDRAWIMAGE) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&sourceWidth) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&sourceHeight) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&colorDepth) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&imageFormat, sizeof(imageFormat)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&destinationSize,
         sizeof(destinationSize)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubTransferDrawImage(int printerContext, int count,
    void *imagedata)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_TRANSFERDRAWIMAGE) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&count) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,imagedata, count) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubEndDrawImage(int printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_ENDDRAWIMAGE,printerContext);
}


static int CStubStartScanline(int printerContext, int yposition)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple2(RPCNO_STARTSCANLINE,printerContext,yposition);
}

static int CStubScanline(int printerContext, int nscanpairs, int *scanpairs)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SCANLINE) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&nscanpairs) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,scanpairs,
         nscanpairs*2*sizeof(int)) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubEndScanline(int printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_ENDSCANLINE,printerContext);
}


static int CStubStartRaster(int printerContext, int rasterWidth)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple2(RPCNO_STARTRASTER,printerContext,rasterWidth);
}

static int CStubTransferRasterData(int printerContext, int count,
    unsigned char *data)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_TRANSFERRASTERDATA) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&count) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,data,count) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubSkipRaster(int printerContext, int count)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple2(RPCNO_SKIPRASTER,printerContext,count);
}

static int CStubEndRaster(int printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_ENDRASTER,printerContext);
}


static int CStubStartStream(int printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_STARTSTREAM,printerContext);
}

static int CStubTransferStreamData(int printerContext, int count, void *data)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_TRANSFERSTREAMDATA) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&count) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,data,count) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	errorno = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubEndStream(int printerContext)
{
#ifdef DEBUG
	fprintf(stderr, "DEBUG:%s\n", __func__);
#endif
    return CStubSimple1(RPCNO_ENDSTREAM,printerContext);
}

