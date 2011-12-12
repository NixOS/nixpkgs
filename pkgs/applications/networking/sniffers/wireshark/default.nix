{ stdenv, fetchurl, perl, pkgconfig, gtk, libpcap, flex, bison
, gnutls, libgcrypt, glib, zlib, libxml2, libxslt, adns, geoip
, heimdal, python, lynx, lua5
}:

let
  version = "1.6.2";
in
stdenv.mkDerivation {
  name = "wireshark-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/wireshark/wireshark-${version}.tar.bz2";
    sha256 = "0zqy8ws05xz36y49azf5lrwzgfz26h7f8d27xjc89hlqrqagahsk";
  };

  buildInputs = [perl pkgconfig gtk libpcap flex bison gnutls libgcrypt
    glib zlib libxml2 libxslt adns geoip heimdal python lynx lua5
  ];

  configureFlags = "--disable-usr-local --with-ssl --enable-threads --enable-packet-editor";

  meta = {
    homepage = "http://sourceforge.net/projects/wireshark/";
    description = "a powerful network protocol analyzer";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      Wireshark (formerly known as "Etherreal") is a powerful network
      protocol analyzer developed by an international team of networking
      experts. It runs on UNIX, OS X and Windows.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
