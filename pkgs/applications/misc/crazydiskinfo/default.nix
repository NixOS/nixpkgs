{ lib, stdenv, cmake, ncurses, libatasmart, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "crazydiskinfo";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "pabs3";
    repo = pname;
    rev = "8563aa8636c37f0b889f3b4b27338691efdeac2b";
    hash = "sha256-pfkJqVtrjoauUQRXLJGvnGWx+TpkbdN62h5raVdqb1g=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ ncurses libatasmart ];

  configurePhase = ''
    mkdir build
    cd build
    cmake ..
  '';

  installPhase = "install -D crazy $out/bin/crazy";

  meta = with lib; {
    description = "crazydiskinfo provides a TUI that surfaces smart data and uses Crystal Disk Info's algorithm for disk health and temperatures.";
    homepage = "https://github.com/otakuto/crazydiskinfo";
    license = licenses.mit;
    maintainers = with maintainers; [ asimpson ];
    platforms = platforms.linux;
    mainProgram = "crazy";
  };
}
