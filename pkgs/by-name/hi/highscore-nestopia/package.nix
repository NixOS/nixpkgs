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
  version = "0-unstable-2026-03-03";

  src = fetchFromGitLab {
    owner = "highscore-emu";
    repo = "nestopia";
    rev = "0ef62709df9ff3af8729c9d7dc257d8fbc2cd48c";
    hash = "sha256-DRA1l5wV/jZhbFni5ZXD6agObt+XZYrPIbgkzSgUGEo=";
  };

  sourceRoot = "${finalAttrs.src.name}/highscore";

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "run_command('git', 'describe', '--always', '--dirty', '--match', ''', check: false).stdout().strip()" \
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
    description = "Port of Nestopia to Highscore";
    homepage = "https://gitlab.com/highscore-emu/nestopia";
    license = lib.licenses.gpl2Plus;
    inherit (libhighscore.meta) maintainers platforms;
  };
})
