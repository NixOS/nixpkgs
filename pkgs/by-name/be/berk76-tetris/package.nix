{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "berk76-tetris";
  version = "1.1.0-unstable-2024-11-24";

  src = fetchFromGitHub {
    owner = "oldcompcz";
    repo = "tetris";
    rev = "31d441a840dff7ad3839087b9a5a594250841342";
    hash = "sha256-B5IYXT6Z3zbeG9lG7rflQvFnvOI/vse6L2Orv5dWlHg=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [ ncurses ];

  buildPhase = ''
    runHook preBuild

    make -f Makefile.con

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 Tetris $out/bin/tetris

    runHook postInstall
  '';

  meta = {
    description = "ASCII Art Tetris";
    homepage = "https://github.com/oldcompcz/tetris";
    mainProgram = "tetris";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
