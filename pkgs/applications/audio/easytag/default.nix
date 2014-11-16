{ stdenv, fetchurl, pkgconfig, intltool, gtk3, glib, libid3tag, id3lib, taglib
, libvorbis, libogg, flac, itstool, libxml2, gsettings_desktop_schemas
, makeWrapper, gnome_icon_theme
}:

stdenv.mkDerivation rec {
  name = "easytag-${version}";
  version = "2.3.1";

  src = fetchurl {
    url = "mirror://gnome/sources/easytag/2.3/${name}.tar.xz";
    sha256 = "19cdx4hma4nl38m1zrc3mq9cjg6knw970abk5anhg7cvpc1371s7";
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
