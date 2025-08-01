{
  appimageTools,
  lib,
  fetchurl,
}:
let
  pname = "everdo";
  version = "1.9.0";

  src = fetchurl {
    url = "https://release.everdo.net/${version}/Everdo-${version}.AppImage";
    hash = "sha256-0yxAzM+qmgm4E726QDYS9QwMdp6dUcuvjZzWYEZx7kU=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/everdo.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/everdo.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=everdo %u'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Cross-platform GTD app with focus on privacy";
    homepage = "https://everdo.net/";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.luftmensch-luftmensch ];
    mainProgram = "everdo";
    platforms = [ "x86_64-linux" ];
  };
}
