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
  version = "0-unstable-2025-12-27";

  src = fetchFromGitLab {
    owner = "highscore-emu";
    repo = "prosystem";
    rev = "44d86957d9377fdc1650c8cdaafbf7e2e2671827";
    hash = "sha256-vxgh819XwI6rjoI7WwUEPx0PVpb58+MIOhCINQKom0Q=";
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
