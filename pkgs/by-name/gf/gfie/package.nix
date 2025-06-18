{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  qt5,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gfie";
  version = "4.2";

  src = fetchurl {
    url = "http://greenfishsoftware.org/dl/gfie/gfie-${finalAttrs.version}.deb";
    hash = "sha256-hyL0t66jRTVF1Hq2FRUobsfjLGmYgsMGDE/DBdoXhCI=";
  };

  unpackCmd = "dpkg -x $curSrc source";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    qt5.wrapQtAppsHook
  ];

  buildInputs = with qt5; [
    qtbase
    qtsvg
    qtwebengine
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv usr/share opt $out
    ln -s $out/opt/gfie-${finalAttrs.version}/gfie $out/bin/gfie

    runHook postInstall
  '';

  meta = {
    description = "Powerful open source image editor, especially suitable for creating icons, cursors, animations and icon libraries";
    homepage = "https://greenfishsoftware.org/gfie.php";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "gfie";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
