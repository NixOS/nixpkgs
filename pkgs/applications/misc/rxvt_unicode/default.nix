args: with args; stdenv.mkDerivation {
  name = "rxvt-unicode-8.4";

  buildInputs = [ libX11 libXt libXft perl ];

  src = fetchurl {
    url = http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-8.4.tar.bz2;
    sha256 = "ff8d904a815151edde72bb3e51d1561125813569cb3d487cbac428ec23facdbb";
  };

  meta = {
    description = "rxvt-unicode is a clone of the well known terminal emulator rxvt.";
    homepage = "http://software.schmorp.de/pkg/rxvt-unicode.html";
  };
}
