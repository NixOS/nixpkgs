/*
 *  Print Dialog for Canon LIPS/PS/LIPSLX/UFR2/CAPT Printer.
 *  Copyright CANON INC. 2010
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

/* The following codes, from line 563 to line 657, are partly exracted 
 * from [printui]-[src]-[keytext.c] and modified by CANON INC. on Feb. 2010.
 * 
*/

/*  Canon Inkjet Printer Driver for Linux
 *  Copyright CANON INC. 2001
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; version 2 of the License.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
 *
 * NOTE:
 *  - As a special exception, this program is permissible to link with the
 *    libraries released as the binary modules.
 *  - If you write modifications of your own for these programs, it is your
 *    choice whether to permit this exception to apply to your modifications.
 *    If you do not wish that, delete this exception.
 */

/*
 * [Change Log]
 *  AddKeyAndTextToTree() - code rule changed,for example if( xmlnode...) changed if(xmlnode...
 *  ParseXMLDoc() -The way to obtain the node changed
 *  ReadXMLFile() - The way to obtain the node changed
 *  LoadKeyTextList() - code rule changed
 *  TreeTraverseFunc() - code rule changed
 *  FreeKeyTextList() - Unity release operation
 *  LookupText() - add that get the text from the package of module
 */





#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/stat.h>
#include <gtk/gtk.h>
#include <libintl.h>

#include "cngplpmod.h"
#include "ppdoptions.h"
#include "localize.h"
#include "controller.h"
#include "widgets.h"
#include "config.h"
#include "ppdkeys.h"

#ifdef __FOR_UFR2__
#define RES_FILE_NAME "common_ufr2.res"
#elif defined __FOR_LIPS__
#define RES_FILE_NAME "common_lips.res"
#elif defined __FOR_CAPT__
#define RES_FILE_NAME "common_capt.res"
#elif defined __FOR_NCAP__
#define RES_FILE_NAME "common_ncap.res"
#else
#define RES_FILE_NAME "common_ps.res"
#endif

#define RES 4

static KeyTextList* g_keytext_list_common = NULL;
static KeyTextList* g_keytext_list_printer = NULL;
static void AddKeyAndTextToTree(const xmlNodePtr xmlnode, GTree* tree);
static void ParseXMLDoc(const xmlDocPtr doc, GTree* tree);
static gboolean ReadXMLFile(const char *fname, GTree* tree);
static KeyTextList* LoadKeyTextList(const gchar* filename);
static const gchar* LookupText(const KeyTextList* list, const gchar* key);
void FreeResource(void);
void FreeKeyTextList(KeyTextList *key_text_list);

typedef struct {
	char *name;
	char *org_text;
}StrText;

static StrText numberup_str[] = {
	{"1 Page per Sheet", 	"number-up_1 Page per Sheet"},
	{"2 Page per Sheet", 	"number-up_2 Pages per Sheet"},
	{"4 Page per Sheet", 	"number-up_4 Pages per Sheet"},
	{"6 Page per Sheet", 	"number-up_6 Pages per Sheet"},
	{"9 Page per Sheet", 	"number-up_9 Pages per Sheet"},
	{"16 Page per Sheet",	"number-up_16 Pages per Sheet"},
	{NULL, NULL}
};

static StrText booklet_str[] = {
	{"None", 	"Booklet_None"},
	{"Left", 	"Booklet_Left"},
	{"Right", 	"Booklet_Right"},
	{NULL, NULL}
};

static StrText booklet_l_str[] = {
	{"None", 	"Booklet_None"},
	{"Left", 	"Booklet_L_Left"},
	{"Right", 	"Booklet_L_Right"},
	{NULL, NULL}
};

static StrText booklet_r_str[] = {
	{"None", 	"Booklet_None"},
	{"Left", 	"Booklet_R_Left"},
	{"Right", 	"Booklet_R_Right"},
	{NULL, NULL}
};

