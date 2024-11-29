{ mkDerivation, lib, fetchFromGitHub, qtbase, qtserialport, qmake }:

mkDerivation rec {
  pname = "candle";
  version = "1.1";

  src = fetchFromGitHub {
    owner  = "Denvi";
    repo   = "Candle";
    rev    = "v${version}";
    sha256 = "1gpx08gdz8awbsj6lsczwgffp19z3q0r2fvm72a73qd9az29pmm0";
  };

  nativeBuildInputs = [ qmake ];

  sourceRoot = "${src.name}/src";

  installPhase = ''
    runHook preInstall
    install -Dm755 Candle $out/bin/candle
    runHook postInstall
  '';

  buildInputs = [ qtbase qtserialport ];

  meta = with lib; {
    description = "GRBL controller application with G-Code visualizer written in Qt";
    mainProgram = "candle";
    homepage = "https://github.com/Denvi/Candle";
    license = licenses.gpl3;
    maintainers = with maintainers; [ matti-kariluoma ];
  };
}
