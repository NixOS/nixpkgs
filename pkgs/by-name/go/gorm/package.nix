{ lib
, clangStdenv
, fetchzip
, gnustep-base
, gnustep-back
, gnustep-make
, gnustep-gui
, wrapGNUstepAppsHook
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "gorm";
  version = "1.4.0";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/dev-apps/gorm-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-B7NNRA3qA2PFbb03m58EBBONuIciLf6eU+YSR0qvaCo=";
  };

  nativeBuildInputs = [ gnustep-make wrapGNUstepAppsHook ];
  buildInputs = [ gnustep-base gnustep-back gnustep-gui ];

  meta = {
    description = "Graphical Object Relationship Modeller is an easy-to-use interface designer for GNUstep";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "Gorm";
    maintainers = with lib.maintainers; [ ashalkhakov matthewbauer dblsaiko ];
    platforms = lib.platforms.linux;
  };
})