static StrText booklet_rl_str[] = {
	{"None", 	"Booklet_None"},
	{"Left", 	"Booklet_RL_Left"},
	{"Right", 	"Booklet_RL_Right"},
	{NULL, NULL}
};

static StrText bindinglocation_str[] = {
	{"Left", 	"BindEdge_Left"},
	{"Right", 	"BindEdge_Right"},
	{"Top", 	"BindEdge_Top"},
	{"Bottom", 	"BindEdge_Bottom"},
	{NULL, NULL}
};

static StrText bindinglocation_l_str[] = {
	{"Left", 	"BindEdge_L_Left"},
	{"Right", 	"BindEdge_L_Right"},
	{"Top", 	"BindEdge_L_Top"},
	{"Bottom", 	"BindEdge_L_Bottom"},
	{NULL, NULL}
};

static StrText bindinglocation_r_str[] = {
	{"Left", 	"BindEdge_R_Left"},
	{"Right", 	"BindEdge_R_Right"},
	{"Top", 	"BindEdge_R_Top"},
	{"Bottom", 	"BindEdge_R_Bottom"},
	{NULL, NULL}
};

static StrText bindinglocation_rl_str[] = {
	{"Left", 	"BindEdge_RL_Left"},
	{"Right", 	"BindEdge_RL_Right"},
	{"Top", 	"BindEdge_RL_Top"},
	{"Bottom", 	"BindEdge_RL_Bottom"},
	{NULL, NULL}
};

static StrText fold_str[] = {
	{"None",      		"CNFoldSetting_None"},
	{"Z-fold",		"CNFoldSetting_Z-fold"},
	{"C-fold",		"CNFoldSetting_C-fold"},
	{"Half Fold",		"CNFoldSetting_Half Fold"},
	{"Accordion Z-fold",	"CNFoldSetting_Accordion Z-fold"},
	{"Double Parallel Fold","CNFoldSetting_Double Parallel Fold"},
	{NULL, NULL}
};

static StrText saddlesetting_str[] = {
	{"None",      		"CNSaddleSetting_None"},
	{"Fold Only",		"CNSaddleSetting_Fold Only"},
	{"Fold + Saddle Stitch","CNSaddleSetting_Fold + Saddle Stitch"},
	{"Fold + Trim","CNSaddleSetting_Fold + Trim"},
	{"Fold + Saddle Stitch + Trim","CNSaddleSetting_Fold + Saddle Stitch + Trim"},
	{"Saddle Stitch",      	"CNSaddleSetting_Saddle Stitch"},
	{"Saddle Stitch + Trim","CNSaddleSetting_Saddle Stitch + Trim"},
	{NULL, NULL}
};

static StrText printstyle_str[] = {
	{"1-sided Printing",	"CNPrintStyle_1-sided Printing"},
	{"2-sided Printing",	"CNPrintStyle_2-sided Printing"},
	{"Booklet Printing",	"CNPrintStyle_Booklet Printing"},
	{NULL, NULL}
};

static StrText staplelocation_str[] = {
	{"None", 	"StapleLocation_None"},
	{"TopLeft", 	"StapleLocation_TopLeft"},
	{"Top", 	"StapleLocation_Top"},
	{"TopRight", 	"StapleLocation_TopRight"},
	{"Left", 	"StapleLocation_Left"},
	{"Right", 	"StapleLocation_Right"},
	{"BottomLeft", 	"StapleLocation_BottomLeft"},
	{"Bottom", 	"StapleLocation_Bottom"},
	{"BottomRight", "StapleLocation_BottomRight"},
	{NULL, NULL}
};

