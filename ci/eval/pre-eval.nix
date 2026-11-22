# This file does a fast pre-evaluation of Nixpkgs to determine:
# - paths: A *superset* of all attrpaths of derivations which might be part of a release on *any* platform.
# - attrPathsDisallowedForInternalUse: Attribute paths whose meta.problems has problems whose kinds should not be used internally in Nixpkgs
#
# This expression runs single-threaded under all current Nix
# implementations, but much faster and with much less memory
# used than ./outpaths.nix itself.
#
# Once you have the list of attrnames you can split it up into
# $NUM_CORES batches and evaluate the outpaths separately for each
# batch, in parallel.
#
# To dump the result:
#
#   nix-instantiate --eval --strict --json ci/eval/pre-eval.nix -A result
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
  listAttrs =
    path: value:
    let
      result =
        if path == [ "AAAAAASomeThingsFailToEvaluate" ] || !(lib.isAttrs value) then
          [ ]
        else if lib.isDerivation value then
          [
            {
              inherit path value;
            }
          ]
        else
          lib.pipe value [
            (lib.mapAttrsToList (
              name: value:
              lib.addErrorContext "while evaluating package set attribute path '${
                lib.showAttrPath (path ++ [ name ])
              }'" (listAttrs (path ++ [ name ]) value)
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

  list =
    map
      (path: {
        inherit path;
        # This looks a bit weird, but the only reason we care about this value
        # is for the meta.problems check below, and stdenv's certainly don't
        # have any problems, so this is fine :)
        value = { };
      })
      [
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
    ++ listAttrs [ ] outpaths;
  paths = map (attrs: attrs.path) list;
  names = map lib.showAttrPath paths;

  inherit (import ../../pkgs/stdenv/generic/problems.nix { inherit lib; })
    disallowNixpkgsInternalUseKinds
    ;

  # Determine the list of attributes whose packages have any meta.problems
  # with a kind that's disallowed from internal Nixpkgs use
  attrPathsDisallowedForInternalUse = lib.pipe list [
    (lib.map (
      attrs:
      attrs
      // {
        problematicProblems = builtins.tryEval (
          lib.filterAttrs (name: problem: disallowNixpkgsInternalUseKinds ? ${problem.kind}) (
            attrs.value.meta.problems or { }
          )
        );
      }
    ))
    (lib.filter (attrs: attrs.problematicProblems.success && attrs.problematicProblems.value != { }))
    (lib.map (attrs: {
      attrPath = attrs.path;
      reason = "it has certain meta.problems whose kinds are disallowed: ${
        lib.generators.toPretty { } attrs.problematicProblems.value
      }";
    }))
  ];
in
{
  # TODO: Do we still need these? Probably not
  inherit paths names;
  result = {
    inherit paths attrPathsDisallowedForInternalUse;
  };
}
