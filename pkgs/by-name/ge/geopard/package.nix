{ stdenv
, cargo
, rustc
, fetchFromGitHub
, glib
, gtk4
, libadwaita
, rustPlatform
, openssl
, pkg-config
, lib
, wrapGAppsHook4
, meson
, ninja
, gdk-pixbuf
, cmake
, desktop-file-utils
, gettext
, blueprint-compiler
, appstream-glib
}:

stdenv.mkDerivation rec {
  pname = "geopard";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "ranfdev";
    repo = pname;
    rev = version;
    hash = "sha256-elHxtFEGkdhEPHxuJtcMYwWnvo6vDaHiOyN51EOzym0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    hash = "sha256-80YujPjcmAxH1gITT4OJk8w4m8Z/pAYtBUpCPQOKe3E=";
  };

  nativeBuildInputs = [
    openssl
    gettext
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    cmake
    blueprint-compiler
    desktop-file-utils
    appstream-glib
    blueprint-compiler
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    desktop-file-utils
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    openssl
  ];

  meta = with lib; {
    homepage = "https://github.com/ranfdev/Geopard";
    description = "Colorful, adaptive gemini browser";
    maintainers = with maintainers; [ jfvillablanca ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "geopard";
  };
}
