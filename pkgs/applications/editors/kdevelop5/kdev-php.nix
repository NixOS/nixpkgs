{ stdenv, lib, fetchurl, cmake, extra-cmake-modules, threadweaver, ktexteditor, kdevelop-unwrapped, kdevelop-pg-qt }:

let
  pname = "kdev-php";
  version = "5.3.1";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/KDE/${pname}/archive/v${version}.tar.gz";
    sha256 = "1xiz4v6w30dsa7l4nk3jw3hxpkx71b0yaaj2k8s7xzgjif824bgl";
  };

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
  ];

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
