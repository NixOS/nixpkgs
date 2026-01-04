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
  version = "0-unstable-2025-12-31";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "SameBoy";
    rev = "80e1d0b5aef4098539979a4670882d590ac9a1ca";
    hash = "sha256-Fp9GODDu0170NoCHCfX5+vs8hQccS/P1N4jM+L784+o=";
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
