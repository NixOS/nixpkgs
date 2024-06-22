{ lib
, makeSetupHook
, which
, callPackage
}:

makeSetupHook {
  name = "patch-ppd-files";
  substitutions = {
    which = lib.getBin which;
    awkscript = ./patch-ppd-lines.awk;
  };
  passthru.tests.test = callPackage ./test.nix {};
  meta = {
    description = "setup hook to patch executable paths in ppd files";
    maintainers = [ lib.maintainers.yarny ];
  };
} ./patch-ppd-hook.sh
