{ stdenv, fetchgit, pkgconfig, makeWrapper, libsoup, webkitgtk2, gtk2, gnutls
, json_c, m4, glib_networking, gsettings_desktop_schemas, dconf }:

stdenv.mkDerivation {
  name = "dwb-2015-07-07";

  src = fetchgit {
    url = "https://bitbucket.org/0mark/dwb_collect";
    rev = "9a50dcc7134015c6cb1d26afb77840cf69f7c782";
    sha256 = "03nyr3c0x5b1jqax0zh407vvi4j47zkj1i52lqs35j2d2sci3lkb";
  };

  buildInputs = [ pkgconfig makeWrapper gsettings_desktop_schemas libsoup
    webkitgtk2 gtk2 gnutls json_c m4 ];

  # There are Xlib and gtk warnings therefore I have set Wno-error
  makeFlags = ''PREFIX=$(out) GTK=2 CPPFLAGS="-Wno-error"'';

  preFixup=''
    wrapProgram "$out/bin/dwb" \
     --prefix GIO_EXTRA_MODULES : "${glib_networking.out}/lib/gio/modules:${dconf}/lib/gio/modules" \
     --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
    wrapProgram "$out/bin/dwbem" \
     --prefix GIO_EXTRA_MODULES : "${glib_networking.out}/lib/gio/modules"
  '';

  meta = with stdenv.lib; {
    homepage = http://portix.bitbucket.org/dwb/;
    description = "A lightweight web browser based on the webkit web browser engine and the gtk toolkit";
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ pSub ];
    license = licenses.gpl3;

    # dwb is no longer maintained by portix and efforts to keep it alive
    # were not successful, see issue #7952 for discussion.
    broken = true;
  };
}
