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
<<<<<<< HEAD
  version = "0.16";
=======
  version = "0.15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    owner = "leesonwai";
    repo = "sums";
<<<<<<< HEAD
    tag = "${finalAttrs.version}";
    hash = "sha256-X+AMUH8nJli0Um1bH0gDGLnfHGknqea3DZxH+tdTEr8=";
=======
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-L+ND18cqXAi0qqt1lECQlx2cBX9HrhAXNFxHFl9wjU8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
