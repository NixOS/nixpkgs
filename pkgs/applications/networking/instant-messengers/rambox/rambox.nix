{ pname, version, src, meta, desktopName ? "Rambox" }:

{ appimageTools, lib, fetchurl, gsettings-desktop-schemas, gtk3, makeDesktopItem }:

let
  name = "${pname}-${version}";

  desktopItem = (makeDesktopItem {
    inherit desktopName;
    name = pname;
    exec = pname;
    icon = pname;
    categories = [ "Network" ];
  });

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 rec {
  inherit name src meta;
  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps
    # CE uses rambox-<version>, Pro uses rambox
    mv $out/bin/rambox* $out/bin/${pname}
    install -Dm644 ${appimageContents}/usr/share/icons/hicolor/256x256/apps/rambox*.png $out/share/icons/hicolor/256x256/apps/${pname}.png
    install -Dm644 ${desktopItem}/share/applications/* $out/share/applications
  '';
}
