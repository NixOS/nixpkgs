{ lib, stdenv, fetchurl, fetchpatch, pidgin, telepathy-glib, python3, glib, dbus-glib, pkg-config, libxslt }:

stdenv.mkDerivation rec {
  pname = "telepathy-haze";
  version = "0.8.1";

  src = fetchurl {
    url = "https://telepathy.freedesktop.org/releases/telepathy-haze/telepathy-haze-${version}.tar.gz";
    hash = "sha256-cEvvpC7sIXPspLrAH/0AQBRmXyutRtyJSOVCM2TN4wo=";
  };

  buildInputs = [ glib telepathy-glib dbus-glib pidgin ];

  nativeBuildInputs = [ pkg-config libxslt python3 ];

  meta = {
    description = "A Telepathy connection manager based on libpurple";
    platforms = lib.platforms.gnu ++ lib.platforms.linux; # Random choice
  };
}
