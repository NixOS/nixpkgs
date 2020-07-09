{ stdenv, fetchFromGitHub, cmake, python3, xxd, boost }:

stdenv.mkDerivation rec {
  pname = "cryptominisat";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner  = "msoos";
    repo   = "cryptominisat";
    rev    = version;
    sha256 = "00hmxdlyhn7pwk9jlvc5g0l5z5xqfchjzf5jgn3pkj9xhl8yqq50";
  };

  patches = [ ./0001-fix-build-on-Nix-macOS.patch ];

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
