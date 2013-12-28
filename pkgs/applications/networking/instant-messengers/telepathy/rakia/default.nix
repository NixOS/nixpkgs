{ stdenv, fetchurl, pkgconfigUpstream, libxslt, telepathy_glib, libxml2, dbus_glib
, python, sofia_sip }:

stdenv.mkDerivation rec {
  pname = "telepathy-rakia";
  name = "${pname}-0.8.0";

  src = fetchurl {
    url = "${meta.homepage}/releases/${pname}/${name}.tar.gz";
    sha256 = "18dxffa8hhjyvqkhhac05rrkx81vnncjrakg5ygikfp0j79vrbhv";
  };

  nativeBuildInputs = [pkgconfigUpstream libxslt python];
  buildInputs = [ libxml2 dbus_glib telepathy_glib sofia_sip];

  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
