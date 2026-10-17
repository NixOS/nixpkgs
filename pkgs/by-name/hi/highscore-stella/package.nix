{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libhighscore,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-stella";
  version = "0-unstable-2026-06-27";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "stella";
    rev = "c68db640e50a9c88b3d01ad9e8470dc1e112c496";
    hash = "sha256-7h6zLnpj0TikPmvr7Lrx5HvQRUmXjslQJXTSSU1CZgA=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/os/highscore";

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
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of Stella to Highscore";
    homepage = "https://github.com/highscore-emu/stella";
    license = lib.licenses.gpl2Only;
    inherit (libhighscore.meta) maintainers platforms;
  };
})
