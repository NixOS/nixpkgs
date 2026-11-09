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

  meta.license = lib.licenses.mit;
} ./gitSetupHook.sh
