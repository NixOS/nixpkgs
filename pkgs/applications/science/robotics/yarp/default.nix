{ stdenv, fetchFromGitHub, pkgconfig, cmake, ace
}:

stdenv.mkDerivation rec {
  name = "yarp-${version}";
  version = "2.3.65";
  src = fetchFromGitHub {
    owner = "robotology";
    repo = "yarp";
    rev = "v${version}";
    sha256 = "003n0z1qrd7l8maa98aa49gsfsyy7w8gb2pprlgj92r0drk8zm02";
  };

  buildInputs = [ cmake ace ];

  enableParallelBuilding = true;

  meta = {
    description = "Yet Another Robot Platform";
    homepage = http://yarp.it;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}

