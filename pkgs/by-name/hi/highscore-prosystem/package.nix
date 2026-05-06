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
  version = "0-unstable-2026-05-01";

  src = fetchFromGitLab {
    owner = "highscore-emu";
    repo = "prosystem";
    rev = "21ff4dbf81497d2867c9e03cb6de1462ecb2ac02";
    hash = "sha256-aDwAwO7DgZqlXGQ1qgaDvLtr7tAmnzf9qHKz1mfsEdc=";
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
    description = "Port of ProSystem to Highscore";
    homepage = "https://gitlab.com/highscore-emu/prosystem";
    license = lib.licenses.gpl2Plus;
    inherit (libhighscore.meta) maintainers platforms;
  };
})
