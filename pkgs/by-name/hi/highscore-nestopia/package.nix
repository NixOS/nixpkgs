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
  version = "0-unstable-2026-05-04";

  src = fetchFromGitLab {
    owner = "highscore-emu";
    repo = "nestopia";
    rev = "bb3916b314a8a7a123eac6543e5fc495ef5b257a";
    hash = "sha256-pQIibnKrAcIZIl+D9c25WTp8j+GILCxIjVRKbzVfaz8=";
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
