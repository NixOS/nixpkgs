#
#  Checks that all set options are described.
#
options: configuration:
with builtins;
with (import ../../lib);

let
  findInList = p: list: default:
	if (list == []) then default else
	if (p (head list)) then (head list) else
	findInList p (tail list) default;
  
	attrSetToList = attrs: if (isAttrs attrs) then (concatLists (map 
			(s: 
				(map (l: ([s] ++ l)) 
				(attrSetToList (getAttr s attrs)))) 
			(attrNames attrs))) else [[]];
in
let opts = (map (a: a.name) options);
	conf = attrSetToList configuration;
in 
let res=findInList (a: (findInList (b: (eqLists a b)) opts null)==null) conf null; 
in
#if res==null then null else map (l: ["<"] ++ l ++ [">"]) res
res
