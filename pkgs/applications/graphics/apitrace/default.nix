{ stdenv, fetchFromGitHub, cmake, libX11, procps, python, libdwarf, qtbase, qtwebkit }:

stdenv.mkDerivation rec {
  name = "apitrace-${version}";
  version = "7.1";

  src = fetchFromGitHub {
    sha256 = "1n2gmsjnpyam7isg7n1ksggyh6y1l8drvx0a93bnvbcskr7jiz9a";
    rev = version;
    repo = "apitrace";
    owner = "apitrace";
  };

  # LD_PRELOAD wrappers need to be statically linked to work against all kinds
  # of games -- so it's fine to use e.g. bundled snappy.
  buildInputs = [ libX11 procps python libdwarf qtbase qtwebkit ];

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://apitrace.github.io;
    description = "Tools to trace OpenGL, OpenGL ES, Direct3D, and DirectDraw APIs";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
