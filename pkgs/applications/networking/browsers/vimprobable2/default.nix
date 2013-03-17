{ stdenv, fetchurl, makeWrapper, glib, glib_networking, gtk, libsoup, libX11, perl,
  pkgconfig, webkit, gsettings_desktop_schemas }:

stdenv.mkDerivation rec {
  version = "1.2.1";
  name = "vimprobable2-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/vimprobable/vimprobable2_${version}.tar.bz2";
    sha256 = "19zx1k3s2gnhzzd2wpyqsk151w9p52ifl64xaz9a6qkgvrxlli8p";
  };

  # Nixos default ca bundle
  patchPhase = ''
    sed -i s,/etc/ssl/certs/ca-certificates.crt,/etc/ca-bundle.crt, config.h
  '';

  buildInputs = [ makeWrapper gtk libsoup libX11 perl pkgconfig webkit ];

  installPhase = ''
    make PREFIX=/ DESTDIR=$out install
    wrapProgram "$out/bin/vimprobable2" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "${gsettings_desktop_schemas}/share"
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
