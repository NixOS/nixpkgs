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
/*
   2007 Modified  for OPVP 1.0 by BBR Inc.
*/

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <sys/time.h>
#include <string.h>
#include <sys/types.h>
#include <signal.h>
#include <sys/wait.h>
#include "opvp.h"
#include "opvp_rpc_client.h"
#include "opvp_rpc_core.h"
#include "opvp_rpc_reqno.h"

opvp_int_t opvpErrorNo = OPVP_OK;

static int serverPid = -1;

static  opvp_api_procs_t apiList;

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
    if (oprpc_get(hp,req) < 0) {
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
    void *vp;

    apiList.opvpOpenPrinter		= opvpOpenPrinter;
    apiList.opvpClosePrinter		= CStubClosePrinter;
    apiList.opvpStartJob		= CStubStartJob;
    apiList.opvpEndJob			= CStubEndJob;
    apiList.opvpAbortJob		= CStubAbortJob;
    apiList.opvpStartDoc		= CStubStartDoc;
    apiList.opvpEndDoc			= CStubEndDoc;
    apiList.opvpStartPage		= CStubStartPage;
    apiList.opvpEndPage			= CStubEndPage;
    apiList.opvpResetCTM		= CStubResetCTM;
    apiList.opvpSetCTM			= CStubSetCTM;
    apiList.opvpGetCTM			= CStubGetCTM;
    apiList.opvpInitGS			= CStubInitGS;
    apiList.opvpSaveGS			= CStubSaveGS;
    apiList.opvpRestoreGS		= CStubRestoreGS;
    apiList.opvpQueryColorSpace		= CStubQueryColorSpace;
    apiList.opvpSetColorSpace		= CStubSetColorSpace;
    apiList.opvpGetColorSpace		= CStubGetColorSpace;
    apiList.opvpSetFillMode		= CStubSetFillMode;
    apiList.opvpGetFillMode		= CStubGetFillMode;
    apiList.opvpSetAlphaConstant	= CStubSetAlphaConstant;
    apiList.opvpGetAlphaConstant	= CStubGetAlphaConstant;
    apiList.opvpSetLineWidth		= CStubSetLineWidth;
    apiList.opvpGetLineWidth		= CStubGetLineWidth;
    apiList.opvpSetLineDash		= CStubSetLineDash;
    apiList.opvpGetLineDash		= CStubGetLineDash;
    apiList.opvpSetLineDashOffset	= CStubSetLineDashOffset;
    apiList.opvpGetLineDashOffset	= CStubGetLineDashOffset;
    apiList.opvpSetLineStyle		= CStubSetLineStyle;
    apiList.opvpGetLineStyle		= CStubGetLineStyle;
    apiList.opvpSetLineCap		= CStubSetLineCap;
    apiList.opvpGetLineCap		= CStubGetLineCap;
    apiList.opvpSetLineJoin		= CStubSetLineJoin;
    apiList.opvpGetLineJoin		= CStubGetLineJoin;
    apiList.opvpSetMiterLimit		= CStubSetMiterLimit;
    apiList.opvpGetMiterLimit		= CStubGetMiterLimit;
    apiList.opvpSetPaintMode		= CStubSetPaintMode;
    apiList.opvpGetPaintMode		= CStubGetPaintMode;
    apiList.opvpSetStrokeColor		= CStubSetStrokeColor;
    apiList.opvpSetFillColor		= CStubSetFillColor;
    apiList.opvpSetBgColor		= CStubSetBgColor;
    apiList.opvpNewPath			= CStubNewPath;
    apiList.opvpEndPath			= CStubEndPath;
    apiList.opvpStrokePath		= CStubStrokePath;
    apiList.opvpFillPath		= CStubFillPath;
    apiList.opvpStrokeFillPath		= CStubStrokeFillPath;
    apiList.opvpSetClipPath		= CStubSetClipPath;
    apiList.opvpSetCurrentPoint		= CStubSetCurrentPoint;
    apiList.opvpLinePath		= CStubLinePath;
    apiList.opvpPolygonPath		= CStubPolygonPath;
    apiList.opvpRectanglePath		= CStubRectanglePath;
    apiList.opvpRoundRectanglePath	= CStubRoundRectanglePath;
    apiList.opvpBezierPath		= CStubBezierPath;
    apiList.opvpArcPath			= CStubArcPath;
    apiList.opvpDrawImage		= CStubDrawImage;
    apiList.opvpStartDrawImage		= CStubStartDrawImage;
    apiList.opvpTransferDrawImage	= CStubTransferDrawImage;
    apiList.opvpEndDrawImage		= CStubEndDrawImage;
    apiList.opvpStartScanline		= CStubStartScanline;
    apiList.opvpScanline		= CStubScanline;
    apiList.opvpEndScanline		= CStubEndScanline;
    apiList.opvpStartRaster		= CStubStartRaster;
    apiList.opvpTransferRasterData	= CStubTransferRasterData;
    apiList.opvpSkipRaster		= CStubSkipRaster;
    apiList.opvpEndRaster		= CStubEndRaster;
    apiList.opvpStartStream		= CStubStartStream;
    apiList.opvpTransferStreamData	= CStubTransferStreamData;
    apiList.opvpEndStream		= CStubEndStream;
    apiList.opvpQueryDeviceCapability 	= CStubQueryDeviceCapability;
    apiList.opvpQueryDeviceInfo		= CStubQueryDeviceInfo;
    apiList.opvpResetClipPath		= CStubResetClipPath;

    vp = &apiList;
    p = vp;
    for (i = 0;i < nApiEntry;i++) {
	if (apiFlags[i] == 0) {
	    p[i] = NULL;
	}
    }

    return 0;
}

