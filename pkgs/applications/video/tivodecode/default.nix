{ stdenv, fetchurl }:

let
  version = "0.2pre4";

in

stdenv.mkDerivation {
  name = "tivodecode-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/tivodecode/tivodecode/${version}/tivodecode-${version}.tar.gz";
    sha256 = "1pww5r2iygscqn20a1cz9xbfh18p84a6a5ifg4h5nvyn9b63k23q";
  };

  meta = {
    description = "Converts a .TiVo file (produced by TiVoToGo) to a normal MPEG file";
    homepage = http://tivodecode.sourceforge.net;
  };
}