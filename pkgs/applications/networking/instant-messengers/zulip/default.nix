{ lib
, fetchurl
, appimageTools
}:

let
  pname = "zulip";
  version = "5.9.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/zulip/zulip-desktop/releases/download/v${version}/Zulip-${version}-x86_64.AppImage";
    hash = "sha256-Hws9vENGzCLQqav4uXtbbI0iNoS3JozC5m2DG38+3Fk=";
    name="${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
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
