let
    realPath=y: (__toPath ((toString ./JustNothing/.. )+"/"+y.version+".nix"));
    dispatch=(x: ((import (realPath x)) x)); 
in
args : 
with args; 
with builderDefs {src="";} null;  
let eater=(lib.sumArgs dispatch args); in
eater
