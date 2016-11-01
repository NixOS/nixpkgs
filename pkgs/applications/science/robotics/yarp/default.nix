{ stdenv, fetchFromGitHub, pkgconfig, cmake, ace
}:

stdenv.mkDerivation rec {
  name = "yarp-${version}";
  version = "2.3.66";
  src = fetchFromGitHub {
    owner = "robotology";
    repo = "yarp";
    rev = "v${version}.1";
    sha256 = "0hznysxhk6pd92fymcrnbbl8ah7rcwhcvb6n92v09zjv6yl5xpiq";
  };

  buildInputs = [ cmake ace ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DYARP_COMPILE_UNMAINTAINED:BOOL=ON"
    "-DCREATE_YARPC:BOOL=ON"
    "-DCREATE_YARPCXX:BOOL=ON"
  ];

  # since we cant expand $out in cmakeFlags
  preConfigure = ''cmakeFlags="$cmakeFlags -DCMAKE_INSTALL_LIBDIR=$out/lib"'';

  postInstall = "mv ./$out/lib/*.so $out/lib/";

  meta = {
    description = "Yet Another Robot Platform";
    homepage = http://yarp.it;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}

