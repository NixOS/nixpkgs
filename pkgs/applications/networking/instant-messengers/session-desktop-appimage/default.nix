{ lib
, fetchurl
, appimageTools
}:

let
  version = "1.7.3";
in
appimageTools.wrapType2 {
  name = "session-desktop-appimage-${version}";
  src = fetchurl {
    url = "https://github.com/oxen-io/session-desktop/releases/download/v${version}/session-desktop-linux-x86_64-${version}.AppImage";
    sha256 = "0s0zvj9ddrngdzsx8hd07pq3150sq8ab1hbpsi9i2ir99sv1p7gn";
  };

  meta = with lib; {
    description = "Onion routing based messenger";
    homepage = "https://getsession.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ alexnortung ];
    platforms = [ "x86_64-linux" ];
  };
}
