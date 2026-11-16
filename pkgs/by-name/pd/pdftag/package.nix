{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  vala,
  ninja,
  gtk4,
  libadwaita,
  poppler,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdftag";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "arrufat";
    repo = "pdftag";
    tag = finalAttrs.version;
    hash = "sha256-vUQ6k0pHhrlrO54x9Yx7we3wbX9NlVY2rIPW30ippj4=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wrapGAppsHook4
    vala
  ];
  buildInputs = [
    gtk4
    libadwaita
    poppler
  ];

  meta = {
    description = "Edit metadata found in PDFs";
    changelog = "https://github.com/arrufat/pdftag/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/arrufat/pdftag";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    mainProgram = "pdftag";
  };
})
