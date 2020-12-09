{ stdenv, lib, fetchurl, cmake, extra-cmake-modules, threadweaver, ktexteditor, kdevelop-unwrapped, python }:

stdenv.mkDerivation rec {
  pname = "kdev-python";
  version = "5.6.0";

  src = fetchurl {
    url = "https://github.com/KDE/${pname}/archive/v${version}.tar.gz";
    sha256 = "1bm6jk7gkl4vi579x99mja4znrzzp15zk66ss600dn8aq11jrxv2";
  };

  cmakeFlags = [
    "-DPYTHON_EXECUTABLE=${python}/bin/python"
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ threadweaver ktexteditor kdevelop-unwrapped ];

  meta = with lib; {
    maintainers = [ maintainers.aanderse ];
    platforms = platforms.linux;
    description = "Python support for KDevelop";
    homepage = "https://www.kdevelop.org";
    license = [ licenses.gpl2 ];
  };
}
