{
  lib,
  gobjcStdenv,
  fetchzip,
  gnustep-base-gcc,
  wrapGNUstepAppsHook,
  gnustep-gui
}:

gobjcStdenv.mkDerivation (finalAttrs: {
  inherit (gnustep-gui) version src nativeBuildInputs patches;
  pname = "gnustep-gui-gcc";

  propagatedBuildInputs = [ gnustep-base-gcc ];

  meta = {
    inherit (gnustep-gui.meta) changelog homepage license platforms maintainers;
    description = "GUI class library of GNUstep (GCC Environment)";
  };
})
