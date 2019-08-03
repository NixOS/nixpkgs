{ stdenv, fetchFromGitHub, cmake, libX11, procps, python2, libdwarf, qtbase, qtwebkit }:

stdenv.mkDerivation rec {
  name = "apitrace-${version}";
  version = "7.1-572-g${builtins.substring 0 8 src.rev}";

  src = fetchFromGitHub {
    sha256 = "11bwb0l8cr1bf9bj1s6cbmi77d5fy4qrphj9cgmcd8jpa862anp5";
    rev = "26966134f15d28f6b4a9a0a560017b3ba36d60bf";
    repo = "apitrace";
    owner = "apitrace";
  };

  # LD_PRELOAD wrappers need to be statically linked to work against all kinds
  # of games -- so it's fine to use e.g. bundled snappy.
  buildInputs = [ libX11 procps python2 libdwarf qtbase qtwebkit ];

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://apitrace.github.io;
    description = "Tools to trace OpenGL, OpenGL ES, Direct3D, and DirectDraw APIs";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
