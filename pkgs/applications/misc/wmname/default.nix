{ stdenv, fetchurl, libX11 }:

stdenv.mkDerivation rec {
  name = "wmname-0.1";

  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "559ad188b2913167dcbb37ecfbb7ed474a7ec4bbcb0129d8d5d08cb9208d02c5";
  };

  buildInputs = [ libX11 ];

  preConfigure = [ ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk'' ];

  meta = {
      description = "Prints or set the window manager name property of the root window";
      homepage = "http://tools.suckless.org/wmname";
      license = stdenv.lib.licenses.mit;
  };
}
