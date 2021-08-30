{ lib
, fetchurl
, appimageTools
}:

let
  version = "1.6.11";
in
appimageTools.wrapType2 {
  name = "session-desktop-appimage-${version}";
  src = fetchurl {
    url = "https://github.com/oxen-io/session-desktop/releases/download/v${version}/session-desktop-linux-x86_64-${version}.AppImage";
    sha256 = "08vnkxj2w2k7lhygs5qhbyikpvw5nmby3qhxigbbkj5qj1wvs48b";
  };

  meta = with lib; {
    description = "Onion routing based messenger";
    homepage = "https://getsession.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ alexnortung ];
    platforms = [ "x86_64-linux" ];
  };
}
