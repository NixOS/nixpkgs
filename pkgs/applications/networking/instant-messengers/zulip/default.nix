{ lib
, fetchurl
, appimageTools
}:

let
  pname = "zulip";
  version = "5.4.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/zulip/zulip-desktop/releases/download/v${version}/Zulip-${version}-x86_64.AppImage";
    sha256 = "0yd4g87kcwiy1arx3y2nyb7lq1nlh4cn87762k2sd8n4s9i52c7r";
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
    homepage = "https://zulipchat.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonafato ];
    platforms = [ "x86_64-linux" ];
  };
}
