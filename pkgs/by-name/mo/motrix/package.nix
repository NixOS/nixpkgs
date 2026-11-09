{
  lib,
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "motrix";
  version = "1.8.19";
  src = fetchurl {
    url = "https://github.com/agalwood/Motrix/releases/download/v${finalAttrs.version}/Motrix-${finalAttrs.version}.AppImage";
    hash = "sha256-oSO+VH3bZcjnXjECqZgOmsvlOONbfgOq50qVLvHdKfo=";
  };

  extraInstallCommands = ''
    install -Dm 444 ${finalAttrs.contents}/${finalAttrs.pname}.desktop -t $out/share/applications
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
  '';

  meta = {
    description = "Full-featured download manager";
    homepage = "https://motrix.app";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ ];
    mainProgram = "motrix";
  };
})
