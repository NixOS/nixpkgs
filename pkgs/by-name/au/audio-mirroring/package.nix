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
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mkg20001";
    repo = "audio-mirroring";
    tag = "v${version}";
    hash = "sha256-GMgFrA8fxaB4W+FDkxfe++RBSChbh59RvWZZwmd/CRo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-tTnrwtLw251aQaM2zUh/sS4MGlmRbZxFROgTRwo9ZlU=";
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
