{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  vala,
  ninja,
  gtk3,
  poppler,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdftag";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "arrufat";
    repo = "pdftag";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FEMwoQGoOXGqeJ0nBIN1r/Q/qANDBWB31H+qIzREUt0=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wrapGAppsHook3
    vala
  ];
  buildInputs = [
    gtk3
    poppler
  ];

  meta = {
    description = "Edit metadata found in PDFs";
    homepage = "https://github.com/arrufat/pdftag";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    mainProgram = "pdftag";
  };
})
