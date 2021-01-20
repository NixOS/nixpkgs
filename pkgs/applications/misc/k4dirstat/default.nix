{ mkDerivation
, extra-cmake-modules
, fetchFromGitHub
, kdoctools
, kiconthemes
, kio
, kjobwidgets
, kxmlgui
, lib, stdenv
}:

mkDerivation rec {
  pname = "k4dirstat";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "jeromerobert";
    repo = pname;
    rev = version;
    sha256 = "sha256-U5p/gW5GPxRoM9XknP8G7iVhLDoqmvgspeRsmCRdxDg=";
  };

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kiconthemes kio kjobwidgets kxmlgui ];

  meta = with lib; {
    homepage = "https://github.com/jeromerobert/k4dirstat";
    description = "A small utility program that sums up disk usage for directory trees";
    license = licenses.gpl2;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.linux;
  };
}
