{ lib
, stdenv
, fetchpatch
, fetchFromGitHub
, rustPlatform
, meson
, ninja
, pkg-config
, glib
, gtk4
, appstream-glib
, desktop-file-utils
, libxml2
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
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "gmg137";
    repo = pname;
    rev = version;
    hash = "sha256-0pmuzdRQBdUS4ORh3zJQWb/hbhk7SY3P4QMwoy4Mgp8=";
  };

  patches = [
    (fetchpatch {
      name = "add-cargo-lock-for-2.0.2.patch";
      url = "https://github.com/gmg137/netease-cloud-music-gtk/commit/21b5d40d49e661fe7bd35ed10bb8b883ef7fcd9f.patch";
      hash = "sha256-pSgc+yJQMNyLPYUMc1Kp/Kr+++2tH8srIM5PgVeoZ+E=";
    })
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    hash = "sha256-7Z5i5Xqtk4ZbBXSVYg1e05ENa2swC88Ctd2paE60Yyo=";
  };

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
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

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
  };
}
