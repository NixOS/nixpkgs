{ stdenv, fetchurl, zlib, bzip2, cmake }:

stdenv.mkDerivation rec {
  pname = "SPAdes";
  version = "3.13.1";

  src = fetchurl {
    url = "http://cab.spbu.ru/files/release${version}/${pname}-${version}.tar.gz";
    sha256 = "0giayz197lmq2108filkn9izma3i803sb3iskv9hs5snzdr9p8ld";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib bzip2 ];

  doCheck = true;

  sourceRoot = "${pname}-${version}/src";

  meta = with stdenv.lib; {
    description = "St. Petersburg genome assembler: assembly toolkit containing various assembly pipelines";
    license = licenses.gpl2;
    homepage = "http://cab.spbu.ru/software/spades/";
    platforms = platforms.unix;
    maintainers = [ maintainers.bzizou ];
  };
}
