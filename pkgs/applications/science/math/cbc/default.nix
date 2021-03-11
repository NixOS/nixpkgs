{ lib, stdenv, fetchurl, zlib, bzip2 }:

stdenv.mkDerivation rec {
  pname = "cbc";
  version = "2.10.5";

  # Note: Cbc 2.10.5 contains Clp 1.17.5 which hits this bug
  # that breaks or-tools https://github.com/coin-or/Clp/issues/130

  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Cbc/Cbc-${version}.tgz";
    sha256 = "sha256-2hqUVkhnmyG6VrRUuB6TlFHceVHZvrPD4U8Y9k3eaXI=";
  };

  # or-tools has a hard dependency on Cbc static libraries, so we build both
  configureFlags = [ "-C" "--enable-static" ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  buildInputs = [ zlib bzip2 ];

  # FIXME: move share/coin/Data to a separate output?

  meta = {
    homepage = "https://projects.coin-or.org/Cbc";
    license = lib.licenses.epl10;
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    description = "A mixed integer programming solver";
  };
}
