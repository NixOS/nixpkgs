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
  version = "0-unstable-2026-06-27";

  src = fetchFromGitLab {
    owner = "highscore-emu";
    repo = "nestopia";
    rev = "d70abf78a172d6c8bf309d2fbae7607d66a9d02b";
    hash = "sha256-JtZAaPYz+G+6R8THqyqN3zeRDHoO6qWwFbcQO7EugZw=";
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
