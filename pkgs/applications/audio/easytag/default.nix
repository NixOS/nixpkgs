{ stdenv, fetchurl, pkgconfig, intltool, gtk3, glib, libid3tag, id3lib, taglib
, libvorbis, libogg, flac, itstool, libxml2, gsettings_desktop_schemas
, makeWrapper, gnome3
}:

stdenv.mkDerivation rec {
  name = "easytag-${version}";
  majorVersion = "2.4";
  version = "${majorVersion}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/easytag/${majorVersion}/${name}.tar.xz";
    sha256 = "1mbpwp3lh6yz5xkaq3a329x4r3chmjsr83r349crhi1gax3mzvxr";
  };

  preFixup = ''
    wrapProgram $out/bin/easytag \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:$out/share" \
      --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules"
  '';

  NIX_LDFLAGS = "-lid3tag -lz";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    pkgconfig intltool gtk3 glib libid3tag id3lib taglib libvorbis libogg flac
    itstool libxml2 gsettings_desktop_schemas gnome3.defaultIconTheme gnome3.dconf
  ];

  meta = {
    description = "View and edit tags for various audio files";
    homepage = "http://projects.gnome.org/easytag/";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
