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

#ifndef _OPVP_RPC_CLIENT_H_
#define _OPVP_RPC_CLIENT_H_

#include "opvp_02.h"

#define	SERVERNAME  "c3pldrv"
#define DRVNAME     ""


static int CStubClosePrinter(int printerContext);
static int CStubStartJob(int printerContext, char *jobInfo);
static int CStubEndJob(int printerContext);
static int CStubStartDoc(int printerContext, char *docInfo);
static int CStubEndDoc(int printerContext);
static int CStubStartPage(int printerContext, char *pageInfo);
static int CStubEndPage(int printerContext);
static int CStubResetCTM(int printerContext);
static int CStubSetCTM(int printerContext, OPVP_CTM *pCTM);
static int CStubGetCTM(int printerContext, OPVP_CTM *pCTM);
static int CStubInitGS(int printerContext);
static int CStubSaveGS(int printerContext);
static int CStubRestoreGS(int printerContext);
static int CStubQueryColorSpace(int printerContext, OPVP_ColorSpace *pcspace,
    int *pnum);
static int CStubSetColorSpace(int printerContext, OPVP_ColorSpace cspace);
static int CStubGetColorSpace(int printerContext, OPVP_ColorSpace *pcspace);
static int CStubQueryROP(int printerContext, int *pnum, int *prop);
static int CStubSetROP(int printerContext, int rop);
static int CStubGetROP(int printerContext, int *prop);
static int CStubSetFillMode(int printerContext, OPVP_FillMode fillmode);
static int CStubGetFillMode(int printerContext, OPVP_FillMode *pfillmode);
static int CStubSetAlphaConstant(int printerContext, float alpha);
static int CStubGetAlphaConstant(int printerContext, float *palpha);
static int CStubSetLineWidth(int printerContext, OPVP_Fix width);
static int CStubGetLineWidth(int printerContext, OPVP_Fix *pwidth);
static int CStubSetLineDash(int printerContext, OPVP_Fix pdash[], int num);
static int CStubGetLineDash(int printerContext, OPVP_Fix pdash[], int *pnum);
static int CStubSetLineDashOffset(int printerContext, OPVP_Fix offset);
static int CStubGetLineDashOffset(int printerContext, OPVP_Fix *poffset);
static int CStubSetLineStyle(int printerContext, OPVP_LineStyle linestyle);
static int CStubGetLineStyle(int printerContext, OPVP_LineStyle *plinestyle);
static int CStubSetLineCap(int printerContext, OPVP_LineCap linecap);
static int CStubGetLineCap(int printerContext, OPVP_LineCap *plinecap);
static int CStubSetLineJoin(int printerContext, OPVP_LineJoin linejoin);
static int CStubGetLineJoin(int printerContext, OPVP_LineJoin *plinejoin);
static int CStubSetMiterLimit(int printerContext, OPVP_Fix miterlimit);
static int CStubGetMiterLimit(int printerContext, OPVP_Fix *pmiterlimit);
static int CStubSetPaintMode(int printerContext, OPVP_PaintMode paintmode);
static int CStubGetPaintMode(int printerContext, OPVP_PaintMode *ppaintmode);
static int CStubSetStrokeColor(int printerContext, OPVP_Brush *brush);
static int CStubSetFillColor(int printerContext, OPVP_Brush *brush);
static int CStubSetBgColor(int printerContext, OPVP_Brush *brush);
static int CStubNewPath(int printerContext);
static int CStubEndPath(int printerContext);
static int CStubStrokePath(int printerContext);
static int CStubFillPath(int printerContext);
static int CStubStrokeFillPath(int printerContext);
static int CStubSetClipPath(int printerContext, OPVP_ClipRule clipRule);
static int CStubSetCurrentPoint(int printerContext, OPVP_Fix x, OPVP_Fix y);
static int CStubLinePath(int printerContext, int flag, int npoints,
    OPVP_Point *points);
static int CStubPolygonPath(int printerContext, int npolygons, int *nvertexes,
    OPVP_Point *points);
static int CStubRectanglePath(int printerContext, int nrectangles,
    OPVP_Rectangle *reclangles);
static int CStubRoundRectanglePath(int printerContext, int nrectangles,
    OPVP_RoundRectangle *reclangles);
#if (_PDAPI_VERSION_MAJOR_ == 0 && _PDAPI_VERSION_MINOR_ < 2)
static int CStubBezierPath(int printerContext, int *npoints,
    OPVP_Point *points);
#else
static int CStubBezierPath(int printerContext, int npoints,
    OPVP_Point *points);
#endif
static int CStubArcPath(int printerContext, int kind, int dir, OPVP_Fix bbx0,
    OPVP_Fix bby0, OPVP_Fix bbx1, OPVP_Fix bby1, OPVP_Fix x0,
    OPVP_Fix y0, OPVP_Fix x1, OPVP_Fix y1);
static int CStubDrawBitmapText(int printerContext, int width, int height,
    int pitch, void *fontdata);
static int CStubDrawImage(int printerContext, int sourceWidth, int sourceHeight,
    int colorDepth, OPVP_ImageFormat imageFormat,
    OPVP_Rectangle destinationSize, int count, void *imagedata);
static int CStubStartDrawImage(int printerContext, int sourceWidth,
    int sourceHeight, int colorDepth, OPVP_ImageFormat imageFormat,
    OPVP_Rectangle destinationSize);
static int CStubTransferDrawImage(int printerContext, int count,
    void *imagedata);
static int CStubEndDrawImage(int printerContext);
static int CStubStartScanline(int printerContext, int yposition);
static int CStubScanline(int printerContext, int nscanpairs, int *scanpairs);
static int CStubEndScanline(int printerContext);
static int CStubStartRaster(int printerContext, int rasterWidth);
static int CStubTransferRasterData(int printerContext, int count,
    unsigned char *data);
static int CStubSkipRaster(int printerContext, int count);
static int CStubEndRaster(int printerContext);
static int CStubStartStream(int printerContext);
static int CStubTransferStreamData(int printerContext, int count, void *data);
static int CStubEndStream(int printerContext);
#if (_PDAPI_VERSION_MAJOR_ > 0 || _PDAPI_VERSION_MINOR_ >= 2)
static int CStubQueryDeviceCapability(int printerContext, int queryflag,
   int buflen, char *infoBuf);
static int CStubQueryDeviceInfo(int printerContext, int queryflag,
   int buflen, char *infoBuf);
static int CStubResetClipPath(int printerContext);
#endif

#endif
