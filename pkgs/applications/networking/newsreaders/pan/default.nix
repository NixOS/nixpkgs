{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk3, gtkspell3 ? null
, perl, pcre, gmime2, gettext, intltool, itstool, libxml2, dbus-glib, libnotify, gnutls
, makeWrapper, gnupg
, gnomeSupport ? true, libgnome-keyring3
}:

assert spellChecking -> gtkspell3 != null;

let version = "0.144"; in

stdenv.mkDerivation {
  name = "pan-${version}";

  src = fetchurl {
    url = "http://pan.rebelbase.com/download/releases/${version}/source/pan-${version}.tar.bz2";
    sha256 = "0l07y75z8jxhbmfv28slw81gjncs7i89x7fq44zif7xhq5vy7yli";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ gtk3 perl gmime2 gettext intltool itstool libxml2 dbus-glib libnotify gnutls ]
    ++ stdenv.lib.optional spellChecking gtkspell3
    ++ stdenv.lib.optional gnomeSupport libgnome-keyring3;

  configureFlags = [
    "--with-dbus"
    "--with-gtk3"
    "--with-gnutls"
    "--enable-libnotify"
  ] ++ stdenv.lib.optional spellChecking "--with-gtkspell"
    ++ stdenv.lib.optional gnomeSupport "--enable-gkr";

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
