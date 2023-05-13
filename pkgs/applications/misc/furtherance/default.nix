{ lib, stdenv, fetchFromGitHub, rustPlatform
, appstream-glib, cargo, desktop-file-utils, glib, libadwaita, meson, ninja
, pkg-config, rustc, wrapGAppsHook4
, dbus, gtk4, sqlite
}:

stdenv.mkDerivation rec {
  pname = "furtherance";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "lakoliu";
    repo = "Furtherance";
    rev = "v${version}";
    sha256 = "sha256-M3k2q32/vMG9uTHk2qqUz0E4ptzxfCOrs9NMjtyxZ5Y=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-qLrX3X8wgNrI8G0RgWydVA35cdxcblSUxTKHty+eCds=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    dbus
    glib
    gtk4
    libadwaita
    sqlite
  ];

  meta = with lib; {
    description = "Track your time without being tracked";
    homepage = "https://github.com/lakoliu/Furtherance";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ CaptainJawZ ];
  };
}
