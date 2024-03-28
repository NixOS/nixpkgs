lib: let
  inherit (lib) concatMapStringsSep foldl head isInt isString length mapAttrsToList splitString;
in rec {
  formatAtom = v:
    if isInt v
    then toString v
    else if isString v
    then ''"${v}"''
    else throw "unimplemented";

  formatList = l:
    if length l == 1
    then formatAtom (head l)
    else formatList' l;

  formatList' = l: "{ ${concatMapStringsSep ", " formatAtom l} }";

  formatPriority = priorityBase: priority:
    if priorityBase != null && priority == null
    then priorityBase
    else if priorityBase == null && priority != null
    then toString priority
    else if priority < 0
    then "${priorityBase} - ${toString - priority}"
    else "${priorityBase} + ${toString priority}";

  strLines = splitString "\n";
  indent = str: concatMapStringsSep "\n" (v: "  ${v}") (strLines str);

  flatten = foldl (acc: a: acc ++ a) [];
  flatMap = f: l: flatten (map f l);
  flatMapAttrsToList = f: l: flatten (mapAttrsToList f l);
}
