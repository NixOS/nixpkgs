{ lib
, stdenv
, fetchurl
, zlib
, gsl
, boost
}:

stdenv.mkDerivation rec {
  pname = "treemix";
  version = "1.13";

  src = fetchurl {
    url = "https://bitbucket.org/nygcresearch/treemix/downloads/${pname}-${version}.tar.gz";
    sha256 = "1nd3rzsdgk47r8b8k43mdfvaagln533sm08s1jr0dz8km8nlym7y";
  };

  buildInputs = [ zlib gsl boost ];

  meta = with lib ; {
    description = "Inference of patterns of population splitting and mixing from genome-wide allele frequency data";
    homepage = "https://bitbucket.org/nygcresearch/treemix/wiki/Home";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.linux;
  };
}