static int outPipe[2];
static int inPipe[2];

static int CStubDoSimple1(int reqNo, opvp_dc_t printerContext)
{
    int seqNo;

    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, reqNo)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return seqNo;
}

static opvp_result_t CStubSimple1(int reqNo, opvp_dc_t printerContext)
{
    return CStubDoSimple1(reqNo, printerContext) >= 0 ? OPVP_OK : -1;
}

static int CStubDoSimple2(int reqNo, opvp_dc_t printerContext, void *parg1,
  int arg1len)
{
    int seqNo;

    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, reqNo)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,parg1,arg1len) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return seqNo;
}

#define CStubSimple2(reqNo, printerContext, arg1) \
    CStubDoSimple2(reqNo,printerContext,&arg1,sizeof(arg1)) \
      >= 0 ? OPVP_OK:-1;

static int checkResponse(int seqNo, int reqNo)
{
    int rreqNo;
    int rseqNo;
    int err = 0;

reenter:
    if ((rseqNo = oprpc_getPktStart(rpcHandle)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_get(rpcHandle,rreqNo) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (rreqNo < 0) {
	opvpErrorNo = rreqNo;
	if (oprpc_get(rpcHandle,rreqNo) < 0) {
	    opvpErrorNo = OPVP_FATALERROR;
	    return -1;
	}
	fprintf(stderr,"Error Response:ReqNo=%d, SeqNo=%d,opvpErrorNo=%d\n",
	   rreqNo,rseqNo,opvpErrorNo);
	if (oprpc_getPktEnd(rpcHandle) < 0) {
	    opvpErrorNo = OPVP_FATALERROR;
	    return -1;
	}
	err = -1;
	if (rseqNo != seqNo) {
	    goto reenter;
	}
	return -1;
    }
    if (rseqNo != seqNo) {
	opvpErrorNo = OPVP_FATALERROR;
	err = -1;
    }
    if (rreqNo != reqNo) {
	opvpErrorNo = OPVP_FATALERROR;
	err = -1;
    }
    if (err < 0) {
	oprpc_getPktEnd(rpcHandle);
    }
    return err;
}

static opvp_result_t CStubDoSimpleGet(int reqNo, opvp_dc_t printerContext,
  void *parg, int arglen)
{
    int seqNo;

    if ((seqNo = CStubDoSimple1(reqNo,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,reqNo) < 0) {
	return -1;
    }
    if (oprpc_getPkt(rpcHandle,parg,arglen) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

#define CStubSimpleGet(reqNo, printerContext, parg) \
  CStubDoSimpleGet(reqNo,printerContext,parg,sizeof(*parg))

static opvp_dc_t CStubOpenPrinter(opvp_int_t outputFD,
    const opvp_char_t *printerModel, const opvp_int_t apiVersion[2],
    opvp_api_procs_t **apiEntry)
{
    char *apiFlags;
    int seqNo;
    opvp_dc_t printerContext;
    int nApiEntry = 0;
    void *vp;

	crpcMsg("%s(%d)\n", __FUNCTION__, __LINE__);

    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, RPCNO_OPENPRINTER)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,outputFD) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putStr(rpcHandle,printerModel) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPkt(rpcHandle,(void *)apiVersion,sizeof(opvp_int_t)*2) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_OPENPRINTER) < 0) {
	return -1;
    }

    if (oprpc_getInt(rpcHandle,&nApiEntry) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getPktPointer(rpcHandle, &vp,
	  nApiEntry) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    apiFlags = vp;
    if (oprpc_get(rpcHandle, printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    if (setApiList(nApiEntry, apiFlags) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    *apiEntry = &apiList;
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return printerContext;
}

opvp_dc_t opvpOpenPrinter(opvp_int_t outputFD, const opvp_char_t *printerModel,
    const opvp_int_t apiVersion[2], opvp_api_procs_t **apiEntry)
{
    char buf1[10];
    char buf2[10];
	 struct  sigaction       act;

	crpcMsg("%s(%d)\n", __FUNCTION__, __LINE__);

    if (pipe(outPipe) < 0) {
	crpcMsg("Can't create pipe for output\n");
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (pipe(inPipe) < 0) {
	crpcMsg("Can't create pipe for input\n");
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    sprintf(buf1,"%d", outPipe[0]);
    sprintf(buf2,"%d", inPipe[1]);

    serverPid = fork();
    if (serverPid < 0) {
	crpcMsg("Can't fork\n");
	opvpErrorNo = OPVP_FATALERROR;
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
	opvpErrorNo = OPVP_FATALERROR;
	return -1;;
    }
    if (oprpc_waitReady(rpcHandle) < 0) {
	crpcMsg("Can't receive READY message\n");
	opvpErrorNo = OPVP_FATALERROR;
	return -1;;
    }
    return CStubOpenPrinter(outputFD, printerModel, apiVersion, apiEntry);
}

static opvp_result_t CStubClosePrinter(opvp_dc_t printerContext)
{
    int seqNo;

    if ((seqNo = CStubDoSimple1(RPCNO_CLOSEPRINTER,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_CLOSEPRINTER) < 0) {
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (serverPid > 0) {
	kill(serverPid,SIGTERM);
	waitpid(serverPid,NULL,0);
    }
    return OPVP_OK;
}


static opvp_result_t CStubStartJob(opvp_dc_t printerContext,
  const opvp_char_t *jobInfo)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_STARTJOB) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putStr(rpcHandle,jobInfo) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubEndJob(opvp_dc_t printerContext)
{
    int seqNo;

    if ((seqNo = CStubDoSimple1(RPCNO_ENDJOB,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_ENDJOB) < 0) {
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubAbortJob(opvp_dc_t printerContext)
{
    int seqNo;

    if ((seqNo = CStubDoSimple1(RPCNO_ABORTJOB,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_ABORTJOB) < 0) {
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubStartDoc(opvp_dc_t printerContext,
  const opvp_char_t *docInfo)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_STARTDOC) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putStr(rpcHandle,docInfo) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubEndDoc(opvp_dc_t printerContext)
{
    int seqNo;

    if ((seqNo = CStubDoSimple1(RPCNO_ENDDOC,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_ENDDOC) < 0) {
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubStartPage(opvp_dc_t printerContext,
    const opvp_char_t *pageInfo)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_STARTPAGE) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putStr(rpcHandle,pageInfo) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubEndPage(opvp_dc_t printerContext)
{
    int seqNo;

    if ((seqNo = CStubDoSimple1(RPCNO_ENDPAGE,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_ENDPAGE) < 0) {
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubQueryDeviceCapability(opvp_dc_t printerContext,
   opvp_queryinfoflags_t queryflag, opvp_int_t *buflen, opvp_char_t *infoBuf)
{
    int seqNo;
    char *info;
    int f;
    opvp_int_t rbuflen;
    opvp_result_t r = OPVP_OK;
    void *vp;

    if (buflen == NULL) {
	opvpErrorNo = OPVP_PARAMERROR;
	return -1;
    }
    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, RPCNO_QUERYDEVICECAPABILITY)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,queryflag) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,*buflen) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    f = (infoBuf == NULL);
    if (oprpc_putInt(rpcHandle,&f) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_QUERYDEVICECAPABILITY) < 0) {
	return -1;
    }
    if (oprpc_get(rpcHandle,rbuflen) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getStr(rpcHandle,&vp) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    info = vp;
    if (rbuflen <= *buflen && infoBuf != NULL && info != NULL) {
	int rlen = strlen(info);

	if (rlen > *buflen-1) rlen = *buflen-1;
	strncpy((char *)infoBuf,info,rlen+1);
    } else {
	opvpErrorNo = OPVP_PARAMERROR;
	r = -1;
    }
    *buflen = rbuflen;
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return r;
}

static opvp_result_t CStubQueryDeviceInfo(opvp_dc_t printerContext,
   opvp_queryinfoflags_t queryflag,
   opvp_int_t *buflen, opvp_char_t *infoBuf)
{
    int seqNo;
    char *info;
    void *vp;
    int f;
    opvp_int_t rbuflen;
    opvp_result_t r = OPVP_OK;

    if (buflen == NULL) {
	opvpErrorNo = OPVP_PARAMERROR;
	return -1;
    }
    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, RPCNO_QUERYDEVICEINFO)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,queryflag) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,*buflen) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    f = (infoBuf == NULL);
    if (oprpc_putInt(rpcHandle,&f) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_QUERYDEVICEINFO) < 0) {
	return -1;
    }
    if (oprpc_get(rpcHandle,rbuflen) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getStr(rpcHandle,&vp) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    info = vp;
    if (rbuflen <= *buflen && infoBuf != NULL && info != NULL) {
	int rlen = strlen(info);

	if (rlen > *buflen-1) rlen = *buflen-1;
	strncpy((char *)infoBuf,info,rlen+1);
    } else {
	opvpErrorNo = OPVP_PARAMERROR;
	r = -1;
    }
    *buflen = rbuflen;
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return r;
}


static opvp_result_t CStubResetCTM(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_RESETCTM,printerContext);
}

static opvp_result_t CStubSetCTM(opvp_dc_t printerContext,
  const opvp_ctm_t *pCTM)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETCTM) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,pCTM,sizeof(opvp_ctm_t)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubGetCTM(opvp_dc_t printerContext, opvp_ctm_t *pCTM)
{
    int seqNo;
    void *vp;

    if ((seqNo = CStubDoSimple1(RPCNO_GETCTM,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_GETCTM) < 0) {
	return -1;
    }
    if (oprpc_getPktPointer(rpcHandle,&vp,sizeof(opvp_ctm_t)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    memcpy(pCTM,vp,sizeof(opvp_ctm_t));
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubInitGS(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_INITGS,printerContext);
}

static opvp_result_t CStubSaveGS(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_SAVEGS,printerContext);
}

static opvp_result_t CStubRestoreGS(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_RESTOREGS,printerContext);
}

static opvp_result_t CStubQueryColorSpace(opvp_dc_t printerContext,
    opvp_int_t *pnum, opvp_cspace_t *pcspace)
{
    int seqNo;
    void *vp;
    int rnum;
    int r = OPVP_OK;

    if (pnum == NULL) {
	opvpErrorNo = OPVP_PARAMERROR;
	return -1;
    }
    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, RPCNO_QUERYCOLORSPACE)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (pcspace == NULL) *pnum = 0;
    if (oprpc_put(rpcHandle,*pnum) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_QUERYCOLORSPACE) < 0) {
	return -1;
    }
    if (oprpc_getInt(rpcHandle,&rnum) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (rnum <= *pnum && pcspace != NULL && *pnum > 0) {
	if (oprpc_getPktPointer(rpcHandle,&vp,
	      rnum*sizeof(opvp_cspace_t)) < 0) {
	    opvpErrorNo = OPVP_FATALERROR;
	    return -1;
	}
	memcpy(pcspace,vp,rnum*sizeof(opvp_cspace_t));
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (rnum > *pnum) {
	opvpErrorNo = OPVP_PARAMERROR;
	r = -1;
    }
    *pnum = rnum;
    return r;
}

static opvp_result_t CStubSetColorSpace(opvp_dc_t printerContext,
    opvp_cspace_t cspace)
{
    return CStubSimple2(RPCNO_SETCOLORSPACE,printerContext,cspace);
}

static opvp_result_t CStubGetColorSpace(opvp_dc_t printerContext,
    opvp_cspace_t *pcspace)
{
    return CStubSimpleGet(RPCNO_GETCOLORSPACE,printerContext,pcspace);
}

static opvp_result_t CStubSetFillMode(opvp_dc_t printerContext,
    opvp_fillmode_t fillmode)
{
    return CStubSimple2(RPCNO_SETFILLMODE,printerContext,fillmode);
}

static opvp_result_t CStubGetFillMode(opvp_dc_t printerContext,
    opvp_fillmode_t *pfillmode)
{
    return CStubSimpleGet(RPCNO_GETFILLMODE,printerContext,pfillmode);
}

static opvp_result_t CStubSetAlphaConstant(opvp_dc_t printerContext,
    opvp_float_t alpha)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETALPHACONSTANT) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,alpha) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubGetAlphaConstant(opvp_dc_t printerContext,
    opvp_float_t *palpha)
{
    int seqNo;

    if ((seqNo = CStubDoSimple1(RPCNO_GETALPHACONSTANT,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_GETALPHACONSTANT) < 0) {
	return -1;
    }
    if (oprpc_get(rpcHandle,*palpha) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubSetLineWidth(opvp_dc_t printerContext,
    opvp_fix_t width)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETLINEWIDTH) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,width) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubGetLineWidth(opvp_dc_t printerContext,
    opvp_fix_t *pwidth)
{
    int seqNo;

    if ((seqNo = CStubDoSimple1(RPCNO_GETLINEWIDTH,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_GETLINEWIDTH) < 0) {
	return -1;
    }
    if (oprpc_get(rpcHandle,*pwidth) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubSetLineDash(opvp_dc_t printerContext,
    opvp_int_t num, const opvp_fix_t *pdash)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETLINEDASH) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putInt(rpcHandle,&printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,num) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,pdash,num*sizeof(opvp_fix_t)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubGetLineDash(opvp_dc_t printerContext,
    opvp_int_t *pnum, opvp_fix_t *pdash)
{
    int seqNo;
    void *vp;
    int rnum;
    int r = OPVP_OK;

    if (pnum == NULL) {
	opvpErrorNo = OPVP_PARAMERROR;
	return -1;
    }
    if ((seqNo = oprpc_putPktStart(rpcHandle, -1, RPCNO_GETLINEDASH)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (pdash == NULL) *pnum = 0;
    if (oprpc_put(rpcHandle,*pnum) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_GETLINEDASH) < 0) {
	return -1;
    }
    if (oprpc_get(rpcHandle,rnum) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (rnum <= *pnum && pdash != NULL && *pnum > 0) {
	if (oprpc_getPktPointer(rpcHandle,&vp,
	      rnum*sizeof(opvp_fix_t)) < 0) {
	    opvpErrorNo = OPVP_FATALERROR;
	    return -1;
	}
	memcpy(pdash,vp,rnum*sizeof(opvp_fix_t));
    } else {
	opvpErrorNo = OPVP_PARAMERROR;
	r = -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    *pnum = rnum;
    return r;
}

static opvp_result_t CStubSetLineDashOffset(opvp_dc_t printerContext,
    opvp_fix_t offset)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETLINEDASHOFFSET) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,offset) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubGetLineDashOffset(opvp_dc_t printerContext,
    opvp_fix_t *poffset)
{
    int seqNo;

    if ((seqNo = CStubDoSimple1(RPCNO_GETLINEDASHOFFSET,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_GETLINEDASHOFFSET) < 0) {
	return -1;
    }
    if (oprpc_get(rpcHandle,*poffset) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubSetLineStyle(opvp_dc_t printerContext,
    opvp_linestyle_t linestyle)
{
    return CStubSimple2(RPCNO_SETLINESTYLE,printerContext,linestyle);
}

static opvp_result_t CStubGetLineStyle(opvp_dc_t printerContext,
    opvp_linestyle_t *plinestyle)
{
    return CStubSimpleGet(RPCNO_GETLINESTYLE,printerContext,plinestyle);
}

static opvp_result_t CStubSetLineCap(opvp_dc_t printerContext,
    opvp_linecap_t linecap)
{
    return CStubSimple2(RPCNO_SETLINECAP,printerContext,linecap);
}

static opvp_result_t CStubGetLineCap(opvp_dc_t printerContext,
    opvp_linecap_t *plinecap)
{
    return CStubSimpleGet(RPCNO_GETLINECAP,printerContext,plinecap);
}

static opvp_result_t CStubSetLineJoin(opvp_dc_t printerContext,
    opvp_linejoin_t linejoin)
{
    return CStubSimple2(RPCNO_SETLINEJOIN,printerContext,linejoin);
}

static int CStubGetLineJoin(opvp_dc_t printerContext,
    opvp_linejoin_t *plinejoin)
{
    return CStubSimpleGet(RPCNO_GETLINEJOIN,printerContext,plinejoin);
}

static int CStubSetMiterLimit(opvp_dc_t printerContext,
    opvp_fix_t miterlimit)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETMITERLIMIT) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,miterlimit) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubGetMiterLimit(opvp_dc_t printerContext,
    opvp_fix_t *pmiterlimit)
{
    int seqNo;

    if ((seqNo = CStubDoSimple1(RPCNO_GETMITERLIMIT,printerContext)) < 0) {
	return -1;
    }

    if (checkResponse(seqNo,RPCNO_GETMITERLIMIT) < 0) {
	return -1;
    }
    if (oprpc_get(rpcHandle,*pmiterlimit) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_getPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubSetPaintMode(opvp_dc_t printerContext,
    opvp_paintmode_t paintmode)
{
    return CStubSimple2(RPCNO_SETPAINTMODE,printerContext,paintmode);
}

static opvp_result_t CStubGetPaintMode(opvp_dc_t printerContext,
    opvp_paintmode_t *ppaintmode)
{
    return CStubSimpleGet(RPCNO_GETPAINTMODE,printerContext,ppaintmode);
}

static int oprpc_putBrushData(const opvp_brushdata_t *pbd)
{
    int f;

    f = (pbd == NULL);
    if (oprpc_put(rpcHandle,f) < 0) {
	return -1;
    }
    if (f) return 0;
    if (oprpc_putPktPointer(rpcHandle,pbd,
       sizeof(pbd->type)+sizeof(pbd->width)+
       sizeof(pbd->height)+sizeof(pbd->pitch)
       +pbd->pitch*pbd->height) < 0) {
	return -1;
    }
    return 0;
}

static int oprpc_putBrush(const opvp_brush_t *pbrush)
{
    if (oprpc_put(rpcHandle,(pbrush->colorSpace)) < 0) {
	    return -1;
    }
    if (oprpc_putPkt(rpcHandle,(char *)&(pbrush->color),
        sizeof(opvp_int_t)*4) < 0) {
	    return -1;
    }
    if (oprpc_put(rpcHandle,(pbrush->xorg)) < 0) {
	    return -1;
    }
    if (oprpc_put(rpcHandle,(pbrush->yorg)) < 0) {
	    return -1;
    }
    if (oprpc_putBrushData(pbrush->pbrush) < 0) {
	return -1;
    }
    return 0;
}

static opvp_result_t CStubSetStrokeColor(opvp_dc_t printerContext,
    const opvp_brush_t *brush)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETSTROKECOLOR) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putBrush(brush) < 0) {
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubSetFillColor(opvp_dc_t printerContext,
    const opvp_brush_t *brush)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETFILLCOLOR) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putBrush(brush) < 0) {
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubSetBgColor(opvp_dc_t printerContext,
    const opvp_brush_t *brush)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETBGCOLOR) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putBrush(brush) < 0) {
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}


static opvp_result_t CStubNewPath(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_NEWPATH,printerContext);
}

static opvp_result_t CStubEndPath(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_ENDPATH,printerContext);
}

static opvp_result_t CStubStrokePath(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_STROKEPATH,printerContext);
}

static opvp_result_t CStubFillPath(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_FILLPATH,printerContext);
}

static opvp_result_t CStubStrokeFillPath(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_STROKEFILLPATH,printerContext);
}

static opvp_result_t CStubSetClipPath(opvp_dc_t printerContext,
    opvp_cliprule_t clipRule)
{
    return CStubSimple2(RPCNO_SETCLIPPATH,printerContext,clipRule);
}

static opvp_result_t CStubResetClipPath(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_RESETCLIPPATH,printerContext);
}

static opvp_result_t CStubSetCurrentPoint(opvp_dc_t printerContext,
    opvp_fix_t x, opvp_fix_t y)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SETCURRENTPOINT) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,x) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,y) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubLinePath(opvp_dc_t printerContext, opvp_pathmode_t flag,
    opvp_int_t npoints, const opvp_point_t *points)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_LINEPATH) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,flag) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,npoints) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,points,
        npoints*sizeof(opvp_point_t)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubPolygonPath(opvp_dc_t printerContext,
    opvp_int_t npolygons, const opvp_int_t *nvertexes,
    const opvp_point_t *points)
{
    int n,i;

    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_POLYGONPATH) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,npolygons) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,nvertexes,
       npolygons*sizeof(opvp_int_t)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    n = 0;
    for (i = 0;i < npolygons;i++) {
	n += nvertexes[i];
    }

    if (oprpc_putPktPointer(rpcHandle,points,
        n*sizeof(opvp_point_t)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubRectanglePath(opvp_dc_t printerContext,
    opvp_int_t nrectangles,
    const opvp_rectangle_t *rectangles)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_RECTANGLEPATH) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,nrectangles) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,rectangles,
        nrectangles*sizeof(opvp_rectangle_t)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubRoundRectanglePath(opvp_dc_t printerContext,
    opvp_int_t nrectangles,
    const opvp_roundrectangle_t *rectangles)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_ROUNDRECTANGLEPATH) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,nrectangles) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,rectangles,
        nrectangles*sizeof(opvp_roundrectangle_t)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubBezierPath(opvp_dc_t printerContext,
    opvp_int_t npoints, const opvp_point_t *points)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_BEZIERPATH) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,npoints) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,points,
        npoints*sizeof(opvp_point_t)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static int CStubArcPath(opvp_dc_t printerContext,
    opvp_arcmode_t kind, opvp_arcdir_t dir,
    opvp_fix_t bbx0, opvp_fix_t bby0, opvp_fix_t bbx1, opvp_fix_t bby1,
    opvp_fix_t x0, opvp_fix_t y0, opvp_fix_t x1, opvp_fix_t y1)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_ARCPATH) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,kind) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,dir) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,bbx0) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,bby0) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,bbx1) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,bby1) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,x0) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,y0) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,x1) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,y1) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}


