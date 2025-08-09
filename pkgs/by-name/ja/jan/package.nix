{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "Jan";
  version = "0.6.5";
  src = fetchurl {
    url = "https://github.com/janhq/jan/releases/download/v${version}/Jan_${version}_amd64.AppImage";
    hash = "sha256-0JRaefi8mUGoy63BbPa2C8EE/7/TGSsP1VmmWh7Lsko=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/Jan.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    changelog = "https://github.com/janhq/jan/releases/tag/v${version}";
    description = "Jan is an open source alternative to ChatGPT that runs 100% offline on your computer";
    homepage = "https://github.com/janhq/jan";
    license = lib.licenses.agpl3Plus;
    mainProgram = "jan";
    maintainers = [ ];
    platforms = with lib.systems.inspect; patternLogicalAnd patterns.isLinux patterns.isx86_64;
  };
}
