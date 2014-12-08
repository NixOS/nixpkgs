{ stdenv, fetchurl, glib, pkgconfig, dbus_glib, telepathy_glib, libxslt }:

stdenv.mkDerivation rec {
  pname = "telepathy-idle";
  version = "0.2.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "1argdzbif1vdmwp5vqbgkadq9ancjmgdm2ncp0qfckni715ss4rh";
  };

  buildInputs = [ pkgconfig glib telepathy_glib dbus_glib libxslt ];

  meta = {
    description = "IRC connection manager for the Telepathy framework";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.gnu;
  };
}
