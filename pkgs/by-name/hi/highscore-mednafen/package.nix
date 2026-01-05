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
  version = "0-unstable-2025-12-28";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "mednafen-highscore";
    rev = "58404782e3f69186c7be821a880cf1442b240f2f";
    hash = "sha256-FXSfBAPpi+Ch9vuPQf6nqLMKxvrbXG+6F5HHaU9fs2s=";
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
