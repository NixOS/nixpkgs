{ stdenv, fetchgit, pkgconfig, makeWrapper, libsoup, webkit, gtk3, gnutls, json_c,
  m4, glib_networking, gsettings_desktop_schemas }:

stdenv.mkDerivation {
  name = "dwb-0.1";

  src = fetchgit {
    url = "https://bitbucket.org/portix/dwb.git";
    rev = "84a8621787baded72e84afdd5cdda278cb81e007";
    sha256 = "5a32f3c21ad59b43935a16108244f84d260fafaea9b93d41e8de9ba9089ee7b0";
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
    platforms = with stdenv.lib.platforms; all;
    maintainers = with stdenv.lib.maintainers; [pSub];
    license = "GPL";
  };
}
