{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk2, gtkspell2 ? null
, perl, pcre, gmime, gettext, intltool, itstool, libxml2, dbus-glib, libnotify
, makeWrapper, gnupg
}:

assert spellChecking -> gtkspell2 != null;

let version = "0.144"; in

stdenv.mkDerivation {
  name = "pan-${version}";

  src = fetchurl {
    url = "http://pan.rebelbase.com/download/releases/${version}/source/pan-${version}.tar.bz2";
    sha256 = "0l07y75z8jxhbmfv28slw81gjncs7i89x7fq44zif7xhq5vy7yli";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ gtk2 perl gmime gettext gnupg intltool itstool libxml2 dbus-glib libnotify ]
    ++ stdenv.lib.optional spellChecking gtkspell2;

  postInstall = ''
    wrapProgram $out/bin/pan --suffix PATH : ${gnupg}/bin
  '';

  enableParallelBuilding = true;

  meta = {
    description = "A GTK+-based Usenet newsreader good at both text and binaries";
    homepage = http://pan.rebelbase.com/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
