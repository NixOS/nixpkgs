{ lib
, stdenv
, fetchFromGitLab
, blueprint-compiler
, cargo
, desktop-file-utils
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
, cairo
, dbus
, gdk-pixbuf
, glib
, gtk4
, libadwaita
, openssl
, pango
}:

stdenv.mkDerivation rec {
  pname = "impression";
  version = "3.0.1";

  src = fetchFromGitLab {
    owner = "adhami3310";
    repo = "Impression";
    rev = "v${version}";
    hash = "sha256-xxPclDjHdXWo43cwvSuF9MpNlMTJANNXScLY1mkQTqY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-LDYckpKwNvkIdpPijTRIZPNfb4d9MZzxVFdSXarhFl0=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    openssl
    pango
  ];

  meta = {
    description = "Straight-forward and modern application to create bootable drives";
    homepage = "https://gitlab.com/adhami3310/Impression";
    license = lib.licenses.gpl3Only;
    mainProgram = "impression";
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
}
