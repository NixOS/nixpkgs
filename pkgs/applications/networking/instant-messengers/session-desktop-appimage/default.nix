{ lib
, fetchurl
, appimageTools
}:

appimageTools.wrapType2 rec {
  pname = "session-desktop-appimage";
  version = "1.7.7";
  src = fetchurl {
    url = "https://github.com/oxen-io/session-desktop/releases/download/v${version}/session-desktop-linux-x86_64-${version}.AppImage";
    sha256 = "iMJk7/Q3Kh2KwLs0m+DAPVv471iPZcsIs4+YCSbmeIo=";
  };

  meta = with lib; {
    description = "Onion routing based messenger";
    homepage = "https://getsession.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ alexnortung ];
    platforms = [ "x86_64-linux" ];
  };
}
