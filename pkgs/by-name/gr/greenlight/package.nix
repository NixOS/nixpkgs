{ lib, 
appimageTools,
fetchurl,
pname ? "greenlight",
version ? "2.4.1",
src-appimage ? fetchurl { url = "https://github.com/unknownskl/greenlight/releases/download/v${version}/Greenlight-${version}.AppImage"; hash = "sha256-CYf0BCkQB4ms9bj9fPgEgdjHA/JvKaCxgC6wb7/bc1c=";}, }:
let
  src = src-appimage;
  appimageContents = appimageTools.extractType1 { inherit pname src version; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    # 1. Create the target directories in your package output
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp ${appimageContents}/greenlight-desktop.desktop $out/share/applications/${pname}.desktop
    cp ${appimageContents}/usr/share/icons/hicolor/512x512/apps/greenlight-desktop.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}' \
      --replace-fail 'Icon=greenlight-desktop' 'Icon=${pname}'
  '';
  meta = {
    description = "Viewer for electronic invoices";
    homepage = "https://github.com/unknownskl/greenlight";
    downloadPage = "https://github.com/unknownskl/greenlight/releases";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ foxtrottt ];
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}

