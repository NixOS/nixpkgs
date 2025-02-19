{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  libhighscore,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-nestopia";
  version = "0-unstable-2024-12-24";

  src = fetchFromGitLab {
    owner = "alice-m";
    repo = "nestopia";
    rev = "bc3bc85fbd357fc1339ccb973d27bf68bb438ebd";
    hash = "sha256-0KbMPpgCdATOHSXBgAVs7yQT+ZsICZ9mNXCouuV7ETc=";
  };

  sourceRoot = "source/highscore";

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
    description = "Port of Nestopia to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})
