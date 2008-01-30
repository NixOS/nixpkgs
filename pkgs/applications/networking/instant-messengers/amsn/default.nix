{stdenv, fetchurl, which, tcl, tk, x11, libstdcpp }:

stdenv.mkDerivation {
  name = "amsn-0.96";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/amsn/amsn-0.96.tar.bz2;
    md5 = "3df6b0d34ef1997a47c0b8af29b2547a";
  };

  inherit tcl tk libstdcpp;
  buildInputs = [which tcl tk x11 ];

  meta = {
    homepage = http://amsn-project.net;
  };
}
