{ stdenv, fetchurl, htslib, zlib, bzip2, lzma, curl, perl, python, bash }:

stdenv.mkDerivation rec {
  pname = "bcftools";
  version = "1.10.2";

  src = fetchurl {
    url = "https://github.com/samtools/bcftools/releases/download/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0b2f6lqhxdlrvfjqxv7a4nzqj68c1j4avn16iqxwwm80kn302wzm";
  };

  buildInputs = [ htslib zlib bzip2 lzma curl perl python ];

  makeFlags = [
    "HSTDIR=${htslib}"
    "prefix=$(out)"
    "CC=cc"
  ];

  preCheck = ''
    patchShebangs misc/
    patchShebangs test/
    sed -ie 's|/bin/bash|${bash}/bin/bash|' test/test.pl
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Tools for manipulating BCF2/VCF/gVCF format, SNP and short indel sequence variants";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimame ];
  };
}
