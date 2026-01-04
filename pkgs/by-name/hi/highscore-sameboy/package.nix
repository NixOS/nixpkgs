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
  version = "0-unstable-2026-01-04";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "SameBoy";
    rev = "80578af6531ac2da2a9ba76318e8e1dab856fabe";
    hash = "sha256-LB0HTcTNEe9WlxTi8xwYsbas0SX6Cs2VNo/ljyrcxzQ=";
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
