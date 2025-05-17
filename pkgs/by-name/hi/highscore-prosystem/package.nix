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
  pname = "highscore-prosystem";
  version = "0-unstable-2024-11-16";

  src = fetchFromGitLab {
    owner = "alice-m";
    repo = "prosystem";
    rev = "bb23771215e048edd4a7af40640503e795f17b6b";
    hash = "sha256-Hy/NWai976741uCIKGcKWtLr+iSVfH9aAS9AKKxz0DY=";
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
    description = "Port of ProSystem to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})
