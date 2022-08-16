{ lib
, stdenv
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
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "gmg137";
    repo = pname;
    rev = version;
    hash = "sha256-dlJZvmfw9+cavAysxVzCekgPdygg5zbU3ZR5BOjPk08=";
  };

  patches = [ ./cargo-lock.patch ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    hash = "sha256-mJyjWEBsLhHwJCeZyRdby/K/jse0F9UBwfQxkNtZito=";
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
