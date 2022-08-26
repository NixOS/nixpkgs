{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  name = "uarmsolver";
  version = "0.2.4";

  src = fetchFromGitHub {
   owner = "firefly-cpp";
   repo = "uARMSolver";
   rev = version;
   sha256 = "17px69z0kw0z6cip41c45i6srbw56b0md92i9vbqyzinx8b75mzw";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
   install -D -t $out/bin uARMSolver
  '';

  meta = with lib; {
   description = "universal Association Rule Mining Solver";
   homepage    = "https://github.com/firefly-cpp/uARMSolver";
   license     = licenses.mit;
   platforms   = platforms.all;
   maintainers = with maintainers; [ firefly-cpp ];
  };

}
