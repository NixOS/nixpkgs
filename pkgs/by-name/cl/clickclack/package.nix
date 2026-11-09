{
  lib,
  stdenv,
  fetchFromSourcehut,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clickclack";
  version = "0.3.0";

  src = fetchFromSourcehut {
    owner = "~proycon";
    repo = "clickclack";
    rev = finalAttrs.version;
    hash = "sha256-YZiGjjJU6qwfRfHKY4jCuuAonTJWA4JuwsSxRxb3C7g=";
  };

  buildInputs = [
    SDL2
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Vibration/audio feedback tool to be used with virtual keyboards";
    homepage = "https://git.sr.ht/~proycon/clickclack";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "clickclack";
  };
})
