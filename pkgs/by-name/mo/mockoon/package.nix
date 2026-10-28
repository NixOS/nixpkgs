{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "mockoon";
  version = "9.6.1";
  src = fetchurl {
    url = "https://github.com/mockoon/mockoon/releases/download/v${finalAttrs.version}/mockoon-${finalAttrs.version}.x86_64.AppImage";
    hash = "sha256-Y6DmoWGvNp0cvRYgDDMHul5K6CzhiWxMxVTR+W9PE5E=";
  };

  extraInstallCommands = ''
    install -Dm 444 ${finalAttrs.contents}/${finalAttrs.pname}.desktop -t $out/share/applications
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
  '';

  meta = {
    description = "Easiest and quickest way to run mock APIs locally";
    longDescription = ''
      Mockoon is the easiest and quickest way to run mock APIs locally.
      No remote deployment, no account required, free and open-source.
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    homepage = "https://mockoon.com";
    changelog = "https://github.com/mockoon/mockoon/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mockoon";
    platforms = [ "x86_64-linux" ];
  };
})
