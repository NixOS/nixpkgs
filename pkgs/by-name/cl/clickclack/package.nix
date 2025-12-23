{
  lib,
  stdenv,
  fetchFromSourcehut,
  SDL2,
}:

stdenv.mkDerivation rec {
  pname = "clickclack";
  version = "0.2.3";

  src = fetchFromSourcehut {
    owner = "~proycon";
    repo = "clickclack";
    rev = version;
    hash = "sha256-YmlbGEmZgT/30c+mWQzdz4rKc69d75zhoNUA5FdxdMc=";
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
}
