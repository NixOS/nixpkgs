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
<<<<<<< HEAD
    meta = {
      description = "Setup-hook to inject source-time PATH prefix to a Bash/Ksh/Zsh script";
      maintainers = with lib.maintainers; [ ShamrockLee ];
=======
    meta = with lib; {
      description = "Setup-hook to inject source-time PATH prefix to a Bash/Ksh/Zsh script";
      maintainers = with maintainers; [ ShamrockLee ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    meta = {
      description = "Setup-hook to inject source-time PATH prefix to a Csh script";
      maintainers = with lib.maintainers; [ ShamrockLee ];
=======
    meta = with lib; {
      description = "Setup-hook to inject source-time PATH prefix to a Csh script";
      maintainers = with maintainers; [ ShamrockLee ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
    passthru.tests = {
      inherit (tests) test-csh;
    };
  } ./patch-rc-path-csh.sh;
  patchRcPathFish = makeSetupHook {
    name = "patch-rc-path-fish";
<<<<<<< HEAD
    meta = {
      description = "Setup-hook to inject source-time PATH prefix to a Fish script";
      maintainers = with lib.maintainers; [ ShamrockLee ];
=======
    meta = with lib; {
      description = "Setup-hook to inject source-time PATH prefix to a Fish script";
      maintainers = with maintainers; [ ShamrockLee ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    meta = {
      description = "Setup-hook to inject source-time PATH prefix to a POSIX shell script";
      maintainers = with lib.maintainers; [ ShamrockLee ];
=======
    meta = with lib; {
      description = "Setup-hook to inject source-time PATH prefix to a POSIX shell script";
      maintainers = with maintainers; [ ShamrockLee ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
    passthru.tests = {
      inherit (tests) test-posix;
    };
  } ./patch-rc-path-posix.sh;
}
