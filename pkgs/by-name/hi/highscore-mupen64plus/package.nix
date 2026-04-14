{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libhighscore,
  mupen64plus,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-mupen64plus";
  version = "0-unstable-2026-04-10";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "mupen64plus-highscore";
    rev = "867c94907cd47f4843f3c8bddd371166c460ba8b";
    hash = "sha256-hnDhyYcKkKh0mvksAOJOLYnyp5gNCk38dxMBT/1ItLQ=";
  };

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
    mupen64plus
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of Mupen64Plus to Highscore";
    homepage = "https://github.com/highscore-emu/mupen64plus-highscore";
    license = lib.licenses.gpl2Plus;
    inherit (libhighscore.meta) maintainers;
    inherit (mupen64plus.meta) platforms broken;
  };
})
