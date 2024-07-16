{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cargo
, meson
, ninja
, pkg-config
, desktop-file-utils
, rustc
, wrapGAppsHook4
, openssl
, dbus
, libadwaita
, glib-networking
, gst_all_1
}:

stdenv.mkDerivation rec {
  pname = "netease-cloud-music-gtk";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "gmg137";
    repo = "netease-cloud-music-gtk";
    rev = version;
    hash = "sha256-uoC9J09U2aI1dhaKc3TxIyFwRrPRxDrzaV+RyoZ6mKo=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "netease-cloud-music-api-1.3.2" = "sha256-QRz9Sdu+0I7SwujoTBKWPQMjPDdX8ZyVlFwMw9pM7UY=";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils # update-desktop-database
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    openssl
    dbus
    libadwaita
    glib-networking
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  meta = with lib; {
    description = "Rust + GTK based netease cloud music player";
    homepage = "https://github.com/gmg137/netease-cloud-music-gtk";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ diffumist aleksana ];
    mainProgram = "netease-cloud-music-gtk4";
    platforms = platforms.linux;
  };
}
