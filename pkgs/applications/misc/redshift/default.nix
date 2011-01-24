{ fetchurl, stdenv,
  libX11, libXrandr, libXxf86vm, libxcb, pkgconfig, python,
  randrproto, xcbutil, xf86vidmodeproto }:

stdenv.mkDerivation rec {
  name = "redshift";
  version = "1.6";
  src = fetchurl {
    url = "http://launchpad.net/${name}/trunk/${version}/+download/${name}-${version}.tar.bz2";
    sha256 = "0g46zhqnx3y2fssmyjgaardzhjw1j29l1dbc2kmccw9wxqfla1wi";
  };

  buildInputs = [ libX11 libXrandr libXxf86vm libxcb pkgconfig python
                  randrproto xcbutil xf86vidmodeproto ];

  meta = {
    description = "changes the color temperature of your screen gradually";
    longDescription = ''
      The color temperature is set according to the position of the
      sun. A different color temperature is set during night and
      daytime. During twilight and early morning, the color
      temperature transitions smoothly from night to daytime
      temperature to allow your eyes to slowly adapt.
      '';
    license = "GPLv3+";
    homepage = "http://jonls.dk/redshift";
  }; 
}