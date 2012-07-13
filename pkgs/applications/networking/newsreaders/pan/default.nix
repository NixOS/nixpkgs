{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk, gtkspell ? null
, perl, pcre, gmime, gettext, intltool, dbus_glib, libnotify
}:

assert spellChecking -> gtkspell != null;

let version = "0.139"; in

stdenv.mkDerivation {
  name = "pan-${version}";

  src = fetchurl {
    url = "http://pan.rebelbase.com/download/releases/${version}/source/pan-${version}.tar.bz2";
    sha1 = "01ea0361a6d81489888e6abb075fd552999c3c60";
  };

  buildInputs = [ pkgconfig gtk perl gmime gettext intltool dbus_glib libnotify ]
    ++ stdenv.lib.optional spellChecking gtkspell;

  enableParallelBuilding = true;

  meta = {
    description = "A GTK+-based Usenet newsreader good at both text and binaries";
    homepage = http://pan.rebelbase.com/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
