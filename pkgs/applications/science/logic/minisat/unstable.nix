{ stdenv, fetchFromGitHub, zlib, cmake }:

stdenv.mkDerivation rec {
  name = "minisat-unstable-2013-09-25";

  src = fetchFromGitHub {
    owner = "niklasso";
    repo = "minisat";
    rev = "37dc6c67e2af26379d88ce349eb9c4c6160e8543";
    sha256 = "091hf3qkm197s5r7xcr3m07xsdwyz2rqk1hc9kj0hn13imz09irq";
  };

  buildInputs = [ zlib ];
  nativeBuildInputs =  [ cmake ];

  meta = with stdenv.lib; {
    description = "Compact and readable SAT solver";
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
    license = licenses.mit;
    homepage = "http://minisat.se/";
  };
}
