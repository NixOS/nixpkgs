{
  lib,
  makeSetupHook,
  removeReferencesTo,
}:

makeSetupHook {
  name = "sanitise-header-paths-hook";

  substitutions = {
    removeReferencesTo = lib.getExe removeReferencesTo;
  };

  meta = {
    description = "Setup hook to sanitise header file paths to avoid leaked references through `__FILE__`";
    maintainers = [ lib.maintainers.emily ];
  };
} ./sanitise-header-paths-hook.bash
