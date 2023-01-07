{ lib
, fetchurl
, appimageTools
}:

let
  pname = "zulip";
  version = "5.9.4";

  src = fetchurl {
    url = "https://github.com/zulip/zulip-desktop/releases/download/v${version}/Zulip-${version}-x86_64.AppImage";
    hash = "sha256-gbusyhMgoaQmeWm6dB6pc3kSykD4T97VQcJgcF5KbzM=";
    name="${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv "$out/bin/${pname}-${version}" "$out/bin/${pname}"
    install -m 444 -D ${appimageContents}/zulip.desktop $out/share/applications/zulip.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/zulip.png \
      $out/share/icons/hicolor/512x512/apps/zulip.png
    substituteInPlace $out/share/applications/zulip.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Desktop client for Zulip Chat";
    homepage = "https://zulip.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk jonafato ];
    platforms = [ "x86_64-linux" ];
  };
}
