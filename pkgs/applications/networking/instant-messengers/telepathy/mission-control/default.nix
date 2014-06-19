{ stdenv, fetchurl, pkgconfig, telepathy_glib, libxslt, makeWrapper, upower }:

stdenv.mkDerivation rec {
  name = "${pname}-5.16.2";
  pname = "telepathy-mission-control";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "1sk8f9jfaxgbsniz0n5hmrcwvxla3x8axjcnjbppg7nidk9gijrx";
  };

  buildInputs = [ telepathy_glib makeWrapper upower ]; # ToDo: optional stuff missing

  nativeBuildInputs = [ pkgconfig libxslt ];

  doCheck = true;

  preFixup = ''
    wrapProgram "$out/libexec/mission-control-5" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "An account manager and channel dispatcher for the Telepathy framework";
    homepage = http://telepathy.freedesktop.org/wiki/;
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
