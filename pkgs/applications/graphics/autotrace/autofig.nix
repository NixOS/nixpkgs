{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "autofig";
  version = "0.1";

  src = fetchurl {
    url = "http://autotrace.sourceforge.net/tools/autofig.tar.gz";
    sha256 = "11cs9hdbgcl3aamcs3149i8kvyyldmnjf6yq81kbcf8fdmfk2zdq";
  };
}
