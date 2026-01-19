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
  version = "0-unstable-2026-01-05";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "mupen64plus-highscore";
    rev = "84f913ed4433f37b8a990cace2f9e1cfb641e2dc";
    hash = "sha256-Afrb7WUw5QeST/NRM06UIyUTzxvrGqayFneaXjAw6aM=";
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
