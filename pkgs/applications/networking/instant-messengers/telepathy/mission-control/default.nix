{ stdenv, fetchurl, pkgconfig, telepathy_glib, libxslt }:

stdenv.mkDerivation rec {
  name = "${pname}-5.14.1";
  pname = "telepathy-mission-control";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "1jqzby5sr09bprp3fyr8w65rcv9ljc045rp7lm9ik89wkhcw05jb";
  };

  buildInputs = [ telepathy_glib ];

  nativeBuildInputs = [ pkgconfig libxslt ];
}
