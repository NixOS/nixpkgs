{ stdenv, fetchurl, zlib }:
    
stdenv.mkDerivation rec {
  pname = "stacks";
  version = "2.53";
  src = fetchurl {
    url = "http://catchenlab.life.illinois.edu/stacks/source/${pname}-${version}.tar.gz";
    sha256 = "1zchds205nwdqch1246953dr8c0019yas178qbq3jypbxvmgq7pf";
  };

  buildInputs = [ zlib ];

  meta = {
    description = "Software pipeline for building loci from short-read sequences";
    homepage = "http://catchenlab.life.illinois.edu/stacks/";
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    license = stdenv.lib.licenses.gpl3;
  };
}
