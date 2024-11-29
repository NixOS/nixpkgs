{ mkDerivation, lib, cmake, extra-cmake-modules, threadweaver, ktexteditor, kdevelop-unwrapped, kdevelop-pg-qt }:

mkDerivation rec {
  pname = "kdev-php";

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ kdevelop-pg-qt threadweaver ktexteditor kdevelop-unwrapped ];

  dontWrapQtApps = true;

  meta = with lib; {
    maintainers = [ maintainers.aanderse ];
    platforms = platforms.linux;
    description = "PHP support for KDevelop";
    homepage = "https://www.kdevelop.org";
    license = [ licenses.gpl2 ];
  };
}
