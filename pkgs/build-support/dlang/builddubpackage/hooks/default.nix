{
  makeSetupHook,
  dub,
}:

{
  dubSetupHook = makeSetupHook {
    name = "dub-setup-hook";
  } ./dub-setup-hook.sh;

  dubBuildHook = makeSetupHook {
    name = "dub-build-hook";
    propagatedBuildInputs = [ dub ];
  } ./dub-build-hook.sh;

  dubCheckHook = makeSetupHook {
    name = "dub-check-hook";
    propagatedBuildInputs = [ dub ];
  } ./dub-check-hook.sh;
}
