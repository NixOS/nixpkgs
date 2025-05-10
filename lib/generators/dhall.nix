{ lib }:

let
  inherit (lib)
    concatStringsSep
    isAttrs
    isBool
    isFunction
    isInt
    isList
    mapAttrsToList
    ;
  inherit (lib.generators) toDhall toJSON;
in
{ }@args:
let
  concatItems = concatStringsSep ", ";
in
v:
if isAttrs v then
  "{ ${concatItems (mapAttrsToList (key: value: "${key} = ${toDhall args value}") v)} }"
else if isList v then
  "[ ${concatItems (map (toDhall args) v)} ]"
else if isInt v then
  "${if v < 0 then "" else "+"}${toString v}"
else if isBool v then
  (if v then "True" else "False")
else if isFunction v then
  abort "generators.toDhall: cannot convert a function to Dhall"
else if v == null then
  abort "generators.toDhall: cannot convert a null to Dhall"
else
  toJSON { } v
