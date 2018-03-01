{ stdenv, fetchurl, pkgconfig, intltool, gtk3, glib, libid3tag, id3lib, taglib
, libvorbis, libogg, flac, itstool, libxml2, gsettings-desktop-schemas
, makeWrapper, gnome3
}:

stdenv.mkDerivation rec {
  name = "easytag-${version}";
  majorVersion = "2.4";
  version = "${majorVersion}.3";

  src = fetchurl {
    url = "mirror://gnome/sources/easytag/${majorVersion}/${name}.tar.xz";
    sha256 = "1mbxnqrw1fwcgraa1bgik25vdzvf97vma5pzknbwbqq5ly9fwlgw";
  };

  preFixup = ''
    wrapProgram $out/bin/easytag \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:$out/share" \
      --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib gnome3.dconf}/lib/gio/modules"
  '';

  NIX_LDFLAGS = "-lid3tag -lz";

  nativeBuildInputs = [ makeWrapper pkgconfig intltool ];
  buildInputs = [
    gtk3 glib libid3tag id3lib taglib libvorbis libogg flac
    itstool libxml2 gsettings-desktop-schemas gnome3.defaultIconTheme (stdenv.lib.getLib gnome3.dconf)
  ];

  meta = with stdenv.lib; {
    description = "View and edit tags for various audio files";
    homepage = http://projects.gnome.org/easytag/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fuuzetsu ];
    platforms = platforms.linux;
  };
}
