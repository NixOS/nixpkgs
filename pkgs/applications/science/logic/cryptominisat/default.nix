{ stdenv, fetchFromGitHub, cmake, python3, xxd, boost }:

stdenv.mkDerivation rec {
  pname = "cryptominisat";
  version = "5.6.8";

  src = fetchFromGitHub {
    owner  = "msoos";
    repo   = "cryptominisat";
    rev    = version;
    sha256 = "0csimmy1nvkfcsxjra9bm4mlcyxa3ac8zarm88zfb7640ca0d0wv";
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
