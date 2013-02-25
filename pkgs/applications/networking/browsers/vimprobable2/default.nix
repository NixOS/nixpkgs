{ stdenv, fetchurl, makeWrapper, glib_networking, gtk, libsoup, libX11, perl,
  pkgconfig, webkit }:

stdenv.mkDerivation {
  name = "vimprobable2-1.2.0";
  src = fetchurl {
    url = "mirror://sourceforge/vimprobable/vimprobable2_1.2.0.tar.bz2";
    sha256 = "0fjakrmz1syjwgx01j2icpdv69jgvfl2nlxbj8zxfr8mw0h2wg1f";
  };

  # Nixos default ca bundle
  patchPhase = ''
    sed -i s,/etc/ssl/certs/ca-certificates.crt,/etc/ca-bundle.crt, config.h
  '';

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
