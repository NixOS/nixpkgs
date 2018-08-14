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


#ifndef _CNGPLPMOD
#define	_CNGPLPMOD

#ifdef _UI_DEBUG
#define UI_DEBUG(fmt, args...) fprintf( stdout,"UI >> " fmt, ##args)
#else
#define UI_DEBUG(fmt, args...)
#endif

#ifndef _OPAL
#include <cups/cups.h>
#else
#include <unistd.h>
#endif
#include "cngplpdef.h"

#ifdef __cplusplus
extern "C" {
#endif

#define	PRINTER_TYPE_OTHER	0
#define PRINTER_TYPE_LIPS	1
#define PRINTER_TYPE_PS		2
#define	PRINTER_TYPE_CAPT	3
#define	PRINTER_TYPE_UFR2	4
#define	PRINTER_TYPE_FAX	5

#define	PORTRAIT	3
#define	LANDSCAPE	4
#define	REV_LAND	5
#define	REV_PORT	6

#undef	max
#undef	min
#define	max(a, b)	( ( (a) > (b) ) ? (a) : (b) )
#define	min(a, b)	( ( (a) < (b) ) ? (a) : (b) )

enum{
	FILTER_NONE,
	FILTER_IMAGE,
	FILTER_TEXT,
	FILTER_HPGL,
};

enum{
	IMGPOSI_TOP_LEFT,
	IMGPOSI_LEFT,
	IMGPOSI_BOTTOM_LEFT,
	IMGPOSI_TOP,
	IMGPOSI_CENTER,
	IMGPOSI_BOTTOM,
	IMGPOSI_TOP_RIGHT,
	IMGPOSI_RIGHT,
	IMGPOSI_BOTTOM_RIGHT
};

enum{
	PAGESEL_ALL,
	PAGESEL_ODD,
	PAGESEL_EVEN,
	PAGESEL_RANGE,
};

#define	OUTPUT_METHOD_PRINT	0
#define	OUTPUT_METHOD_MEILBOX	1
#define	OUTPUT_METHOD_SECURED	2

#define	SELECTBY_NONE		0
#define	SELECTBY_INPUTSLOT	1
#define	SELECTBY_MEDIATYPE	2

#define	CNUICONF_FLG_CNCOPIES_COLLATE		0x0001
#define	CNUICONF_FLG_CUSTOMSIZE				0x0002
#define	CNUICONF_FLG_INPUTSLOT				0x0004
#define	CNUICONF_FLG_CNDUPLEX				0x0008
#define	CNUICONF_FLG_CNOUTPUTPROFILE		0x0010
#define	CNUICONF_FLG_CNMONITORPROFILE		0x0020
#define	CNUICONF_FLG_NUMBER_UP				0x0040
#define	CNUICONF_FLG_ORIENTATION_REQUESTED	0x0080

#define	CNSUMMARY_FLG_GUTTER			0x0001

#define	DUPLEX_VALTYPE_TRUE	1
#define	DUPLEX_VALTYPE_TUMBLE	2

typedef enum{
	PICKONE = 1,
	PICKMANY,
	BOOLEAN,
}UIType;

typedef struct uivalue_s{
	char 		*key;
	char		*value;
	int		opt_flag;
	struct uivalue_s *next;
}UIValueList;

typedef struct uiconst_s{
	char		*key;
	char		*option;
	struct uiconst_s *next;
}UIConstList, UIConfList, UIChgList;

typedef struct uiextconf_s{
	UIConfList *other_elem;
	UIConfList *conf_elem;
	struct uiextconf_s *next;
}UIExtConfList, UIExtChgList;

typedef struct uioptionlist_s{
	char		*name;
	char		*text;
	int		disable;
	int		num_uiconst;
	UIConstList	*uiconst;
	UIExtConfList	*uiconf;
	UIExtChgList	*uichg;
	struct uioptionlist_s *next;
}UIOptionList;

typedef struct ui_items_s{
	UIType	type;
	char		*name;
	char		*string;
	char		*default_option;
	char		*new_option;
	UIOptionList	*current_option;
	int		num_options;
	UIOptionList	*opt_lists;
	int		disable;
	int		num_uiconst;
	UIConstList	*uiconst;
	struct ui_items_s *next;
}UIItemsList;

typedef struct form_items_s{
	char *handle;
	char *name;
	char *date;
	char *color;
	int disable;
	struct form_items_s *next;
}FormList;

typedef struct{
	int job_account;
	char job_account_id[12];
	char job_account_passwd[8];
	char usr_passwd[128];
#ifndef _OPAL
	char doc_name[128];
#else
	char *doc_name;
#endif
	char usr_name[128];
	char passwd_array[8];
	int data_name;
	int holddata_name;
#ifndef _OPAL
	char enter_name[128];
#else
	char *enter_name;
#endif
#ifndef __APPLE__
	int box_num;
#else
	char box_num[512];
#endif
	int disable_job_account_bw;
	int show_disable_job_account_bw;
	int org_job_account;
	char org_job_account_id[12];
	char org_job_account_passwd[8];
	char form_handle[128];
	FormList *form_list;
	char form_name[128];
	char hold_name[128];
#if !defined(__APPLE__) && !defined(_OPAL)
	int show_job_account;
#endif
}SpecialFunc;

typedef struct{
	char note[97];
	char details[385];
}JobNote;

#define	MEDIA_BRAND_FLG_WEIGHT_MIN	0x00000001
#define	MEDIA_BRAND_FLG_WEIGHT_MAX	0x00000002
#define	MEDIA_BRAND_FLG_SURFACE		0x00000004
#define	MEDIA_BRAND_FLG_SHAPE		0x00000008
#define	MEDIA_BRAND_FLG_COLOR		0x00000010
typedef struct media_brand_conv_s{
	long flag;
	char *name;
	long weight_min;
	long weight_max;
	long surface;
	long shape;
	long color;
	struct media_brand_conv_s *next;
}MediaBrandConvertList;

typedef struct media_brand_items_s{
	long id;
	char *name;
	long weight;
	long surface;
	long shape;
	long color;
	struct media_brand_items_s *next;
}MediaBrandList;

typedef struct {
	MediaBrandList *def_item;
	MediaBrandList *cur_item;
	MediaBrandList *def_ins_item;
	MediaBrandList *cur_ins_item;
	MediaBrandList *def_interleaf_item;
	MediaBrandList *cur_interleaf_item;
	MediaBrandList *def_pb_cover_item;
	MediaBrandList *cur_pb_cover_item;

	MediaBrandList *brand_list;
	MediaBrandConvertList *convert_list;
}MediaBrand;

typedef struct{
	char send_time[6];
	char outside_line_number[6];
	char sender_name[100];
	char outside_line_number_intra[6];
	char outside_line_number_ngn[6];
	char outside_line_number_ngnmynum[6];
	char outside_line_number_voip[6];
}FAXFunc;

typedef struct{
	char *printer_name;
	int printer_type;
	int max_copy_num;
	int color_mode;
	int items_num;
	int selectby;
	int gutter_value;
	double gutter_value_d;
	int startnum_value;
	int max_gutter_value;
	double max_gutter_value_d;
	int max_box_num;
	int max_doc_length;
	int list_mediatype_value;
	int list_pagesize_value;
	int us_type;
	int input_slot_type;
	SpecialFunc	*special;
	UIItemsList *items_list;
	int dpicon_pictid;
	int enable_finishflag;
	int enable_inputflag;
	int enable_qualitytype;
	int uiconf_flag;
	int summary_flag;
	UIValueList *uivalue;
	int custom_size;
	int duplex_valtype;
	int shift_pos_type;
	int shift_upwards;
	int shift_right;
	int shift_front_long;
	int shift_front_short;
	int shift_back_long;
	int shift_back_short;
	double detail_shift_upwards;
	double detail_shift_right;
	double detail_shift_front_long;
	double detail_shift_front_short;
	double detail_shift_back_long;
	double detail_shift_back_short;
	JobNote *job_note;
	int offset_num;
	double guttershiftnum_value_d;
	double tab_shift;
	MediaBrand *media_brand;
	char *drv_root_path;
	UIItemsList *dev_items_list;
	char *ins_pos;
	char *ins_pos_papersource;
	char *ins_pos_printon;
	char *tab_ins_pos;
	char *tab_ins_pos_papersource;
	char *tab_ins_pos_printon;
	int tab_ins_multi_number;
	char *tab_ins_multi_papersource;
	char *tab_ins_multi_papertype;
	double ins_tab_shift;
	double adjust_trim_num;
	double adjust_frtrim_num;
	double adjust_tbtrim_num;
	double pb_fin_fore_trim_num;
	double pb_fin_topbtm_trim_num;
	FAXFunc *fax_setting;
	char *feed_paper_name;
	char *bin_name;
	char *bin_name_array;
	int stack_copies_num;
	int saddle_press_adjust;
	int list_specialprintmode_value;
	char *pcfile_name;
#ifndef __APPLE__
	char multipunch[16];
#endif
#if !defined(__APPLE__) && !defined(_OPAL)
	int booklet_offset;
#endif
	char *manufacturer;
	char *nickname;
	char *cnpdl_type;
	char *ap_printer_icon_path;
}PPDOptions;

typedef struct{
	char *text;
	char *value;
}CupsOptionTxtVal;

typedef struct cups_opt_val_t{
	char *option;
	char *value;
	struct cups_opt_val_t *next;
}CupsOptVal;

typedef struct{
	CupsOptVal *option;
	int opt_num;
	int filter;
}CupsCommonOptions;

typedef struct{
	CupsOptVal *option;
	int opt_num;
	int img_reso_scale;
}CupsImageOptions;

typedef struct{
	CupsOptVal *option;
	int opt_num;
	int margin_on;
	int margin_unit;
}CupsTextOptions;

typedef struct{
	CupsOptVal *option;
	int opt_num;
}CupsHPGLOptions;

typedef struct{
	CupsCommonOptions *common;
	CupsImageOptions *image;
	CupsTextOptions *text;
	CupsHPGLOptions *hpgl;
}CupsOptions;


typedef struct save_data_t SaveOptions;

typedef struct{
	int printer_num;
	int update_flag;
	char **printer_names;
	char *ppdfile;
	char *file_name;
	const char *curr_printer;
	char *update_options;
	CupsOptions *cups_opt;
	PPDOptions *ppd_opt;
	SaveOptions *save_data;
}cngplpData;


#ifndef _OPAL
cngplpData* cngplpNew(char *file_name);
#else
cngplpData* cngplpNew(char *file_name, const char *ppdFilePath);
#endif
void cngplpDestroy(cngplpData *data);
int cngplpInitOptions(cngplpData *data);
void cngplpFreeOptions(cngplpData *data);
char* cngplpSetData(cngplpData *data, int id, char *value);
char* cngplpGetData(cngplpData *data, int id);
char* cngplpSetValue(cngplpData *data, char *key, char *value);
char* cngplpGetValue(cngplpData *data, char *key);
char* cngplpIDtoKey(int id);
char* cngplpGetDevOptionConflict(cngplpData *data, int id);
char* cngplpGetFuncVerConflict(cngplpData *data, int id);

#if _UI_DEBUG
void DebugDisable(cngplpData *data, int id);
#endif

char* cngplp_util_strcpy( char* dst, const char* src );
char* cngplp_util_strcat( char* dst, const char* src );
int	cngplp_util_sprintf( char* dst, const char* frm, ... );

#if !defined(__APPLE__) && !defined(_OPAL)
void ConvertDecimalPoint(char *value);
#endif

#ifdef __cplusplus
}
#endif

#endif