static StrText staplelocation_l_str[] = {
	{"None", 	"StapleLocation_L_None"},
	{"TopLeft", 	"StapleLocation_L_TopLeft"},
	{"Top", 	"StapleLocation_L_Top"},
	{"TopRight", 	"StapleLocation_L_TopRight"},
	{"Left", 	"StapleLocation_L_Left"},
	{"Right", 	"StapleLocation_L_Right"},
	{"BottomLeft", 	"StapleLocation_L_BottomLeft"},
	{"Bottom", 	"StapleLocation_L_Bottom"},
	{"BottomRight", "StapleLocation_L_BottomRight"},
	{NULL, NULL}
};

static StrText staplelocation_r_str[] = {
	{"None", 	"StapleLocation_R_None"},
	{"TopLeft", 	"StapleLocation_R_TopLeft"},
	{"Top", 	"StapleLocation_R_Top"},
	{"TopRight", 	"StapleLocation_R_TopRight"},
	{"Left", 	"StapleLocation_R_Left"},
	{"Right", 	"StapleLocation_R_Right"},
	{"BottomLeft", 	"StapleLocation_R_BottomLeft"},
	{"Bottom", 	"StapleLocation_R_Bottom"},
	{"BottomRight", "StapleLocation_R_BottomRight"},
	{NULL, NULL}
};

static StrText staplelocation_rl_str[] = {
	{"None", 	"StapleLocation_RL_None"},
	{"TopLeft", 	"StapleLocation_RL_TopLeft"},
	{"Top", 	"StapleLocation_RL_Top"},
	{"TopRight", 	"StapleLocation_RL_TopRight"},
	{"Left", 	"StapleLocation_RL_Left"},
	{"Right", 	"StapleLocation_RL_Right"},
	{"BottomLeft", 	"StapleLocation_RL_BottomLeft"},
	{"Bottom", 	"StapleLocation_RL_Bottom"},
	{"BottomRight", "StapleLocation_RL_BottomRight"},
	{NULL, NULL}
};

#define		STAPLELOCATIONTYPE_PORTRAITE	"1"

void InitKeyTextList(const char* res_path, const char* printer_name)
{
	char* res_name;
	char* res_name_common;
	struct stat s;
	gint status;

	res_name = (char*)g_malloc(strlen(res_path) + strlen(printer_name) + RES + 1);
	strcpy(res_name, res_path);
	strcat(res_name, printer_name);
	strcat(res_name, ".res");
	status = stat(res_name, &s);
	if((status == 0) && S_ISREG(s.st_mode)){
		g_keytext_list_printer = LoadKeyTextList(res_name);
	}else{
		g_keytext_list_printer = NULL;
	}
	res_name_common = (char*)g_malloc(strlen(res_path) + strlen(RES_FILE_NAME) + 1);
	strcpy(res_name_common, res_path);
	strcat(res_name_common, RES_FILE_NAME);
	g_keytext_list_common = LoadKeyTextList(res_name_common);
	free(res_name);
	res_name = NULL;
	free(res_name_common);
	res_name_common = NULL;
}

void FreeResource(void)
{
	if(g_keytext_list_common != NULL){
		FreeKeyTextList(g_keytext_list_common);
		g_keytext_list_common = NULL;
	}
	if(g_keytext_list_printer != NULL){
		FreeKeyTextList(g_keytext_list_printer);
		g_keytext_list_printer = NULL;
	}
}

int IsPortrait(void)
{
	int orientation = PORTRAIT;
	orientation = GetCurrOptInt(ID_ORIENTATION_REQUESTED, PORTRAIT);
	return ((orientation == PORTRAIT) || (orientation == REV_PORT)) ? 1 : 0;
}

int IsReverse(void)
{
	int orientation = PORTRAIT;
	orientation = GetCurrOptInt(ID_ORIENTATION_REQUESTED, PORTRAIT);
	return ((orientation == REV_LAND) || (orientation == REV_PORT)) ? 1 : 0;
}

StrText* GetBookletStrTextTbl(void)
{
	StrText *tbl = NULL;

	if(IsPortrait() == 1){
		tbl = (IsReverse() == 1) ? ((StrText *)(&booklet_r_str)) : ((StrText *)(&booklet_str));
	}else{
		tbl = (IsReverse() == 1) ? ((StrText *)(&booklet_rl_str)) : ((StrText *)(&booklet_l_str));
	}
	return tbl;
}

