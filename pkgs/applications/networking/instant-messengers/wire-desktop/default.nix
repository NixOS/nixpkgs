{ stdenv, fetchurl, makeDesktopItem

, alsaLib, at-spi2-atk, atk, cairo, cups, dbus, dpkg, expat, fontconfig
, freetype, gdk-pixbuf, glib, gtk3, hunspell, libX11, libXScrnSaver
, libXcomposite, libXcursor, libXdamage, libXext, libXfixes, libXi, libXrandr
, libXrender, libXtst, libnotify, libuuid, nspr, nss, pango, pciutils
, pulseaudio, udev, xdg_utils, xorg

, cpio, xar
}:

let

  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${system}";

  pname = "wire-desktop";

  version = {
    x86_64-darwin = "3.16.3630";
    x86_64-linux = "3.16.2923";
  }.${system} or throwSystem;

  sha256 = {
    x86_64-darwin = "1lnjn45bhd36n9xgx6xx9cggwivvkr2s6r4zai2dwg0aac1bywr5";
    x86_64-linux = "0c8jmlsg2gnxsvly04xj1al80nj52rg4czfdha58sg14x14lyspz";
  }.${system} or throwSystem;

  meta = with stdenv.lib; {
    description = "A modern, secure messenger for everyone";
    longDescription = ''
      Wire Personal is a secure, privacy-friendly messenger. It combines useful
      and fun features, audited security, and a beautiful, distinct user
      interface.  It does not require a phone number to register and chat.

        * End-to-end encrypted chats, calls, and files
        * Crystal clear voice and video calling
        * File and screen sharing
        * Timed messages and chats
        * Synced across your phone, desktop and tablet
    '';
    homepage = https://wire.com/;
    downloadPage = https://wire.com/download/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ toonn worldofpeace ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version meta;

    src = fetchurl {
      url = "https://wire-app.wire.com/linux/debian/pool/main/"
        + "Wire-${version}_amd64.deb";
      inherit sha256;
    };

    desktopItem = makeDesktopItem {
      name = "wire-desktop";
      exec = "wire-desktop %U";
      icon = "wire-desktop";
      comment = "Secure messenger for everyone";
      desktopName = "Wire";
      genericName = "Secure messenger";
      categories = "Network;InstantMessaging;Chat;VideoConference";
      extraEntries = ''
        StartupWMClass=Wire
      '';
    };

    dontBuild = true;
    dontPatchELF = true;
    dontConfigure = true;

    nativeBuildInputs = [ dpkg ];
    rpath = stdenv.lib.makeLibraryPath [
      alsaLib at-spi2-atk atk cairo cups dbus expat fontconfig freetype
      gdk-pixbuf glib gtk3 hunspell libX11 libXScrnSaver libXcomposite
      libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
      libXtst libnotify libuuid nspr nss pango pciutils pulseaudio
      stdenv.cc.cc udev xdg_utils xorg.libxcb
    ];

    unpackPhase = "dpkg-deb -x $src .";

    installPhase = ''
      mkdir -p "$out"
      cp -R "opt" "$out"
      cp -R "usr/share" "$out/share"
      chmod -R g-w "$out"

      # Patch wire-desktop
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${rpath}:$out/opt/Wire" \
        "$out/opt/Wire/wire-desktop"

      # Symlink to bin
      mkdir -p "$out/bin"
      ln -s "$out/opt/Wire/wire-desktop" "$out/bin/wire-desktop"

      # Desktop file
      mkdir -p "$out/share/applications"
      cp "${desktopItem}/share/applications/"* "$out/share/applications"
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "https://github.com/wireapp/wire-desktop/releases/download/"
          + "macos%2F${version}/Wire.pkg";
      inherit sha256;
    };

    buildInputs = [ cpio xar ];

    unpackPhase = ''
      xar -xf $src
      cd com.wearezeta.zclient.mac.pkg
    '';


    buildPhase = ''
      cat Payload | gunzip -dc | cpio -i
    '';

    installPhase = ''
      mkdir -p $out/Applications
      cp -r Wire.app $out/Applications
    '';
  };

in if stdenv.isDarwin
  then darwin
  else linux
