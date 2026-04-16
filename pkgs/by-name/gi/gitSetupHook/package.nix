{
  lib,
  gitMinimal,
  makeSetupHook,
}:

makeSetupHook {
  name = "gitSetupHook";

  substitutions = {
    gitMinimal = gitMinimal.exe;
  };

} ./gitSetupHook.sh
