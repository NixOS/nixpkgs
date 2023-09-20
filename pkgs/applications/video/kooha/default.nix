{ lib
, stdenv
, fetchFromGitHub
, appstream-glib
, cargo
, desktop-file-utils
, glib
, gst_all_1
, pipewire
, gtk4
, libadwaita
, libpulseaudio
, librsvg
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wayland
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "kooha";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Kooha";
    rev = "v${version}";
    hash = "sha256-vLgBuP0DncBIb05R3484WozS+Nl+S7YBJUYek2CkJkQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-NPh603/5yZDUdTegAzFvjRn5tuzyrcNzbbKQr6NxXso=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-ugly
    gtk4
    libadwaita
    libpulseaudio
    librsvg
    wayland
    pipewire
  ];

  installCheckPhase = ''
    $out/bin/kooha --help
  '';

  meta = with lib; {
    description = "Elegantly record your screen";
    homepage = "https://github.com/SeaDve/Kooha";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ austinbutler ];
    mainProgram = "kooha";
  };
}
