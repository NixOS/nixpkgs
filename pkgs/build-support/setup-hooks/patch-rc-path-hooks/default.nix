{
  lib,
  callPackage,
  makeSetupHook,
  gnused,
}:
let
  tests = import ./test { inherit callPackage; };
in
{
  patchRcPathBash = makeSetupHook {
    name = "patch-rc-path-bash";
    meta = {
      description = "Setup-hook to inject source-time PATH prefix to a Bash/Ksh/Zsh script";
      maintainers = [ lib.maintainers.ShamrockLee ];
    };
    passthru.tests = {
      inherit (tests) test-bash;
    };
  } ./patch-rc-path-bash.sh;
  patchRcPathCsh = makeSetupHook {
    name = "patch-rc-path-csh";
    substitutions = {
      sed = "${gnused}/bin/sed";
    };
    meta = {
      description = "Setup-hook to inject source-time PATH prefix to a Csh script";
      maintainers = [ lib.maintainers.ShamrockLee ];
    };
    passthru.tests = {
      inherit (tests) test-csh;
    };
  } ./patch-rc-path-csh.sh;
  patchRcPathFish = makeSetupHook {
    name = "patch-rc-path-fish";
    meta = {
      description = "Setup-hook to inject source-time PATH prefix to a Fish script";
      maintainers = [ lib.maintainers.ShamrockLee ];
    };
    passthru.tests = {
      inherit (tests) test-fish;
    };
  } ./patch-rc-path-fish.sh;
  patchRcPathPosix = makeSetupHook {
    name = "patch-rc-path-posix";
    substitutions = {
      sed = "${gnused}/bin/sed";
    };
    meta = {
      description = "Setup-hook to inject source-time PATH prefix to a POSIX shell script";
      maintainers = [ lib.maintainers.ShamrockLee ];
    };
    passthru.tests = {
      inherit (tests) test-posix;
    };
  } ./patch-rc-path-posix.sh;
}
