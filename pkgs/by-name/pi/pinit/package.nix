{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  blueprint-compiler,
  wrapGAppsHook4,
  libadwaita,
  libgee,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pinit";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "ryonakano";
    repo = "pinit";
    rev = finalAttrs.version;
    hash = "sha256-unvlMytZdjVbrWlwkpw90NZoFw9A6Ga0bB2XqFEPuVE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    blueprint-compiler
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libgee
  ];

  meta = {
    description = "Pin portable apps to the launcher";
    homepage = "https://github.com/ryonakano/pinit";
    license = with lib.licenses; [
      gpl3Plus
      cc0
    ];
    mainProgram = "com.github.ryonakano.pinit";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
