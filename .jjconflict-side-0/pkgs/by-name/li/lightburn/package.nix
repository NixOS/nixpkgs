{
  lib,
  stdenv,
  fetchurl,
  p7zip,
  nss,
  nspr,
  libusb1,
  cups,
  autoPatchelfHook,
  libgpg-error,
  e2fsprogs,
  makeDesktopItem,
  copyDesktopItems,
  xorg,
  libGL,
  alsa-lib,
  freetype,
  fontconfig,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "lightburn";
  version = "1.7.08";

  src = fetchurl {
    url = "https://release.lightburnsoftware.com/LightBurn/Release/LightBurn-v${version}/LightBurn-Linux64-v${version}.7z";
    hash = "sha256-dG/A39/SapyS6GGSKCsHUvYN+CONul/s55HTi9Cc59g=";
  };

  nativeBuildInputs = [
    p7zip
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    nss
    nspr
    libusb1
    cups
    libgpg-error
    e2fsprogs
    xorg.libX11
    xorg.libxcb
    libGL
    alsa-lib
    freetype
    fontconfig
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

    mkdir -p $out/opt
    cp -ar LightBurn $out/opt/lightburn
    install -Dm644 $out/opt/lightburn/LightBurn.png $out/share/pixmaps/lightburn.png

    runHook postInstall
  '';

  postFixup = ''
    mkdir $out/bin
    makeWrapper $out/opt/lightburn/AppRun $out/bin/lightburn \
      --unset QT_PLUGIN_PATH \
      --unset QML2_IMPORT_PATH
  '';

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
