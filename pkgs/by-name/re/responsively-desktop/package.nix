{ lib
, stdenv
, fetchurl
, appimageTools
}:

appimageTools.wrapType2 rec {
  pname = "responsively-desktop";
  version = "1.11.1";

  src = fetchurl {
    url = "https://github.com/responsively-org/responsively-app-releases/releases/download/v${version}/ResponsivelyApp-${version}.AppImage";
    sha256 = "sha256-PM0Cqrz/1AgQmDJdeA1VQCHTiLY7BhtNN1JxxilQNfM=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/responsivelyapp.desktop $out/share/applications/responsivelyapp.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/responsivelyapp.png \
      $out/share/icons/hicolor/512x512/apps/responsivelyapp.png
    substituteInPlace $out/share/applications/responsivelyapp.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "A modified web browser that helps in responsive web development";
    mainProgram = "responsively-desktop";
    homepage = "https://responsively.app/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ kashw2 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
