{ lib, stdenv, fetchurl, gnome2, gtk3, pango, atk, cairo, gdk-pixbuf, glib,
freetype, fontconfig, dbus, libX11, xorg, libXi, libXcursor, libXdamage,
libXrandr, libXcomposite, libXext, libXfixes, libXrender, libXtst,
libXScrnSaver, nss, nspr, alsa-lib, cups, expat, udev, wrapGAppsHook,
hicolor-icon-theme, libuuid, at-spi2-core, at-spi2-atk }:

let
  rpath = lib.makeLibraryPath [
    alsa-lib
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
    version = "4.6.2";

    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-x64.tar.gz";
          sha256 = "0i836bc0gx375a9fm2cdxg84k03zhpx1z6jqxndf2m8pkfsblc3x";
        }
      else if stdenv.hostPlatform.system == "i686-linux" then
        fetchurl {
          url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-ia32.tar.gz";
          sha256 = "04jv9hkmkh0jipv0fjdprnp5kmkjvf3c0fah6ysi21wmnmp5ab3m";
        }
      else
        throw "Mattermost-Desktop is not currently supported on ${stdenv.hostPlatform.system}";

    dontBuild = true;
    dontConfigure = true;
    dontPatchELF = true;

    nativeBuildInputs = [ wrapGAppsHook ];

    buildInputs = [ gtk3 hicolor-icon-theme ];

    installPhase = ''
      runHook preInstall

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

      runHook postInstall
    '';

    meta = with lib; {
      description = "Mattermost Desktop client";
      homepage    = "https://about.mattermost.com/";
      license     = licenses.asl20;
      platforms   = [ "x86_64-linux" "i686-linux" ];
      maintainers = [ maintainers.joko ];
    };
  }
