{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
}:

let
  version = "3.4.1";
  pname = "hyper";

  src = fetchurl {
    url = "https://github.com/vercel/hyper/releases/download/v${version}/Hyper-${version}.AppImage";
    hash = "sha256-UFC+Zn/lbWhx7W+Gs7A6AjsrdaqRMpqCwvFf9+1mtjw=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/hyper.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'

    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/hyper.png \
      $out/share/icons/hicolor/1024x1024/apps/${pname}.png
  '';

  meta = with lib; {
    description = "A terminal built on web technologies";
    homepage = "https://hyper.is";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "hyper";
  };
}
