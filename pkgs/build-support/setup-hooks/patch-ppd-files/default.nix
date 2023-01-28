{ lib
, makeSetupHook
, which
, callPackage
}:

let
  patchPpdFilesHook = makeSetupHook
    {
      name = "patch-ppd-files";
      substitutions.which = lib.attrsets.getBin which;
      substitutions.awkscript = ./patch-ppd-lines.awk;
    }
    ./patch-ppd-hook.sh;
in

patchPpdFilesHook.overrideAttrs (
  lib.trivial.flip
  lib.attrsets.recursiveUpdate
  {
    passthru.tests.test = callPackage ./test.nix {};
    meta.description = "setup hook to patch executable paths in ppd files";
    meta.maintainers = [ lib.maintainers.yarny ];
  }
)
