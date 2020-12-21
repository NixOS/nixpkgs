{ stdenv, fetchurl, zlib, bzip2, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "SPAdes";
  version = "3.14.1";

  src = fetchurl {
    url = "http://cab.spbu.ru/files/release${version}/${pname}-${version}.tar.gz";
    sha256 = "1ji3afn6yvx7ysg7p9j0d1g28zrnxg1b7x90mhs2bj3lgs7vfafn";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib bzip2 python3 ];

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
