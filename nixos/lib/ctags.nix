# Implementation of ctags(1) compatible tags file for NixOS options
{ lib, options }:
with lib;
let
  locationToTagLine = name: loc:
    let line = if loc ? line && loc.line != null then loc.line else 1;
    in
    if loc != null then
      "${name}\t${loc.file}\t${toString line}"
    else "";

  toTags = acc0: struct: (foldl'
    (acc: name:
      let item = struct.${name}; in
      if item ? _type && item._type == "option" then
        acc ++ map (locationToTagLine (toString item)) item.declarationPositions
      else toTags acc item
    )
    acc0
    (attrNames struct));

  # see vim help tags-file-format for details
  header = ''
    !_TAG_FILE_SORTED''\t1''\t1
    !_TAG_FILE_ENCODING''\tutf-8''\t1
  '';
in
header + concatStringsSep "\n" (sort lessThan (toTags [ ] options)) + "\n"
