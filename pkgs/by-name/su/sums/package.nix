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
  version = "0.11";

  src = fetchFromGitLab {
    owner = "leesonwai";
    repo = "sums";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-D8BkrStS6IwkWy8J7YRHIhyJ68kX4Dky0Vbphn6CsVM=";
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
