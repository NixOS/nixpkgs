{ stdenv, fetchurl, perl, pkgconfig, gtk, libpcap, flex, bison
, gnutls, libgcrypt, glib, zlib, libxml2, libxslt, adns, geoip
, heimdal, python, lynx, lua5
, makeDesktopItem
}:

let version = "1.8.7"; in

stdenv.mkDerivation {
  name = "wireshark-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/wireshark/wireshark-${version}.tar.bz2";
    sha256 = "0hm8zisy5dg7sfhh7rvgnpffq2qcw0syd8k5kns8j0j13sf44zjw";
  };

  buildInputs =
    [ perl pkgconfig gtk libpcap flex bison gnutls libgcrypt
      glib zlib libxml2 libxslt adns geoip heimdal python lynx lua5
    ];

  configureFlags = "--disable-usr-local --with-ssl --enable-threads --enable-packet-editor";

  desktopItem = makeDesktopItem {
    name = "Wireshark";
    exec = "wireshark";
    icon = "wireshark";
    comment = "Powerful network protocol analysis suite";
    desktopName = "Wireshark";
    genericName = "Network packet analyzer";
    categories = "Network;System";
  };

  postInstall = ''
    mkdir -p "$out"/share/applications/
    mkdir -p "$out"/share/icons/
    cp "$desktopItem"/share/applications/* "$out"/share/applications/
    cp image/wsicon.svg "$out"/share/icons/wireshark.svg
  '';

  meta = {
    homepage = http://www.wireshark.org/;
    description = "a powerful network protocol analyzer";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      Wireshark (formerly known as "Ethereal") is a powerful network
      protocol analyzer developed by an international team of networking
      experts. It runs on UNIX, OS X and Windows.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
