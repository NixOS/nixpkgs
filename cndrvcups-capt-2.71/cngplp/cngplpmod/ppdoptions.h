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

#ifndef	_PARSER
#define	_PARSER

#ifdef __cplusplus
extern "C" {
#endif

#define	NO_ERROR	0
#define	ERROR		-1
#define	ALLOC_ERROR	-2

void MemFree(void *pointer);
int ParsePPD(PPDOptions *ppd_opt, char *ppd_filename);
void FreePPDOptions(PPDOptions *ppd_opt);
void InitUIDisable(cngplpData *data);
void UpdatePPDData(cngplpData *data, char *item_name, char *new_opt);
void UpdateEnableData(cngplpData *data, char *item_name, int num);
void SetUIConst(cngplpData *data, char *new_item_name, char *new_opt_name);
void ResetUIConst(cngplpData *data, char *old_item_name, char *old_opt_name);
void UpdateCurrOption(UIItemsList *curr_items);
void ResetUIDisable(cngplpData *data);
void ResetCurrOption(UIItemsList *items_list);
void UpdateCurrOption(UIItemsList *curr_items);
int GetActiveData(UIItemsList *list, char *item_name);
int GetActiveBooklet(PPDOptions *ppd_opt);
int GetDisableOpt(UIItemsList *list, char *item_name, char *opt_name);
int GetDisable(UIItemsList *list, char *item_name);
char* FindCurrOpt(UIItemsList *list, char *item_name);
UIItemsList* FindItemsList(UIItemsList *items_list, char *items_name);
void AllUpdatePPDData(cngplpData *data);

void InitUpdateOption(cngplpData *data);
char* ExitUpdateOption(cngplpData *data);
char* IDtoPPDOption(int index);
void AddUpdateOption(cngplpData *data, char *item_name);

char* IDAddList(char *list, int id);
int ToID(char *item_name);
char* GetItemString(UIItemsList *list, char *item_name);

int MarkDisable(cngplpData *data, char *item_name, char *opt_name, int flag, int other);
int MarkDisableOpt(cngplpData *data, char *item_name, char *opt_name, int flag);
int MarkDisableFeedCustom(cngplpData *data, char *item_name, char *opt_name, int flag, float width, float height);
void RemarkOptValue(cngplpData *data, char *item_name);

void CreateOptionByItem(char **update_options, char *item_name);
void UpdatePPDData_Priority(cngplpData *data, char *item_name, char *new_opt);

int SetCustomSize(cngplpData *data, char *value);
void UpdateUIValue(cngplpData *data, char *key, char *value);
char* GetUIValue(cngplpData *data, char *key);
char* GetAllUIValue(cngplpData *data);
char* IDtoDevOption(int id);

char* GetPPDDevOptionConflict(cngplpData *data, int id);
int GetOptionDisableCount(PPDOptions *ppd_opt, char *conf_key, char *key, char *value);
char* GetPPDFuncVerConflict(cngplpData *data, int id);
UIOptionList *FindOptionList(UIItemsList *items_list, char *item_name, char *opt_name);
void FreeMediaBrand(PPDOptions *ppd_opt);
char* MakeMediaBrandListChar(PPDOptions *ppd_opt);
char* MakeMediaBrandChar(PPDOptions *ppd_opt);
char* MakeInsertMediaBrandListChar(PPDOptions *ppd_opt);
char* MakeInsertMediaBrandChar(PPDOptions *ppd_opt);
char* MakeInterleafMediaBrandListChar(PPDOptions *ppd_opt);
char* MakeInterleafMediaBrandChar(PPDOptions *ppd_opt);
void UpdatePBindCoverMediaBrand(cngplpData *data, char *new_opt);
char* MakePBindCoverMediaBrandListChar(PPDOptions *ppd_opt);
char* MakePBindCoverMediaBrandChar(PPDOptions *ppd_opt);
char* GetPPDDevOptionConflict_DeviceInfo(cngplpData *data, int id);
int InitAdjustTrimm(PPDOptions *ppd_opt);
void UpdateBindCover(cngplpData *data, char *item_name, char *value);
int isUseJobAccount(PPDOptions *ppd_opt);
int isUseUserManagement(PPDOptions *ppd_opt);
int AddUIValueList(PPDOptions *ppd_opt, char *key, char *value, int opt_flag);
int RemakeMediaBrandList(PPDOptions *ppd_opt, char *buf);
void UpdateMediaBrand(cngplpData *data, char *new_opt);
void UpdateInsertMediaBrand(cngplpData *data, char *new_opt);
void UpdateInterleafMediaBrand(cngplpData *data, char *new_opt);
void UpdateMediaBrandWithCurrMediaType(cngplpData *data, int exeCurrDisableFlag);

int UpdateFormHandle(cngplpData *data, const char *handle);
int UpdateFormList(cngplpData *data, const char *buf);
char* MakeFormListChar(PPDOptions *ppd_opt);

int UpdateMonitorProfileList(cngplpData *data, char *buf);
int UpdateDeviceProfileList(cngplpData *data, char *item_name, char *buf);
void UpdatePPDDataForCancel(cngplpData *data, char *item_name, char *new_opt);
void SetDefaultOptIfAllOptConflict(cngplpData *data);
void UpdatePPDDataForDefault(cngplpData *data, char *item_name);
int GetOffsetNumConflict(cngplpData *data);
int IsConflictBetweenFunctions(cngplpData *data, char *cond_item_name, char *cond_opt_name, char *dst_item_name, char *dst_opt_name);

#ifdef __cplusplus
}
#endif

#endif
