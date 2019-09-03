{ stdenv, fetchurl, gnome2, gtk3, pango, atk, cairo, gdk-pixbuf, glib,
freetype, fontconfig, dbus, libX11, xorg, libXi, libXcursor, libXdamage,
libXrandr, libXcomposite, libXext, libXfixes, libXrender, libXtst,
libXScrnSaver, nss, nspr, alsaLib, cups, expat, udev }:
let
  rpath = stdenv.lib.makeLibraryPath [
    alsaLib
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
    version = "4.2.3";

    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-x64.tar.gz";
          sha256 = "14xyn8dp0xxl4j9xdsjik9p6srqdxbirgcgym2sv64p01w3kc9wf";
        }
      else if stdenv.hostPlatform.system == "i686-linux" then
        fetchurl {
          url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-ia32.tar.gz";
          sha256 = "063rrxw76mjz71wp9xd3ppkq3s017vrzms879r2cilypmay7fhgs";
        }
      else
        throw "Mattermost-Desktop is not currently supported on ${stdenv.hostPlatform.system}";

    dontBuild = true;
    dontConfigure = true;
    dontPatchELF = true;

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
