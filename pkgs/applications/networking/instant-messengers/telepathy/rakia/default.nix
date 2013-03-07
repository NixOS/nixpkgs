{ stdenv, fetchurl, pkgconfigUpstream, libxslt, telepathy_glib, libxml2, dbus_glib
, python, sofia_sip }:

stdenv.mkDerivation rec {
  pname = "telepathy-rakia";
  name = "${pname}-0.7.4";

  src = fetchurl {
    url = "${meta.homepage}/releases/${pname}/${name}.tar.gz";
    sha256 = "11cmmdq31kivm6nsv61hxy3hxnnmbd8sj55xqwx9hyqzybh70dyf";
  };

  nativeBuildInputs = [pkgconfigUpstream libxslt python];
  buildInputs = [ libxml2 dbus_glib telepathy_glib sofia_sip];

  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
