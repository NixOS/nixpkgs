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
  version = "0.15.2";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "schmiddi-on-mobile";
    repo = "flare";
    rev = version;
    hash = "sha256-w8H6EYnVYJ6gDhdeZwyxRquem4ayZ4cgLaJMKqcetuI=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "blurhash-0.2.3" = "sha256-s1777+2O0D/VyKwlPUA53gho5sOP8pN610KqxEjugz0=";
      "curve25519-dalek-4.1.3" = "sha256-bPh7eEgcZnq9C3wmSnnYv0C4aAP+7pnwk9Io29GrI4A=";
      "libsignal-core-0.1.0" = "sha256-AdN8UHu0khgsog1btE++0J4BmdUC6wMpZzL7HPzhALQ=";
      "libsignal-service-0.1.0" = "sha256-bnbbbnoBaHUdobBywOAUQojoMYkOlgI2O1RG2DoyvUc=";
      "presage-0.6.2" = "sha256-AB4ttolC6MPp3foT66DG5RArqX+c1wf2w3lIZ0u0LCM=";
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
    description = "Unofficial Signal GTK client";
    mainProgram = "flare";
    homepage = "https://gitlab.com/schmiddi-on-mobile/flare";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
}
