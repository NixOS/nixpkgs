{ appimageTools, symlinkJoin, lib, fetchurl, makeDesktopItem }:

let
  pname = "ssb-patchwork";
  version = "3.16.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/ssbc/patchwork/releases/download/v${version}/${pname}-${version}-x86_64.AppImage";
    sha256 = "0hi9ysmwhiiww82a3mqdd2b1anj7qa41b46f6zb3q9d0b8nmvlz4";
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
    name = "ssb-patchwork";
    exec = "${binary}/bin/ssb-patchwork";
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
