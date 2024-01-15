{ lib
, stdenv
, fetchFromGitHub
, appstream-glib
, cargo
, dbus
, desktop-file-utils
, glib
, glib-networking
, gobject-introspection
, gst_all_1
, gtk4
, libadwaita
, libpulseaudio
, libsoup_3
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "mousai";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Mousai";
    rev = "v${version}";
    hash = "sha256-QInnKjGYaWlIj+F3upQ8CJ6RqCM72Y+BGrrezndqfOg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-/AwTNuDdhAhj/kbc6EdC3FKGO1LfZIY68utPjcrw0S0=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    dbus
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    glib
    glib-networking
    gtk4
    libadwaita
    libpulseaudio
    libsoup_3
  ];

  meta = with lib; {
    description = "Identify any songs in seconds";
    homepage = "https://github.com/SeaDve/Mousai";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
