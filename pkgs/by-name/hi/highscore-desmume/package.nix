{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libhighscore,
  SDL2,
  libpcap,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-desmume";
  version = "0-unstable-2024-12-17";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "desmume";
    rev = "2bf455fb63ad533d8a8c36fcf2d521aeaa1b6811";
    hash = "sha256-ti7bL8Dt6bSnM/+q+i4frrvjfXWppBlpwcRurbWkyyc=";
  };

  sourceRoot = "source/desmume/src/frontend/highscore";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libhighscore
    SDL2
    libpcap
  ];

  # cc1plus: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
  hardeningDisable = [ "format" ];

  passthru.updateScript = unstableGitUpdater {
    url = finalAttrs.src.gitRepoUrl;
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of DeSmuME to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})
