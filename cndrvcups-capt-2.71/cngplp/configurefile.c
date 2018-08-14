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


#include <string.h>
#include <dlfcn.h>
#include <libxml/xmlmemory.h>
#include <libxml/parser.h>

#include "configurefile.h"

#define CONFIG_FILE_NAME "./func_config.xml"

#if 0
void ParseUpdate(xmlDocPtr doc, UpdateInfo **update_list, xmlNodePtr cur)
{
	UpdateInfo *update;
	UpdateInfo *tmp = NULL;

	if(update_list != NULL){
		tmp = *update_list;
	}else{
		return;
	}

	update = (UpdateInfo *)malloc(sizeof(UpdateInfo));
	if(update == NULL){
		return;
	}
	memset(update, 0, sizeof(UpdateInfo));

	update->value = xmlGetProp(cur, (const xmlChar *) "value");
	if(tmp == NULL){
		*update_list = update;
	}else{
		while(tmp->next != NULL){
			tmp = tmp->next;
		}
		tmp->next = update;
	}
}
#endif

void ParseCondition(const xmlDocPtr doc, ConditionInfo **condition_list, xmlNodePtr cur)
{
	ConditionInfo *condition;
	ConditionInfo *tmp = NULL;

	if(condition_list != NULL){
		tmp = *condition_list;
	}else{
		return;
	}

	condition = (ConditionInfo *)malloc(sizeof(ConditionInfo));
	if(condition == NULL){
		return;
	}
	memset(condition, 0, sizeof(ConditionInfo));

	condition->name = (char *)xmlGetProp(cur, (const xmlChar *) "value");
	condition->id = (char *)xmlGetProp(cur, (const xmlChar *) "id");
	condition->value = (char *)xmlGetProp(cur, (const xmlChar *) "update");
	condition->widget = (char *)xmlGetProp(cur, (const xmlChar *) "widget");
	if(cur != NULL){
		cur = cur->xmlChildrenNode;
	}else{
		return;
	}
#if 0
	while(cur != NULL){
		if(xmlStrcmp(cur->name, (const xmlChar *) "update") == 0){
			ParseUpdate(doc, &(condition->update), cur);
		}
		cur = cur->next;
	}
#endif
	if(tmp == NULL){
		*condition_list = condition;
	}else{
		while(tmp->next != NULL){
			tmp = tmp->next;
		}
		tmp->next = condition;
	}
}

void ParseSignal(const xmlDocPtr doc, SignalInfo **signal_list, xmlNodePtr cur)
{
	SignalInfo *signal;
	SignalInfo *tmp = NULL;

	if(signal_list != NULL){
		tmp = *signal_list;
	}else{
		return;
	}

	signal = (SignalInfo *)malloc(sizeof(SignalInfo));
	if(signal == NULL){
		return;
	}
	memset(signal, 0, sizeof(SignalInfo));

	signal->name = (char *)xmlGetProp(cur, (const xmlChar *) "name");
	signal->id = (char *)xmlGetProp(cur, (const xmlChar *) "id");
	signal->widget = (char *)xmlGetProp(cur, (const xmlChar *) "widget");
	if(cur != NULL){
		cur = cur->xmlChildrenNode;
	}else{
		return;
	}
	while(cur != NULL){
		if(xmlStrcmp(cur->name, (const xmlChar *) "condition") == 0){
			ParseCondition(doc, &(signal->condition), cur);
		}
		cur = cur->next;
	}
	if(tmp == NULL){
		*signal_list = signal;
	}else{
		while(tmp->next != NULL){
			tmp = tmp->next;
		}
		tmp->next = signal;
	}
}

void ParseProperty(xmlDocPtr doc, PropInfo **prop_list, const xmlNodePtr cur)
{
	PropInfo *property;
	PropInfo *tmp = NULL;

	if(prop_list != NULL){
		tmp = *prop_list;
	}else{
		return;
	}

	property = (PropInfo *)malloc(sizeof(PropInfo));
	if(property == NULL){
		return;
	}
	memset(property, 0, sizeof(PropInfo));

	property->prop_name = (char *)xmlGetProp(cur, (const xmlChar *) "name");
	property->value = (char *)xmlGetProp(cur, (const xmlChar *) "value");
	property->id = (char *)xmlGetProp(cur, (const xmlChar *) "id");
	property->res = (char *)xmlGetProp(cur, (const xmlChar *) "res");
	property->def = (char *)xmlGetProp(cur, (const xmlChar *) "def");

	if(tmp == NULL){
		*prop_list = property;
	}else{
		while(tmp->next != NULL){
			tmp = tmp->next;
		}
		tmp->next = property;
	}
}

