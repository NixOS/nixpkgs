args: with args; stdenv.mkDerivation {
  name = "dwm-5.1";
 
  src = fetchurl {
    url = http://code.suckless.org/dl/dwm/dwm-5.1.tar.gz;
    sha256 = "d8dca894c4805a845baca1c3f9b16299e1eaeab661fd3827b374e57b4c603bf8";
  };
 
  buildInputs = [ libX11 libXinerama ];
 
  buildPhase = " make ";
 
  meta = { homepage = "www.suckless.org";
           description = "dynamic window manager for X";
           license="MIT";
         };
}
