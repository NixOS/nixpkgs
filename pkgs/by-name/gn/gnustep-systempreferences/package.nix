{ lib
, clangStdenv
, fetchurl
, gnustep-make
, gnustep-back
, gnustep-base
, gnustep-gui
, wrapGNUstepAppsHook
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "system-preferences";
  version = "1.2.0";

  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/usr-apps/SystemPreferences-${finalAttrs.version}.tar.gz";
    sha256 = "1fg7c3ihfgvl6n21rd17fs9ivx3l8ps874m80vz86n1callgs339";
  };

  nativeBuildInputs = [ gnustep-make wrapGNUstepAppsHook ];
  buildInputs = [ gnustep-back gnustep-base gnustep-gui ];

  meta = {
    description = "Settings manager for the GNUstep environment and its applications";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "SystemPreferences";
    maintainers = with lib.maintainers; [ ashalkhakov matthewbauer dblsaiko ];
    platforms = lib.platforms.linux;
  };
})
