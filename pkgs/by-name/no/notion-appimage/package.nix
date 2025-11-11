{
  appimageTools,
  fetchurl,
  lib,
  nix-update-script,
}:
let
  pname = "notion-appimage";
  version = "4.23.0";

  src = fetchurl {
    url = "https://github.com/jcorbalanm/notion-appimage/releases/download/${version}/Notion-${version}-x86_64.AppImage";
    hash = "sha256-IMijh723HBrkGgrfVwzaDp/aPx3qTpG1WJI55ZSashs=";
  };

  passthru.updateScript = nix-update-script { };

in
appimageTools.wrapType2 {
  inherit pname version src;
  meta = {
    mainProgram = "notion-appimage";
    description = "App to write, plan, collaborate, and get organised (AppImage version)";
    homepage = "https://www.notion.so/";
    downloadPage = "https://github.com/jcorbalanm/notion-appimage/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ jcorbalan ];
    platforms = [
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
