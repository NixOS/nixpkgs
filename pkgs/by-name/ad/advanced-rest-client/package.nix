{ lib, appimageTools, makeDesktopItem, fetchurl }:
let
  pname = "advanced-rest-client";
  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = pname;
    comment = "An API consumption tool for developers";
    exec = pname;
  };
in
appimageTools.wrapType2 rec {
  inherit pname;
  version = "17.0.9";

  src = fetchurl {
    url = "https://github.com/advanced-rest-client/arc-electron/releases/download/v${version}/arc-linux-${version}-x86_64.AppImage";
    hash = "sha256-BGHrhv+tfuczlkpSfBuF4GFURU9lVjHXvvXqWxEVd9U=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  extraInstallCommands = ''
    mkdir -p $out/share
    cp -rt $out/share ${desktopItem}/share/applications
    chmod -R +w $out/share
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "Advanced REST Client - Desktop application";
    homepage = "https://www.advancedrestclient.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kashw2 ];
    platforms = lib.platforms.linux;
  };
}
