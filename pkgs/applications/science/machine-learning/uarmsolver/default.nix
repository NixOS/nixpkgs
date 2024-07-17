{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "uarmsolver";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "uARMSolver";
    rev = version;
    sha256 = "sha256-E8hc7qoIDaNERMUhVlh+iBvQX1odzd/szeMSh8TCNFo=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -D -t $out/bin uARMSolver
  '';

  meta = with lib; {
    description = "universal Association Rule Mining Solver";
    mainProgram = "uARMSolver";
    homepage = "https://github.com/firefly-cpp/uARMSolver";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
