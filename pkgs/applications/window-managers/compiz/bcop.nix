{ stdenv, fetchurl, pkgconfig, libxslt }:

stdenv.mkDerivation rec {
  name = "compiz-bcop-0.8.4";

  src = fetchurl {
    url = "http://releases.compiz.org/components/compiz-bcop/${name}.tar.bz2";
    sha256 = "0kwcvalmx2aab7j3x7s0xqm102i3kr5gh1z8mfws9q4qkqdclnfk";
  };

  buildInputs = [ pkgconfig libxslt ];
    
  meta = {
    homepage = http://www.compiz.org/;
    description = "Code generator for Compiz plugins";
  };
}
