{ lib, stdenv, fetchurl, zlib, bzip2 }:

stdenv.mkDerivation rec {
  pname = "cbc";
  version = "2.10.5";

  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Cbc/Cbc-${version}.tgz";
    sha256 = "0wk9vr6zc62gw71v7gnra5wxqlcljcgbhm5lasx236v791b986ns";
  };

  configureFlags = [ "-C" ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  buildInputs = [ zlib bzip2 ];

  # FIXME: move share/coin/Data to a separate output?

  meta = {
    homepage = "https://projects.coin-or.org/Cbc";
    license = lib.licenses.epl10;
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    broken = stdenv.isAarch64; # Missing <immintrin.h> after 2.10.0
    description = "A mixed integer programming solver";
  };
}
