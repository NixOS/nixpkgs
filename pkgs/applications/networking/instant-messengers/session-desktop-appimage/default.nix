{ lib
, fetchurl
, appimageTools
}:

appimageTools.wrapType2 rec {
  pname = "session-desktop-appimage";
  version = "1.7.9";
  src = fetchurl {
    url = "https://github.com/oxen-io/session-desktop/releases/download/v${version}/session-desktop-linux-x86_64-${version}.AppImage";
    sha256 = "ca7754e59146633b71e66b02a90cff87e4f2574e57ff831ca4a5f983b7e2fbef";
  };

  meta = with lib; {
    description = "Onion routing based messenger";
    homepage = "https://getsession.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ alexnortung ];
    platforms = [ "x86_64-linux" ];
  };
}
