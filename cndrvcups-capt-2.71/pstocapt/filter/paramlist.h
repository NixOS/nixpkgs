/*
 *  CUPS add-on module for Canon CAPT printer.
 *  Copyright CANON INC. 2001
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

#ifndef _paramlist_
#define _paramlist_


#define	MAX_KEY_LEN		255
#define	MAX_VALUE_LEN	255


typedef struct param_list_s ParamList;

struct param_list_s {
  ParamList *next;
  char *key;
  char *value;
  int value_size;
};

ParamList *param_list_find(ParamList *pl, const char *key);
void param_list_delete(ParamList **root, const char *key);
void param_list_add(ParamList **root,
		const char *key, const char *value, int value_size);
void param_list_free(ParamList *pl);
int param_list_num(ParamList *pl);
void param_list_print(ParamList *pl);

#endif

