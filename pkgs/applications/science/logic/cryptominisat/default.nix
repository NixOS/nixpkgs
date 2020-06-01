{ stdenv, fetchFromGitHub, cmake, python3, xxd, boost }:

stdenv.mkDerivation rec {
  pname = "cryptominisat";
  version = "5.7.1";

  src = fetchFromGitHub {
    owner  = "msoos";
    repo   = "cryptominisat";
    rev    = version;
    sha256 = "16lydnbd4rxfyabvvw7l4hbbby3yprcqqzrydd3n8rjbxibi4xyf";
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
