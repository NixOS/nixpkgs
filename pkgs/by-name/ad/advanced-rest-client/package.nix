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

  extraInstallCommands = ''
    mkdir -p $out/share
    cp -rt $out/share ${desktopItem}/share/applications
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    chmod -R +w $out/share
  '';

  meta = with lib; {
    description = "Advanced REST Client - Desktop application";
    homepage = "https://www.advancedrestclient.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ kashw2 ];
    platforms = platforms.linux;
  };
}
