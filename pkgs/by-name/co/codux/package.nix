{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "codux";
  version = "15.42.0";

  src = fetchurl {
    url = "https://github.com/wixplosives/codux-versions/releases/download/${version}/Codux-${version}.x86_64.AppImage";
    hash = "sha256-rD0yXZAEUcPtxWlWuZD77gjw6JlcUvBsaDYGj+NgLss=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in

appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/codux.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
    substituteInPlace $out/share/applications/codux.desktop  --replace 'Exec=AppRun' 'Exec=codux'
  '';

  meta = {
    description = "Visual IDE for React";
    homepage = "https://www.codux.com";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      dit7ya
      kashw2
    ];
    mainProgram = "codux";
  };
}
