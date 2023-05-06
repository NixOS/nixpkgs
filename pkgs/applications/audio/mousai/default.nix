{ lib
, stdenv
, fetchFromGitHub
, appstream-glib
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
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "mousai";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Mousai";
    rev = "v${version}";
    hash = "sha256-VAP2ENgI0Ge1JJEfNtw8dgOLZ1g0sEaoZHICFKI3hXM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-vbMfIk/fXmAHgouzyeceP7jAc/OIyUxFDu/+31aB1F4=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

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
