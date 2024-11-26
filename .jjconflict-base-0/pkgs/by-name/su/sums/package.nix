{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  mpfr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sums";
  version = "0.13";

  src = fetchFromGitLab {
    owner = "leesonwai";
    repo = "sums";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-DztSQcaH/k5EOvsrVA/DdgNSEHtz4Nr938tIhC94Gu8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    mpfr
  ];

  meta = {
    description = "Simple GTK postfix calculator for GNOME";
    homepage = "https://gitlab.com/leesonwai/sums";
    license = lib.licenses.gpl3Plus;
    mainProgram = "sums";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
