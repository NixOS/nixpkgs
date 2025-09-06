{
  stdenv,
  lib,
  fetchFromGitHub,
  qt5,
}:

stdenv.mkDerivation rec {
  pname = "candle";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "Denvi";
    repo = "Candle";
    rev = "v${version}";
    sha256 = "sha256-A53rHlabcuw/nWS7jsCyVrP3CUkmUI/UMRqpogyFOCM=";
  };

  nativeBuildInputs = [ qt5.qmake ];

  sourceRoot = "${src.name}/src";

  installPhase = ''
    runHook preInstall
    install -Dm755 Candle $out/bin/candle
    runHook postInstall
  '';

  buildInputs = [
    qt5.qtbase
    qt5.qtserialport
    qt5.wrapQtAppsHook
  ];

  meta = with lib; {
    description = "GRBL controller application with G-Code visualizer written in Qt";
    mainProgram = "candle";
    homepage = "https://github.com/Denvi/Candle";
    license = licenses.gpl3;
    maintainers = with maintainers; [ matti-kariluoma ];
  };
}
