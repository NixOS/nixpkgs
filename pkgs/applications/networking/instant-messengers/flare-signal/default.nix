{ lib
, stdenv
, fetchFromGitLab
, cargo
, meson
, ninja
, pkg-config
, gst_all_1
, protobuf
, libspelling
, libsecret
, libadwaita
, gtksourceview5
, rustPlatform
, rustc
, appstream-glib
, blueprint-compiler
, desktop-file-utils
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "flare";
  version = "0.10.0";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "schmiddi-on-mobile";
    repo = pname;
    rev = version;
    hash = "sha256-+9zpYW9xjLe78c2GRL6raFDR5g+R/JWxQzU/ZS+5JtY=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "blurhash-0.1.1" = "sha256-SLpszTL2CupMAfUQK5KlnsHTIBDB8hbJs1d6DQXaUiA=";
      "curve25519-dalek-3.2.1" = "sha256-0hFRhn920tLBpo6ZNCl6DYtTMHMXY/EiDvuhOPVjvC0=";
      "libsignal-protocol-0.1.0" = "sha256-VQwrGTNZnlDK5p8ZleAZYtbzDiVTHxc93/CRlCUjWtE=";
      "libsignal-service-0.1.0" = "sha256-1ub0IPSvGhZ2tsC6IolusJ1NSWy+5SXSx8qlIdPngTE=";
      "presage-0.6.0-dev" = "sha256-4isKBn/4yHoAYsYbBTULK/veZmaecU7t+PvE4Y0oNgk=";
    };
  };

  nativeBuildInputs = [
    appstream-glib # for appstream-util
    blueprint-compiler
    desktop-file-utils # for update-desktop-database
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    gtksourceview5
    libadwaita
    libsecret
    libspelling
    protobuf

    # To reproduce audio messages
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  meta = {
    changelog = "https://gitlab.com/schmiddi-on-mobile/flare/-/blob/${src.rev}/CHANGELOG.md";
    description = "An unofficial Signal GTK client";
    homepage = "https://gitlab.com/schmiddi-on-mobile/flare";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
}
