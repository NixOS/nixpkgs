{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  htslib,
  zlib,
  bzip2,
  xz,
  curl,
  perl,
  python3,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcftools";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "samtools";
    repo = "bcftools";
    tag = finalAttrs.version;
    hash = "sha256-S+FuqjiOf38sAQKWYOixv/MlXGnuDmkx9z4Co/pk/eM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    perl
    python3
  ];

  buildInputs = [
    htslib
    zlib
    bzip2
    xz
    curl
  ];

  nativeCheckInputs = [
    htslib
  ];

  strictDeps = true;

  makeFlags = [
    "HSTDIR=${htslib}"
    "prefix=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  preCheck = ''
    patchShebangs misc/
    patchShebangs test/
    sed -i -e 's|/bin/bash|${bash}/bin/bash|' test/test.pl
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "Tools for manipulating BCF2/VCF/gVCF format, SNP and short indel sequence variants";
    license = licenses.mit;
    homepage = "http://www.htslib.org/";
    platforms = platforms.unix;
    maintainers = [ maintainers.mimame ];
  };
})
