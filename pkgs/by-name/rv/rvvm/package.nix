{
  lib,
  stdenv,
  fetchFromGitHub,

  pkg-config,

  SDL2,
  libX11,
  libXext,
  libxkbcommon,
  wayland,
}:

stdenv.mkDerivation {
  pname = "rvvm";
  version = "0.6-unstable-2025-10-02";

  src = fetchFromGitHub {
    owner = "LekKit";
    repo = "RVVM";
    rev = "2247f2dca3955f22d651118d5a50e853cc77b780";
    sha256 = "sha256-gwyG/rV5Fv2dhFhD4P2+SPHSmmhH7mvTk6i///UClyg=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    SDL2
    libX11
    libXext
    libxkbcommon
    wayland
  ];

  enableParallelBuilding = true;

  buildFlags = [
    "all"
    "lib"
  ];

  makeFlags = [
    "USE_SDL=2"
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    homepage = "https://github.com/LekKit/RVVM";
    description = "RISC-V Virtual Machine";
    license = with licenses; [
      gpl3 # or
      mpl20
    ];
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      dramforever
      kamillaova
    ];
    mainProgram = "rvvm";
  };
}