static opvp_result_t CStubDrawImage(opvp_dc_t printerContext,
    opvp_int_t sourceWidth, opvp_int_t sourceHeight,
    opvp_int_t sourcePitch, opvp_imageformat_t imageFormat,
    opvp_int_t destinationWidth, opvp_int_t destinationHeight,
    const void *imagedata)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_DRAWIMAGE) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,sourceWidth) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,sourceHeight) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,sourcePitch) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,imageFormat) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,destinationWidth) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,destinationHeight) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,imagedata,
          sourcePitch*sourceHeight) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubStartDrawImage(opvp_dc_t printerContext,
    opvp_int_t sourceWidth, opvp_int_t sourceHeight, opvp_int_t sourcePitch,
    opvp_imageformat_t imageFormat,
    opvp_int_t destinationWidth, opvp_int_t destinationHeight)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_STARTDRAWIMAGE) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,sourceWidth) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,sourceHeight) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,sourcePitch) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,imageFormat) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,destinationWidth) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,destinationHeight) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubTransferDrawImage(opvp_dc_t printerContext,
    opvp_int_t count, const void *imagedata)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_TRANSFERDRAWIMAGE) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,count) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,imagedata, count) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubEndDrawImage(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_ENDDRAWIMAGE,printerContext);
}


