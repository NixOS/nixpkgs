{ mkDerivation
, extra-cmake-modules
, fetchFromGitHub
, kdoctools
, kiconthemes
, kio
, kjobwidgets
, kxmlgui
, lib
, testVersion
, k4dirstat
}:

mkDerivation rec {
  pname = "k4dirstat";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "jeromerobert";
    repo = pname;
    rev = version;
    hash = "sha256-KLvWSDv4x0tMhAPqp8yNQed2i7R0MPbvadHddSJ1Nx4=";
  };

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kiconthemes kio kjobwidgets kxmlgui ];

  passthru.tests.version =
    testVersion {
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
