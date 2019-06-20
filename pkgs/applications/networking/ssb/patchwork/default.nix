{ appimageTools, symlinkJoin, lib, fetchurl, makeDesktopItem }:

let
  pname = "patchwork";
  version = "3.14.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/ssbc/patchwork/releases/download/v${version}/ssb-${pname}-${version}-x86_64.AppImage";
    sha256 = "01vsldabv9nmbx8kzlgw275zykm72s1dxglnaq4jz5vbysbyn0qd";
  };

  binary = appimageTools.wrapType2 {
    name = "${pname}";
    inherit src;
  };
  # we only use this to extract the icon
  appimage-contents = appimageTools.extractType2 {
    inherit name src;
  };

  desktopItem = makeDesktopItem {
    name = "patchwork";
    exec = "${binary}/bin/patchwork";
    icon = "ssb-patchwork.png";
    comment = "Decentralized messaging and sharing app";
    desktopName = "Patchwork";
    genericName = "Patchwork";
    categories = "Network;";
  };

in
  symlinkJoin {
    inherit name;
    paths = [ binary ];

    postBuild = ''
      mkdir -p $out/share/pixmaps/ $out/share/applications
      cp ${appimage-contents}/ssb-patchwork.png $out/share/pixmaps
      cp ${desktopItem}/share/applications/* $out/share/applications/
    '';

  meta = with lib; {
    description = "A decentralized messaging and sharing app built on top of Secure Scuttlebutt (SSB)";
    longDescription = ''
      sea-slang for gossip - a scuttlebutt is basically a watercooler on a ship.
    '';
    homepage = https://www.scuttlebutt.nz/;
    license = licenses.agpl3;
    maintainers = with maintainers; [ thedavidmeister ninjatrappeur flokli ];
    platforms = [ "x86_64-linux" ];
  };
}
