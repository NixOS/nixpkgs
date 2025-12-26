# This expression will, as efficiently as possible, dump a
# *superset* of all attrpaths of derivations which might be
# part of a release on *any* platform.
#
# This expression runs single-threaded under all current Nix
# implementations, but much faster and with much less memory
# used than ./outpaths.nix itself.
#
# Once you have the list of attrnames you can split it up into
# $NUM_CORES batches and evaluate the outpaths separately for each
# batch, in parallel.
#
# To dump the attrnames:
#
#   nix-instantiate --eval --strict --json ci/eval/attrpaths.nix -A names
#
{
  lib ? import (path + "/lib"),
  trace ? false,
  path ? ./../..,
  extraNixpkgsConfigJson ? "{}",
}:
let

  # TODO: Use mapAttrsToListRecursiveCond when this PR lands:
  # https://github.com/NixOS/nixpkgs/pull/395160
  justAttrNames =
    path: value:
    let
      result =
        if path == [ "AAAAAASomeThingsFailToEvaluate" ] || !(lib.isAttrs value) then
          [ ]
        else if lib.isDerivation value then
          [ path ]
        else
          lib.pipe value [
            (lib.mapAttrsToList (
              name: value:
              lib.addErrorContext "while evaluating package set attribute path '${
                lib.showAttrPath (path ++ [ name ])
              }'" (justAttrNames (path ++ [ name ]) value)
            ))
            lib.concatLists
          ];
    in
    lib.traceIf trace "** ${lib.showAttrPath path}" result;

  outpaths = import ./outpaths.nix {
    inherit path;
    extraNixpkgsConfig = builtins.fromJSON extraNixpkgsConfigJson;
    attrNamesOnly = true;
  };

  paths = [
    # Some of the following are based on variants, which are disabled with `attrNamesOnly = true`.
    # Until these have been removed from release.nix / hydra, we manually add them to the list.
    [
      "pkgsLLVM"
      "stdenv"
    ]
    [
      "pkgsArocc"
      "stdenv"
    ]
    [
      "pkgsZig"
      "stdenv"
    ]
    [
      "pkgsStatic"
      "stdenv"
    ]
    [
      "pkgsMusl"
      "stdenv"
    ]
  ]
  ++ justAttrNames [ ] outpaths;

  names = map lib.showAttrPath paths;

in
{
  inherit paths names;
}
