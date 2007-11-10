#
#  Checks that all set options are described.
#
options: configuration:
with builtins;
let lib=(import ../../lib); in
with lib;

let 
  findInList = p: list: default:
       if (list == []) then default else
       if (p (head list)) then (head list) else
       findInList p (tail list) default;
  

  checkAttrInclusion = s: a: b:
	(
	if (! isAttrs b) then s else
	if (lib.getAttr ["_type"] "" b) == "option" then "" else
	findInList (x : x != "") 
		(map (x: checkAttrInclusion 
			(s + "." + x) 
			(__getAttr x a)
			(lib.getAttr [x] null b)) 
		(attrNames a)) ""
	);
in 	
	checkAttrInclusion "" configuration options

