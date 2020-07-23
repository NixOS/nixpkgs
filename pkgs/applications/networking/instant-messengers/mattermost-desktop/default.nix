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
    version = "4.5.2";

    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-x64.tar.gz";
          sha256 = "0r9xmhzif1ia1m53yr59q6p3niyq3jv3vgv4703x68jmd46f91n6";
        }
      else if stdenv.hostPlatform.system == "i686-linux" then
        fetchurl {
          url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-ia32.tar.gz";
          sha256 = "1h8lw06p3cqz9dkgbhfmzcrzjsir5cfhx28xm4zrmvkj4yfzbcnv";
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
      substituteInPlace \
        $out/share/applications/Mattermost.desktop \
        --replace /share/mattermost-desktop/mattermost-desktop /bin/mattermost-desktop

      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${rpath}:$out/share/mattermost-desktop" \
        $out/share/mattermost-desktop/mattermost-desktop
    '';

    meta = with stdenv.lib; {
      description = "Mattermost Desktop client";
      homepage    = "https://about.mattermost.com/";
      license     = licenses.asl20;
      platforms   = [ "x86_64-linux" "i686-linux" ];
      maintainers = [ maintainers.joko ];
    };
  }
