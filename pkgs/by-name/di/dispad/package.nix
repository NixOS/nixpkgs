{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXi,
  libconfuse,
}:

stdenv.mkDerivation rec {
  pname = "dispad";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "BlueDragonX";
    repo = "dispad";
    rev = "v${version}";
    hash = "sha256-PtwvaNtnCm3Y+6vlxPDc21RyIA2v3vkMOHpoGFxNFng=";
  };

  buildInputs = [
    libX11
    libXi
    libconfuse
  ];

  meta = {
    description = "Small daemon for disabling trackpads while typing";
    homepage = "https://github.com/BlueDragonX/dispad";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ zimbatm ];
    platforms = lib.platforms.linux;
    mainProgram = "dispad";
  };
}
