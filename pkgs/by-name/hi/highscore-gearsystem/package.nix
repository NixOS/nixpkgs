{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libhighscore,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-gearsystem";
  version = "0-unstable-2024-12-24";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "gearsystem";
    rev = "2b1d152f551ecbb4222688892458395eab40f5f1";
    hash = "sha256-TBk/Bu9OtnkcMnbAPsnHujn5tUXvYCmDgA+KKKp3KmA=";
  };

  sourceRoot = "source/platforms/highscore";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libhighscore
  ];

  passthru.updateScript = unstableGitUpdater {
    url = finalAttrs.src.gitRepoUrl;
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of Gearsystem to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})
