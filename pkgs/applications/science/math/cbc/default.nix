{ lib, stdenv, fetchurl, zlib, bzip2 }:

stdenv.mkDerivation {
  name = "cbc-2.9.5";

  src = fetchurl {
    url = "http://www.coin-or.org/download/source/Cbc/Cbc-2.9.5.tgz";
    sha256 = "0kmsg9qpajh5jhnql04m6akpdjzlppxfz99q320vw5bkzgl3i18w";
  };

  configureFlags = "-C";

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
