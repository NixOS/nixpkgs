/*

Copyright (c) 2003-2004, AXE, Inc.  All rights reserved.

Permission is hereby granted, free of opvp_char_tge, to any person obtaining
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

#ifndef _OPVP_RPC_CLIENT_H_
#define _OPVP_RPC_CLIENT_H_

#include "opvp.h"

#define SERVERNAME "c3pldrv"
#define DRVNAME    ""


static opvp_result_t CStubClosePrinter(opvp_dc_t printerContext);
static opvp_result_t CStubStartJob(opvp_dc_t printerContext,
    const opvp_char_t *jobInfo);
static opvp_result_t CStubEndJob(opvp_dc_t printerContext);
static opvp_result_t CStubAbortJob(opvp_dc_t printerContext);
static opvp_result_t CStubStartDoc(opvp_dc_t printerContext,
    const opvp_char_t *docInfo);
static opvp_result_t CStubEndDoc(opvp_dc_t printerContext);
static opvp_result_t CStubStartPage(opvp_dc_t printerContext,
    const opvp_char_t *pageInfo);
static opvp_result_t CStubEndPage(opvp_dc_t printerContext);
static opvp_result_t CStubResetCTM(opvp_dc_t printerContext);
static opvp_result_t CStubSetCTM(opvp_dc_t printerContext,
    const opvp_ctm_t *pCTM);
static opvp_result_t CStubGetCTM(opvp_dc_t printerContext,
    opvp_ctm_t *pCTM);
static opvp_result_t CStubInitGS(opvp_dc_t printerContext);
static opvp_result_t CStubSaveGS(opvp_dc_t printerContext);
static opvp_result_t CStubRestoreGS(opvp_dc_t printerContext);
static opvp_result_t CStubQueryColorSpace(opvp_dc_t printerContext,
    opvp_int_t *pnum, opvp_cspace_t *pcspace);
static opvp_result_t CStubSetColorSpace(opvp_dc_t printerContext,
    opvp_cspace_t cspace);
static opvp_result_t CStubGetColorSpace(opvp_dc_t printerContext,
    opvp_cspace_t *pcspace);
static opvp_result_t CStubSetFillMode(opvp_dc_t printerContext,
    opvp_fillmode_t fillmode);
static opvp_result_t CStubGetFillMode(opvp_dc_t printerContext, opvp_fillmode_t *pfillmode);
static opvp_result_t CStubSetAlphaConstant(opvp_dc_t printerContext,
    opvp_float_t alpha);
static opvp_result_t CStubGetAlphaConstant(opvp_dc_t printerContext,
    opvp_float_t *palpha);
static opvp_result_t CStubSetLineWidth(opvp_dc_t printerContext,
    opvp_fix_t width);
static opvp_result_t CStubGetLineWidth(opvp_dc_t printerContext,
    opvp_fix_t *pwidth);
static opvp_result_t CStubSetLineDash(opvp_dc_t printerContext, opvp_int_t num,
    const opvp_fix_t *pdash);
static opvp_result_t CStubGetLineDash(opvp_dc_t printerContext,
    opvp_int_t *pnum, opvp_fix_t *pdash);
static opvp_result_t CStubSetLineDashOffset(opvp_dc_t printerContext,
    opvp_fix_t offset);
static opvp_result_t CStubGetLineDashOffset(opvp_dc_t printerContext,
    opvp_fix_t *poffset);
static opvp_result_t CStubSetLineStyle(opvp_dc_t printerContext,
    opvp_linestyle_t linestyle);
static opvp_result_t CStubGetLineStyle(opvp_dc_t printerContext,
    opvp_linestyle_t *plinestyle);
static opvp_result_t CStubSetLineCap(opvp_dc_t printerContext,
    opvp_linecap_t linecap);
static opvp_result_t CStubGetLineCap(opvp_dc_t printerContext,
    opvp_linecap_t *plinecap);
static opvp_result_t CStubSetLineJoin(opvp_dc_t printerContext,
    opvp_linejoin_t linejoin);
static opvp_result_t CStubGetLineJoin(opvp_dc_t printerContext,
    opvp_linejoin_t *plinejoin);
static opvp_result_t CStubSetMiterLimit(opvp_dc_t printerContext,
    opvp_fix_t miterlimit);
static opvp_result_t CStubGetMiterLimit(opvp_dc_t printerContext,
    opvp_fix_t *pmiterlimit);
static opvp_result_t CStubSetPaintMode(opvp_dc_t printerContext,
    opvp_paintmode_t paintmode);
static opvp_result_t CStubGetPaintMode(opvp_dc_t printerContext,
    opvp_paintmode_t *ppaintmode);
static opvp_result_t CStubSetStrokeColor(opvp_dc_t printerContext,
    const opvp_brush_t *brush);
static opvp_result_t CStubSetFillColor(opvp_dc_t printerContext,
    const opvp_brush_t *brush);
static opvp_result_t CStubSetBgColor(opvp_dc_t printerContext,
    const opvp_brush_t *brush);
static opvp_result_t CStubNewPath(opvp_dc_t printerContext);
static opvp_result_t CStubEndPath(opvp_dc_t printerContext);
static opvp_result_t CStubStrokePath(opvp_dc_t printerContext);
static opvp_result_t CStubFillPath(opvp_dc_t printerContext);
static opvp_result_t CStubStrokeFillPath(opvp_dc_t printerContext);
static opvp_result_t CStubSetClipPath(opvp_dc_t printerContext,
    opvp_cliprule_t clipRule);
static opvp_result_t CStubSetCurrentPoint(opvp_dc_t printerContext,
    opvp_fix_t x, opvp_fix_t y);
static opvp_result_t CStubLinePath(opvp_dc_t printerContext,
    opvp_pathmode_t flag, opvp_int_t npoints, const opvp_point_t *points);
static opvp_result_t CStubPolygonPath(opvp_dc_t printerContext,
    opvp_int_t npolygons, const opvp_int_t *nvertexes,
    const opvp_point_t *points);
static opvp_result_t CStubRectanglePath(opvp_dc_t printerContext,
    opvp_int_t nrectangles, const opvp_rectangle_t *reclangles);
static opvp_result_t CStubRoundRectanglePath(opvp_dc_t printerContext,
    opvp_int_t nrectangles, const opvp_roundrectangle_t *reclangles);
static opvp_result_t CStubBezierPath(opvp_dc_t printerContext,
    opvp_int_t npoints, const opvp_point_t *points);
static opvp_result_t CStubArcPath(opvp_dc_t printerContext,
    opvp_arcmode_t kind, opvp_arcdir_t dir, opvp_fix_t bbx0,
    opvp_fix_t bby0, opvp_fix_t bbx1, opvp_fix_t bby1, opvp_fix_t x0,
    opvp_fix_t y0, opvp_fix_t x1, opvp_fix_t y1);
static opvp_result_t CStubDrawImage(opvp_dc_t printerContext,
    opvp_int_t sourceWidth, opvp_int_t sourceHeight, opvp_int_t sourcePitch,
    opvp_imageformat_t imageFormat,
    opvp_int_t destinationWidth, opvp_int_t destinationHeight,
    const void *imagedata);
static opvp_result_t CStubStartDrawImage(opvp_dc_t printerContext,
    opvp_int_t sourceWidth, opvp_int_t sourceHeight, opvp_int_t sourcePitch,
    opvp_imageformat_t imageFormat,
    opvp_int_t destinationWidth, opvp_int_t destinationHeight);
static opvp_result_t CStubTransferDrawImage(opvp_dc_t printerContext,
    opvp_int_t count, const void *imagedata);
static opvp_result_t CStubEndDrawImage(opvp_dc_t printerContext);
static opvp_result_t CStubStartScanline(opvp_dc_t printerContext,
    opvp_int_t yposition);
static opvp_result_t CStubScanline(opvp_dc_t printerContext,
    opvp_int_t nscanpairs, const opvp_int_t *scanpairs);
static opvp_result_t CStubEndScanline(opvp_dc_t printerContext);
static opvp_result_t CStubStartRaster(opvp_dc_t printerContext,
    opvp_int_t rasterWidth);
static opvp_result_t CStubTransferRasterData(opvp_dc_t printerContext,
    opvp_int_t count, const opvp_byte_t *data);
static opvp_result_t CStubSkipRaster(opvp_dc_t printerContext,
    opvp_int_t count);
static opvp_result_t CStubEndRaster(opvp_dc_t printerContext);
static opvp_result_t CStubStartStream(opvp_dc_t printerContext);
static opvp_result_t CStubTransferStreamData(opvp_dc_t printerContext,
    opvp_int_t count, const void *data);
static opvp_result_t CStubEndStream(opvp_dc_t printerContext);
static opvp_result_t CStubQueryDeviceCapability(opvp_dc_t printerContext,
    opvp_queryinfoflags_t queryflag, opvp_int_t *buflen, opvp_char_t *infoBuf);
static opvp_result_t CStubQueryDeviceInfo(opvp_dc_t printerContext,
    opvp_queryinfoflags_t queryflag, opvp_int_t *buflen, opvp_char_t *infoBuf);
static opvp_result_t CStubResetClipPath(opvp_dc_t printerContext);

#endif
