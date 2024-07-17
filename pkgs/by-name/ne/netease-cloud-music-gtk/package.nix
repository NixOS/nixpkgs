{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk4,
  appstream-glib,
  desktop-file-utils,
  libxml2,
  rustc,
  wrapGAppsHook4,
  openssl,
  dbus,
  libadwaita,
  glib-networking,
  gst_all_1,
}:

stdenv.mkDerivation rec {
  pname = "netease-cloud-music-gtk";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "gmg137";
    repo = "netease-cloud-music-gtk";
    rev = version;
    hash = "sha256-75zovq7Q370L+bRczTCCC34G2w8xeMMUK5EUTfKAc+w=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "netease-cloud-music-api-1.3.1" = "sha256-ZIc5zj9ZtLBYlZqBR7iUW+KmD71M+OYDiv0dkZrpFos=";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

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

  buildInputs =
    [
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

  meta = with lib; {
    description = "A Rust + GTK based netease cloud music player";
    homepage = "https://github.com/gmg137/netease-cloud-music-gtk";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      diffumist
      aleksana
    ];
    mainProgram = "netease-cloud-music-gtk4";
    platforms = platforms.linux;
  };
}
