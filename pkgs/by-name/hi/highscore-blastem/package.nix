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
  pname = "highscore-blastem";
  version = "0-unstable-2024-12-17";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "blastem-highscore";
    rev = "8b5dc82206c8bf15d2de11bdba96c2d1e1ffe53f";
    hash = "sha256-YyH+1li+1M8RkVqBPOkiVBvQQJjofRL8pjcrfboGx1g=";
  };

  sourceRoot = "source/highscore";

  postPatch = ''
    patchShebangs gen-db.sh
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libhighscore
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=maybe-uninitialized";

  passthru.updateScript = unstableGitUpdater {
    url = finalAttrs.src.gitRepoUrl;
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of BlastEm to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
    broken = stdenv.hostPlatform.isAarch64;
  };
})
