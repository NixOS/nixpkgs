{ stdenv, libXcomposite, libgnome-keyring, makeWrapper, udev, curl, alsaLib
, libXfixes, atk, gtk3, libXrender, pango, gnome3, cairo, freetype, fontconfig
, libX11, libXi, libxcb, libXext, libXcursor, glib, libXScrnSaver, libxkbfile, libXtst
, nss, nspr, cups, fetchzip, expat, gdk-pixbuf, libXdamage, libXrandr, dbus
, makeDesktopItem, openssl, wrapGAppsHook, at-spi2-atk, at-spi2-core, libuuid
, e2fsprogs, krb5
}:

with stdenv.lib;

let
  curlWithGnuTls = curl.override { gnutlsSupport = true; sslSupport = false; };
in
stdenv.mkDerivation rec {
  pname = "gitkraken";
  version = "6.5.4";

  src = fetchzip {
    url = "https://release.axocdn.com/linux/GitKraken-v${version}.tar.gz";
    sha256 = "0hrxkhxp6kp82jg1pkcl6vxa5mjpgncx0k353bcnm4986ysizhj4";
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
    alsaLib
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
  ];

  desktopItem = makeDesktopItem {
    name = "gitkraken";
    exec = "gitkraken";
    icon = "gitkraken";
    desktopName = "GitKraken";
    genericName = "Git Client";
    categories = "Application;Development;";
    comment = "Graphical Git client from Axosoft";
  };

  nativeBuildInputs = [ makeWrapper wrapGAppsHook ];
  buildInputs = [ gtk3 gnome3.adwaita-icon-theme ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/gitkraken/
    cp -R $src/* $out/share/gitkraken/

    mkdir -p $out/bin
    ln -s $out/share/gitkraken/gitkraken $out/bin/gitkraken

    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications/

    substituteInPlace $out/share/applications/gitkraken.desktop \
      --replace $out/usr/share/gitkraken $out/bin

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
    homepage = https://www.gitkraken.com/;
    description = "The downright luxurious and most popular Git client for Windows, Mac & Linux";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xnwdd evanjs ];
  };
}
