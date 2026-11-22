{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  htslib,
  zlib,
  bzip2,
  xz,
  curl,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "angsd";
  version = "0.940";

  src = fetchFromGitHub {
    owner = "ANGSD";
    repo = "angsd";
    sha256 = "sha256-Ppxgy54pAnqJUzNX5c12NHjKTQyEEcPSpCEEVOyZ/LA=";
    tag = finalAttrs.version;
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

  buildInputs = [
    htslib
    zlib
    bzip2
    xz
    curl
    openssl
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "HTSSRC=systemwide"
    "prefix=$(out)"
  ];

  meta = {
    description = "Program for analysing NGS data";
    homepage = "http://www.popgen.dk/angsd";
    maintainers = [ lib.maintainers.bzizou ];
    license = lib.licenses.gpl2;
  };
})
