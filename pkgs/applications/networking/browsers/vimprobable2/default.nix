{stdenv, fetchurl, makeWrapper, perl, pkgconfig, webkit, gtk, libX11, libsoup,
glib_networking}:

stdenv.mkDerivation {
  name = "vimprobable2-0.9.11.2";
  src = fetchurl {
    url = "mirror://sourceforge/vimprobable/vimprobable2_0.9.11.2.tar.bz2";
    sha256 = "017qwhndchmpsn2g38v85rjx00fss69aa1nmgj3v85k5zskv7z65";
  };
  buildInputs = [ makeWrapper perl pkgconfig libX11 libsoup webkit gtk ];
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
    license = "MIT";
    maintainers = ["Alexander Foremny <alexanderforemny@googlemail.com>"];
  };
}

