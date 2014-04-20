{ stdenv, fetchurl, pkgconfig, telepathy_glib, libxslt, makeWrapper }:

stdenv.mkDerivation rec {
  name = "${pname}-5.16.0";
  pname = "telepathy-mission-control";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "1l61w6j04mbrjsbcfrlc0safh9nlsjnj0z6lszal64r9bhkcghzd";
  };

  buildInputs = [ telepathy_glib makeWrapper ];

  nativeBuildInputs = [ pkgconfig libxslt ];

  preFixup = ''
    wrapProgram "$out/libexec/mission-control-5" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';
}
