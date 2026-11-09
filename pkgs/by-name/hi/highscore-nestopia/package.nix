{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  libhighscore,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-nestopia";
  version = "0-unstable-2026-05-31";

  src = fetchFromGitLab {
    owner = "highscore-emu";
    repo = "nestopia";
    rev = "ef344470ab045b3ab94c91b287ecc647df0e60f7";
    hash = "sha256-70aaHudrB72k87jOtIt+mJ27cUOqcrYIJ9PFT57xPdw=";
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
  ];

  buildInputs = [
    libhighscore
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of Nestopia to Highscore";
    homepage = "https://gitlab.com/highscore-emu/nestopia";
    license = lib.licenses.gpl2Plus;
    inherit (libhighscore.meta) maintainers platforms;
  };
})
