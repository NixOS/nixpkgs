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
  version = "0-unstable-2026-01-02";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "stella";
    rev = "a8d92c100e83ae2249c5b30afcaa4b4ed31fcc46";
    hash = "sha256-QfKtAIMCqniF15vCuWKz/pwb0FuE6xDp6/rfeUWpMgQ=";
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
