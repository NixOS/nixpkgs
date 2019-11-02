{ stdenv, fetchurl, zlib }:
    
stdenv.mkDerivation rec {
  pname = "stacks";
  version = "2.41";
  src = fetchurl {
    url = "http://catchenlab.life.illinois.edu/stacks/source/${pname}-${version}.tar.gz";
    sha256 = "0q420rzjb05jfchcls3pysm4hxfgs6xj2jw246isx0il10g93gkq";
  };

  buildInputs = [ zlib ];

  meta = {
    description = "Software pipeline for building loci from short-read sequences";
    homepage = http://catchenlab.life.illinois.edu/stacks/;
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    license = stdenv.lib.licenses.gpl3;
  };
}
