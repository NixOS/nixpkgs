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
  version = "0-unstable-2026-01-27";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "stella";
    rev = "689e4325099fbc348a92be40237d94bba692aff4";
    hash = "sha256-7+/qgWUiL/dzacuFmbQiAOO+R71rFas+Tf0kpZHOjgY=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/os/highscore";

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "run_command('git', 'describe', '--always', '--dirty', check: false).stdout().strip()" \
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
    description = "Port of Stella to Highscore";
    homepage = "https://github.com/highscore-emu/stella";
    license = lib.licenses.gpl2Only;
    inherit (libhighscore.meta) maintainers platforms;
  };
})
