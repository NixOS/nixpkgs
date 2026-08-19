{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libhighscore,
  libGL,
  libx11,
  SDL2,
  libpcap,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-desmume";
  version = "0-unstable-2025-09-21";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "desmume";
    rev = "7d80d2a70850a5595ac8160e6dee5dea8b2fe293";
    hash = "sha256-wpW8Y68qzuu6J51snw2slbD6cnceFzONG4kutBOeB8I=";
  };

  sourceRoot = "${finalAttrs.src.name}/desmume/src/frontend/highscore";

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "run_command('git', 'describe', '--always', '--dirty').stdout().strip()" \
        "'${finalAttrs.src.rev}'"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libhighscore
    libGL
    libx11
    SDL2
    libpcap
  ];

  # cc1plus: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
  hardeningDisable = [ "format" ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of DeSmuME to Highscore";
    homepage = "https://github.com/highscore-emu/desmume";
    license = lib.licenses.gpl2Plus;
    inherit (libhighscore.meta) platforms maintainers;
  };
})
