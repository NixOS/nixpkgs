{
  lib,
  stdenv,
  fetchurl,
  wrapGAppsHook3,
  autoPatchelfHook,
  webkitgtk_4_1,
  gtk3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "arduino-app-lab";
  version = "0.1.23";
  src = fetchurl {
    url = "https://downloads.arduino.cc/app-lab-release/ArduinoAppLab_${finalAttrs.version}_Linux_x86-64.tar.gz";
    hash = "sha256-0Sw/xdC/sh2iXsOJrvfVuTMFMM7FCnH8qF4GuuNk0Uk=";
  };
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
  ];
  buildInputs = [
    webkitgtk_4_1
    gtk3
  ];

  installPhase = ''
    runHook preInstall

    install -D ./arduino-app-lab $out/bin/arduino-app-lab

    runHook postInstall
  '';

  meta = {
    description = "A powerful visual environment for managing your UNO Q board";
    longDescription = ''
      Combine prebuilt modules, called Bricks, with AI models to define your board’s behavior with ease.
      App Lab supports both classic C++ sketches via the Arduino IDE and Python,
      giving you full flexibility to develop the way you prefer.
    '';
    mainProgram = "arduino-app-lab";
    homepage = "https://www.arduino.cc/en/software/#app-lab-section";
    downloadPage = "https://www.arduino.cc/en/software/#app-lab-section";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    platforms = [ "x86_64-linux" ];
  };
})
