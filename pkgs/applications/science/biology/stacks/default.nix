{ lib, stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  pname = "stacks";
  version = "2.59";
  src = fetchurl {
    url = "http://catchenlab.life.illinois.edu/stacks/source/${pname}-${version}.tar.gz";
    sha256 = "sha256-pVFwb4EPba9wL9kDGN2gi7aeH+sPhDG/XLyHxqG4zd4=";
  };

  buildInputs = [ zlib ];

  meta = {
    description = "Software pipeline for building loci from short-read sequences";
    homepage = "http://catchenlab.life.illinois.edu/stacks/";
    maintainers = [ lib.maintainers.bzizou ];
    license = lib.licenses.gpl3Plus;
  };
}
