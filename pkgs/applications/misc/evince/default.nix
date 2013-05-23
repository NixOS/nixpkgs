{ fetchurl, stdenv, perl, perlXMLParser, gettext, intltool
, pkgconfig, glib, gtk, gnomedocutils, gnomeicontheme
, libgnome, libgnomeui, scrollkeeper, libxslt
, libglade, libgnome_keyring, dbus, dbus_glib
, poppler, libspectre, djvulibre, shared_mime_info
, makeWrapper, which, ghostscript
, recentListSize ? null # 5 is not enough, allow passing a different number
}:

stdenv.mkDerivation rec {
  name = "evince-2.32.0";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/evince/2.32/${name}.tar.bz2";
    sha256 = "2a4c91ae38f8b5028cebb91b9da9ddc50ea8ae3f3d429df89ba351da2d787ff7";
  };

  buildInputs = [
    perl perlXMLParser gettext intltool pkgconfig glib gtk
    gnomedocutils gnomeicontheme libgnome libgnomeui libglade
    scrollkeeper libgnome_keyring
    libxslt  # for `xsltproc'
    dbus dbus_glib poppler libspectre djvulibre makeWrapper which
    ghostscript
  ];

  configureFlags = "--with-libgnome --enable-dbus --enable-pixbuf "

    # Do not use nautilus
    + " --disable-nautilus "
    # Do not update Scrollkeeper's database (GNOME's help system).
    + "--disable-scrollkeeper";

  postUnpack = if recentListSize != null then ''
    sed -i 's/\(gtk_recent_chooser_set_limit .*\)5)/\1${builtins.toString recentListSize})/' */shell/ev-open-recent-action.c
    sed -i 's/\(if (++n_items == \)5\(.*\)/\1${builtins.toString recentListSize}\2/' */shell/ev-window.c
  '' else "";

  postInstall = ''
    # Tell Glib/GIO about the MIME info directory, which is used
    # by `g_file_info_get_content_type ()'.
    wrapProgram "$out/bin/evince" \
      --prefix XDG_DATA_DIRS : "${shared_mime_info}/share:$out/share"
  '';

  meta = {
    homepage = http://www.gnome.org/projects/evince/;
    description = "Evince, GNOME's document viewer";

    longDescription = ''
      Evince is a document viewer for multiple document formats.  It
      currently supports PDF, PostScript, DjVu, TIFF and DVI.  The goal
      of Evince is to replace the multiple document viewers that exist
      on the GNOME Desktop with a single simple application.
    '';

    license = "GPLv2+";
  };
}
