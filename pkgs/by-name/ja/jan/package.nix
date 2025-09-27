{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "Jan";
  version = "0.6.10";
  src = fetchurl {
    url = "https://github.com/menloresearch/jan/releases/download/v${version}/jan_${version}_amd64.AppImage";
    hash = "sha256-eag8c/Jp2ahV71kEuFoT2rmz0S9RPbiqy5YBO0Z+ICY=";
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
    changelog = "https://github.com/menloresearch/jan/releases/tag/v${version}";
    description = "Jan is an open source alternative to ChatGPT that runs 100% offline on your computer";
    homepage = "https://github.com/menloresearch/jan";
    license = lib.licenses.agpl3Plus;
    mainProgram = "Jan";
    maintainers = [ ];
    platforms = with lib.systems.inspect; patternLogicalAnd patterns.isLinux patterns.isx86_64;
  };
}
