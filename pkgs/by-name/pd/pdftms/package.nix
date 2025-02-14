{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gnumake,
  gcc,
  yaml-cpp,
}:

stdenv.mkDerivation {
  pname = "pdftms";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "pingponghero12";
    repo = "pdftms";
    rev = "main";
    sha256 = "sha256-ig7L0/DOcTpKiODbWGfYMmLjlXgb4Am5sPQzf/Eo1hY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    gnumake
    gcc
    yaml-cpp
  ];

  # Use -B -S to avoid error with normal mkdir -p build etc
  configurePhase = ''
    cmake -B build -S .
  '';

  buildPhase = ''
    make -C build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/pdftms $out/bin/
  '';

  meta = with lib; {
    description = "PDF TUI Managment System";
    homepage = "https://github.com/pingponghero12/pdftms";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
