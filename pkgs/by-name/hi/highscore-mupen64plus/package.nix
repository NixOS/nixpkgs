{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libhighscore,
  mupen64plus,

  # Emulation mode: Performance
  gliden64,

  # Emulation mode: Accuracy
  highscore-mupen64plus-rsp-parallel,
  highscore-mupen64plus-video-parallel,

  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-mupen64plus";
  version = "0-unstable-2026-04-11";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "mupen64plus-highscore";
    rev = "9654f94da5ab382e4257c26c9a26cbab4fe6b43f";
    hash = "sha256-oE7yDKYxDz4WTrttOLHY8zvHw0Xnu1ERfBjAOeqkSOQ=";
  };

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
    mupen64plus
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  postInstall = ''
    mkdir -p $out/lib/mupen64plus
    ln -sf ${mupen64plus}/lib/*.so* $out/lib/
    ln -sf ${mupen64plus}/lib/mupen64plus/*.so* $out/lib/mupen64plus/
    ln -sf ${gliden64}/lib/mupen64plus/*.so* $out/lib/mupen64plus/
    ln -sf ${highscore-mupen64plus-rsp-parallel}/lib/mupen64plus/*.so* $out/lib/mupen64plus/
    ln -sf ${highscore-mupen64plus-video-parallel}/lib/mupen64plus/*.so* $out/lib/mupen64plus/
  '';

  meta = {
    description = "Port of Mupen64Plus to Highscore";
    homepage = "https://github.com/highscore-emu/mupen64plus-highscore";
    license = lib.licenses.gpl2Plus;
    inherit (libhighscore.meta) maintainers;
    inherit (mupen64plus.meta) platforms broken;
  };
})
