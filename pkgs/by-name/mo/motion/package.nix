{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  ffmpeg-headless,
  libjpeg,
  libmicrohttpd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "motion";
  version = "4.7.1";

  src = fetchFromGitHub {
    owner = "Motion-Project";
    repo = "motion";
    rev = "release-${finalAttrs.version}";
    sha256 = "sha256-NAzVFWWbys+jYYOifCOOoucAKfa19njIzXBQbtgGX9M=";
  };

  patches = [
    # https://github.com/Motion-Project/motion/pull/1959
    ./fix-cross.diff
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ffmpeg-headless
    libjpeg
    libmicrohttpd
  ];

  meta = {
    description = "Monitors the video signal from cameras";
    homepage = "https://motion-project.github.io/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      puffnfresh
      veprbl
    ];
    platforms = lib.platforms.unix;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
    mainProgram = "motion";
  };
})
