{ stdenv, fetchurl, pkgconfig, gnome3, telepathy-glib, libxslt, makeWrapper }:

stdenv.mkDerivation rec {
  name = "${pname}-5.16.4";
  pname = "telepathy-mission-control";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "1jz6wwgsfxixha6ys2hbzbk5faqnj9kh2m5qdlgx5anqgandsscp";
  };

  buildInputs = [ telepathy-glib telepathy-glib.python ]; # ToDo: optional stuff missing

  nativeBuildInputs = [ pkgconfig libxslt makeWrapper ];

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
