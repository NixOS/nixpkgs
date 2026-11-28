{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ascii-tetris";
  version = "0-unstable-2017-11-20";

  src = fetchFromGitHub {
    owner = "Gregwar";
    repo = "ASCII-Tetris";
    rev = "f983b0488a43bfea9ab1637f31596bbb94a1135e";
    hash = "sha256-heIQQ/T7h9pZi4YvcbGVF1wX/dCiHCRPa2hNF/T/U+U=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 Tetris $out/bin/ascii-tetris

    runHook postInstall
  '';

  meta = {
    description = "ASCII Tetris game written in C";
    homepage = "https://github.com/Gregwar/ASCII-Tetris";
    mainProgram = "ascii-tetris";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
