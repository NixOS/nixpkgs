{
  lib,
  stdenv,
  fetchurl,
  p7zip,
  nss,
  nspr,
  libusb1,
  qtbase,
  qtmultimedia,
  qtserialport,
  cups,
  autoPatchelfHook,
  libgpg-error,
  e2fsprogs,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation rec {
  pname = "lightburn";
  version = "1.7.04";

  src = fetchurl {
    url = "https://release.lightburnsoftware.com/LightBurn/Release/LightBurn-v${version}/LightBurn-Linux64-v${version}.7z";
    hash = "sha256-zO6lQTlBARHmYIdq/xHwFg+6FLbkAIAWAG30Tpw8Z4c=";
  };

  nativeBuildInputs = [
    p7zip
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    nss
    nspr
    libusb1
    qtbase
    qtmultimedia
    qtserialport
    cups
    libgpg-error
    e2fsprogs
  ];

  unpackPhase = ''
    7z x $src
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "lightburn";
      exec = "lightburn";
      icon = "lightburn";
      genericName = "LightBurn";
      desktopName = "LightBurn";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/app
    cp -ar LightBurn $out/app/lightburn
    ln -s $out/app/lightburn/AppRun $out/bin/lightburn
    install -Dm644 $out/app/lightburn/LightBurn.png $out/share/pixmaps/lightburn.png

    runHook postInstall
  '';

  dontWrapQtApps = true;

  meta = {
    description = "Layout, editing, and control software for your laser cutter";
    homepage = "https://lightburnsoftware.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ q3k ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "lightburn";
  };
}
