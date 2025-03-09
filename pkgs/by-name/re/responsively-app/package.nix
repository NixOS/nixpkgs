{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 rec {
  pname = "responsively-app";
  version = "1.15.0";

  src = fetchurl {
    url = "https://github.com/responsively-org/responsively-app-releases/releases/download/v${version}/ResponsivelyApp-${version}.AppImage";
    hash = "sha256-BkljY8Il45A2JbsLgQbjsxCy0lnFZvtpc5HzvI1nwWk=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/responsivelyapp.desktop $out/share/applications/responsivelyapp.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/responsivelyapp.png \
      $out/share/icons/hicolor/512x512/apps/responsivelyapp.png
    substituteInPlace $out/share/applications/responsivelyapp.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "Modified web browser that helps in responsive web development";
    mainProgram = "responsively-desktop";
    homepage = "https://responsively.app/";
    changelog = "https://github.com/responsively-org/responsively-app/releases/tag/v${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ kashw2 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
