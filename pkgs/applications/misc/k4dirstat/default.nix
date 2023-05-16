{ mkDerivation
, extra-cmake-modules
, fetchFromGitHub
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
<<<<<<< HEAD
  version = "3.4.3";
=======
  version = "3.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jeromerobert";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-TXMUtiPS7qRLm6cCy2ZntYrcNJ0fn6X+3o3P5u7oo08=";
=======
    hash = "sha256-nedtCa3h62pAmJYGIYp9jkNYiqe9WevVjwNAqVaaFuc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
