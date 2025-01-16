{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libhighscore,
  zstd,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-mednafen";
  version = "0-unstable-2024-11-22";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "mednafen-highscore";
    rev = "2bf66e150646f972d58c6fe1a18316b342f0c0c4";
    hash = "sha256-uP4E8rLcNSiea9oxjNN+x7dbWsd+x32c3GVQHqmoEH0=";
  };

  sourceRoot = "source/highscore";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libhighscore
    zstd
  ];

  passthru.updateScript = unstableGitUpdater {
    url = finalAttrs.src.gitRepoUrl;
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of Mednafen to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})
