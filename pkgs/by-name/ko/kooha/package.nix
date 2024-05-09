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
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Kooha";
    rev = "v${version}";
    hash = "sha256-D/+tsIfcXrlwwL6vSLRsiAp7wMVtIgzjNNd2uk+9bco=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-iDyhK2k2RB7CvtW+91isVzIFOl2/Loh+Bvneu4TGfn0=";
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
