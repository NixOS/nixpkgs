{ lib, stdenv, fetchFromGitHub, htslib, zlib, bzip2, xz, curl, openssl }:

stdenv.mkDerivation rec {
  pname = "angsd";
  version = "0.937";

  src = fetchFromGitHub {
    owner = "ANGSD";
    repo = "angsd";
    sha256 = "1020gh066dprqhfi90ywqzqqnq7awn49wrkkjnizmmab52v00kxs";
    rev = "${version}";
  };

  buildInputs = [ htslib zlib bzip2 xz curl openssl ];

  makeFlags = [ "HTSSRC=systemwide" "prefix=$(out)" ];

  meta = with lib; {
    description = "Program for analysing NGS data";
    homepage = "http://www.popgen.dk/angsd";
    maintainers = [ maintainers.bzizou ];
    license = licenses.gpl2;
  };
}

