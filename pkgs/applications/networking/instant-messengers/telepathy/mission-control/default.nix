{ stdenv, fetchurl, pkgconfig, gnome3, telepathy_glib, libxslt, makeWrapper, upower }:

stdenv.mkDerivation rec {
  name = "${pname}-5.16.3";
  pname = "telepathy-mission-control";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "0zcbx69k0d3p2pjh3g7sa3q2zkd5xchxkqsmlfn3fwxaz0pmsmvi";
  };

  buildInputs = [ telepathy_glib telepathy_glib.python makeWrapper /*upower*/ ]; # ToDo: optional stuff missing
  # 5.16.3 won't build with upower-0.99. Arch and Debian choose to disable it

  nativeBuildInputs = [ pkgconfig libxslt ];

  doCheck = true;

  preFixup = ''
    wrapProgram "$out/libexec/mission-control-5" \
      --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib gnome3.dconf}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "An account manager and channel dispatcher for the Telepathy framework";
    homepage = http://telepathy.freedesktop.org/wiki/;
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
