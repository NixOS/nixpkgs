{ appimageTools, symlinkJoin, lib, fetchurl, makeDesktopItem, gsettings-desktop-schemas, gtk3 }:

let
  pname = "ssb-patchbay";
  version = "8.1.0";
  name = "patchbay-${version}";

  src = fetchurl {
    url = "https://github.com/ssbc/patchbay/releases/download/v${version}/patchbay-Linux-${version}-x86_64.AppImage";
    sha256 = "sha256-9PQsaXbgAiVMDrVW1QS0BmayPTN5QgodEY+HurpcNjI=";
  };

  binary = appimageTools.wrapType2 {
    name = pname;
    inherit src;
    profile = ''
      export LC_ALL=C.UTF-8
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';
  };
  # we only use this to extract the icon
  appimage-contents = appimageTools.extractType2 {
    inherit name src;
  };

  desktopItem = makeDesktopItem {
    name = "patchbay";
    exec = "${binary}/bin/patchbay";
    icon = "patchbay";
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
      cp ${appimage-contents}/patchbay.png $out/share/pixmaps
      cp ${desktopItem}/share/applications/* $out/share/applications/
    '';

    meta = with lib; {
      description = "An alternative Secure Scuttlebutt client interface that is fully compatible with Patchwork";
      homepage = "https://www.scuttlebutt.nz/";
      license = licenses.agpl3;
      maintainers = with maintainers; [ asymmetric ninjatrappeur cyplo ];
      platforms = [ "x86_64-linux" ];
    };
  }
