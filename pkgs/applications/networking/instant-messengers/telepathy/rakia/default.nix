{ stdenv, fetchurl, pkgconfig, libxslt, telepathy_glib, libxml2, dbus_glib
, python, sofia_sip }:

stdenv.mkDerivation rec {
  pname = "telepathy-rakia";
  name = "${pname}-0.7.3";

  src = fetchurl {
    url = "${meta.homepage}/releases/${pname}/${name}.tar.gz";
    sha256 = "1jnxlx135c660vb1n2vpg6ci2ps0rbrp3244jgchik3g6q5vwbb4";
  };

  buildNativeInputs = [pkgconfig libxslt python];
  buildInputs = [ libxml2 dbus_glib telepathy_glib sofia_sip];

  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
