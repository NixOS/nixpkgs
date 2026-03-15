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
  version = "0-unstable-2026-03-03";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "stella";
    rev = "13c012a92cd1f4be7ac777df403f482bfdc8fc0e";
    hash = "sha256-y3GPyeFUVhhF56ip57ak/YiWqogp6UW84uxvfK0+Ejw=";
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
