{ stdenv, fetchFromGitHub, cmake, python3, xxd, boost }:

stdenv.mkDerivation rec {
  pname = "cryptominisat";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner  = "msoos";
    repo   = "cryptominisat";
    rev    = version;
    sha256 = "0ny5ln8fc0irprs04qw01c9mppps8q27lkx01a549zazwhj4b5rm";
  };

  buildInputs = [ python3 boost ];
  nativeBuildInputs = [ cmake xxd ];

  meta = with stdenv.lib; {
    description = "An advanced SAT Solver";
    homepage    = "https://github.com/msoos/cryptominisat";
    license     = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms   = platforms.unix;
  };
}
