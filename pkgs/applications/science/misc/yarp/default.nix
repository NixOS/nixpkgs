{ stdenv, fetchFromGitHub, pkgconfig, cmake, ace
}:

stdenv.mkDerivation rec {
  name = "yarp-${version}";
  version = "2.3.64";
  src = fetchFromGitHub {
    owner = "robotology";
    repo = "yarp";
    rev = "v2.3.64";
    sha256 = "0x9sdc8d6rppzf1kx53w0yjlnmz7h75qv62yd3ls09w3cy7nb5x7";
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

