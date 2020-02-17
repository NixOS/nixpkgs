{ appimageTools, symlinkJoin, lib, fetchurl, makeDesktopItem }:

let
  pname = "ssb-patchbay";
  version = "8.1.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url =
      "https://github.com/ssbc/patchbay/releases/download/v${version}/patchbay-Linux-${version}-x86_64.AppImage";
    sha256 = "0cinbjxbm1wg24fhlhkr6cyv4rh6nh2dammm1r62a0p0frljrx7l";
  };

  binary = appimageTools.wrapType2 {
    name = pname;
    inherit src;
  };
  # we only use this to extract the icon
  appimage-contents = appimageTools.extractType2 { inherit name src; };

  desktopItem = makeDesktopItem {
    name = "ssb-patchbay";
    exec = "${binary}/bin/ssb-patchbay";
    icon = "ssb-patchbay.png";
    comment = "Decentralized messaging and sharing app";
    desktopName = "Patchbay";
    genericName = "Patchbay";
    categories = "Network;";
  };

in symlinkJoin {
  inherit name;
  paths = [ binary ];

  postBuild = ''
    mkdir -p $out/share/pixmaps/ $out/share/applications
    cp ${appimage-contents}/patchbay.png $out/share/pixmaps
    cp ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with lib; {
    description =
      "An alternative Secure Scuttlebutt client interface that is fully compatible with Patchwork";
    homepage = "https://www.scuttlebutt.nz/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
