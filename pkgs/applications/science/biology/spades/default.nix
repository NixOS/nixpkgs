{ stdenv, fetchurl, zlib, bzip2, cmake }:

stdenv.mkDerivation rec {
  pname = "SPAdes";
  version = "3.14.0";

  src = fetchurl {
    url = "http://cab.spbu.ru/files/release${version}/${pname}-${version}.tar.gz";
    sha256 = "1ffxswd2ngkpy1d6l3lb6a9cmyy1fglbdsws00b3m1k22zaqv60q";
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
