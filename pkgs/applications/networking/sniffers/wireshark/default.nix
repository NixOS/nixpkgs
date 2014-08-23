{ stdenv, fetchurl, pkgconfig, perl, flex, bison, libpcap, libnl, c-ares
, gnutls, libgcrypt, geoip, heimdal, lua5, gtk, makeDesktopItem, python
, libcap
}:

let version = "1.11.2"; in

stdenv.mkDerivation {
  name = "wireshark-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/wireshark/wireshark-${version}.tar.bz2";
    sha256 = "077hjnmqn44s8dx3pc38bxps5liicjnhzrnf6ky2x60m2cp7ngr3";
  };

  buildInputs = [
    bison flex perl pkgconfig libpcap lua5 heimdal libgcrypt gnutls
    geoip libnl c-ares gtk python libcap
  ];

  patches = [ ./wireshark-lookup-dumpcap-in-path.patch ];

  preConfigure = ''
    sed -re 's/g_memmove/memmove/' -i $(grep -rl g_memmove .)
  '';

  configureFlags = "--disable-usr-local --disable-silent-rules --with-gtk2 --without-gtk3 --without-qt --with-ssl";

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
    cp "$desktopItem/share/applications/"* "$out/share/applications/"
    cp image/wsicon.svg "$out"/share/icons/wireshark.svg
  '';

  enableParallelBuilding = true;

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
    maintainers = with stdenv.lib.maintainers; [ simons bjornfor ];
  };
}
