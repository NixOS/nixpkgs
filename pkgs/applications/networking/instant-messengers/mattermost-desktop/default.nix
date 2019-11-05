{ stdenv, fetchurl, gnome2, gtk3, pango, atk, cairo, gdk-pixbuf, glib,
freetype, fontconfig, dbus, libX11, xorg, libXi, libXcursor, libXdamage,
libXrandr, libXcomposite, libXext, libXfixes, libXrender, libXtst,
libXScrnSaver, nss, nspr, alsaLib, cups, expat, udev, wrapGAppsHook,
hicolor-icon-theme, libuuid, at-spi2-core, at-spi2-atk }:

let
  rpath = stdenv.lib.makeLibraryPath [
    alsaLib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gnome2.GConf
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
    nspr
    nss
    stdenv.cc.cc
    udev
    xorg.libxcb
  ];

in
  stdenv.mkDerivation rec {
    pname = "mattermost-desktop";
    version = "4.3.1";

    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-x64.tar.gz";
          sha256 = "076nv5h6xscbw1987az00x493qhqgrli87gnn57zbvz0acgvlhfv";
        }
      else if stdenv.hostPlatform.system == "i686-linux" then
        fetchurl {
          url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-ia32.tar.gz";
          sha256 = "19ps9g8j6kp4haj6r3yfy4ma2wm6isq5fa8zlcz6g042ajkqq0ij";
        }
      else
        throw "Mattermost-Desktop is not currently supported on ${stdenv.hostPlatform.system}";

    dontBuild = true;
    dontConfigure = true;
    dontPatchELF = true;

    buildInputs = [ wrapGAppsHook gtk3 hicolor-icon-theme ];

    installPhase = ''
      mkdir -p $out/share/mattermost-desktop
      cp -R . $out/share/mattermost-desktop

      mkdir -p "$out/bin"
      ln -s $out/share/mattermost-desktop/mattermost-desktop \
        $out/bin/mattermost-desktop

      patchShebangs $out/share/mattermost-desktop/create_desktop_file.sh
      $out/share/mattermost-desktop/create_desktop_file.sh
      rm $out/share/mattermost-desktop/create_desktop_file.sh
      mkdir -p $out/share/applications
      mv Mattermost.desktop $out/share/applications/Mattermost.desktop

      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${rpath}:$out/share/mattermost-desktop" \
        $out/share/mattermost-desktop/mattermost-desktop
    '';

    meta = with stdenv.lib; {
      description = "Mattermost Desktop client";
      homepage    = https://about.mattermost.com/;
      license     = licenses.asl20;
      platforms   = [ "x86_64-linux" "i686-linux" ];
      maintainers = [ maintainers.joko ];
    };
  }
