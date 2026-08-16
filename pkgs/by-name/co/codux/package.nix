{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "codux";
  version = "15.42.0";

  src = fetchurl {
    url = "https://github.com/wixplosives/codux-versions/releases/download/${finalAttrs.version}/Codux-${finalAttrs.version}.x86_64.AppImage";
    hash = "sha256-rD0yXZAEUcPtxWlWuZD77gjw6JlcUvBsaDYGj+NgLss=";
  };

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/codux.desktop -t $out/share/applications
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
    substituteInPlace $out/share/applications/codux.desktop  --replace 'Exec=AppRun' 'Exec=codux'
  '';

  meta = {
    description = "Visual IDE for React";
    homepage = "https://www.codux.com";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      kashw2
    ];
    mainProgram = "codux";
  };
})
