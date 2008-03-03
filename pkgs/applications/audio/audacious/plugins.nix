{ stdenv, fetchurl, pkgconfig, audacious, dbus_glib, gettext
, libmad, xlibs, alsaLib, taglib, libmpcdec, libogg, libvorbis
}:

stdenv.mkDerivation {
  name = "audacious-plugins-1.4.5";
  
  src = fetchurl {
    url = http://distfiles.atheme.org/audacious-plugins-1.4.5.tbz2;
    sha256 = "145dn2x1rldwbaxnl19j7cw338fs9fwcn607r8gk01adfy3warxq";
  };

  buildInputs = [
    pkgconfig audacious dbus_glib gettext libmad
    xlibs.libXcomposite alsaLib taglib libmpcdec
    libogg libvorbis
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
