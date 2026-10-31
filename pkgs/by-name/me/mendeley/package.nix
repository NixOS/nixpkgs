{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "mendeley";
  version = "2.150.0";

  src = fetchurl {
    url = "https://static.mendeley.com/bin/desktop/mendeley-reference-manager-${finalAttrs.version}-x86_64.AppImage";
    hash = "sha256-SSvL2GprttW3goYP6G47qmkZwJL5XF1Vv2kwh362wGg=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/mendeley-reference-manager.desktop $out/share/applications/mendeley-reference-manager.desktop

    install -m 444 -D ${finalAttrs.contents}/mendeley-reference-manager.png $out/share/icons/hicolor/512x512/apps/mendeley-reference-manager.png

    substituteInPlace $out/share/applications/mendeley-reference-manager.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=mendeley'
  '';

  meta = {
    homepage = "https://www.mendeley.com";
    description = "Reference manager and academic social network";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    mainProgram = "mendeley";
  };
})
