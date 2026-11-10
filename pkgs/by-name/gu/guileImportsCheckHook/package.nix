{
  lib,
  makeSetupHook,
  guile,
  effectiveVersion ? guile.effectiveVersion,
}:

makeSetupHook {
  name = "guileImportsCheckHook";
  substitutions = {
    effectiveVersion = guile.effectiveVersion;
  };
  meta = {
    description = "Import Guile libraries";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
} ./guileImportsCheckHook.sh
