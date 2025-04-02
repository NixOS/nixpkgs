{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libhighscore,
  mupen64plus,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-mupen64plus";
  version = "0-unstable-2024-12-25";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "mupen64plus-highscore";
    rev = "a64ff811a7daa65e3503a46f9d2a78c6cb0cc175";
    hash = "sha256-sgiig/yzIttmSLqcRGa35okYwQ/6nQQX7WX/PDNopQM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libhighscore
    mupen64plus
  ];

  passthru.updateScript = unstableGitUpdater {
    url = finalAttrs.src.gitRepoUrl;
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of Mupen64Plus to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
    inherit (mupen64plus.meta) platforms broken;
  };
})