StrText* GetBindEdgeStrTextTbl(void)
{
	StrText *tbl = NULL;

	if(IsPortrait() == 1){
		tbl = (IsReverse() == 1) ? ((StrText *)(&bindinglocation_r_str)) : ((StrText *)(&bindinglocation_str));
	}else{
		tbl = (IsReverse() == 1) ? ((StrText *)(&bindinglocation_rl_str)) : ((StrText *)(&bindinglocation_l_str));
	}
	return tbl;
}

StrText* GetStapleLocationStrTextTbl(void)
{
	StrText *tbl = NULL;
	char* tmp = NULL;

	tmp = GetUIValue( g_cngplp_data, kPPD_Items_CNUIStapleLocationType );

	if( NULL != tmp ){
		if( 0 == strcasecmp( tmp, STAPLELOCATIONTYPE_PORTRAITE ) ){
			tbl = (IsReverse() == 1) ? ((StrText *)(staplelocation_r_str)) : ((StrText *)(staplelocation_str));
		}
	}

	if( NULL == tbl ){
		if(IsPortrait() == 1){
			tbl = (IsReverse() == 1) ? ((StrText *)(staplelocation_r_str)) : ((StrText *)(staplelocation_str));
		}else{
			tbl = (IsReverse() == 1) ? ((StrText *)(staplelocation_rl_str)) : ((StrText *)(staplelocation_l_str));
		}
	}
	return tbl;
}

const char* NameToText(const int id, const char *name)
{
	char *res_id = NULL;
	char *key = NULL;
	int length = 0;
	const char *text = NULL;
	FuncInfo *func = NULL, *tmp = NULL;
	WidgetInfo *widget = NULL;
	StrText *str = NULL;
	int i = 0;

	if(-1 == id){
		return NULL;
	}
	switch(id){
		case ID_NUMBER_UP:
			str = (StrText *)&numberup_str;
			break;
		case ID_BOOKLET:
		case ID_BOOKLET_DLG:
			str = GetBookletStrTextTbl();
			break;
		case ID_BINDEDGE:
			str = GetBindEdgeStrTextTbl();
			break;
		case ID_STAPLELOCATION:
			str = GetStapleLocationStrTextTbl();
			break;
		default:
			break;
	}
	if(str != NULL){
		for(i = 0; str[i].name != NULL; i++){
			if(strlen(str[i].name) == strlen(name)){
				if(strcasecmp(str[i].name, name) == 0){
					text = LookupText(g_keytext_list_printer, str[i].org_text);
					if(NULL == text){
						text = LookupText(g_keytext_list_common, str[i].org_text);
					}
				}
			}
		}
		return text;
	}
	if((ID_CNCFOLDSETTING == id) || (ID_CNHALFFOLDSETTING == id) || (ID_CNACCORDIONZFOLDSETTING == id) || (ID_CNDOUBLEPARALLELFOLDSETTING == id)){
		func = FindKeyInfoBasedID(g_config_file_data, ID_CNFOLDDETAIL);
	}else{
		func = FindKeyInfoBasedID(g_config_file_data, id);
	}
	while(func != NULL){
		widget = func->widget_list;
		while(widget != NULL){
			if(NULL == text){
				key = cngplpIDtoKey(id);
				if(NULL == key){
					return NULL;
				}
				length = strlen(key) + strlen("_") + strlen(name) + 1;
				res_id = (char*)malloc(length);
				if(res_id != NULL){
					memset(res_id, 0, length);
					strcat(res_id, key);
					strcat(res_id, "_");
					strcat(res_id, name);
					text = LookupText(g_keytext_list_printer, res_id);
					if(NULL == text){
						text = LookupText(g_keytext_list_common, res_id);
					}
					MemFree(res_id);
				}
				MemFree(key);
			}
			widget = widget->next;
		}
		tmp = func;
		func = func->next;
		MemFree(tmp);
	}
	return text;
}

