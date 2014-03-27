{ stdenv, fetchurl, pkgconfig, intltool, python, pygobject3
, glib, gnome3, pango, libxml2, libxslt, sqlite, libsoup, glib_networking
, webkitgtk, json_glib, gobjectIntrospection, gst_all_1
, libnotify
, makeWrapper
}:

let pname = "liferea";
    version = "1.10.8";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/lwindolf/${pname}/releases/download/v${version}/${name}.tar.bz2";
    sha256 = "1d3icma90mj0nai20pfhxp4k4l33iwkkkcddb9vg5hi4yq4wpmwx";
  };

  buildInputs = with gst_all_1; [
    pkgconfig intltool python
    glib gnome3.gtk pango libxml2 libxslt sqlite libsoup
    webkitgtk json_glib gobjectIntrospection gnome3.gsettings_desktop_schemas
    gnome3.libpeas gnome3.dconf
    gst-plugins-base gst-plugins-good gst-plugins-bad
    gnome3.libgnome_keyring
    libnotify
    makeWrapper
  ];

  preFixup = ''
    rm $out/share/icons/hicolor/icon-theme.cache'';

  postInstall  = ''
    for f in "$out"/bin/*; do
      wrapProgram "$f" \
        --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${pygobject3})" \
        --prefix LD_LIBRARY_PATH : "${gnome3.libgnome_keyring}/lib" \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
        --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules:${glib_networking}/lib/gio/modules" \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gnome3.gnome_icon_theme}/share:${gnome3.gsettings_desktop_schemas}/share:${gnome3.gtk}/share:$out/share"
    done
  '';

  meta = {
    description = "A GTK-based news feed agregator";
    homepage = http://lzone.de/liferea/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ vcunat romildo ];
    platforms = stdenv.lib.platforms.linux;

    longDescription = ''
      Liferea (Linux Feed Reader) is an RSS/RDF feed reader.
      It's intended to be a clone of the Windows-only FeedReader.
      It can be used to maintain a list of subscribed feeds,
      browse through their items, and show their contents.
    '';
  };
}
