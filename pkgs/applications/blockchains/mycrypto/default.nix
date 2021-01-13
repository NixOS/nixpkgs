{ lib, appimageTools, fetchurl, makeDesktopItem
, gsettings-desktop-schemas, gtk2
}:

let
  pname = "MyCrypto";
  version = "1.7.13";
  sha256 = "15m21n68lxnz6fxwf1bb3cxg5qi6nrwcnqymiw8s9wizvv575vj7";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/mycryptohq/mycrypto/releases/download/${version}/linux-x86-64_${version}_MyCrypto.AppImage";
    inherit sha256;
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = pname;
    comment = "MyCrypto is a free, open-source interface for interacting with the blockchain";
    exec = pname;
    icon = "mycrypto";
    categories = "Finance;";
  };

in appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk2}/share/gsettings-schemas/${gtk2.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no p32bit needed
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}

    mkdir -p $out/share
    cp -rt $out/share ${desktopItem}/share/applications ${appimageContents}/usr/share/icons
    chmod -R +w $out/share
    mv $out/share/icons/hicolor/{0x0,256x256}
  '';

  meta = with lib; {
    description = "A free, open-source interface for interacting with the blockchain";
    longDescription = ''
      MyCrypto is an open-source, client-side tool for generating ether wallets,
      handling ERC-20 tokens, and interacting with the blockchain more easily.
    '';
    homepage = "https://mycrypto.com";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ oxalica ];
  };
}
