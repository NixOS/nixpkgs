{ stdenv, fetchurl, fetchpatch, pidgin, telepathy-glib, glib, dbus-glib, pkgconfig, libxslt }:

stdenv.mkDerivation rec {
  pname = "telepathy-haze";
  name = "${pname}-0.8.0";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "1jgrp32p6rllj089ynbsk3n9xrvsvzmwzhf0ql05kkgj0nf08xiy";
  };

  buildInputs = [ glib telepathy-glib dbus-glib pidgin telepathy-glib.python ];

  nativeBuildInputs = [ pkgconfig libxslt ];

  patches = [
    # Patch from Gentoo that helps telepathy-haze build with more
    # recent versions of pidgin.
    (fetchpatch {
      url = https://raw.githubusercontent.com/gentoo/gentoo/master/net-voip/telepathy-haze/files/telepathy-haze-0.8.0-pidgin-2.10.12-compat.patch;
      sha256 = "0fa1p4n1559qd096w7ya4kvfnc1c98ykarkxzlpkwvzbczwzng3c";
    })
  ];

  meta = {
    description = "A Telepathy connection manager based on libpurple";
    platforms = stdenv.lib.platforms.gnu; # Random choice
  };
}
