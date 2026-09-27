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
  pname = "highscore-prosystem";
  version = "0-unstable-2026-06-27";

  src = fetchFromGitLab {
    owner = "highscore-emu";
    repo = "prosystem";
    rev = "8787e0ee4af7234c72811437db974024620d94b3";
    hash = "sha256-RojEZLPurjBy1o2BUVrr5k7cLsTMn4Dl4+SPrSGpOvA=";
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
    description = "Port of ProSystem to Highscore";
    homepage = "https://gitlab.com/highscore-emu/prosystem";
    license = lib.licenses.gpl2Plus;
    inherit (libhighscore.meta) maintainers platforms;
  };
})
