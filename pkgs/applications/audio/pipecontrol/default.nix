{
  lib,
  stdenv,
  fetchFromGitHub,
  pipewire,
  cmake,
  extra-cmake-modules,
  wrapQtAppsHook,
  qtbase,
  qttools,
  kirigami2,
  kcoreaddons,
  ki18n,
  qtquickcontrols2,
}:

stdenv.mkDerivation rec {
  pname = "pipecontrol";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "portaloffreedom";
    repo = "pipecontrol";
    rev = "v${version}";
    sha256 = "sha256-WvQFmoEaxnkI61wPldSnMAoPAxNtI399hdHb/9bkPqc=";
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
    mainProgram = "pipecontrol";
    homepage = "https://github.com/portaloffreedom/pipecontrol";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tilcreator ];
  };
}
