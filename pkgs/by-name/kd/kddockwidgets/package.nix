{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  spdlog,
  fmt,
  nlohmann_json,
}:

stdenv.mkDerivation rec {
  pname = "KDDockWidgets";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = "KDDockWidgets";
    rev = "v${version}";
    sha256 = "sha256-NNGIR2MTaNs2zFeN9vmHxoRuss2IR7FQ8F34b00L9z4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    spdlog
    fmt
    nlohmann_json
  ];
  propagatedBuildInputs = with qt6; [
    qtbase
    qtdeclarative
  ];

  cmakeFlags = [ (lib.strings.cmakeBool "KDDockWidgets_QT6" true) ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "KDAB's Dock Widget Framework for Qt";
    homepage = "https://www.kdab.com/development-resources/qt-tools/kddockwidgets";
    license = with licenses; [
      gpl2Only
      gpl3Only
    ];
    maintainers = with maintainers; [
      _1000teslas
      tmarkus
    ];
  };
}
