{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "uarmsolver";
  version = "0.2.5";

  src = fetchFromGitHub {
   owner = "firefly-cpp";
   repo = "uARMSolver";
   rev = version;
   sha256 = "sha256-t5Nep99dH/TvJzI9woLSuBrAWSqXZvLncXl7/43Z7sA=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -D -t $out/bin uARMSolver
  '';

  meta = with lib; {
    description = "universal Association Rule Mining Solver";
    homepage    = "https://github.com/firefly-cpp/uARMSolver";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
