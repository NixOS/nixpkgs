{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cargo
, meson
, ninja
, pkg-config
, glib
, gtk4
, appstream-glib
, desktop-file-utils
, libxml2
, rustc
, wrapGAppsHook4
, openssl
, dbus
, libadwaita
, gst_all_1
, Foundation
, SystemConfiguration
}:

stdenv.mkDerivation rec {
  pname = "netease-cloud-music-gtk";
<<<<<<< HEAD
  version = "2.2.0";
=======
  version = "2.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gmg137";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-9qUzRmm3WQEVjzhzHMT1vNw3r3ymWGlBWXnnPsYGSnk=";
=======
    hash = "sha256-A3mvf6TZ3+aiWA6rg9G5NMaDKvO0VQzwIM1t0MaTpTc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "netease-cloud-music-api-1.2.0" = "sha256-MR1yVPrNzhZC65mQen88t7NbLfRcoWvT6DMSLGCMeTY=";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

=======
      "netease-cloud-music-api-1.0.2" = "sha256-7Yp2ZBg5wHnDPtdPLwZQnqcSlVuGCrXpV5M/dp/IaOE=";
    };
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib # glib-compile-resources
    gtk4 # gtk4-update-icon-cache
    appstream-glib # appstream-util
    desktop-file-utils # update-desktop-database
    libxml2 # xmllint
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    openssl
    dbus
    libadwaita
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]) ++ lib.optionals stdenv.isDarwin [
    Foundation
    SystemConfiguration
  ];

  meta = with lib; {
    description = "A Rust + GTK based netease cloud music player";
    homepage = "https://github.com/gmg137/netease-cloud-music-gtk";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ diffumist ];
    mainProgram = "netease-cloud-music-gtk4";
<<<<<<< HEAD
    platforms = platforms.linux;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
