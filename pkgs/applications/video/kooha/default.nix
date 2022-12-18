{ lib
, stdenv
, fetchFromGitHub
, appstream-glib
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
, wayland
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "kooha";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Kooha";
    rev = "v${version}";
    hash = "sha256-HgouIMbwpmR/K1hPU7QDzeEtyi5hC66huvInkJFLS2w=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-rdxD9pys11QcUtufcZ/zCrviytyc8hIXJfsXg2JoaKE=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
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
    description = "Simple screen recorder";
    homepage = "https://github.com/SeaDve/Kooha";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ austinbutler ];
  };
}
