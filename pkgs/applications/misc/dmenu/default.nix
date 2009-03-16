args: with args;
stdenv.mkDerivation {
  name = "dmenu-3.9";

  src = fetchurl {
    url = http://code.suckless.org/dl/tools/dmenu-3.9.tar.gz;
    sha256 = "2370111e02c6a3863ea04376795fa72f9e41cdd2650b12f90e6a0c7d096e4b22";
  };

  buildInputs = [ libX11 libXinerama ];

  preConfigure = [ ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk'' ];

  meta = { 
      description = "a generic, highly customizable, and efficient menu for the X Window System";
      homepage = http://tools.suckless.org/dmenu;
      license = "MIT";
  };
}
