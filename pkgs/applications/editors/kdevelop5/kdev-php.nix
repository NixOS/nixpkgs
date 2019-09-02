{ stdenv, lib, fetchurl, cmake, extra-cmake-modules, threadweaver, ktexteditor, kdevelop-unwrapped, kdevelop-pg-qt }:

stdenv.mkDerivation rec {
  pname = "kdev-php";
  version = "5.4.1";

  src = fetchurl {
    url = "https://github.com/KDE/${pname}/archive/v${version}.tar.gz";
    sha256 = "07j06k2f5rbwgknwcbj70wwn831a54is4kiwlpfd4la2c05slmy5";
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
