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
  version = "0-unstable-2026-01-31";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "mednafen-highscore";
    rev = "f1646bbc664837f5b2ecbfb32cc5c42101466bfd";
    hash = "sha256-YHVV6/8JTESLtGA5jFozE5IhXHB4RaUaT2yvFd7wGo8=";
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
