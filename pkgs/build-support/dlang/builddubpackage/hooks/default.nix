{ callPackage }:

{
  dubSetupHook = callPackage (
    { makeSetupHook }:
    makeSetupHook {
      name = "dub-setup-hook";
    } ./dub-setup-hook.sh
  ) { };

  dubBuildHook = callPackage (
    { makeSetupHook, dub }:
    makeSetupHook {
      name = "dub-build-hook";
      propagatedBuildInputs = [ dub ];
    } ./dub-build-hook.sh
  ) { };

  dubCheckHook = callPackage (
    { makeSetupHook, dub }:
    makeSetupHook {
      name = "dub-check-hook";
      propagatedBuildInputs = [ dub ];
    } ./dub-check-hook.sh
  ) { };
}
