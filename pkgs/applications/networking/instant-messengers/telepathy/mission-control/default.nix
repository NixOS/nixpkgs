{ stdenv, fetchurl, pkgconfig, telepathy_glib, libxslt }:

stdenv.mkDerivation rec {
  name = "${pname}-5.12.0";
  pname = "telepathy-mission-control";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "0xsycjk2l19h026adqms8ik7c2xj9j9rba76znfh46ryaijyn2k6";
  };

  buildInputs = [ telepathy_glib ];

  nativeBuildInputs = [ pkgconfig libxslt ];
}
