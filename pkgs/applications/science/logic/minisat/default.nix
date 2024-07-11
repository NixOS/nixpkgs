{ lib, stdenv, fetchFromGitHub, cmake, zlib }:

stdenv.mkDerivation rec {
  pname = "minisat";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "stp";
    repo = pname;
    rev = "releases/${version}";
    sha256 = "14vcbjnlia00lpyv2fhbmw3wbc9bk9h7bln9zpyc3nwiz5cbjz4a";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Compact and readable SAT solver";
    maintainers = with maintainers; [ gebner raskin ];
    platforms = platforms.unix;
    license = licenses.mit;
    homepage = "http://minisat.se/";
  };
}
