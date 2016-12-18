{ stdenv, fetchurl, pkgconfig, perl, flex, bison, libpcap, libnl, c-ares
, gnutls, libgcrypt, geoip, openssl, lua5, makeDesktopItem, python, libcap, glib
, zlib
, withGtk ? false, gtk2 ? null, pango ? null, cairo ? null, gdk_pixbuf ? null
, withQt ? false, qt4 ? null
, ApplicationServices, SystemConfiguration, gmp
}:

assert withGtk -> !withQt && gtk2 != null;
assert withQt -> !withGtk && qt4 != null;

with stdenv.lib;

let
  version = "2.2.3";
  variant = if withGtk then "gtk" else if withQt then "qt" else "cli";
in

stdenv.mkDerivation {
  name = "wireshark-${variant}-${version}";

  src = fetchurl {
    url = "http://www.wireshark.org/download/src/all-versions/wireshark-${version}.tar.bz2";
    sha256 = "0fsrvl6sp772g2q2j24h10h9lfda6q67x7wahjjm8849i2gciflp";
  };

  buildInputs = [
    bison flex perl pkgconfig libpcap lua5 openssl libgcrypt gnutls
    geoip c-ares python glib zlib
  ] ++ optional withQt qt4
    ++ (optionals withGtk [gtk2 pango cairo gdk_pixbuf])
    ++ optionals stdenv.isLinux [ libcap libnl ]
    ++ optionals stdenv.isDarwin [ SystemConfiguration ApplicationServices gmp ];

  patches = [ ./wireshark-lookup-dumpcap-in-path.patch ];

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

    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ bjornfor fpletz ];
  };
}