void ParseWidget(const xmlDocPtr doc, WidgetInfo **widget_list, xmlNodePtr cur)
{
	WidgetInfo *widget;
	WidgetInfo *tmp = NULL;

	if(widget_list != NULL){
		tmp = *widget_list;
	}else{
		return;
	}

	widget = (WidgetInfo *)malloc(sizeof(WidgetInfo));
	if(widget == NULL){
		return;
	}
	memset(widget, 0, sizeof(WidgetInfo));

	widget->name = (char *)xmlGetProp(cur, (const xmlChar *) "name");
	widget->type = (char *)xmlGetProp(cur, (const xmlChar *) "type");
	widget->func = (char *)xmlGetProp(cur, (const xmlChar *) "func");
	if(cur != NULL){
		cur = cur->xmlChildrenNode;
	}else{
		return;
	}
	while(cur != NULL){
		if(xmlStrcmp(cur->name, (const xmlChar *) "property") == 0){
			ParseProperty(doc, &(widget->prop_list), cur);
		}
		else if(xmlStrcmp(cur->name, (const xmlChar *) "signal") == 0){
			ParseSignal(doc, &(widget->signal_list), cur);
		}
		cur = cur->next;
	}
	if(tmp == NULL){
		*widget_list = widget;
	}else{
		while(tmp->next != NULL){
			tmp = tmp->next;
		}
		tmp->next = widget;
	}
}

void ParseShowWidget(xmlDocPtr doc, ShowWidgetInfo **show_widget_list, const xmlNodePtr cur)
{
	ShowWidgetInfo *showwidget;
	ShowWidgetInfo *tmp = NULL;

	if(show_widget_list != NULL){
		tmp = *show_widget_list;
	}else{
		return;
	}

	showwidget = (ShowWidgetInfo *)malloc(sizeof(ShowWidgetInfo));
	if(showwidget == NULL){
		return;
	}
	memset(showwidget, 0, sizeof(ShowWidgetInfo));

	showwidget->name = (char *)xmlGetProp(cur, (const xmlChar *) "name");

	if(tmp == NULL){
		*show_widget_list = showwidget;
	}else{
		while(tmp->next != NULL){
			tmp = tmp->next;
		}
		tmp->next = showwidget;
	}
}

void ParseKey(xmlDocPtr doc, KeyInfo **key_list, const xmlNodePtr cur)
{
	KeyInfo *key;
	KeyInfo *tmp = NULL;

	if(key_list != NULL){
		tmp = *key_list;
	}else{
		return;
	}

	key = (KeyInfo *)malloc(sizeof(KeyInfo));
	if(key == NULL){
		return;
	}
	memset(key, 0, sizeof(KeyInfo));

	key->name = (char *)xmlGetProp(cur, (const xmlChar *) "name");
	key->value = (char *)xmlGetProp(cur, (const xmlChar *) "value");
	key->type = (char *)xmlGetProp(cur, (const xmlChar *) "type");

	if(tmp == NULL){
		*key_list = key;
	}else{
		while(tmp->next != NULL){
			tmp = tmp->next;
		}
		tmp->next = key;
	}
}

void ParseConflict(const xmlDocPtr doc, ConflictInfo **conflict_list, xmlNodePtr cur)
{
	ConflictInfo *conflict;
	ConflictInfo *tmp = NULL;

	if(conflict_list != NULL){
		tmp = *conflict_list;
	}else{
		return;
	}

	conflict = (ConflictInfo *)malloc(sizeof(ConflictInfo));
	if(conflict == NULL){
		return;
	}
	memset(conflict, 0 , sizeof(ConflictInfo));

	conflict->widget = (char *)xmlGetProp(cur, (const xmlChar *) "widget");
	conflict->id = (char *)xmlGetProp(cur, (const xmlChar *) "id");
	conflict->value = (char *)xmlGetProp(cur, (const xmlChar *) "value");
	conflict->type = (char *)xmlGetProp(cur, (const xmlChar *) "type");
	if(cur != NULL){
		cur = cur->xmlChildrenNode;
	}else{
		return;
	}
	while(cur != NULL){
		if(xmlStrcmp(cur->name, (const xmlChar *) "widget") == 0){
			ParseWidget(doc, &(conflict->update_list), cur);
		}
		cur = cur->next;
	}
	if(tmp == NULL){
		*conflict_list = conflict;
	}else{
		while(tmp->next != NULL){
			tmp = tmp->next;
		}
		tmp->next = conflict;
	}
}

