{ mkDerivation
, extra-cmake-modules
, fetchFromGitHub
, kdoctools
, kiconthemes
, kio
, kjobwidgets
, kxmlgui
, stdenv
}:

mkDerivation rec {
  pname = "k4dirstat";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "jeromerobert";
    repo = pname;
    rev = version;
    sha256 = "15xjb80jq6vhzvzx4l341f40d8a23w1334qh6cczqm9adfnzycp7";
  };

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kiconthemes kio kjobwidgets kxmlgui ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jeromerobert/k4dirstat";
    description = "A small utility program that sums up disk usage for directory trees";
    license = licenses.gpl2;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.linux;
  };
}
