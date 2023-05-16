{ lib, stdenv, fetchFromGitHub, rustPlatform
, appstream-glib, cargo, desktop-file-utils, glib, libadwaita, meson, ninja
, pkg-config, rustc, wrapGAppsHook4
, dbus, gtk4, sqlite
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "furtherance";
  version = "1.8.1";
=======
stdenv.mkDerivation rec {
  pname = "furtherance";
  version = "1.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lakoliu";
    repo = "Furtherance";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-KNC0e1Qfls+TcUDPvLaTWWF4ELBJYPE7Oo9/4PK10js=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-NHrKk7XgqeEuNAOyIDfzFJzIExTpUfv83Pdv/NPkgYQ=";
=======
    rev = "v${version}";
    sha256 = "sha256-M3k2q32/vMG9uTHk2qqUz0E4ptzxfCOrs9NMjtyxZ5Y=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-qLrX3X8wgNrI8G0RgWydVA35cdxcblSUxTKHty+eCds=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
