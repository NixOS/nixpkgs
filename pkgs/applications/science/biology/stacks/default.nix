{ lib, stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  pname = "stacks";
  version = "2.55";
  src = fetchurl {
    url = "http://catchenlab.life.illinois.edu/stacks/source/${pname}-${version}.tar.gz";
    sha256 = "sha256-p8L0F3A+GdNsPgTQNn9Em5EjFCc9f7gUvyLIRCTd05c=";
  };

  buildInputs = [ zlib ];

  meta = {
    description = "Software pipeline for building loci from short-read sequences";
    homepage = "http://catchenlab.life.illinois.edu/stacks/";
    maintainers = [ lib.maintainers.bzizou ];
    license = lib.licenses.gpl3;
  };
}
