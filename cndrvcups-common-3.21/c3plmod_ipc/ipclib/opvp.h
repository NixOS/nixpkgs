/*
 * OpenPrinting Vector Printer Driver API Definitions [opvp.h]
 *
 * Copyright (c) 2006 Free Standards Group
 * Copyright (c) 2006 Fuji Xerox Printing Systems Co., Ltd.
 * Copyright CANON INC. 2006
 * Copyright (c) 2003-2006 AXE Inc.
 *
 * All Rights Reserverd.
 *
 * Permission to use, copy, modify, distribute, and sell this software
 * and its documentation for any purpose is hereby granted without
 * fee, provided that the above copyright notice appear in all copies
 * and that both that copyright notice and this permission notice
 * appear in supporting documentation.
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT.  IN NO EVENT SHALL THE OPEN GROUP BE LIABLE FOR
 * ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
 /*
  2007 Modified  for OPVP 1.0 by BBR Inc.
 */

#ifndef _OPVP_H_
#define _OPVP_H_

#define OPVP_OK			0
#define OPVP_FATALERROR		-1
#define OPVP_BADREQUEST		-2
#define OPVP_BADCONTEXT		-3
#define OPVP_NOTSUPPORTED	-4
#define OPVP_JOBCANCELED	-5
#define OPVP_PARAMERROR		-6
#define OPVP_VERSIONERROR	-7

typedef int opvp_dc_t;
typedef int opvp_result_t;
typedef unsigned char opvp_byte_t;
typedef unsigned char opvp_char_t;
typedef int opvp_int_t;
typedef int opvp_fix_t;
typedef float opvp_float_t;
typedef unsigned int opvp_flag_t;
typedef unsigned int opvp_rop_t;

#define OPVP_FIX_FRACT_WIDTH    8
#define OPVP_FIX_FRACT_DENOM    (1<<OPVP_FIX_FRACT_WIDTH)
#define OPVP_FIX_FLOOR_WIDTH    (sizeof(int)*8-OPVP_FIX_FRACT_WIDTH)

#define	OPVP_I2FIX(i,fix)	(fix=i<<OPVP_FIX_FRACT_WIDTH)
#define	OPVP_F2FIX(f,fix)	(fix=((int)floor(f)<<OPVP_FIX_FRACT_WIDTH)\
				    |((int)((f-floor(f))*OPVP_FIX_FRACT_DENOM)\
				      &(OPVP_FIX_FRACT_DENOM-1)))

typedef struct _opvp_point {
	opvp_fix_t x, y;
} opvp_point_t;

typedef struct _opvp_rectangle {
	opvp_point_t p0;
	opvp_point_t p1;
} opvp_rectangle_t;

typedef struct _opvp_roundrectangle {
	opvp_point_t p0;
	opvp_point_t p1;
	opvp_fix_t xellipse, yellipse;
} opvp_roundrectangle_t;

typedef enum _opvp_imageformat {
	OPVP_IFORMAT_RAW		= 0,
	OPVP_IFORMAT_MASK		= 1,
	OPVP_IFORMAT_RLE		= 2,
	OPVP_IFORMAT_JPEG		= 3,
	OPVP_IFORMAT_PNG		= 4
} opvp_imageformat_t;

typedef enum _opvp_colormapping {
	OPVP_CMAP_DIRECT		= 0,
	OPVP_CMAP_INDEXED		= 1
} opvp_colormapping_t;

typedef enum _opvp_cspace {
	OPVP_CSPACE_BW			= 0,
	OPVP_CSPACE_DEVICEGRAY		= 1,
	OPVP_CSPACE_DEVICECMY		= 2,
	OPVP_CSPACE_DEVICECMYK		= 3,
	OPVP_CSPACE_DEVICERGB		= 4,
	OPVP_CSPACE_DEVICEKRGB		= 5,
	OPVP_CSPACE_STANDARDRGB		= 6,
	OPVP_CSPACE_STANDARDRGB64	= 7
} opvp_cspace_t;

