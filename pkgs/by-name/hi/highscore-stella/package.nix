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
  version = "0-unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "stella";
    rev = "d4e5a1f26fd62766e2ff9eb070f59efa89d68ed6";
    hash = "sha256-/TbINGmvsDFxTwdaewg1Hv/fDQMk4ELz6j1TDLaffUQ=";
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
