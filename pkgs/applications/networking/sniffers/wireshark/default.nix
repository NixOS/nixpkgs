{ stdenv, fetchurl, pkgconfig, perl, flex, bison, libpcap, libnl, c-ares
, gnutls, libgcrypt, geoip, openssl, lua5, makeDesktopItem, python, libcap, glib
, zlib
, withGtk ? false, gtk ? null, pango ? null, cairo ? null, gdk_pixbuf ? null
, withQt ? false, qt4 ? null
}:

assert withGtk -> !withQt && gtk != null;
assert withQt -> !withGtk && qt4 != null;

with stdenv.lib;

let
  version = "2.2.4";
  variant = if withGtk then "gtk" else if withQt then "qt" else "cli";
in

stdenv.mkDerivation {
  name = "wireshark-${variant}-${version}";

  src = fetchurl {
    url = "http://www.wireshark.org/download/src/all-versions/wireshark-${version}.tar.bz2";
    sha256 = "049r5962yrajhhz9r4dsnx403dab50d6091y2mw298ymxqszp9s2";
  };

  buildInputs = [
    bison flex perl pkgconfig libpcap lua5 openssl libgcrypt gnutls
    geoip libnl c-ares python libcap glib zlib
  ] ++ optional withQt qt4
    ++ (optionals withGtk [gtk pango cairo gdk_pixbuf]);

  patches = [ ./wireshark-lookup-dumpcap-in-path.patch
  (fetchurl {
    url = "https://code.wireshark.org/review/gitweb?p=wireshark.git;a=commitdiff_plain;h=c7042bedbb3b12c5f4e19e59e52da370d4ffe62f;hp=bc2b135677110d8065ba1174f09bc7f5ba73b9e9";
    sha256 = "1m70akywf2r52lhlvzr720vl1i7ng9cqbzaiif8s81xs4g4nn2rz";
    name = "wireshark-CVE-2017-6014.patch";
  })
  ];

  configureFlags = "--disable-usr-local --disable-silent-rules --with-ssl"
    + (if withGtk then
         " --with-gtk2 --without-gtk3 --without-qt"
       else if withQt then
         " --without-gtk2 --without-gtk3 --with-qt"
       else " --disable-wireshark");

  desktopItem = makeDesktopItem {
    name = "Wireshark";
    exec = "wireshark";
    icon = "wireshark";
    comment = "Powerful network protocol analysis suite";
    desktopName = "Wireshark";
    genericName = "Network packet analyzer";
    categories = "Network;System";
  };

  postInstall = optionalString (withQt || withGtk) ''
    mkdir -p "$out"/share/applications/
    mkdir -p "$out"/share/icons/
    cp "$desktopItem/share/applications/"* "$out/share/applications/"
    cp image/wsicon.svg "$out"/share/icons/wireshark.svg
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.wireshark.org/;
    description = "Powerful network protocol analyzer";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      Wireshark (formerly known as "Ethereal") is a powerful network
      protocol analyzer developed by an international team of networking
      experts. It runs on UNIX, OS X and Windows.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ bjornfor fpletz ];
  };
}
