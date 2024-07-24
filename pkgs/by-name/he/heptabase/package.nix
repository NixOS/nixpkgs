{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "heptabase";
  version = "1.34.2";
  src = fetchurl {
    url = "https://github.com/heptameta/project-meta/releases/download/v${version}/Heptabase-${version}.AppImage";
    hash = "sha256-0wPtAvBuc8J+XJqZXDzV+RL/37NPZjKcs3do1jQkE14=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/project-meta.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    changelog = "https://github.com/heptameta/project-meta/releases/tag/v${version}";
    description = "A visual note-taking tool for learning complex topics";
    homepage = "https://heptabase.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "heptabase";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