char* TextToName(int id, const char *text)
{
	const char *txt = NULL;
	char *res_id = NULL;
	char *key = NULL;
	int length = 0;
	UIItemsList *item = NULL;
	UIOptionList *tmp_opt = NULL;
	StrText *str = NULL;
	int i = 0;

	if(-1 == id){
		return NULL;
	}
	switch(id){
		case ID_NUMBER_UP:
			str = (StrText *)&numberup_str;
			break;
		case ID_BOOKLET:
		case ID_BOOKLET_DLG:
			str = GetBookletStrTextTbl();
			break;
		case ID_BINDEDGE:
			str = GetBindEdgeStrTextTbl();
			break;
		case ID_STAPLELOCATION:
			str = GetStapleLocationStrTextTbl();
			break;
		case ID_CNFOLDSETTING:
			str = (StrText *)&fold_str;
			break;
		case ID_CNSADDLESETTING:
			str = (StrText *)&saddlesetting_str;
			break;
		case ID_CNPRINTSTYLE:
			str = (StrText *)&printstyle_str;
			break;
		default:
			break;
	}
	if(ID_CNFOLDDETAIL == id){
		char *cur = NULL;

		if((g_cngplp_data != NULL) && (g_cngplp_data->ppd_opt != NULL)){
			cur = FindCurrOpt(g_cngplp_data->ppd_opt->items_list, "CNCfolding");
		}
		if(cur != NULL){
			if(strcmp(cur, "True") == 0){
				id = ID_CNCFOLDSETTING;
			}
		}
		if((g_cngplp_data != NULL) && (g_cngplp_data->ppd_opt != NULL)){
			cur = FindCurrOpt(g_cngplp_data->ppd_opt->items_list, "CNHalfFolding");
		}
		if(cur != NULL){
			if(strcmp(cur, "True") == 0){
				id = ID_CNHALFFOLDSETTING;
			}
		}
		if((g_cngplp_data != NULL) && (g_cngplp_data->ppd_opt != NULL)){
			cur = FindCurrOpt(g_cngplp_data->ppd_opt->items_list, "CNAccordionZfolding");
		}
		if(cur != NULL){
			if(strcmp(cur, "True") == 0){
				id = ID_CNACCORDIONZFOLDSETTING;
			}
		}
		if((g_cngplp_data != NULL) && (g_cngplp_data->ppd_opt != NULL)){
			cur = FindCurrOpt(g_cngplp_data->ppd_opt->items_list, "CNDoubleParallelFolding");
		}
		if(cur != NULL){
			if(strcmp(cur, "True") == 0){
				id = ID_CNDOUBLEPARALLELFOLDSETTING;
			}
		}
	}
	if(str != NULL){
		for(i = 0; str[i].name != NULL; i++){
			txt = LookupText(g_keytext_list_printer, str[i].org_text);
			if(NULL == txt){
				txt = LookupText(g_keytext_list_common, str[i].org_text);
			}
			if(txt != NULL){
				if(strlen(txt) == strlen(text)){
					if(strcasecmp(txt, text) == 0){
						return str[i].name;
					}
				}
			}
		}
		return NULL;
	}
	key = cngplpIDtoKey(id);
	if(NULL == key){
		return NULL;
	}
	if((g_cngplp_data != NULL) && (g_cngplp_data->ppd_opt != NULL)){
		item = FindItemsList(g_cngplp_data->ppd_opt->items_list, key);
	}
	if(NULL == item){
		return NULL;
	}
	tmp_opt = item->opt_lists;
	while(tmp_opt != NULL){
		length = strlen(key) + strlen("_") + strlen(tmp_opt->name) + 1;
		res_id = (char*)malloc(length);
		if(res_id != NULL){
			memset(res_id, 0, length);
			strcat(res_id, key);
			strcat(res_id, "_");
			strcat(res_id, tmp_opt->name);
			txt = LookupText(g_keytext_list_printer, res_id);
			if(NULL == txt){
				txt = LookupText(g_keytext_list_common, res_id);
			}
			MemFree(res_id);
			if((txt != NULL) && (0 == strcmp(txt, text))){
				MemFree(key);
				return tmp_opt->name;
			}
			tmp_opt = tmp_opt->next;
		}
	}
	MemFree(key);
	return NULL;
}

