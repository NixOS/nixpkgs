{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libhighscore,
  zstd,
  libchdr,
  libvorbis,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-mednafen";
  version = "0-unstable-2026-05-22";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "mednafen-highscore";
    rev = "e13c337a2cde6d5304f2a33311447280ef206a7a";
    hash = "sha256-nwvOkL1RzqXCqMFiDuSvNhgmujvxFYpdp4OScvEmppI=";
  };

  sourceRoot = "${finalAttrs.src.name}/highscore";

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
    zstd
    libchdr
    libvorbis
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of Mednafen to Highscore";
    homepage = "https://github.com/highscore-emu/mednafen-highscore";
    license = lib.licenses.gpl2Plus;
    inherit (libhighscore.meta) maintainers platforms;
  };
})
