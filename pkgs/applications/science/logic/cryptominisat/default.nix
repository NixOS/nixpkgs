{ stdenv, fetchFromGitHub, fetchpatch, cmake, lit, python, boost, libzip, sqlite, ncurses }:

stdenv.mkDerivation rec {
  name = "cryptominisat-${version}";
  version = "5.6.3";

  src = fetchFromGitHub {
    owner  = "msoos";
    repo   = "cryptominisat";
    rev    = version;
    sha256 = "0902dy2k5qkvav9qc4b4nvz7bynsahb46llms46bnpamb0rqnzc8";
    fetchSubmodules = true;
  };

  buildInputs = [ boost libzip sqlite python ncurses];
  nativeBuildInputs = [ cmake lit ];

  cmakeFlags = [ "-DENABLE_TESTING=ON" ];

  doCheck = true;

  checkPhase = ''
    LD_LIBRARY_PATH=$PWD/lib:$LD_LIBRARY_PATH \
    DYLD_LIBRARY_PATH=$PWD/lib:$DYLD_LIBRARY_PATH \
      make test
  '';

  meta = with stdenv.lib; {
    description = "An advanced SAT Solver";
    homepage    = https://github.com/msoos/cryptominisat;
    license     = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms   = platforms.unix;
  };
}
