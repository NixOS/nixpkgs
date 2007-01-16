{stdenv, fetchurl, which, tcl, tk, x11}:

stdenv.mkDerivation {
  name = "amsn-0.96";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://belnet.dl.sourceforge.net/sourceforge/amsn/amsn-0.96.tar.bz2;
    md5 = "3df6b0d34ef1997a47c0b8af29b2547a";
  };

  inherit tcl tk;
  buildInputs = [which tcl tk x11];
}
