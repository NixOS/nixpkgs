{ stdenv, fetchFromGitHub, cmake, glibc }:

stdenv.mkDerivation rec {
  version = "0.16.1";
  name = "tini-${version}";

  src = fetchFromGitHub {
    owner = "krallin";
    repo = "tini";
    rev = "v${version}";
    sha256 ="1abvjwjk7xhsbx60niy4ykcj3xvrxcl6zx8z1v827jsn47wzpikp";
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
