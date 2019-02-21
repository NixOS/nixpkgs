{ stdenv, lib, fetchurl, cmake, extra-cmake-modules, threadweaver, ktexteditor, kdevelop-unwrapped, python }:

let
  pname = "kdev-python";
  version = "5.3.1";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/KDE/${pname}/archive/v${version}.tar.gz";
    sha256 = "11hf8n6vrlaz31c0p3xbnf0df2q5j6ykgc9ip0l5g33kadwn5b9j";
  };

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DPYTHON_EXECUTABLE=${python}/bin/python"
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ threadweaver ktexteditor kdevelop-unwrapped ];

  meta = with lib; {
    maintainers = [ maintainers.aanderse ];
    platforms = platforms.linux;
    description = "Python support for KDevelop";
    homepage = https://www.kdevelop.org;
    license = [ licenses.gpl2 ];
  };
}
