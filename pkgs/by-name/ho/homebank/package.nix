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

stdenv.mkDerivation rec {
  pname = "homebank";
  version = "5.8.5";
  src = fetchurl {
    url = "https://www.gethomebank.org/public/sources/homebank-${version}.tar.gz";
    hash = "sha256-TrRFHleEA5VGjC1qP+TQFq2gun1Hyn8c7AQYwKEznpc=";
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

  meta = with lib; {
    description = "Free, easy, personal accounting for everyone";
    mainProgram = "homebank";
    homepage = "https://www.gethomebank.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      pSub
      frlan
    ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
