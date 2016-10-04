{ stdenv, fetchurl, gettext, gtk3, pythonPackages
, gdk_pixbuf, libnotify, gst_all_1
, libgnome_keyring3 ? null, networkmanager ? null
}:

pythonPackages.buildPythonApplication rec {
  name = "mailnag-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/pulb/mailnag/archive/v${version}.tar.gz";
    sha256 = "0li4kvxjmbz3nqg6bysgn2wdazqrd7gm9fym3rd7148aiqqwa91r";
  };

  buildInputs = [
    gettext gtk3 pythonPackages.pygobject3 pythonPackages.dbus-python
    pythonPackages.pyxdg gdk_pixbuf libnotify gst_all_1.gstreamer
    gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad libgnome_keyring3 networkmanager
  ];

  preFixup = ''
    for script in mailnag mailnag-config; do
      wrapProgram $out/bin/$script \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share" \
        --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  meta = with stdenv.lib; {
    description = "An extensible mail notification daemon";
    homepage = https://github.com/pulb/mailnag;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