void ParseFunc(const xmlDocPtr doc, FuncInfo **func_list, xmlNodePtr cur)
{
	FuncInfo *func = NULL;
	WidgetInfo* widget = NULL;
	SignalInfo* signal = NULL;
	ConditionInfo *cond = NULL;
	char* id = NULL;
	FuncInfo *tmp = NULL;

	if(func_list != NULL){
		tmp = *func_list;
	}else{
		return;
	}

	if((cur != NULL) && (cur->children == NULL)){
		return;
	}

	func = (FuncInfo *)malloc(sizeof(FuncInfo));
	if(func == NULL){
		return;
	}
	memset(func, 0, sizeof(FuncInfo));

	func->name = (char *)xmlGetProp(cur, (const xmlChar *) "name");

	if(cur != NULL){
		cur = cur->xmlChildrenNode;
	}else{
		return;
	}
	while(cur != NULL){
		if(xmlStrcmp(cur->name, (const xmlChar *) "ID") == 0){
			KeyInfo *id_info;
			id_info = (KeyInfo *)malloc(sizeof(KeyInfo));
			memset(id_info, 0, sizeof(KeyInfo));
			if(id_info != NULL){
				id_info->name = (char *)xmlGetProp(cur, (const xmlChar *) "name");
				id_info->value = (char *)xmlGetProp(cur, (const xmlChar *) "value");
				id_info->type = (char *)xmlGetProp(cur, (const xmlChar *) "type");
				func->func_id = id_info;
			}
		}
		if(xmlStrcmp(cur->name, (const xmlChar *) "key") == 0){
			ParseKey(doc, &(func->key_list), cur);
		}
		if(xmlStrcmp(cur->name, (const xmlChar *) "show-widget") == 0){
			ParseShowWidget(doc, &(func->show_widget_list), cur);
		}
		if(xmlStrcmp(cur->name, (const xmlChar *) "widget") == 0){
			ParseWidget(doc, &(func->widget_list), cur);
		}
		if(xmlStrcmp(cur->name, (const xmlChar *) "ui-conflict") == 0){
			ParseConflict(doc, &(func->conflict_list), cur);
		}
		cur = cur->next;
	}
	widget = func->widget_list;
	while(widget != NULL){
		id = NULL;
		signal = widget->signal_list;
		while(signal != NULL){
			if((func->func_id != NULL) && (func->func_id->name != NULL) && (NULL == signal->id)){
				signal->id = strdup(func->func_id->name);
			}
			cond = signal->condition;
			while(cond != NULL){
				if(id != NULL){
					break;
				}else{
					id = cond->id;
				}
				cond = cond->next;
			}

			if(NULL == id){
				id = signal->id;
			}
			cond = signal->condition;
			while(cond != NULL){
				if((id != NULL) && (NULL == cond->id)){
					cond->id = strdup(id);
				}
				cond = cond->next;
			}
			signal = signal->next;
		}
		widget = widget->next;
	}

	if(tmp == NULL){
		*func_list = func;
	}else{
		while(tmp->next != NULL){
			tmp = tmp->next;
		}
		tmp->next = func;
	}
}

