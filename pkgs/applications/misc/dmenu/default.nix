args: with args;
stdenv.mkDerivation {
  name = "dmenu-3.8";

  src = fetchurl {
    url = http://code.suckless.org/dl/tools/dmenu-3.8.tar.gz;
    sha256 = "6d111a0e4d970df827f6e3c8ff60f5c96fdac4805f8100d508087859dc4f158b";
  };

  buildInputs = [ libX11 libXinerama ];

  preConfigure = [ ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk'' ];

  meta = { 
      description = "a generic, highly customizable, and efficient menu for the X Window System";
      homepage = http://www.suckless.org/programs/dmenu.html;
      license = "MIT";
  };
}
