{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ace,
}:

stdenv.mkDerivation rec {
  pname = "yarp";
  version = "2.3.70.2";
  src = fetchFromGitHub {
    owner = "robotology";
    repo = "yarp";
    rev = "v${version}";
    sha256 = "0mphh899niy30xbjjwi9xpsliq8mladfldbbbjfngdrqfhiray1a";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ace ];

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
    homepage = "http://yarp.it";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