void ParseSpecial(const xmlDocPtr doc, SpecialInfo **special_list, xmlNodePtr cur)
{
	char *type;
	SpecialInfo *tmp = NULL;

	if(special_list != NULL){
		tmp = *special_list;
	}else{
		return;
	}

	if(cur != NULL){
		cur = cur->xmlChildrenNode;
	}else{
		return;
	}
	while(cur != NULL){
		if(xmlStrcmp(cur->name, (const xmlChar *) "special-widget") == 0){
			SpecialInfo *special;
			special= (SpecialInfo*)malloc(sizeof(SpecialInfo));
			if(special == NULL){
				return;
			}
			memset(special, 0 , sizeof(SpecialInfo));
			special->name = (char *)xmlGetProp(cur, (const xmlChar *) "name");
			special->parent = (char *)xmlGetProp(cur, (const xmlChar *) "parent");
			special->print = 0;
			type = (char *)xmlGetProp(cur, (const xmlChar *) "type");
			if(type != NULL){
				if(strcmp(type, "dialog") == 0){
					special->type = 1;
				}else if(strcmp(type, "notebook") == 0){
					special->type = 0;
				}
				free(type);
				type = NULL;
			}
			if(special->type == 1){
				xmlNodePtr child;
				child = cur->children;
				while(child != NULL){
					if(xmlStrcmp(child->name, (const xmlChar *) "button") == 0){
						ButtonInfo * button;
						button = (ButtonInfo *)malloc(sizeof(ButtonInfo));
						if(button == NULL){
							return;
						}
						memset(button, 0, sizeof(ButtonInfo));
						button->button_name = (char *)xmlGetProp(child, (const xmlChar *) "name");
						type = (char *)xmlGetProp(child, (const xmlChar *) "type");
						if(type != NULL){
							if(strcmp(type, "OK") == 0){
								button->type = OK_BUTTON;
							}else if(strcmp(type, "Cancel") == 0){
								button->type = CANCEL_BUTTON;
							}else if(strcmp(type, "Save") == 0){
								button->type = SAVE_BUTTON;
							}else if(strcmp(type, "Print") == 0){
								button->type = PRINT_BUTTON;
							}else if(strcmp(type, "Restore") == 0){
								button->type = RESTORE_BUTTON;
							}
							free(type);
							type = NULL;
						}
						button->value= (char *)xmlGetProp(child, (const xmlChar *) "value");
						button->next = special->button_list;
						special->button_list = button;
					}
					if(xmlStrcmp(child->name, (const xmlChar *) "ui-conflict") == 0){
						ParseConflict(doc, &(special->conflict_list), child);
					}
					child = child->next;
				}
			}
			if(*special_list == NULL){
				*special_list = special;
			}else{
				tmp = *special_list;
				while(tmp->next != NULL){
					tmp = tmp->next;
				}
				tmp->next = special;
			}
		}
		cur = cur->next;
	}
}

void ParseCommon(const xmlDocPtr doc, FuncInfo **common_list, xmlNodePtr cur)
{
	if(cur != NULL){
		cur = cur->xmlChildrenNode;
	}else{
		return;
	}
	while(cur != NULL){
		if(xmlStrcmp(cur->name, (const xmlChar *) "function") == 0){
			ParseFunc(doc, common_list, cur);
		}
		cur = cur->next;
	}
}

ConfigFile* ParseConfigureFile(const char *filename)
{
	xmlDocPtr doc;
	xmlNodePtr cur;
	FuncInfo *func_list = NULL;
	SpecialInfo *special_list = NULL;
	FuncInfo *common_list = NULL;
	ConfigFile *configfile = NULL;

	doc = xmlParseFile(filename);
	if(doc == NULL){
		return NULL;
	}

	cur = xmlDocGetRootElement(doc);
	if(cur == NULL){
		fprintf(stderr,"empty document\n");
		xmlFreeDoc(doc);
		return NULL;
	}
	while(cur != NULL){
		if(xmlStrcmp(cur->name, (const xmlChar *) "configuration") == 0){
			configfile = (ConfigFile *)malloc(sizeof(ConfigFile));
			if(configfile == NULL){
				return NULL;
			}
			memset(configfile, 0, sizeof(ConfigFile));
			break;
		}
		cur = cur->next;
	}
	if((cur == NULL) || ((cur->xmlChildrenNode) == NULL)){
		return NULL;
	}
	cur = cur->xmlChildrenNode;
	while(cur != NULL){
		if(xmlStrcmp(cur->name, (const xmlChar *) "function") == 0){
			ParseFunc(doc, &func_list, cur);
		}else if(xmlStrcmp(cur->name, (const xmlChar *) "special") == 0){
			ParseSpecial(doc, &special_list, cur);
		}else if(xmlStrcmp(cur->name, (const xmlChar *) "common") == 0){
			ParseCommon(doc, &common_list, cur);
		}
		cur = cur->next;
	}
	if(configfile != NULL){
		configfile->func_list = func_list;
		configfile->special_list = special_list;
		configfile->common_list = common_list;
	}
	xmlFreeDoc(doc);
	return configfile;
}

