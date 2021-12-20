{ lib
, fetchurl
, appimageTools
}:

appimageTools.wrapType2 rec {
  pname = "session-desktop-appimage";
  version = "1.7.5";
  src = fetchurl {
    url = "https://github.com/oxen-io/session-desktop/releases/download/v${version}/session-desktop-linux-x86_64-${version}.AppImage";
    sha256 = "We1/1UIMJ8JnI9V4Z7TA0Vx3YNOfqLBW9DtklwwqUVE=";
  };

  meta = with lib; {
    description = "Onion routing based messenger";
    homepage = "https://getsession.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ alexnortung ];
    platforms = [ "x86_64-linux" ];
  };
}
