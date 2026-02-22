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
  version = "0-unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "SameBoy";
    rev = "00922fa99b723aae3837d9e2eecb28cbeaca1b59";
    hash = "sha256-FkJ2VOY6Na73gIpu1MrK37Lo/aHfWKOwnFsXRuKHKsI=";
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
