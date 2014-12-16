{ stdenv, fetchgit, pkgconfig, makeWrapper, libsoup, webkitgtk2, gtk2, gnutls, json_c,
  m4, glib_networking, gsettings_desktop_schemas, dconf }:

stdenv.mkDerivation {
  name = "dwb-2014-12-15";

  src = fetchgit {
    url = "https://bitbucket.org/0mark/dwb_collect";
    rev = "b94785470b11a0b6b52eecfc3bae276796b83a0d";
    sha256 = "09xbifj223mflj62rfhi6q7cvnkpkzkwyyqhkm8w067pdscdhyvs";
  };

  buildInputs = [ pkgconfig makeWrapper gsettings_desktop_schemas libsoup webkitgtk2 gtk2 gnutls json_c m4 ];

  # There are Xlib and gtk warnings therefore I have set Wno-error
  makeFlags = ''PREFIX=$(out) GTK=2 CPPFLAGS="-Wno-error"'';

  preFixup=''
    wrapProgram "$out/bin/dwb" \
     --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules:${dconf}/lib/gio/modules" \
     --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
    wrapProgram "$out/bin/dwbem" \
     --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules"
  '';

  meta = with stdenv.lib; {
    homepage = http://portix.bitbucket.org/dwb/;
    description = "A lightweight web browser based on the webkit web browser engine and the gtk toolkit";
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers;[ pSub ];
    license = licenses.gpl3;
  };
}
