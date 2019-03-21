{ lib, stdenv, fetchurl, zlib, bzip2 }:

stdenv.mkDerivation {
  name = "cbc-2.10.0";

  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Cbc/Cbc-2.10.0.tgz";
    sha256 = "1wx90dh1gi5wbw0f10hj9765y1qq3nq6f3jyq995z5lana4zy2ap";
  };

  configureFlags = [ "-C" ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  buildInputs = [ zlib bzip2 ];

  # FIXME: move share/coin/Data to a separate output?

  meta = {
    homepage = https://projects.coin-or.org/Cbc;
    license = lib.licenses.epl10;
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    description = "A mixed integer programming solver";
  };
}