typedef enum _opvp_fillmode {
	OPVP_FILLMODE_EVENODD		= 0,
	OPVP_FILLMODE_WINDING		= 1
} opvp_fillmode_t;

typedef enum _opvp_paintmode {
	OPVP_PAINTMODE_OPAQUE		= 0,
	OPVP_PAINTMODE_TRANSPARENT	= 1
} opvp_paintmode_t;

typedef enum _opvp_cliprule {
	OPVP_CLIPRULE_EVENODD		= 0,
	OPVP_CLIPRULE_WINDING		= 1
} opvp_cliprule_t;

typedef enum _opvp_linestyle {
	OPVP_LINESTYLE_SOLID		= 0,
	OPVP_LINESTYLE_DASH		= 1
} opvp_linestyle_t;

typedef enum _opvp_linecap {
	OPVP_LINECAP_BUTT		= 0,
	OPVP_LINECAP_ROUND		= 1,
	OPVP_LINECAP_SQUARE		= 2
} opvp_linecap_t;

typedef enum _opvp_linejoin {
	OPVP_LINEJOIN_MITER		= 0,
	OPVP_LINEJOIN_ROUND		= 1,
	OPVP_LINEJOIN_BEVEL		= 2
} opvp_linejoin_t;

typedef enum _opvp_bdtype {
	OPVP_BDTYPE_NORMAL		= 0
} opvp_bdtype_t;

typedef struct _opvp_brushdata {
	opvp_bdtype_t type;
	opvp_int_t width, height, pitch;
#if defined(__GNUC__) && __GNUC__ <= 2
	opvp_byte_t data[1];
#else
	opvp_byte_t data[];
#endif

} opvp_brushdata_t;

typedef struct _opvp_brush {
	opvp_cspace_t colorSpace;
	opvp_int_t color[4];
	opvp_int_t xorg, yorg;
	opvp_brushdata_t *pbrush;
} opvp_brush_t;

typedef enum _opvp_arcmode {
	OPVP_ARC			= 0,
	OPVP_CHORD			= 1,
	OPVP_PIE			= 2
} opvp_arcmode_t;

typedef enum _opvp_arcdir {
	OPVP_CLOCKWISE			= 0,
	OPVP_COUNTERCLOCKWISE		= 1
} opvp_arcdir_t;

typedef enum _opvp_pathmode {
	OPVP_PATHCLOSE			= 0,
	OPVP_PATHOPEN			= 1
} opvp_pathmode_t;

typedef struct _opvp_ctm {
	opvp_float_t a, b, c, d, e, f;
} opvp_ctm_t;

typedef enum _opvp_queryinfoflags {
  OPVP_QF_DEVICERESOLUTION	= 0x00000001,
  OPVP_QF_MEDIASIZE		= 0x00000002,
  OPVP_QF_PAGEROTATION		= 0x00000004,
  OPVP_QF_MEDIANUP		= 0x00000008,
  OPVP_QF_MEDIADUPLEX		= 0x00000010,
  OPVP_QF_MEDIASOURCE		= 0x00000020,
  OPVP_QF_MEDIADESTINATION	= 0x00000040,
  OPVP_QF_MEDIATYPE		= 0x00000080,
  OPVP_QF_MEDIACOPY		= 0x00000100,
  OPVP_QF_PRINTREGION		= 0x00010000
} opvp_queryinfoflags_t;


