{
  lib,
  stdenv,
  fetchFromGitLab,
  SDL2,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "anarch";
  version = "1.0-unstable-2023-09-08";

  src = fetchFromGitLab {
    owner = "drummyfish";
    repo = "anarch";
    rev = "6f90562161200682459e772f1dacb747f23c5f95";
    hash = "sha256-KmuJruzQRFunhwUGz3bHhXgtD2m4+5Vk0n7xhzVBMWs=";
  };

  buildInputs = [
    SDL2
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXfixes
    xorg.libXext
    xorg.libXi
    xorg.libXScrnSaver
  ];

  # upstream is an error-prone make/build script
  buildPhase = ''
    runHook preBuild

    $CC -O3 -o anarch main_sdl.c $(sdl2-config --cflags --libs)

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 anarch $out/bin/anarch

    runHook postInstall
  '';

  meta = {
    homepage = "https://drummyfish.gitlab.io/anarch/";
    description = "Suckless FPS game";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    license = lib.licenses.cc0;
    platforms = lib.platforms.unix;
    mainProgram = "anarch";
  };
})
