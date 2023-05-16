<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, htslib
, zlib
, bzip2
, xz
, curl
, openssl
}:
=======
{ lib, stdenv, fetchFromGitHub, htslib, zlib, bzip2, xz, curl, openssl }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "angsd";
  version = "0.940";

  src = fetchFromGitHub {
    owner = "ANGSD";
    repo = "angsd";
    sha256 = "sha256-Ppxgy54pAnqJUzNX5c12NHjKTQyEEcPSpCEEVOyZ/LA=";
<<<<<<< HEAD
    rev = version;
  };

  patches = [
    # Pull pending inclusion upstream patch for parallel buil fixes:
    #   https://github.com/ANGSD/angsd/pull/590
    (fetchpatch {
      name = "parallel-make.patch";
      url = "https://github.com/ANGSD/angsd/commit/89fd1d898078016df390e07e25b8a3eeadcedf43.patch";
      hash = "sha256-KQgUfr3v8xc+opAm4qcSV2eaupztv4gzJJHyzJBCxqA=";
    })
  ];

  buildInputs = [ htslib zlib bzip2 xz curl openssl ];

  enableParallelBuilding = true;

=======
    rev = "${version}";
  };

  buildInputs = [ htslib zlib bzip2 xz curl openssl ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  makeFlags = [ "HTSSRC=systemwide" "prefix=$(out)" ];

  meta = with lib; {
    description = "Program for analysing NGS data";
    homepage = "http://www.popgen.dk/angsd";
    maintainers = [ maintainers.bzizou ];
    license = licenses.gpl2;
  };
}

