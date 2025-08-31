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
}:
let

  # The intended semantics are that an attrpath rooted at pkgs is
  # part of the (unfiltered) release jobset iff both of the following
  # are true:
  #
  # 1. The attrpath leads to a value for which lib.isDerivation is true
  #
  # 2. Any proper prefix of the attrpath at which lib.isDerivation
  #    is true also has __recurseIntoDerivationForReleaseJobs=true.
  #
  # The second condition is unfortunately necessary because there are
  # Hydra release jobnames which have proper prefixes which are
  # attrnames of derivations (!).  We should probably restructure
  # the job tree so that this is not the case.
  #
  # TODO: Use mapAttrsToListRecursiveCond when this PR lands:
  # https://github.com/NixOS/nixpkgs/pull/395160
  justAttrNames =
    path: value:
    let
      result =
        if path == [ "AAAAAASomeThingsFailToEvaluate" ] || !(lib.isAttrs value) then
          [ ]
        else if
          lib.isDerivation value
          &&
            # in some places we have *derivations* with jobsets as subattributes, ugh
            !(value.__recurseIntoDerivationForReleaseJobs or false)
        then
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
    attrNamesOnly = true;
  };

  paths = [
    # I am not entirely sure why these three packages end up in
    # the Hydra jobset.  But they do, and they don't meet the
    # criteria above, so at the moment they are special-cased.
    [
      "pkgsLLVM"
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
