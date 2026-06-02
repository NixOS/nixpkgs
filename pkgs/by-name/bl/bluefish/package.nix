{
  lib,
  stdenv,
  fetchurl,
  wrapGAppsHook3,
  pkg-config,
  gtk3,
  libxml2,
  enchant,
  gucharmap,
  python3,
  adwaita-icon-theme,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bluefish";
  version = "2.2.19";

  src = fetchurl {
    url = "mirror://sourceforge/bluefish/bluefish-${finalAttrs.version}.tar.bz2";
    hash = "sha256-tXTHwSiX3c73Pxmfr6H5i/w2asdvCr5/l6emLIB/kq4=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    adwaita-icon-theme
    gtk3
    libxml2
    enchant
    gucharmap
    python3
  ];

  # infb_gui.c:143:61: error: implicit declaration of function 'xmlNanoHTTPFetch' [-Wimplicit-function-declaration]
  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  meta = {
    description = "Powerful editor targeted towards programmers and webdevelopers";
    homepage = "https://bluefish.openoffice.nl/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ vbgl ];
    platforms = lib.platforms.all;
    mainProgram = "bluefish";
  };
})
