{ lib
, stdenv
, fetchFromGitLab
, cargo
, desktop-file-utils
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
, cairo
, gdk-pixbuf
, glib
, gtk4
, libadwaita
, pango
, gettext
, darwin
}:

stdenv.mkDerivation rec {
  pname = "diebahn";
  version = "1.5.0";

  src = fetchFromGitLab {
    owner = "schmiddi-on-mobile";
    repo = "diebahn";
    rev = version;
    hash = "sha256-WEjMtRXRmcbgCIQNJRlGYGQhem9W8nb/lsjft0oWxAk=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hafas-rs-0.1.0" = "sha256-9YmWiief8Nux1ZkPTZjzer/qKAa5hORVn8HngMtKDxM=";
    };
  };

  nativeBuildInputs = [
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
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreFoundation
    Foundation
    Security
  ]);

  # Darwin needs to link against gettext from nixpkgs instead of the one vendored by gettext-sys
  # because the vendored copy does not build with newer versions of clang.
  env = lib.optionalAttrs stdenv.isDarwin {
    GETTEXT_BIN_DIR = "${lib.getBin gettext}/bin";
    GETTEXT_INCLUDE_DIR = "${lib.getDev gettext}/include";
    GETTEXT_LIB_DIR = "${lib.getLib gettext}/lib";
  };

  meta = {
    description = "GTK4 frontend for the travel information of the german railway";
    homepage = "https://gitlab.com/schmiddi-on-mobile/diebahn";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
