{ lib, stdenv, fetchurl, htslib, zlib, bzip2, xz, curl, perl, python3, bash }:

stdenv.mkDerivation rec {
  pname = "bcftools";
  version = "1.13";

  src = fetchurl {
    url = "https://github.com/samtools/bcftools/releases/download/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-E7+h2ipe3aj6URlqR6C0r7P+8XUWRR5PDnhHfz3TC5A=";
  };

  nativeBuildInputs = [
    perl
    python3
  ];

  buildInputs = [ htslib zlib bzip2 xz curl ];

  strictDeps = true;

  makeFlags = [
    "HSTDIR=${htslib}"
    "prefix=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  preCheck = ''
    patchShebangs misc/
    patchShebangs test/
    sed -ie 's|/bin/bash|${bash}/bin/bash|' test/test.pl
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
}
