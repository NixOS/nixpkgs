{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, boost
}:

stdenv.mkDerivation rec {
  pname = "cryptominisat";
  version = "5.11.12";

  src = fetchFromGitHub {
    owner = "msoos";
    repo = "cryptominisat";
    rev = version;
    hash = "sha256-1AJx8gPf+qDpAp0p4cfCObKZDWKDAKdGopllr2ajpHw=";
  };

  buildInputs = [ python3 boost ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "An advanced SAT Solver";
    homepage = "https://github.com/msoos/cryptominisat";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
}
