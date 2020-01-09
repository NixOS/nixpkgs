{ stdenv, fetchFromGitHub, cmake, glibc }:

stdenv.mkDerivation rec {
  version = "0.18.0";
  pname = "tini";

  src = fetchFromGitHub {
    owner = "krallin";
    repo = "tini";
    rev = "v${version}";
    sha256 ="1h20i3wwlbd8x4jr2gz68hgklh0lb0jj7y5xk1wvr8y58fip1rdn";
  };

  patchPhase = "sed -i /tini-static/d CMakeLists.txt";

  NIX_CFLAGS_COMPILE = "-DPR_SET_CHILD_SUBREAPER=36 -DPR_GET_CHILD_SUBREAPER=37";

  buildInputs = [ cmake glibc glibc.static ];

  meta = with stdenv.lib; {
    description = "A tiny but valid init for containers";
    homepage = https://github.com/krallin/tini;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
