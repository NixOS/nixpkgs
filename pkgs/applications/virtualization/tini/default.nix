{ stdenv, fetchFromGitHub, cmake, glibc }:

stdenv.mkDerivation rec {
  version = "0.13.1";
  name = "tini-${version}";
  src = fetchFromGitHub {
    owner = "krallin";
    repo = "tini";
    rev = "v${version}";
    sha256 ="1g4n8v5d197zcb41fcpbhip2x342383zw1d2zkv57w73vkqgv6z6";
  };
  patchPhase = "sed -i /tini-static/d CMakeLists.txt";
  NIX_CFLAGS_COMPILE = [
    "-DPR_SET_CHILD_SUBREAPER=36"
    "-DPR_GET_CHILD_SUBREAPER=37"
  ];
  buildInputs = [ cmake glibc glibc.static ];
  meta = with stdenv.lib; {
    description = "A tiny but valid init for containers";
    homepage = https://github.com/krallin/tini;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
