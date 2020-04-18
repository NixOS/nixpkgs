{ stdenv, fetchurl, zlib }:
    
stdenv.mkDerivation rec {
  pname = "stacks";
  version = "2.52";
  src = fetchurl {
    url = "http://catchenlab.life.illinois.edu/stacks/source/${pname}-${version}.tar.gz";
    sha256 = "0gq3kbj910jsq591wylzjmd23srjlsssmrckmf46m4ysjqdqd8vm";
  };

  buildInputs = [ zlib ];

  meta = {
    description = "Software pipeline for building loci from short-read sequences";
    homepage = "http://catchenlab.life.illinois.edu/stacks/";
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    license = stdenv.lib.licenses.gpl3;
  };
}
