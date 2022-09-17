{ mkDerivation
, extra-cmake-modules
, fetchFromGitHub
, kdoctools
, kiconthemes
, kio
, kjobwidgets
, kxmlgui
, lib
, testers
, k4dirstat
}:

mkDerivation rec {
  pname = "k4dirstat";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "jeromerobert";
    repo = pname;
    rev = version;
    hash = "sha256-nedtCa3h62pAmJYGIYp9jkNYiqe9WevVjwNAqVaaFuc=";
  };

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kiconthemes kio kjobwidgets kxmlgui ];

  passthru.tests.version =
    testers.testVersion {
      package = k4dirstat;
      command = "k4dirstat -platform offscreen --version &>/dev/stdout";
    };

  meta = with lib; {
    homepage = "https://github.com/jeromerobert/k4dirstat";
    description = "A small utility program that sums up disk usage for directory trees";
    license = licenses.gpl2;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.linux;
  };
}
