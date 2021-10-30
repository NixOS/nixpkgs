{ lib, stdenv, libXcomposite, libgnome-keyring, makeWrapper, udev, curl, alsa-lib
, libXfixes, atk, gtk3, libXrender, pango, gnome, cairo, freetype, fontconfig
, libX11, libXi, libxcb, libXext, libXcursor, glib, libXScrnSaver, libxkbfile, libXtst
, nss, nspr, cups, fetchzip, expat, gdk-pixbuf, libXdamage, libXrandr, dbus
, makeDesktopItem, openssl, wrapGAppsHook, at-spi2-atk, at-spi2-core, libuuid
, e2fsprogs, krb5, libdrm, mesa
}:

with lib;

let
  curlWithGnuTls = curl.override { gnutlsSupport = true; sslSupport = false; };
in
stdenv.mkDerivation rec {
  pname = "gitkraken";
  version = "8.1.0";

  src = fetchzip {
    url = "https://release.axocdn.com/linux/GitKraken-v${version}.tar.gz";
    sha256 = "1115616d642chnisil7gv6fxw699sryphrfrp92cq3vi6lcwqbn8";
  };

  dontBuild = true;
  dontConfigure = true;

  libPath = makeLibraryPath [
    stdenv.cc.cc.lib
    curlWithGnuTls
    udev
    libX11
    libXext
    libXcursor
    libXi
    libxcb
    glib
    libXScrnSaver
    libxkbfile
    libXtst
    nss
    nspr
    cups
    alsa-lib
    expat
    gdk-pixbuf
    dbus
    libXdamage
    libXrandr
    atk
    pango
    cairo
    freetype
    fontconfig
    libXcomposite
    libXfixes
    libXrender
    gtk3
    libgnome-keyring
    openssl
    at-spi2-atk
    at-spi2-core
    libuuid
    e2fsprogs
    krb5
    libdrm
    mesa
  ];

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "gitkraken";
    icon = "gitkraken";
    desktopName = "GitKraken";
    genericName = "Git Client";
    categories = "Development;";
    comment = "Graphical Git client from Axosoft";
  };

  nativeBuildInputs = [ makeWrapper wrapGAppsHook ];
  buildInputs = [ gtk3 gnome.adwaita-icon-theme ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/gitkraken/
    cp -R $src/* $out/share/gitkraken/

    mkdir -p $out/bin
    ln -s $out/share/gitkraken/gitkraken $out/bin/gitkraken

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications

    mkdir -p $out/share/pixmaps
    cp gitkraken.png $out/share/pixmaps/gitkraken.png

    runHook postInstall
  '';

  postFixup = ''
    pushd $out/share/gitkraken
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" gitkraken

    for file in $(find . -type f \( -name \*.node -o -name gitkraken -o -name \*.so\* \) ); do
      patchelf --set-rpath ${libPath}:$out/share/gitkraken $file || true
    done
    popd
  '';

  meta = {
    homepage = "https://www.gitkraken.com/";
    description = "The downright luxurious and most popular Git client for Windows, Mac & Linux";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xnwdd evanjs ];
  };
}