typedef	struct _opvp_api_procs {
	opvp_dc_t     (*opvpOpenPrinter)(opvp_int_t,const opvp_char_t*,const opvp_int_t[2],struct _opvp_api_procs**);
	opvp_result_t (*opvpClosePrinter)(opvp_dc_t);
	opvp_result_t (*opvpStartJob)(opvp_dc_t,const opvp_char_t*);
	opvp_result_t (*opvpEndJob)(opvp_dc_t);
	opvp_result_t (*opvpAbortJob)(opvp_dc_t);
	opvp_result_t (*opvpStartDoc)(opvp_dc_t,const opvp_char_t*);
	opvp_result_t (*opvpEndDoc)(opvp_dc_t);
	opvp_result_t (*opvpStartPage)(opvp_dc_t,const opvp_char_t*);
	opvp_result_t (*opvpEndPage)(opvp_dc_t);
	opvp_result_t (*opvpQueryDeviceCapability)(opvp_dc_t,opvp_flag_t,opvp_int_t*,opvp_byte_t*);
	opvp_result_t (*opvpQueryDeviceInfo)(opvp_dc_t,opvp_flag_t,opvp_int_t*,opvp_char_t*);
	opvp_result_t (*opvpResetCTM)(opvp_dc_t);
	opvp_result_t (*opvpSetCTM)(opvp_dc_t,const opvp_ctm_t*);
	opvp_result_t (*opvpGetCTM)(opvp_dc_t,opvp_ctm_t*);
	opvp_result_t (*opvpInitGS)(opvp_dc_t);
	opvp_result_t (*opvpSaveGS)(opvp_dc_t);
	opvp_result_t (*opvpRestoreGS)(opvp_dc_t);
	opvp_result_t (*opvpQueryColorSpace)(opvp_dc_t,opvp_int_t*,opvp_cspace_t*);
	opvp_result_t (*opvpSetColorSpace)(opvp_dc_t,opvp_cspace_t);
	opvp_result_t (*opvpGetColorSpace)(opvp_dc_t,opvp_cspace_t*);
	opvp_result_t (*opvpSetFillMode)(opvp_dc_t,opvp_fillmode_t);
	opvp_result_t (*opvpGetFillMode)(opvp_dc_t,opvp_fillmode_t*);
	opvp_result_t (*opvpSetAlphaConstant)(opvp_dc_t,opvp_float_t);
	opvp_result_t (*opvpGetAlphaConstant)(opvp_dc_t,opvp_float_t*);
	opvp_result_t (*opvpSetLineWidth)(opvp_dc_t,opvp_fix_t);
	opvp_result_t (*opvpGetLineWidth)(opvp_dc_t,opvp_fix_t*);
	opvp_result_t (*opvpSetLineDash)(opvp_dc_t,opvp_int_t,const opvp_fix_t*);
	opvp_result_t (*opvpGetLineDash)(opvp_dc_t,opvp_int_t*,opvp_fix_t*);
	opvp_result_t (*opvpSetLineDashOffset)(opvp_dc_t,opvp_fix_t);
	opvp_result_t (*opvpGetLineDashOffset)(opvp_dc_t,opvp_fix_t*);
	opvp_result_t (*opvpSetLineStyle)(opvp_dc_t,opvp_linestyle_t);
	opvp_result_t (*opvpGetLineStyle)(opvp_dc_t,opvp_linestyle_t*);
	opvp_result_t (*opvpSetLineCap)(opvp_dc_t,opvp_linecap_t);
	opvp_result_t (*opvpGetLineCap)(opvp_dc_t,opvp_linecap_t*);
	opvp_result_t (*opvpSetLineJoin)(opvp_dc_t,opvp_linejoin_t);
	opvp_result_t (*opvpGetLineJoin)(opvp_dc_t,opvp_linejoin_t*);
	opvp_result_t (*opvpSetMiterLimit)(opvp_dc_t,opvp_fix_t);
	opvp_result_t (*opvpGetMiterLimit)(opvp_dc_t,opvp_fix_t*);
	opvp_result_t (*opvpSetPaintMode)(opvp_dc_t,opvp_paintmode_t);
	opvp_result_t (*opvpGetPaintMode)(opvp_dc_t,opvp_paintmode_t*);
	opvp_result_t (*opvpSetStrokeColor)(opvp_dc_t,const opvp_brush_t*);
	opvp_result_t (*opvpSetFillColor)(opvp_dc_t,const opvp_brush_t*);
	opvp_result_t (*opvpSetBgColor)(opvp_dc_t,const opvp_brush_t*);
	opvp_result_t (*opvpNewPath)(opvp_dc_t);
	opvp_result_t (*opvpEndPath)(opvp_dc_t);
	opvp_result_t (*opvpStrokePath)(opvp_dc_t);
	opvp_result_t (*opvpFillPath)(opvp_dc_t);
	opvp_result_t (*opvpStrokeFillPath)(opvp_dc_t);
	opvp_result_t (*opvpSetClipPath)(opvp_dc_t,opvp_cliprule_t);
	opvp_result_t (*opvpResetClipPath)(opvp_dc_t);
	opvp_result_t (*opvpSetCurrentPoint)(opvp_dc_t,opvp_fix_t,opvp_fix_t);
	opvp_result_t (*opvpLinePath)(opvp_dc_t,opvp_pathmode_t,opvp_int_t,const opvp_point_t*);
	opvp_result_t (*opvpPolygonPath)(opvp_dc_t,opvp_int_t,const opvp_int_t*,const opvp_point_t*);
	opvp_result_t (*opvpRectanglePath)(opvp_dc_t,opvp_int_t,const opvp_rectangle_t*);
	opvp_result_t (*opvpRoundRectanglePath)(opvp_dc_t,opvp_int_t,const opvp_roundrectangle_t*);
	opvp_result_t (*opvpBezierPath)(opvp_dc_t,opvp_int_t,const opvp_point_t*);
	opvp_result_t (*opvpArcPath)(opvp_dc_t,opvp_arcmode_t,opvp_arcdir_t,opvp_fix_t,opvp_fix_t,opvp_fix_t,opvp_fix_t,opvp_fix_t,opvp_fix_t,opvp_fix_t,opvp_fix_t);
	opvp_result_t (*opvpDrawImage)(opvp_dc_t,opvp_int_t,opvp_int_t,opvp_int_t,opvp_imageformat_t,opvp_int_t, opvp_int_t ,const void*);
	opvp_result_t (*opvpStartDrawImage)(opvp_dc_t,opvp_int_t,opvp_int_t,opvp_int_t,opvp_imageformat_t,opvp_int_t, opvp_int_t);
	opvp_result_t (*opvpTransferDrawImage)(opvp_dc_t,opvp_int_t,const void*);
	opvp_result_t (*opvpEndDrawImage)(opvp_dc_t);
	opvp_result_t (*opvpStartScanline)(opvp_dc_t,opvp_int_t);
	opvp_result_t (*opvpScanline)(opvp_dc_t,opvp_int_t,const opvp_int_t*);
	opvp_result_t (*opvpEndScanline)(opvp_dc_t);
	opvp_result_t (*opvpStartRaster)(opvp_dc_t,opvp_int_t);
	opvp_result_t (*opvpTransferRasterData)(opvp_dc_t,opvp_int_t,const opvp_byte_t*);
	opvp_result_t (*opvpSkipRaster)(opvp_dc_t,opvp_int_t);
	opvp_result_t (*opvpEndRaster)(opvp_dc_t);
	opvp_result_t (*opvpStartStream)(opvp_dc_t);
	opvp_result_t (*opvpTransferStreamData)(opvp_dc_t,opvp_int_t,const void*);
	opvp_result_t (*opvpEndStream)(opvp_dc_t);
} opvp_api_procs_t;

opvp_dc_t opvpOpenPrinter(
	opvp_int_t outputFD,
	const opvp_char_t *printerModel,
	const opvp_int_t apiVersion[2],
	opvp_api_procs_t **apiProcs);

extern opvp_int_t	opvpErrorNo;

#endif
