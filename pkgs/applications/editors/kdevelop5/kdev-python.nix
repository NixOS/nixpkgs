{ stdenv, lib, fetchurl, cmake, extra-cmake-modules, threadweaver, ktexteditor, kdevelop-unwrapped, python }:

stdenv.mkDerivation rec {
  pname = "kdev-python";
  version = "5.6.1";

  src = fetchurl {
    url = "https://github.com/KDE/${pname}/archive/v${version}.tar.gz";
    sha256 = "1jma7j70imzxlyz8580m79jycif7zphga3zzfmqimn8syzz917hv";
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
