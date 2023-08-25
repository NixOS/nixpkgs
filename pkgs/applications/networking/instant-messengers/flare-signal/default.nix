{ lib
, stdenv
, fetchFromGitLab
, cargo
, meson
, ninja
, pkg-config
, gst_all_1
, protobuf
, libsecret
, libadwaita
, rustPlatform
, rustc
, appstream-glib
, blueprint-compiler
, desktop-file-utils
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "flare";
  version = "0.9.1";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "schmiddi-on-mobile";
    repo = pname;
    rev = version;
    hash = "sha256-RceCVn2OmrHyY2DWT+5XeOc+HlQGVdtOmfo3+2r9hKs=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "curve25519-dalek-3.2.1" = "sha256-0hFRhn920tLBpo6ZNCl6DYtTMHMXY/EiDvuhOPVjvC0=";
      "libsignal-protocol-0.1.0" = "sha256-VQwrGTNZnlDK5p8ZleAZYtbzDiVTHxc93/CRlCUjWtE=";
      "libsignal-service-0.1.0" = "sha256-azXQGC008rcqF2C8yHy5CM2NU1Hvwv2I3Kr8aI6URS8=";
      "presage-0.6.0-dev" = "sha256-MNd4CvBv6htZQj2g2a3JcQ1r/kk4UPSBLFezEnRK+60=";
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
    libadwaita
    libsecret
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
