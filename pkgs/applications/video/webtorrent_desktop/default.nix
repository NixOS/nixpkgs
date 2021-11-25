{
  alsa-lib, atk, cairo, cups, dbus, dpkg, expat, fetchurl, fetchzip, fontconfig, freetype,
  gdk-pixbuf, glib, gtk3, libX11, libXScrnSaver, libXcomposite, libXcursor,
  libXdamage, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst,
  libxcb, nspr, nss, lib, stdenv, udev, libuuid, pango, at-spi2-atk, at-spi2-core
}:

  let
    rpath = lib.makeLibraryPath ([
    alsa-lib
    atk
    at-spi2-core
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    pango
    libuuid
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libxcb
    nspr
    nss
    stdenv.cc.cc
    udev
    ]);
  in stdenv.mkDerivation rec {
    pname = "webtorrent-desktop";
    version = "0.21.0";

    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchzip {
          url = "https://github.com/webtorrent/webtorrent-desktop/releases/download/v${version}/WebTorrent-v${version}-linux.zip";
          sha256 = "13gd8isq2l10kibsc1bsc15dbgpnwa7nw4cwcamycgx6pfz9a852";
        }
        else
          throw "Webtorrent is not currently supported on ${stdenv.hostPlatform.system}";
    desktopFile = fetchurl {
      url = "https://raw.githubusercontent.com/webtorrent/webtorrent-desktop/v${version}/static/linux/share/applications/webtorrent-desktop.desktop";
      sha256 = "1v16dqbxqds3cqg3xkzxsa5fyd8ssddvjhy9g3i3lz90n47916ca";
    };
    icon256File = fetchurl {
      url = "https://raw.githubusercontent.com/webtorrent/webtorrent-desktop/v${version}/static/linux/share/icons/hicolor/256x256/apps/webtorrent-desktop.png";
      sha256 = "1dapxvvp7cx52zhyaby4bxm4rll9xc7x3wk8k0il4g3mc7zzn3yk";
    };
    icon48File = fetchurl {
      url = "https://raw.githubusercontent.com/webtorrent/webtorrent-desktop/v${version}/static/linux/share/icons/hicolor/48x48/apps/webtorrent-desktop.png";
      sha256 = "00y96w9shbbrdbf6xcjlahqd08154kkrxmqraik7qshiwcqpw7p4";
    };
    nativeBuildInputs = [ dpkg ];
    installPhase = ''
      mkdir -p $out/share/{applications,icons/hicolor/{48x48,256x256}/apps}
      cp -R . $out/libexec

      # Patch WebTorrent
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
               --set-rpath ${rpath}:$out/libexec $out/libexec/WebTorrent

      # Symlink to bin
      mkdir -p $out/bin
      ln -s $out/libexec/WebTorrent $out/bin/WebTorrent

      cp $icon48File $out/share/icons/hicolor/48x48/apps/webtorrent-desktop.png
      cp $icon256File $out/share/icons/hicolor/256x256/apps/webtorrent-desktop.png
      ## Fix the desktop link
      substitute $desktopFile $out/share/applications/webtorrent-desktop.desktop \
        --replace /opt/webtorrent-desktop $out/libexec
    '';

    meta = with lib; {
      description = "Streaming torrent app for Mac, Windows, and Linux";
      homepage = "https://webtorrent.io/desktop";
      license = licenses.mit;
      maintainers = [ maintainers.flokli ];
      platforms = [
        "x86_64-linux"
      ];
    };
  }
