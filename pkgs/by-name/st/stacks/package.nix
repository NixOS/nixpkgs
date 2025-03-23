{
  lib,
  stdenv,
  fetchurl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "stacks";
  version = "2.68";
  src = fetchurl {
    url = "http://catchenlab.life.illinois.edu/stacks/source/${pname}-${version}.tar.gz";
    sha256 = "sha256-ncUeo1bWDrRVewstGohUqvrkkq7Yf5dOAknMCapedlA=";
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
