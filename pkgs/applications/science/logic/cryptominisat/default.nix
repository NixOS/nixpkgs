{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, boost
}:

stdenv.mkDerivation rec {
  pname = "cryptominisat";
  version = "5.11.21";

  src = fetchFromGitHub {
    owner = "msoos";
    repo = "cryptominisat";
    rev = version;
    hash = "sha256-8oH9moMjQEWnQXKmKcqmXuXcYkEyvr4hwC1bC4l26mo=";
  };

  buildInputs = [ python3 boost ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "An advanced SAT Solver";
    mainProgram = "cryptominisat5";
    homepage = "https://github.com/msoos/cryptominisat";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
}