void FreeUpdateList(UpdateInfo *updatelist)
{
	UpdateInfo *update;

	if(updatelist == NULL){
		return;
	}
	for(; updatelist != NULL; updatelist = update){
		update = updatelist->next;
		if(updatelist->value != NULL){
			free(updatelist->value);
			updatelist->value = NULL;
		}
		free(updatelist);
		updatelist = NULL;
	}
}

void FreeConditionList(ConditionInfo *conditionlist)
{
	ConditionInfo *condition;

	if(conditionlist == NULL){
		return;
	}
	for(; conditionlist != NULL; conditionlist = condition){
		condition = conditionlist->next;
		if(conditionlist->name != NULL){
			free(conditionlist->name);
			conditionlist->name = NULL;
		}
		if(conditionlist->id != NULL){
			free(conditionlist->id);
			conditionlist->id = NULL;
		}
		if(conditionlist->value != NULL){
			free(conditionlist->value);
			conditionlist->value = NULL;
		}
		if(conditionlist->widget != NULL){
			free(conditionlist->widget);
			conditionlist->widget = NULL;
		}
		if(conditionlist->update != NULL){
			FreeUpdateList(conditionlist->update);
			conditionlist->update = NULL;
		}
		free(conditionlist);
		conditionlist = NULL;
	}
}

void FreeSignalList(SignalInfo *signallist)
{
	SignalInfo *signal;

	if(signallist == NULL){
		return;
	}
	for(; signallist != NULL; signallist = signal){
		signal = signallist->next;
		if(signallist->name != NULL){
			free(signallist->name);
			signallist->name = NULL;
		}
		if(signallist->id != NULL){
			free(signallist->id);
			signallist->id = NULL;
		}
		if(signallist->widget != NULL){
			free(signallist->widget);
			signallist->widget = NULL;
		}
		if(signallist->condition != NULL){
			FreeConditionList(signallist->condition);
			signallist->condition = NULL;
		}
		free(signallist);
		signallist = NULL;
	}
}

void FreePropertyList(PropInfo *proplist)
{
	PropInfo *prop;

	if(proplist == NULL){
		return;
	}
	for(; proplist != NULL; proplist = prop){
		prop = proplist->next;
		if(proplist->prop_name != NULL){
			free(proplist->prop_name);
			proplist->prop_name = NULL;
		}
		if(proplist->value != NULL){
			free(proplist->value);
			proplist->value = NULL;
		}
		if(proplist->id != NULL){
			free(proplist->id);
			proplist->id = NULL;
		}
		if(proplist->res != NULL){
			free(proplist->res);
			proplist->res = NULL;
		}
		if(proplist->def != NULL){
			free(proplist->def);
			proplist->def = NULL;
		}
		free(proplist);
		proplist = NULL;
	}
}

void FreeWidgetList(WidgetInfo *widgetlist)
{
	WidgetInfo *widget = NULL;

	if(widgetlist == NULL){
		return;
	}
	for(; widgetlist != NULL; widgetlist = widget){
		widget = widgetlist->next;
		if(widgetlist->name != NULL){
			free(widgetlist->name);
			widgetlist->name = NULL;
		}
		if(widgetlist->type != NULL){
			free(widgetlist->type);
			widgetlist->type =NULL;
		}
		if(widgetlist->func != NULL){
			free(widgetlist->func);
			widgetlist->func =NULL;
		}
		if(widgetlist->prop_list != NULL){
			FreePropertyList(widgetlist->prop_list);
			widgetlist->prop_list = NULL;
		}
		if(widgetlist->signal_list != NULL){
			FreeSignalList(widgetlist->signal_list);
			widgetlist->signal_list = NULL;
		}
		if(widgetlist->data != NULL){
			free(widgetlist->data);
			widgetlist->data = NULL;
		}
		free(widgetlist);
		widgetlist = NULL;
	}
}

