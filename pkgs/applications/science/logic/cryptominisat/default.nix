{ lib, stdenv, fetchFromGitHub, cmake, python3, xxd, boost, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "cryptominisat";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner  = "msoos";
    repo   = "cryptominisat";
    rev    = version;
    sha256 = "00hmxdlyhn7pwk9jlvc5g0l5z5xqfchjzf5jgn3pkj9xhl8yqq50";
  };

  patches = [
    (fetchpatch {
      # https://github.com/msoos/cryptominisat/pull/621
      url = "https://github.com/msoos/cryptominisat/commit/11a97003b0bfbfb61ed6c4e640212110d390c28c.patch";
      sha256 = "0hdy345bwcbxz0jl1jdxfa6mmfh77s2pz9rnncsr0jzk11b3j0cw";
    })
  ];

  buildInputs = [ python3 boost ];
  nativeBuildInputs = [ cmake xxd ];

  meta = with lib; {
    description = "An advanced SAT Solver";
    homepage    = "https://github.com/msoos/cryptominisat";
    license     = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms   = platforms.unix;
  };
}
