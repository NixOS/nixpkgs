{ stdenv, fetchurl, zlib }:
    
stdenv.mkDerivation rec {
  pname = "stacks";
  version = "2.4";
  src = fetchurl {
    url = "http://catchenlab.life.illinois.edu/stacks/source/${pname}-${version}.tar.gz";
    sha256 = "1ha1avkh6rqqvsy4k42336a2gj14y1jq19a2x8cjmiidi9l3s29h";
  };

  buildInputs = [ zlib ];

  meta = {
    description = "Software pipeline for building loci from short-read sequences";
    homepage = http://catchenlab.life.illinois.edu/stacks/;
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    license = stdenv.lib.licenses.gpl3;
  };
}
