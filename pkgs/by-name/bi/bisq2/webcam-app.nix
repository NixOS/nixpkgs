# bisq2 contains a separate Java app which is used to scan Bitcoin Lightning QR codes.
# bisq2 communicates with the webcam app via a local TCP connection using a simple one-way protocol.
# Since the webcam app dynamically loads native code, this package is for maintainers to test QR code scanning without having to spend bitcoin to execute a trade.
# This package is exposed as an attribute of the bisq2 package; bisq2.webcam-app.
{
  stdenv,
  lib,
  makeBinaryWrapper,
  jdk,
  writeShellScript,
  unzip,
  bisq2,
  socat,
  libraryPath,
}:

let
  version = "1.0.0";

  launcher = writeShellScript "bisq2-webcam-app-launcher" ''
    ${socat}/bin/socat TCP-LISTEN:8000,keepalive,fork STDIO &
    socat_pid=$!
    LD_LIBRARY_PATH=${libraryPath} "${lib.getExe jdk}" -classpath @out@/lib/app/webcam-app-${version}-all.jar:${bisq2}/lib/app/* bisq.webcam.WebcamAppLauncher "$@"
    kill $socat_pid
  '';
in
stdenv.mkDerivation rec {
  inherit version;

  pname = "bisq2-webcam-app";
  src = bisq2;
  dontUnpack = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    unzip
  ];

  buildPhase = ''
    # Extract the webcam app from Bisq2.

    unzip ${bisq2}/lib/app/desktop.jar 'webcam-app/*'
    unzip webcam-app/webcam-app-1.0.0.zip
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/app $out/bin
    cp webcam-app-${version}-all.jar $out/lib/app/
    install -D -m 777 ${launcher} $out/bin/bisq2-webcam-app
    substituteAllInPlace $out/bin/bisq2-webcam-app

    runHook postInstall
  '';
}
