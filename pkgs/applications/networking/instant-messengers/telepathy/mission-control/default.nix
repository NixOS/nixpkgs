{ stdenv, fetchurl, pkgconfig, telepathy_glib, libxslt }:

stdenv.mkDerivation rec {
  name = "${pname}-5.14.0";
  pname = "telepathy-mission-control";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "0c4asjgk7pk39i8njf0q1df0mhisif83lq716ln6r0wja9zh9q2q";
  };

  buildInputs = [ telepathy_glib ];

  nativeBuildInputs = [ pkgconfig libxslt ];
}
