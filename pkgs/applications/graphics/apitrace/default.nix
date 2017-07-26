{ stdenv, fetchFromGitHub, cmake, libX11, procps, python2, libdwarf, qtbase, qtwebkit }:

stdenv.mkDerivation rec {
  name = "apitrace-${version}";
  version = "7.1-363-ge3509be1";

  src = fetchFromGitHub {
    sha256 = "1xbz6gwl7kqjm7jjy5gxkdxzrg93vj1a3l19ara7rni6dii0q136";
    rev = "e3509be175eda77749abffe051ed0d3eb5d14e72";
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
    maintainers = with maintainers; [ nckx ];
  };
}