const char* NameToTextByName(const char *name)
{
	const char *text = NULL;

	text = LookupText(g_keytext_list_printer, name);
	if(NULL == text){
		text = LookupText(g_keytext_list_common, name);
	}
	return text;
}

static void AddKeyAndTextToTree(const xmlNodePtr xmlnode, GTree* tree)
{
	char *key, *text;

	if(xmlnode != NULL){
		if((xmlnode->name == NULL) || (g_strcasecmp((const gchar *)(xmlnode->name),"Item") != 0)){
			return;
		}
	}else{
		return;
	}

	key  = (char*)xmlGetProp(xmlnode,(const xmlChar *)"key");
	text = (char*)xmlNodeGetContent(xmlnode);

	if((key != NULL) && (text != NULL)){
		g_tree_insert(tree, (gpointer)key, (gpointer)text);
	}
}

static void ParseXMLDoc(const xmlDocPtr doc, GTree* tree)
{
	xmlNodePtr node;
	if((doc != NULL) && (doc->children != NULL)){
		for(node = doc->children->children; node != NULL; node = node->next){
			if(g_strcasecmp((const gchar *)(node->name),"Item") == 0){
				AddKeyAndTextToTree(node, tree);
			}
		}
	}
}

static gboolean ReadXMLFile(const char *fname, GTree* tree)
{
	xmlDocPtr doc;

	doc = xmlParseFile(fname);
	if(doc == NULL){
		return FALSE;
	}

	if((doc->children == NULL) || (doc->children->name == NULL) || (g_strcasecmp((const gchar *)(doc->children->name), "KeyTextList") != 0)){
		xmlFreeDoc(doc);
		return FALSE;
	}
	ParseXMLDoc(doc, tree);
	xmlFreeDoc(doc);
	return TRUE;
}

static KeyTextList* LoadKeyTextList(const gchar* filename)
{
	KeyTextList* list;
	list = (KeyTextList*)g_malloc(sizeof(KeyTextList));
	if(list != NULL){
		list->tree = g_tree_new((GCompareFunc)strcmp);
		if(list->tree != NULL){
			if(ReadXMLFile(filename, list->tree) == TRUE){
				return list;
			}
		}
		g_free(list);
	}
	return NULL;
}

static int TreeTraverseFunc(const gpointer key, const gpointer value, gpointer data)
{
	g_free((gchar *)key);
	g_free((gchar *)value);
	return FALSE;
}

void FreeKeyTextList(KeyTextList *key_text_list)
{
	if(key_text_list != NULL){
		if(key_text_list->tree != NULL){
			g_tree_traverse(key_text_list->tree, TreeTraverseFunc, G_IN_ORDER, NULL);
			g_tree_destroy(key_text_list->tree);
		}
	}
	free(key_text_list);
	key_text_list = NULL;
}

static const gchar* LookupText(const KeyTextList* list, const gchar* key)
{
	if((list == NULL) || (list->tree == NULL) || (key == NULL)){
		return NULL;
	}
	bindtextdomain(GETTEXT_PACKAGE, PACKAGE_LOCALE_DIR);
	textdomain(GETTEXT_PACKAGE);
	gtk_set_locale();
	return (const gchar *)(dgettext(GETTEXT_PACKAGE,(gchar*)g_tree_lookup(list->tree, (gpointer)key)));
}

