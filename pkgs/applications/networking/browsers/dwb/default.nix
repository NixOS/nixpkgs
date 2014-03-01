{ stdenv, fetchgit, pkgconfig, makeWrapper, libsoup, webkit, gtk3, gnutls, json_c,
  m4, glib_networking, gsettings_desktop_schemas }:

stdenv.mkDerivation {
  name = "dwb-2014-03-01";

  src = fetchgit {
    url = "https://bitbucket.org/portix/dwb.git";
    rev = "e8d4b8d7937b70279d006da4938dfe52fb85f9e8";
    sha256 = "0m4730zqmnvb9k6xyydi221sh0wbanzbhg07xvwil3kn1d29340w";
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
