{ stdenv, lib, fetchurl, cmake, extra-cmake-modules, threadweaver, ktexteditor, kdevelop-unwrapped, kdevelop-pg-qt }:

stdenv.mkDerivation rec {
  pname = "kdev-php";
  version = "5.4.2";

  src = fetchurl {
    url = "https://github.com/KDE/${pname}/archive/v${version}.tar.gz";
    sha256 = "1ilazq2y671wifcrh7pa0zf9yqymqxwj1m2kd389ik2p6wm68jx8";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ kdevelop-pg-qt threadweaver ktexteditor kdevelop-unwrapped ];

  meta = with lib; {
    maintainers = [ maintainers.aanderse ];
    platforms = platforms.linux;
    description = "PHP support for KDevelop";
    homepage = "https://www.kdevelop.org";
    license = [ licenses.gpl2 ];
  };
}
