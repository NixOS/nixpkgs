{ stdenv, fetchurl, makeWrapper, glib_networking, gtk, libsoup, libX11, perl,
  pkgconfig, webkit }:

stdenv.mkDerivation {
  name = "vimprobable2-1.0.2";
  src = fetchurl {
    url = "mirror://sourceforge/vimprobable/vimprobable2_1.0.2.tar.bz2";
    sha256 = "19gwlfv0lczbns73xg3637q7ixly62y3ijccnv0m1bqaqxjl4v8x";
  };
  buildInputs = [ makeWrapper gtk libsoup libX11 perl pkgconfig webkit ];
  installPhase = ''
    make PREFIX=/ DESTDIR=$out install
    wrapProgram "$out/bin/vimprobable2" --prefix GIO_EXTRA_MODULES : \
      ${glib_networking}/lib/gio/modules
  '';

  meta = {
    description = ''
      Vimprobable is a web browser that behaves like the Vimperator plugin
      available for Mozilla Firefox
    '';
    longDescription = ''
      Vimprobable is a web browser that behaves like the Vimperator plugin
      available for Mozilla Firefox. It is based on the WebKit engine (using
      GTK bindings). The goal of Vimprobable is to build a completely
      keyboard-driven, efficient and pleasurable browsing-experience. Its
      featureset might be considered "minimalistic", but not as minimalistic as
      being completely featureless. 
    '';
    homepage = "http://sourceforge.net/apps/trac/vimprobable";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.aforemny ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
