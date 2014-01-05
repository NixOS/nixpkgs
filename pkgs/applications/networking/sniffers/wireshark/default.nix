{ stdenv, fetchurl, pkgconfig, perl, flex, bison, libpcap, libnl, c-ares, gnutls, libgcrypt
, geoip, heimdal, lua5, gtk, makeDesktopItem
}:

let version = "1.10.3"; in

stdenv.mkDerivation {
  name = "wireshark-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/wireshark/wireshark-${version}.tar.bz2";
    sha256 = "1329zph63z5mcij9lp111bh6b2w88z3d40gvjld2rjmhmqv1nr61";
  };

  buildInputs =
    [ bison flex perl pkgconfig libpcap lua5 heimdal libgcrypt gnutls geoip libnl c-ares gtk ];

  configureFlags = "--disable-usr-local --enable-packet-editor --with-ssl";

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
