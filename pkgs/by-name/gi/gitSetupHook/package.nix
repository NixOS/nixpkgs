{
  lib,
  gitMinimal,
  makeSetupHook,
}:

makeSetupHook {
  name = "gitSetupHook";

  substitutions = {
    gitMinimal = lib.getExe gitMinimal;
  };

} ./gitSetupHook.sh
