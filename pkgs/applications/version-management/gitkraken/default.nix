{ stdenv, libXcomposite, libgnome-keyring, makeWrapper, udev, curl, alsaLib
, libXfixes, atk, gtk3, libXrender, pango, gnome3, cairo, freetype, fontconfig
, libX11, libXi, libxcb, libXext, libXcursor, glib, libXScrnSaver, libxkbfile, libXtst
, nss, nspr, cups, fetchurl, expat, gdk-pixbuf, libXdamage, libXrandr, dbus
, dpkg, makeDesktopItem, openssl, wrapGAppsHook, at-spi2-atk, libuuid
, e2fsprogs, krb5
}:

with stdenv.lib;

let
  curlWithGnuTls = curl.override { gnutlsSupport = true; sslSupport = false; };
in
stdenv.mkDerivation rec {
  pname = "gitkraken";
  version = "6.4.1";

  src = fetchurl {
    url = "https://release.axocdn.com/linux/GitKraken-v${version}.deb";
    sha256 = "1w8iwpbr6nwzhhf63fvr7pd66yjx3jgjy4gx5y02qxa3ip5psq5b";
  };

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

  nativeBuildInputs = [ dpkg makeWrapper wrapGAppsHook ];
  buildInputs = [ gtk3 gnome3.adwaita-icon-theme ];

  unpackCmd = ''
    mkdir out
    dpkg -x $curSrc out
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    pushd usr
    pushd share
    substituteInPlace applications/gitkraken.desktop \
      --replace /usr/share/gitkraken $out/bin
    popd
    rm -rf bin/gitkraken share/lintian
    cp -av share bin $out/
    popd

    ln -s $out/share/gitkraken/gitkraken $out/bin/gitkraken
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
