{
  fetchurl,
  lib,
  stdenv,
  gtk3,
  pkg-config,
  libofx,
  intltool,
  wrapGAppsHook3,
  libsoup_3,
  adwaita-icon-theme,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "homebank";
  version = "5.9.7";
  src = fetchurl {
    url = "https://www.gethomebank.org/public/sources/homebank-${finalAttrs.version}.tar.gz";
    hash = "sha256-K4/fUSQpow7XpFfPWvR2dWwM/dyfznYA2rlcfwO+JuQ=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    intltool
  ];
  buildInputs = [
    gtk3
    libofx
    libsoup_3
    adwaita-icon-theme
  ];

  meta = {
    description = "Free, easy, personal accounting for everyone";
    mainProgram = "homebank";
    homepage = "https://www.gethomebank.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      pSub
      frlan
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
