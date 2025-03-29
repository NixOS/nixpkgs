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
  version = "5.8.6";
  src = fetchurl {
    url = "https://www.gethomebank.org/public/sources/homebank-${version}.tar.gz";
    hash = "sha256-rxOKe/LNeVwTOMXj2emZCe5rM9kgxhjcNcZHf9gm3fU=";
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
