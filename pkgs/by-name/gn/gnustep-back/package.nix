{
  lib,
  clangStdenv,
  fetchzip,
  cairo,
  fontconfig,
  freetype,
  gnustep-gui,
  libXft,
  libXmu,
  pkg-config,
  wrapGNUstepAppsHook,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "gnustep-back";
  version = "0.32.0";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-E9rg3ySRUXSVgdPLeg1WrMO8u+SHHmM2Kb/XDAYqIOQ=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGNUstepAppsHook
  ];

  buildInputs = [
    cairo
    fontconfig
    freetype
    libXft
    libXmu
  ];

  propagatedBuildInputs = [ gnustep-gui ];

  meta = {
    description = "Generic backend for GNUstep";
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
