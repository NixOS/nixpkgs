{stdenv, fetchurl, imake, libX11, libXext, libXmu}:

stdenv.mkDerivation {
  name = "larswm-7.5.3";
  src = /home/viric/larswm-7.5.3.tar.gz;

  buildInputs = [ imake libX11 libXext libXmu ];

  configurePhase = ''
    xmkmf
    makeFlags="DESTDIR=$out"
  '';

  meta = {
    homepage = http://larswm.fnurt.net/;
    description = "9wm-like tiling window manager";
    license = "free";
  };
}
