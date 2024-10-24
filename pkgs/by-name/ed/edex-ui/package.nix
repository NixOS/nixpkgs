{
  appimageTools,
  fetchurl,
  lib,
}:
appimageTools.wrapType2 rec {
  pname = "edex-ui";
  name = "eDEX-UI";
  version = "2.2.8";
  platform = "Linux-x86_64";
  src = fetchurl {
    url = "https://github.com/GitSquared/edex-ui/releases/download/v${version}/${name}-${platform}.AppImage";
    hash = "sha256-yPKM1yHKAyygwZYLdWyj5k3EQaZDwy6vu3nGc7QC1oE=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/${pname}.png \
    $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
    --replace 'Exec=AppRun' 'Exec=${pname} %U'
  '';

  meta = {
    description = "A cross-platform, customizable science fiction terminal emulator with advanced monitoring & touchscreen support.";
    mainProgram = "edex-ui";
    changelog = "https://github.com/GitSquared/edex-ui/releases/tag${version}";
    homepage = "https://github.com/GitSquared/edex-ui";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ yassinebenarbia ];
  };
}
