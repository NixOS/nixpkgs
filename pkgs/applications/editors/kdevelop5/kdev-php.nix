{ stdenv, lib, fetchFromGitHub, cmake, extra-cmake-modules, threadweaver, ktexteditor, kdevelop-unwrapped, kdevelop-pg-qt }:

stdenv.mkDerivation rec {
  pname = "kdev-php";
  version = "5.6.2";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "kdev-php";
    rev = "v${version}";
    sha256 = "sha256-hEumH7M6yAuH+jPShOmbKjHmuPRg2djaVy9Xt28eK38=";
  };

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
