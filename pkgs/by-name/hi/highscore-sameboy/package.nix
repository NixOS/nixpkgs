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
  version = "0-unstable-2026-06-16";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "SameBoy";
    rev = "10703e58fde906df5cd80b81a104b959880bed42";
    hash = "sha256-jpMY40f3xUMl2ZJPH815F0hRqnYiEtm17KYHHLVk4jk=";
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
