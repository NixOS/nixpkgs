{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk3, gtkspell3 ? null
, perl, gmime2, gettext, intltool, itstool, libxml2, dbus-glib, libnotify, gnutls
, makeWrapper, gnupg
, gnomeSupport ? true, libsecret, gcr
}:

assert spellChecking -> gtkspell3 != null;

let version = "0.145"; in

stdenv.mkDerivation {
  name = "pan-${version}";

  src = fetchurl {
    url = "http://pan.rebelbase.com/download/releases/${version}/source/pan-${version}.tar.bz2";
    sha256 = "1b4wamv33hprghcjk903bpvnd233yxyrm18qnh13alc8h1553nk8";
  };

  nativeBuildInputs = [ pkgconfig gettext intltool itstool libxml2 makeWrapper ];
  buildInputs = [ gtk3 gmime2 libnotify gnutls ]
    ++ stdenv.lib.optional spellChecking gtkspell3
    ++ stdenv.lib.optionals gnomeSupport [ libsecret gcr ];

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
