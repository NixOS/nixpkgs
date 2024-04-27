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
  version = "0.13.0";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "schmiddi-on-mobile";
    repo = "flare";
    rev = version;
    hash = "sha256-WfW2xUlF1vCaYFVP6ds06+niULKZgMMxgAOm66LK2xQ=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "curve25519-dalek-4.0.0" = "sha256-KUXvYXeVvJEQ/+dydKzXWCZmA2bFa2IosDzaBL6/Si0=";
      "libsignal-protocol-0.1.0" = "sha256-FCrJO7porlY5FrwZ2c67UPd4tgN7cH2/3DTwfPjihwM=";
      "libsignal-service-0.1.0" = "sha256-XkCb83IvlnmvhHD8Vi9D5fNuBOoR9yX0/Vlb+YhrDz8=";
      "presage-0.6.0-dev" = "sha256-zot92dlGtB7B423BU74oqpPzQKvLm2Dw9P8lCWkbsoE=";
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
    mainProgram = "flare";
    homepage = "https://gitlab.com/schmiddi-on-mobile/flare";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
}
