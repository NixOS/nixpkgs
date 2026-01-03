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
  version = "0-unstable-2025-12-28";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "mupen64plus-highscore";
    rev = "94ab5644e5363cf359b334ac057f3f36d24910be";
    hash = "sha256-Q+6iL7DGr62C2fVEP0EWCgm7S7AYAW1C2X1GPKbI7aY=";
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