static opvp_result_t CStubStartScanline(opvp_dc_t printerContext,
    opvp_int_t yposition)
{
    return CStubSimple2(RPCNO_STARTSCANLINE,printerContext,yposition);
}

static opvp_result_t CStubScanline(opvp_dc_t printerContext,
    opvp_int_t nscanpairs, const opvp_int_t *scanpairs)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_SCANLINE) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,nscanpairs) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,scanpairs,
         nscanpairs*2*sizeof(opvp_int_t)) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubEndScanline(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_ENDSCANLINE,printerContext);
}


static opvp_result_t CStubStartRaster(opvp_dc_t printerContext,
    opvp_int_t rasterWidth)
{
    return CStubSimple2(RPCNO_STARTRASTER,printerContext,rasterWidth);
}

static opvp_result_t CStubTransferRasterData(opvp_dc_t printerContext,
    opvp_int_t count,
    const opvp_byte_t *data)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_TRANSFERRASTERDATA) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,count) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,data,count) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubSkipRaster(opvp_dc_t printerContext, opvp_int_t count)
{
    return CStubSimple2(RPCNO_SKIPRASTER,printerContext,count);
}

static opvp_result_t CStubEndRaster(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_ENDRASTER,printerContext);
}


static opvp_result_t CStubStartStream(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_STARTSTREAM,printerContext);
}

static opvp_result_t CStubTransferStreamData(opvp_dc_t printerContext,
    opvp_int_t count, const void *data)
{
    if (oprpc_putPktStart(rpcHandle, -1, RPCNO_TRANSFERSTREAMDATA) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,printerContext) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_put(rpcHandle,count) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    if (oprpc_putPktPointer(rpcHandle,data,count) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }

    if (oprpc_putPktEnd(rpcHandle) < 0) {
	opvpErrorNo = OPVP_FATALERROR;
	return -1;
    }
    return OPVP_OK;
}

static opvp_result_t CStubEndStream(opvp_dc_t printerContext)
{
    return CStubSimple1(RPCNO_ENDSTREAM,printerContext);
}

