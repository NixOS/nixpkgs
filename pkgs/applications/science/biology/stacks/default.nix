{ stdenv, fetchurl, zlib }:
    
stdenv.mkDerivation rec {
  pname = "stacks";
  version = "2.3e";
  src = fetchurl {
    url = "http://catchenlab.life.illinois.edu/stacks/source/${pname}-${version}.tar.gz";
    sha256 = "046gmq8nzqy5v70ydqrhib2aiyrlja3cljvd37w4qbd4ryj3jr0w";
  };

  buildInputs = [ zlib ];

  meta = {
    description = "Software pipeline for building loci from short-read sequences";
    homepage = http://catchenlab.life.illinois.edu/stacks/;
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    license = stdenv.lib.licenses.gpl3;
  };
}
