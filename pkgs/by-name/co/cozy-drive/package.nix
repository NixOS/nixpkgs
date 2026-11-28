{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "cozydrive";
  version = "3.42.0";
  src = fetchurl {
    url = "https://github.com/cozy-labs/cozy-desktop/releases/download/v${finalAttrs.version}/Cozy-Drive-${finalAttrs.version}-x86_64.AppImage";
    sha256 = "sha256-1MsRxLp+IZAoj9yqo5n0N1kfRYmYR2tjIjnlbRPrKH4=";
  };

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/cozydrive.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/cozydrive.desktop \
      --replace 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Cozy Drive is a synchronization tool for your files and folders with Cozy Cloud";
    homepage = "https://cozy.io";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ simarra ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "cozydrive";
  };
})
