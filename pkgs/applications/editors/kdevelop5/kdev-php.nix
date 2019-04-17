{ stdenv, lib, fetchurl, cmake, extra-cmake-modules, threadweaver, ktexteditor, kdevelop-unwrapped, kdevelop-pg-qt }:

let
  pname = "kdev-php";
  version = "5.3.2";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/KDE/${pname}/archive/v${version}.tar.gz";
    sha256 = "0yjn7y7al2xs8g0mrjvcym8gbjy4wmiv7lsljcrasjd7ymag1wgs";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ kdevelop-pg-qt threadweaver ktexteditor kdevelop-unwrapped ];

  meta = with lib; {
    maintainers = [ maintainers.aanderse ];
    platforms = platforms.linux;
    description = "PHP support for KDevelop";
    homepage = https://www.kdevelop.org;
    license = [ licenses.gpl2 ];
  };
}
