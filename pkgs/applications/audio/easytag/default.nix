{ stdenv, fetchurl, pkgconfig, intltool, gtk3, glib, libid3tag, id3lib, taglib
, libvorbis, libogg, flac, itstool, libxml2, gsettings_desktop_schemas
, makeWrapper, gnome_icon_theme
}:

stdenv.mkDerivation rec {
  name = "easytag-${version}";
  version = "2.3.2";

  src = fetchurl {
    url = "mirror://gnome/sources/easytag/2.3/${name}.tar.xz";
    sha256 = "0bj3sj4yzlnhan38j84acs7qv27fl3xy4rdrfq6dnpz4q6qccm84";
  };

  preFixup = ''
    wrapProgram $out/bin/easytag \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:$out/share"
  '';

  NIX_LDFLAGS = "-lid3tag -lz";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    pkgconfig intltool gtk3 glib libid3tag id3lib taglib libvorbis libogg flac
    itstool libxml2 gsettings_desktop_schemas gnome_icon_theme
  ];

  meta = {
    description = "View and edit tags for various audio files";
    homepage = "http://projects.gnome.org/easytag/";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
