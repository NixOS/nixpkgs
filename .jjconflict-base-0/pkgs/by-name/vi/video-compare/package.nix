{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_ttf,
  ffmpeg,
}:

stdenv.mkDerivation rec {
  pname = "video-compare";
  version = "20250420";

  src = fetchFromGitHub {
    owner = "pixop";
    repo = "video-compare";
    tag = version;
    hash = "sha256-q61ZT2a2AkYWk4v2oZqCLHVu5eZQQrDLgD8vxitGyA4=";
  };

  postPatch = ''
    # Fix build on Darwin by using $CXX set by setup-hook
    substituteInPlace makefile \
      --replace-fail 'CXX = g++' ""
  '';

  buildInputs = [
    SDL2
    SDL2_ttf
    ffmpeg
  ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL2}/include/SDL2";

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin video-compare

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/pixop/video-compare";
    description = "Split screen video comparison tool";
    maintainers = with lib.maintainers; [ orivej ];
    license = lib.licenses.gpl2Only;
    mainProgram = "video-compare";
    platforms = lib.platforms.unix;
  };
}
