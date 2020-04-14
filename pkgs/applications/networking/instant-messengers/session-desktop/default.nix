{ lib
, fetchurl
, appimageTools
}:

let
  pname = "session-messenger-desktop";
  version = "1.0.6";
  name="${pname}-${version}.AppImage";
  src = fetchurl {
    url = "https://github.com/loki-project/session-desktop/releases/download/v${version}/session-messenger-desktop-linux-x86_64-${version}.AppImage";
    sha256 = "43abf0d0aedf200c14a853070965142d3fdbe39b26e4186e1814418612f9f8b5";
    name="${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/session.desktop
    install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/512x512/apps/session.png
    substituteInPlace $out/share/applications/session.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Desktop client for Session Messenger";
    homepage = https://getsession.org/;
    license = licenses.gpl3;
    #maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
