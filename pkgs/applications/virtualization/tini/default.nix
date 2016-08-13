{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  version = "0.8.3";
  name = "tini-${version}";
  src = fetchurl {
    url = "https://github.com/krallin/tini/archive/v0.8.3.tar.gz";
    sha256 ="1w7rj4crrcyv25idmh4asbp2sxzwyihy5mbpw384bzxjzaxn9xpa";
  };
  patchPhase = "sed -i /tini-static/d CMakeLists.txt";
  NIX_CFLAGS_COMPILE = [
    "-DPR_SET_CHILD_SUBREAPER=36"
    "-DPR_GET_CHILD_SUBREAPER=37"
  ];
  buildInputs = [ cmake ];
  meta = with stdenv.lib; {
    description = "A tiny but valid init for containers";
    homepage = https://github.com/krallin/tini;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
