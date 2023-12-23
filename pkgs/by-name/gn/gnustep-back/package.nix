{ lib
, clangStdenv
, gnustep-make
, wrapGNUstepAppsHook
, cairo
, fetchzip
, gnustep-base
, gnustep-gui
, fontconfig
, freetype
, pkg-config
, libXft
, libXmu
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "gnustep-back";
  version = "0.31.0";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-CjcoXlKiPVPJMOdrBKjxiNauTZvLcId5Lb8DzbgBbBg=";
  };

  nativeBuildInputs = [ gnustep-make pkg-config wrapGNUstepAppsHook ];
  buildInputs = [ cairo gnustep-base gnustep-gui fontconfig freetype libXft libXmu ];

  meta = {
    description = "Generic backend for GNUstep";
    mainProgram = "gpbs";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ ashalkhakov matthewbauer dblsaiko ];
    platforms = lib.platforms.linux;
  };
})
