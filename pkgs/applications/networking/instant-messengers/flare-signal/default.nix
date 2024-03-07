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
  version = "0.11.1";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "schmiddi-on-mobile";
    repo = pname;
    rev = version;
    hash = "sha256-c02+nWIklZMD5jqyjmDBL7lffHQ+dOo2ggicd/vItUE=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "curve25519-dalek-4.0.0" = "sha256-KUXvYXeVvJEQ/+dydKzXWCZmA2bFa2IosDzaBL6/Si0=";
      "libsignal-protocol-0.1.0" = "sha256-FCrJO7porlY5FrwZ2c67UPd4tgN7cH2/3DTwfPjihwM=";
      "libsignal-service-0.1.0" = "sha256-OWLtaxldKgYPP/aJuWezNkNN0990l3RtDWK38R1fL90=";
      "presage-0.6.0-dev" = "sha256-sd/kvdbrlJnKPSC/0SDXo6Z6Zc5Am0op/t6gprJf91w=";
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
