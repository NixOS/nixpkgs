{
  lib,
  stdenv,
  fetchurl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "stacks";
  version = "2.66";
  src = fetchurl {
    url = "http://catchenlab.life.illinois.edu/stacks/source/${pname}-${version}.tar.gz";
    sha256 = "sha256-9pHmcLYMdn9xy3vhlOU42Io/4L61auoncfpZNRPUN/I=";
  };

  buildInputs = [ zlib ];

  meta = {
    description = "Software pipeline for building loci from short-read sequences";
    homepage = "http://catchenlab.life.illinois.edu/stacks/";
    maintainers = [ lib.maintainers.bzizou ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
