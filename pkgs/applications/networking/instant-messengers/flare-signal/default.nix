{ lib
, stdenv
, fetchFromGitLab
, cargo
, meson
, ninja
, pkg-config
<<<<<<< HEAD
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
=======
, protobuf
, libsecret
, libadwaita
, rustPlatform
, rustc
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, desktop-file-utils
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "flare";
<<<<<<< HEAD
  version = "0.10.0";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "schmiddi-on-mobile";
    repo = pname;
    rev = version;
    hash = "sha256-+9zpYW9xjLe78c2GRL6raFDR5g+R/JWxQzU/ZS+5JtY=";
=======
  version = "0.6.0";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "Schmiddiii";
    repo = pname;
    rev = version;
    hash = "sha256-wY95sXWGDjEy8vvP79XliJOn5GQkAvDmOXKmRz0TPEw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "blurhash-0.1.1" = "sha256-SLpszTL2CupMAfUQK5KlnsHTIBDB8hbJs1d6DQXaUiA=";
      "curve25519-dalek-3.2.1" = "sha256-0hFRhn920tLBpo6ZNCl6DYtTMHMXY/EiDvuhOPVjvC0=";
      "libsignal-protocol-0.1.0" = "sha256-VQwrGTNZnlDK5p8ZleAZYtbzDiVTHxc93/CRlCUjWtE=";
      "libsignal-service-0.1.0" = "sha256-1ub0IPSvGhZ2tsC6IolusJ1NSWy+5SXSx8qlIdPngTE=";
      "presage-0.6.0-dev" = "sha256-4isKBn/4yHoAYsYbBTULK/veZmaecU7t+PvE4Y0oNgk=";
=======
      "curve25519-dalek-3.2.1" = "sha256-T/NGZddFQWq32eRu6FYfgdPqU8Y4Shi1NpMaX4GeQ54=";
      "libsignal-protocol-0.1.0" = "sha256-gapAurbs/BdsfPlVvWWF7Ai1nXZcxCW8qc5gQdbnthM=";
      "libsignal-service-0.1.0" = "sha256-AXWCR1maqgIPk8H/IKR22BvMToqJrtlaOelFAnMJ6kI=";
      "presage-0.4.0" = "sha256-HtqSNEaQXgvgrs9xvm76W1v7PLmdsJ5M3fbqH2Dpw8A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  nativeBuildInputs = [
<<<<<<< HEAD
    appstream-glib # for appstream-util
    blueprint-compiler
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
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
=======
    libadwaita
    libsecret
    protobuf
  ];

  meta = {
    changelog = "https://gitlab.com/Schmiddiii/flare/-/blob/${src.rev}/CHANGELOG.md";
    description = "An unofficial Signal GTK client";
    homepage = "https://gitlab.com/Schmiddiii/flare";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda tomfitzhenry ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = lib.platforms.linux;
  };
}
