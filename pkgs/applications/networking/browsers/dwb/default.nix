{ stdenv, fetchgit, pkgconfig, makeWrapper, libsoup, webkit, gtk3, gnutls, json_c,
  m4, glib_networking, gsettings_desktop_schemas }:

stdenv.mkDerivation {
  name = "dwb-0.1";

  src = fetchgit {
    url = "https://bitbucket.org/portix/dwb.git";
    rev = "4a4c3adb8fbc680a0a2b8c9d3d3a4105c07c2514";
    sha256 = "93e8f2c82609447d54a3c139c153cc66d37d3c6aa8922cd09717caa95fd8b1d5";
  };

  buildInputs = [ pkgconfig makeWrapper libsoup webkit gtk3 gnutls json_c m4  ];

  # There are Xlib and gtk warnings therefore I have set Wno-error
  preBuild=''
    makeFlagsArray=(CPPFLAGS="-Wno-error" GTK=3 PREFIX=$out);
  '';

  postInstall=''
    wrapProgram "$out/bin/dwb" \
     --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
     --prefix XDG_DATA_DIRS : "${gsettings_desktop_schemas}/share:$out/share"
  '';

  meta = {
    homepage = http://portix.bitbucket.org/dwb/;
    description = "A lightweight web browser based on the webkit web browser engine and the gtk toolkit";
    platforms = stdenv.lib.platforms.mesaPlatforms;
    maintainers = [ stdenv.lib.maintainers.pSub ];
    license = "GPL";
  };
}
