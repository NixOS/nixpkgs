{ fetchurl, stdenv,
  libX11, libXrandr, libXxf86vm, libxcb, pkgconfig, python,
  randrproto, xcbutil, xf86vidmodeproto }:

stdenv.mkDerivation rec {
  pname = "redshift";
  version = "1.7";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "http://launchpad.net/${pname}/trunk/${version}/+download/${pname}-${version}.tar.bz2";
    sha256 = "1j0hs0vnlic90cf4bryn11n4ani1x2s5l8z6ll3fmrlw98ykrylv";
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
