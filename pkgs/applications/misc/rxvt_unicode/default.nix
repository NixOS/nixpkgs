args: with args;
stdenv.mkDerivation {
  name = "rxvt-unicode-8.9";
 
  buildInputs = [ libX11 libXt libXft perl ];
 
  src = fetchurl {
    url = http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-8.9.tar.bz2;
    sha256 = "89858c5bfe72dba037cd3435b2221269580f3c699553fe24ee468ddec8831d27";
  };
 
  meta = {
    description = "rxvt-unicode is a clone of the well known terminal emulator rxvt.";
    homepage = "http://software.schmorp.de/pkg/rxvt-unicode.html";
  };
}
