{ lib, stdenv, fetchurl, fetchpatch, pidgin, telepathy-glib, python2, glib, dbus-glib, pkg-config, libxslt }:

stdenv.mkDerivation rec {
  pname = "telepathy-haze";
  version = "0.8.0";

  src = fetchurl {
    url = "https://telepathy.freedesktop.org/releases/telepathy-haze/telepathy-haze${version}.tar.gz";
    sha256 = "1jgrp32p6rllj089ynbsk3n9xrvsvzmwzhf0ql05kkgj0nf08xiy";
  };

  buildInputs = [ glib telepathy-glib dbus-glib pidgin python2 ];

  nativeBuildInputs = [ pkg-config libxslt ];

  patches = [
    # Patch from Gentoo that helps telepathy-haze build with more
    # recent versions of pidgin.
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/gentoo/master/net-voip/telepathy-haze/files/telepathy-haze-0.8.0-pidgin-2.10.12-compat.patch";
      sha256 = "0fa1p4n1559qd096w7ya4kvfnc1c98ykarkxzlpkwvzbczwzng3c";
    })
  ];

  meta = {
    description = "A Telepathy connection manager based on libpurple";
    platforms = lib.platforms.gnu ++ lib.platforms.linux; # Random choice
  };
}
