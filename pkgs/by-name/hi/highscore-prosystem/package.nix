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
  version = "0-unstable-2026-05-16";

  src = fetchFromGitLab {
    owner = "highscore-emu";
    repo = "prosystem";
    rev = "c371e250cc01b8be99955671b93d4e3769535e05";
    hash = "sha256-XTOOfcJo5/T6JtirG0wH7LTdjBoNzdaxNKqFkhc9RO8=";
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
