{stdenv, fetchurl, which, tcl, tk, x11}:

stdenv.mkDerivation {
  name = "amsn-0.96rc1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/amsn/amsn-0.96rc1.tar.bz2;
    md5 = "1b90fdbb0a51c7646f4d2e6b22f18711";
  };

  inherit tcl tk;
  buildInputs = [which tcl tk x11];
}
