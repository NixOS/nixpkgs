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
  version = "4.7.1";

  src = fetchFromGitHub {
    owner = "Motion-Project";
    repo = "motion";
    rev = "release-${version}";
    sha256 = "sha256-NAzVFWWbys+jYYOifCOOoucAKfa19njIzXBQbtgGX9M=";
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

<<<<<<< HEAD
  meta = {
    description = "Monitors the video signal from cameras";
    homepage = "https://motion-project.github.io/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      puffnfresh
      veprbl
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Monitors the video signal from cameras";
    homepage = "https://motion-project.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      puffnfresh
      veprbl
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
    mainProgram = "motion";
  };
}
