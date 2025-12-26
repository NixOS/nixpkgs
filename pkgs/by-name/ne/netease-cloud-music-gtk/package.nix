{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  meson,
  ninja,
  pkg-config,
  desktop-file-utils,
  rustc,
  wrapGAppsHook4,
  openssl,
  dbus,
  libadwaita,
  glib-networking,
  gst_all_1,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netease-cloud-music-gtk";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "gmg137";
    repo = "netease-cloud-music-gtk";
    tag = finalAttrs.version;
    hash = "sha256-3vAEk4HwS7EiMv0DAYOvZ9dOlO0yMEUcaO2qCCWlpLs=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "netease-cloud-music-api-1.5.1" = "sha256-PFzXm7jgNsEJiluBaNuhSF0kg/licDdbItMDWmfIBDk=";
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
    libxml2
  ];

  buildInputs = [
    openssl
    dbus
    libadwaita
    glib-networking
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  meta = {
    description = "Rust + GTK based netease cloud music player";
    homepage = "https://github.com/gmg137/netease-cloud-music-gtk";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      diffumist
      aleksana
    ];
    mainProgram = "netease-cloud-music-gtk4";
    platforms = lib.platforms.linux;
  };
})
