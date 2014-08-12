{ stdenv, fetchgit, pkgconfig, makeWrapper, libsoup, webkitgtk2, gtk2, gnutls, json_c,
  m4, glib_networking, gsettings_desktop_schemas, dconf }:

stdenv.mkDerivation {
  name = "dwb-2014-07-03";

  src = fetchgit {
    url = "https://bitbucket.org/portix/dwb.git";
    rev = "6224470489eb5ba92987e01396269f8b7cd78ada";
    sha256 = "04p9frsnh1qz067cw36anvr41an789fba839svdjrdva0f2751g8";
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

  meta = {
    homepage = http://portix.bitbucket.org/dwb/;
    description = "A lightweight web browser based on the webkit web browser engine and the gtk toolkit";
    platforms = stdenv.lib.platforms.mesaPlatforms;
    maintainers = [ stdenv.lib.maintainers.pSub ];
    license = "GPL";
  };
}
