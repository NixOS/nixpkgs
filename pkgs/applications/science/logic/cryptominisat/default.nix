{ stdenv, fetchFromGitHub, fetchpatch, cmake, python3, xxd, boost }:

stdenv.mkDerivation rec {
  name = "cryptominisat-${version}";
  version = "5.6.6";

  src = fetchFromGitHub {
    owner  = "msoos";
    repo   = "cryptominisat";
    rev    = version;
    sha256 = "1a1494gj4j73yij0hjbzsn2hglk9zy5c5wfwgig3j67cis28saf5";
  };

  buildInputs = [ python3 boost ];
  nativeBuildInputs = [ cmake xxd ];

  meta = with stdenv.lib; {
    description = "An advanced SAT Solver";
    homepage    = https://github.com/msoos/cryptominisat;
    license     = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms   = platforms.unix;
  };
}
