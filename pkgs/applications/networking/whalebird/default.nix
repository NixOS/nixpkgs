{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3
, makeDesktopItem
}:

let
  pname = "whalebird";
  version = "4.4.1";

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/h3poteto/whalebird-desktop/master/static/images/icon.png";
    sha256 = "15i5jp1i0134acvh78f8x4dfdfm22sfr1j26cmih3haqlk0y694x";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = icon;
    desktopName = pname;
    genericName = "Whalebird fediverse client";
    categories = "Application";
  };

in appimageTools.wrapType2 rec {
  name = "${pname}";
  src = fetchurl {
    url = "https://github.com/h3poteto/whalebird-desktop/releases/download/${version}/Whalebird-${version}-linux-x64.AppImage";
    sha256 = "158nisk69yzkp5f681zrm2nj9zv1f6vrw93b8r9ry7dah34c94py";
  };

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = pkgs:
    appimageTools.defaultFhsEnvArgs.multiPkgs pkgs ++ (with pkgs; [ libdbusmenu ]);

  extraInstallCommands = ''
    mkdir "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/"
  '';

  meta = with lib; {
    description = "Fediverse client application";
    longDescription = ''
      Whalebird is a client app for Mastodon, Pleroma, and Misskey, implemented in Typescript and Electron.
    '';
    homepage = "https://whalebird.social/";
    license = licenses.mit;
    maintainers = with maintainers; [ greydot ];
    platforms = [ "x86_64-linux" ];
  };
}
