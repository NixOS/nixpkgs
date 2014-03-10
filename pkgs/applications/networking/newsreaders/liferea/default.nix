{ stdenv, fetchurl, pkgconfig, intltool, python, pygobject3
, glib, gnome3, pango, libxml2, libxslt, sqlite, libsoup
, webkitgtk, json_glib, gobjectIntrospection, gsettings_desktop_schemas
, gst_all_1
, libnotify
, makeWrapper
}:

let pname = "liferea";
    version = "1.10.6";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/lwindolf/${pname}/releases/download/v${version}/${name}.tar.gz";
    sha256 = "0vp19z4p3cn3zbg1zjpg2iyzwq893dx5c1kh6aac06s3rf1124gm";
  };

  buildInputs = with gst_all_1; [
    pkgconfig intltool python
    glib gnome3.gtk pango libxml2 libxslt sqlite libsoup
    webkitgtk json_glib gobjectIntrospection gsettings_desktop_schemas
    gnome3.libpeas
    gst-plugins-base gst-plugins-good gst-plugins-bad
    gnome3.gnome_keyring
    libnotify
    makeWrapper
  ];

  preFixup = ''
    rm $out/share/icons/hicolor/icon-theme.cache'';

  postInstall  = ''
    for f in "$out"/bin/*; do
      wrapProgram "$f" \
        --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${pygobject3})" \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gnome3.gnome_icon_theme}/share:${gsettings_desktop_schemas}/share:${gnome3.gtk}/share:$out/share"
    done
  '';

  meta = {
    description = "A GTK-based news feed agregator";
    homepage = http://lzone.de/liferea/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ vcunat romildo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
