{ lib
, callPackage
, makeSetupHook
, gnused
}:
let
  tests = import ./test { inherit callPackage; };
in
{
  patchSourcetimePathBash = makeSetupHook
    {
      name = "patch-sourcetime-path-bash";
      passthru.tests = {
        inherit (tests) test-bash;
      };
      meta = with lib; {
        description = "Setup-hook to inject source-time PATH prefix to a Bash/Ksh/Zsh script";
        maintainers = with maintainers; [ ShamrockLee ];
      };
    } ./patch-sourcetime-path-bash.sh;
  patchSourcetimePathCsh = makeSetupHook
    {
      name = "patch-sourcetime-path-csh";
      substitutions = {
        sed = "${gnused}/bin/sed";
      };
      passthru.tests = {
        inherit (tests) test-csh;
      };
      meta = with lib; {
        description = "Setup-hook to inject source-time PATH prefix to a Csh script";
        maintainers = with maintainers; [ ShamrockLee ];
      };
    } ./patch-sourcetime-path-csh.sh;
  patchSourcetimePathFish = makeSetupHook
    {
      name = "patch-sourcetime-path-fish";
      passthru.tests = {
        inherit (tests) test-fish;
      };
      meta = with lib; {
        description = "Setup-hook to inject source-time PATH prefix to a Fish script";
        maintainers = with maintainers; [ ShamrockLee ];
      };
    } ./patch-sourcetime-path-fish.sh;
  patchSourcetimePathPosix = makeSetupHook
    {
      name = "patch-sourcetime-path-posix";
      substitutions = {
        sed = "${gnused}/bin/sed";
      };
      passthru.tests = {
        inherit (tests) test-posix;
      };
      meta = with lib; {
        description = "Setup-hook to inject source-time PATH prefix to a POSIX shell script";
        maintainers = with maintainers; [ ShamrockLee ];
      };
    } ./patch-sourcetime-path-posix.sh;
}
