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
  pname = "highscore-stella";
  version = "0-unstable-2024-12-17";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "stella";
    rev = "896c6b05222c2f6d34291b95a526a6bfcc39030b";
    hash = "sha256-K6HSBT/d2G7nmrgpnfycjhwTlf+w6KGcOSH8Jchouck=";
  };

  sourceRoot = "source/src/os/highscore";

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
    description = "Port of Stella to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})
