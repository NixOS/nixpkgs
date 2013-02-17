{ stdenv, fetchurl, pkgconfig, libxslt, telepathy_glib, libxml2, dbus_glib
, sqlite, libsoup, libnice, gnutls }:

stdenv.mkDerivation rec {
  name = "telepathy-gabble-0.16.0";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-gabble/${name}.tar.gz";
    sha256 = "0fk65f7q75z3wm5h4wad7g5sm2j6r8v2845b74ycl29br78ki2hf";
  };

  nativeBuildInputs = [pkgconfig libxslt];
  buildInputs = [ libxml2 dbus_glib sqlite libsoup libnice telepathy_glib gnutls ];

  configureFlags = "--with-ca-certificates=/etc/ca-bundle.crt";
  
  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
