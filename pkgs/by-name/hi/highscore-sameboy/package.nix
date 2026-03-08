{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  rgbds,
  libhighscore,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-sameboy";
  version = "0-unstable-2026-02-17";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "SameBoy";
    rev = "aae1571db7de438638d4180dc451b1b348d5a135";
    hash = "sha256-PZNWzN/C6QPTgNLIsN55cE/3DyfcUdUknAUjxZ7sJvA=";
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
    rgbds
  ];

  buildInputs = [
    libhighscore
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of SameBoy to Highscore";
    homepage = "https://github.com/highscore-emu/SameBoy";
    license = lib.licenses.mit;
    inherit (libhighscore.meta) maintainers platforms;
  };
})
