{ stdenv, fetchurl, pkgconfig, audacious, dbus_glib, gettext
, libmad, xlibs, alsaLib, taglib, libmpcdec, libogg, libvorbis
, libcdio, libcddb
}:

stdenv.mkDerivation {
  name = "audacious-plugins-1.5.1";
  
  src = fetchurl {
    url = http://distfiles.atheme.org/audacious-plugins-1.5.1.tbz2;
    sha256 = "1ki5bd50g4vi4d0qzxynyrgaq2n4cwhbsxln9rwk8ppphvk9pawc";
  };

  buildInputs = [
    pkgconfig audacious dbus_glib gettext libmad
    xlibs.libXcomposite alsaLib taglib libmpcdec
    libogg libvorbis libcdio libcddb
  ];

  preBuild = ''
    makeFlagsArray=(pluginlibdir=$out/lib/audacious)
  '';

  NIX_LDFLAGS = "-L${audacious}/lib/audacious"; # needed because we override pluginlibdir

  meta = {
    description = "Plugins for the Audacious media player";
    homepage = http://audacious-media-player.org/;
  };
}
