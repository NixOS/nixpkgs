{stdenv, fetchurl, imake, libX11, libXext, libXmu}:

stdenv.mkDerivation {
  name = "larswm-7.5.3";

  src = fetchurl {
    url = mirror://sourceforge/larswm/larswm-7.5.3.tar.gz;
    sha256 = "1xmlx9g1nhklxjrg0wvsya01s4k5b9fphnpl9zdwp29mm484ni3v";
  };

  buildInputs = [ imake libX11 libXext libXmu ];

  configurePhase = ''
    xmkmf
    makeFlags="BINDIR=$out/bin MANPATH=$out/share/man"
    installTargets="install install.man"
  '';

  meta = {
    homepage = http://www.fnurt.net/larswm;
    description = "9wm-like tiling window manager";
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.linux;
  };
}
