{ appimageTools, symlinkJoin, lib, fetchurl, makeDesktopItem }:

let
  pname = "ssb-patchwork";
  version = "3.18.1";
  name = "Patchwork-${version}";

  src = fetchurl {
    url = "https://github.com/ssbc/patchwork/releases/download/v${version}/${name}.AppImage";
    sha256 = "F8n6LLbgkg3z55lSY60T+pn2lra8aPt6Ztepw1gf2rI=";
  };

  binary = appimageTools.wrapType2 {
    name = pname;
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
    comment = "Client for the decentralized social network Secure Scuttlebutt";
    desktopName = "Patchwork";
    genericName = "Patchwork";
    categories = [ "Network" ];
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
      homepage = "https://www.scuttlebutt.nz/";
      license = licenses.agpl3;
      maintainers = with maintainers; [ asymmetric picnoir cyplo ];
      mainProgram = "ssb-patchwork";
      platforms = [ "x86_64-linux" ];
    };
  }
