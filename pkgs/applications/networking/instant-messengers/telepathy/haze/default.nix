{ stdenv, fetchurl, pidgin, telepathy_glib, glib, dbus_glib, pkgconfig, libxslt }:

stdenv.mkDerivation rec {
  pname = "telepathy-haze";
  name = "${pname}-0.8.0";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "1jgrp32p6rllj089ynbsk3n9xrvsvzmwzhf0ql05kkgj0nf08xiy";
  };

  buildInputs = [ glib telepathy_glib dbus_glib pidgin ];

  nativeBuildInputs = [ pkgconfig libxslt ];

  meta = {
    description = "A Telepathy connection manager based on libpurple";
    platforms = stdenv.lib.platforms.gnu; # Random choice
  };
}
