{
  stdenv,
  lib,
  fetchFromGitea,
  qmake,
  qttools,
  qtbase,
  qtserialport,
  qtconnectivity,
  qtcharts,
  wrapQtAppsHook,
  fetchpatch,
  udev,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ubpm";
  version = "1.12.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "LazyT";
    repo = "ubpm";
    rev = finalAttrs.version;
    hash = "sha256-XymrRkN7dBc0174D3wigRj682kI4SQNy+d7TCuGcRbE=";
  };

  preConfigure = ''
    cd ./sources/
  '';

  postFixup = ''
    wrapQtApp $out/bin/ubpm
  '';

  nativeBuildInputs = [
    qmake
    qttools
    wrapQtAppsHook
    pkg-config
  ];

  # *.so plugins are being wrapped automatically which breaks them
  dontWrapQtApps = true;

  buildInputs = [
    qtbase
    qtserialport
    qtconnectivity
    qtcharts
    udev
  ];

  meta = with lib; {
    homepage = "https://codeberg.org/LazyT/ubpm";
    description = "Universal Blood Pressure Manager";
    mainProgram = "ubpm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kurnevsky ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
