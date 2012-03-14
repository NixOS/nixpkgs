{ stdenv, fetchurl, pkgconfig, telepathy_glib, libxslt }:

stdenv.mkDerivation rec {
  name = "${pname}-5.11.0";
  pname = "telepathy-mission-control";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "19fz1lrsvrm0p58wkxhjn7xyickz8bgzks4mkhlvgp692ypvvppm";
  };

  buildInputs = [ telepathy_glib ];

  buildNativeInputs = [ pkgconfig libxslt ];
}
