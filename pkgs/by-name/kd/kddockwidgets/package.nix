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
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = "KDDockWidgets";
    rev = "v${version}";
    sha256 = "sha256-/ioCX/Txqr84uJJYPhVLrZKug6VdWQDVirmsTg42PXs=";
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
