{ lib
, fetchurl
, appimageTools
}:

let
  version = "1.7.4";
in
appimageTools.wrapType2 {
  name = "session-desktop-appimage-${version}";
  src = fetchurl {
    url = "https://github.com/oxen-io/session-desktop/releases/download/v${version}/session-desktop-linux-x86_64-${version}.AppImage";
    sha256 = "1yjah9ip3r2irvv2g9j0ql55nkmpwml7lngmq954xrkq9smrdrm5";
  };

  meta = with lib; {
    description = "Onion routing based messenger";
    homepage = "https://getsession.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ alexnortung ];
    platforms = [ "x86_64-linux" ];
  };
}
