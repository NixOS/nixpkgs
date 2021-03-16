{ lib, stdenv, fetchurl, zlib, bzip2, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "SPAdes";
  version = "3.15.1";

  src = fetchurl {
    url = "http://cab.spbu.ru/files/release${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-2wZzdFRZ7zyhWwYL+c/5qhKDgj+LPtnge3UNHWJ9Ykk=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib bzip2 python3 ];

  doCheck = true;

  sourceRoot = "${pname}-${version}/src";

  meta = with lib; {
    description = "St. Petersburg genome assembler: assembly toolkit containing various assembly pipelines";
    license = licenses.gpl2;
    homepage = "http://cab.spbu.ru/software/spades/";
    platforms = platforms.unix;
    maintainers = [ maintainers.bzizou ];
  };
}
