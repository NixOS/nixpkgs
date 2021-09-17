{ lib
, fetchurl
, appimageTools
}:

let
  version = "1.7.1";
in
appimageTools.wrapType2 {
  name = "session-desktop-appimage-${version}";
  src = fetchurl {
    url = "https://github.com/oxen-io/session-desktop/releases/download/v${version}/session-desktop-linux-x86_64-${version}.AppImage";
    sha256 = "126dx37099pjaqgfv5gbmvn5iiwv2a8lvfbqy5i9h1w1gqnihwq6";
  };

  meta = with lib; {
    description = "Onion routing based messenger";
    homepage = "https://getsession.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ alexnortung ];
    platforms = [ "x86_64-linux" ];
  };
}
