{ lib, stdenv, libGLU, qtbase, fetchurl, dpkg, autoPatchelfHook, wrapQtAppsHook }:

stdenv.mkDerivation (finalAttrs: {
  pname = "flashprint";
  version = "5.8.4";

  src = fetchurl {
    url = "http://www.ishare3d.com/3dapp/public/FlashPrint-5/FlashPrint/flashprint5_${finalAttrs.version}_amd64.deb";
    hash = "sha256-Gr76yG3Qz7bnbm5YerHbpb+yzqhw1LthUb4qIH03VQw=";
  };

  nativeBuildInputs = [ dpkg autoPatchelfHook wrapQtAppsHook ];

  buildInputs = [ qtbase libGLU ];

  qtWrapperArgs = [ "--prefix QT_QPA_PLATFORM : xcb" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv etc usr/* $out
    ln -s $out/share/FlashPrint5/FlashPrint $out/bin/flashprint
    sed -i "/^Exec=/ c Exec=$out/bin/flashprint" $out/share/applications/FlashPrint5.desktop

    runHook postInstall
  '';

  meta = with lib; {
    description = "Slicer for the FlashForge 3D printers";
    homepage = "https://www.flashforge.com/";
    license = licenses.unfree;
    mainProgram = "flashprint";
    maintainers = [ maintainers.ianliu ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
})
