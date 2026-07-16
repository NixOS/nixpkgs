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
  version = "0-unstable-2025-06-28";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "blastem-highscore";
    rev = "d19e9a8ddd0accf017f44dcc81bdd2661f63f25f";
    hash = "sha256-KetitwqL4S0T4GayeTdwR5hG/LVUF+mJ8oGIN6XPLfU=";
  };

  sourceRoot = "${finalAttrs.src.name}/highscore";

  postPatch = ''
    patchShebangs gen-db.sh

    substituteInPlace meson.build \
      --replace-fail "run_command('git', 'describe', '--always', '--dirty').stdout().strip()" \
        "'${finalAttrs.src.rev}'"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libhighscore
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of BlastEm to Highscore";
    homepage = "https://github.com/highscore-emu/blastem-highscore";
    license = lib.licenses.gpl3Plus;
    inherit (libhighscore.meta) maintainers platforms;
    badPlatforms = lib.platforms.aarch64;
  };
})
