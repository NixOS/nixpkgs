{ lib, callPackage }:

{
  dubSetupHook = callPackage (
    { makeSetupHook }:
    makeSetupHook {
      name = "dub-setup-hook";
      meta.license = lib.licenses.mit;
    } ./dub-setup-hook.sh
  ) { };

  dubBuildHook = callPackage (
    { makeSetupHook, dub }:
    makeSetupHook {
      name = "dub-build-hook";
      propagatedBuildInputs = [ dub ];
      meta.license = lib.licenses.mit;
    } ./dub-build-hook.sh
  ) { };

  dubCheckHook = callPackage (
    { makeSetupHook, dub }:
    makeSetupHook {
      name = "dub-check-hook";
      propagatedBuildInputs = [ dub ];
      meta.license = lib.licenses.mit;
    } ./dub-check-hook.sh
  ) { };
}
