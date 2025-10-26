{
  lib,
  cargo,
  desktop-file-utils,
  fetchFromGitHub,
  glib,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pipewire,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "audio-mirroring";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "mkg20001";
    repo = "audio-mirroring";
    tag = "v${version}";
    hash = "sha256-f4V5ZJvXhdwqS4kx99Lr2Eb8r08PRd3T4mbRoAyyIqE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-+mAdxaaQOO7AIn/o/J13FbHIvtepk8/okGxO6p6aGzI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    rustPlatform.bindgenHook
    wrapGAppsHook4
  ];

  buildInputs = [
    desktop-file-utils
    glib
    gtk4
    libadwaita
    pipewire
  ];

  meta = with lib; {
    description = "Audio Mirroring for Linux";
    homepage = "https://github.com/mkg20001/audio-mirroring";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.linux;
    mainProgram = "audio-mirroring";
  };
}
