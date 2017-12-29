{ stdenv, fetchurl, makeWrapper, glib, glib_networking, gtk2, libsoup, libX11, perl,
  pkgconfig, webkit, gsettings_desktop_schemas }:

stdenv.mkDerivation rec {
  version = "1.4.2";
  name = "vimprobable2-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/vimprobable/vimprobable2_${version}.tar.bz2";
    sha256 = "13jdximksh9r3cgd2f8vms0pbsn3x0gxvyqdqiw16xp5fmdx5kzr";
  };

  buildInputs = [ makeWrapper gtk2 libsoup libX11 perl pkgconfig webkit gsettings_desktop_schemas ];

  hardeningDisable = [ "format" ];

  installFlags = "PREFIX=/ DESTDIR=$(out)";

  preFixup = ''
    wrapProgram "$out/bin/vimprobable2" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking.out}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
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
    homepage = http://sourceforge.net/apps/trac/vimprobable;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.aforemny ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
