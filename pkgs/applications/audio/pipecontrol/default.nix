{ lib
, stdenv
, fetchFromGitHub
, pipewire
, cmake
, extra-cmake-modules
, gnumake
, wrapQtAppsHook
, qtbase
, qttools
, kirigami2
, kcoreaddons
, ki18n
, qtquickcontrols2
}:

stdenv.mkDerivation rec {
  pname = "pipecontrol";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "portaloffreedom";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F3faJMkvjAY6A5ieNpAxjk6BHPb6uCvYYfwrI9/Iskg=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
    qttools
  ];

  buildInputs = [
    pipewire
    qtbase
    kirigami2
    kcoreaddons
    ki18n
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Pipewire control GUI program in Qt (Kirigami2)";
    homepage = "https://github.com/portaloffreedom/pipecontrol";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tilcreator ];
  };
}
