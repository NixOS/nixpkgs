{
  lib,
  gobjcStdenv,
  fetchzip,
  cairo,
  fontconfig,
  freetype,
  gnustep-gui-gcc,
  libXft,
  libXmu,
  pkg-config,
  wrapGNUstepAppsHook,
  gnustep-back,
}:

gobjcStdenv.mkDerivation (finalAttrs: {
  inherit (gnustep-back) version src nativeBuildInputs buildInputs meta;
  pname = "gnustep-back-gcc";

  propagatedBuildInputs = [ gnustep-gui-gcc ];

  meta = {
    description = "Generic backend for GNUstep (GCC environment)";
    mainProgram = "gpbs";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [
      ashalkhakov
      dblsaiko
      matthewbauer
    ];
    platforms = lib.platforms.linux;
  };
})
