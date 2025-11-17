{
  lib,
  stdenv,
  fetchurl,
  expat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bloodspilot-xpilot-fxi-server";
  version = "1.4.6";

  src = fetchurl {
    url = "mirror://sourceforge/project/bloodspilot/server/server%20v${finalAttrs.version}/xpilot-${finalAttrs.version}fxi.tar.gz";
    hash = "sha256-UYZGHrSkoQwJ4siaob2XGD8YoKHRPKCSfwa7CPW18DQ=";
  };

  buildInputs = [
    expat
  ];

  patches = [
    ./server-gcc5.patch
    ./bloodspilot-server-strcpy-fix.patch
  ];

  meta = {
    description = "Multiplayer X11 space combat game (server part)";
    mainProgram = "xpilots";
    homepage = "http://bloodspilot.sf.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
  };
})
