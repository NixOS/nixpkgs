{ stdenv
, fetchurl
, pkgconfig
, gnome3
, telepathy-glib
, python3
, libxslt
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "telepathy-mission-control";
  version = "5.16.5";

  src = fetchurl {
    url = "https://telepathy.freedesktop.org/releases/${pname}/${pname}-${version}.tar.gz";
    sha256 = "00xxv38cfdirnfvgyd56m60j0nkmsv5fz6p2ydyzsychicxl6ssc";
  };

  buildInputs = [
    telepathy-glib
    python3
  ]; # ToDo: optional stuff missing

  nativeBuildInputs = [
    pkgconfig
    libxslt
    makeWrapper
  ];

  doCheck = true;

  preFixup = ''
    wrapProgram "$out/libexec/mission-control-5" \
      --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib gnome3.dconf}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "An account manager and channel dispatcher for the Telepathy framework";
    homepage = https://telepathy.freedesktop.org/components/telepathy-mission-control/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
