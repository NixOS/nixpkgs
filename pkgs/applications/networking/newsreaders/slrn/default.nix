{ stdenv, fetchurl, pkgs
, slang
}:

let version = "1.0.1"; in

stdenv.mkDerivation {
  name = "slrn-${version}";

  src = fetchurl {
    url = "http://www.jedsoft.org/slrn/download/slrn-1.0.1.tar.gz";
    sha256 = "1rmaprfwvshzkv0c5vi43839cz3laqjpl306b9z0ghwyjdha1d06";
  };

  nativeBuildInputs = [ slang ];

  meta = {
    description = "The slrn (S-Lang read news) newsreader";
    homepage = http://slrn.sourceforge.net/index.html;
    license = pkgs.lib.licenses.gpl2;
  };
}
