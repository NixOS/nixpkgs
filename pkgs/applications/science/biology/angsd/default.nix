{ lib, stdenv, fetchFromGitHub, htslib, zlib, bzip2, xz, curl, openssl }:

stdenv.mkDerivation rec {
  pname = "angsd";
  version = "0.940";

  src = fetchFromGitHub {
    owner = "ANGSD";
    repo = "angsd";
    sha256 = "sha256-Ppxgy54pAnqJUzNX5c12NHjKTQyEEcPSpCEEVOyZ/LA=";
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

