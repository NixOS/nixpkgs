{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  ffmpeg,
  libjpeg,
  libmicrohttpd,
}:

stdenv.mkDerivation rec {
  pname = "motion";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "Motion-Project";
    repo = "motion";
    rev = "release-${version}";
    sha256 = "sha256-bGjiO14a7xKRgoeo5JlexXlKggE+agRMmQViBXagmt8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ffmpeg
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
}