void FreeConflictList(ConflictInfo *conflictlist)
{
	ConflictInfo *conflict = NULL;

	if(conflictlist == NULL){
		return;
	}
	for(; conflictlist != NULL; conflictlist = conflict){
		conflict = conflictlist->next;
		if(conflictlist->id != NULL){
			free(conflictlist->widget);
			conflictlist->widget = NULL;
		}
		if(conflictlist->id != NULL){
			free(conflictlist->id);
			conflictlist->id = NULL;
		}
		if(conflictlist->value != NULL){
			free(conflictlist->value);
			conflictlist->value = NULL;
		}
		if(conflictlist->type != NULL){
			free(conflictlist->type);
			conflictlist->type = NULL;
		}
		if(conflictlist->update_list != NULL){
			FreeWidgetList(conflictlist->update_list);
			conflictlist->update_list = NULL;
		}
		free(conflictlist);
		conflictlist = NULL;
	}
}

void FreeShowWidgetList(ShowWidgetInfo* showwidgetlist)
{
	ShowWidgetInfo *showwidget = NULL;

	if(showwidgetlist == NULL){
		return;
	}
	for(; showwidgetlist != NULL; showwidgetlist = showwidget){
		showwidget = showwidgetlist->next;
		if(showwidgetlist->name != NULL){
			free(showwidgetlist->name);
			showwidgetlist->name = NULL;
		}
		free(showwidgetlist);
		showwidgetlist = NULL;
	}
}

void FreeKeyList(KeyInfo* keylist)
{
	KeyInfo *key = NULL;

	if(keylist == NULL){
		return;
	}
	for(; keylist != NULL; keylist = key){
		key = keylist->next;
		if(keylist->name != NULL){
			free(keylist->name);
			keylist->name = NULL;
		}
		if(keylist->value != NULL){
			free(keylist->value);
			keylist->value = NULL;
		}
		if(keylist->type != NULL){
			free(keylist->type);
			keylist->type = NULL;
		}
		free(keylist);
		keylist = NULL;
	}
}

void FreeFuncList(FuncInfo* funclist)
{
	FuncInfo *func = NULL;

	if(funclist == NULL){
		return;
	}
	for(; funclist != NULL; funclist = func){
		func = funclist->next;
		if(funclist->name != NULL){
			free(funclist->name);
			funclist->name = NULL;
		}
		if(funclist->func_id != NULL){
			FreeKeyList(funclist->func_id);
			funclist->func_id = NULL;
		}
		if(funclist->key_list != NULL){
			FreeKeyList(funclist->key_list);
			funclist->key_list = NULL;
		}
		if(funclist->show_widget_list != NULL){
			FreeShowWidgetList(funclist->show_widget_list);
			funclist->show_widget_list = NULL;
		}
		if(funclist->widget_list != NULL){
			FreeWidgetList(funclist->widget_list);
			funclist->widget_list = NULL;
		}
		if(funclist->conflict_list != NULL){
			FreeConflictList(funclist->conflict_list);
			funclist->conflict_list = NULL;
		}
		free(funclist);
		funclist = NULL;
	}
}


void FreeButtonList(ButtonInfo *buttonlist)
{
	ButtonInfo *button;

	if(buttonlist == NULL){
		return;
	}
	for(; buttonlist != NULL; buttonlist = button){
		button = buttonlist->next;
		if(buttonlist->button_name != NULL){
			free(buttonlist->button_name);
			buttonlist->button_name = NULL;
		}
		if(buttonlist->value != NULL){
			free(buttonlist->value);
			buttonlist->value = NULL;
		}
		free(buttonlist);
		buttonlist = NULL;
	}
}

void FreeSpecialWidget(SpecialInfo *speciallist)
{
	SpecialInfo *special;

	if(speciallist == NULL){
		return;
	}
	for(; speciallist != NULL; speciallist = special){
		special = speciallist->next;
		if(speciallist->name != NULL){
			free(speciallist->name);
			speciallist->name = NULL;
		}
		if(speciallist->parent != NULL){
			free(speciallist->parent);
			speciallist->parent = NULL;
		}
		if(speciallist->button_list != NULL){
			FreeButtonList(speciallist->button_list);
			speciallist->button_list = NULL;
		}
		if(speciallist->conflict_list != NULL){
			FreeConflictList(speciallist->conflict_list);
			speciallist->conflict_list = NULL;
		}
		free(speciallist);
		speciallist = NULL;
	}
}

void FreeConfigfileData(ConfigFile* data)
{
	if(data == NULL){
		return;
	}
	FreeSpecialWidget(data->special_list);
	data->special_list = NULL;
	FreeFuncList(data->func_list);
	data->func_list = NULL;
	FreeFuncList(data->common_list);
	data->common_list = NULL;
	free(data);
	data = NULL;
}
