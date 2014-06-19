{ stdenv, fetchgit, pkgconfig, makeWrapper, libsoup, webkit, gtk3, gnutls, json_c,
  m4, glib_networking, gsettings_desktop_schemas }:

stdenv.mkDerivation {
  name = "dwb-2014-06-17";

  src = fetchgit {
    url = "https://bitbucket.org/portix/dwb.git";
    rev = "9f4bdb9a1f8d5e45071019da4626231dfebd4d8e";
    sha256 = "1nj34w2hhw47jsmswsc1y6a09my8zdd01qxwai8dxdvisld3marm";
  };

  buildInputs = [ pkgconfig makeWrapper gsettings_desktop_schemas libsoup webkit gtk3 gnutls json_c m4 ];

  # There are Xlib and gtk warnings therefore I have set Wno-error
  preBuild=''
    makeFlagsArray=(CPPFLAGS="-Wno-error" GTK=3 PREFIX=$out);
  '';

  preFixup=''
    wrapProgram "$out/bin/dwb" \
     --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
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
