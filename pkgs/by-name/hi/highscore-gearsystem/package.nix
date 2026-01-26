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
  pname = "highscore-gearsystem";
  version = "0-unstable-2026-01-02";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "gearsystem";
    rev = "7a2cd21c54f1487ec255b71eaf629d1e48d4bbf1";
    hash = "sha256-y4ZSw2yXBNg49X4aB1TE79ydu3EVqvtb73eB2QBKLEk=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "run_command('git', 'describe', '--always', '--dirty', '--match', ''', check: false).stdout().strip()" \
        "'${finalAttrs.src.rev}'"
  '';

  sourceRoot = "${finalAttrs.src.name}/platforms/highscore";

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
    description = "Port of Gearsystem to Highscore";
    homepage = "https://github.com/highscore-emu/Gearsystem";
    license = lib.licenses.gpl3Plus;
    inherit (libhighscore.meta) maintainers platforms;
  };
})
