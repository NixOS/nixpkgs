{ stdenv, fetchurl, htslib, zlib, bzip2, lzma, perl }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "bcftools";
  major = "1.5";
  version = "${major}.0";

  src = fetchurl {
    url = "https://github.com/samtools/bcftools/releases/download/${major}/bcftools-${major}.tar.bz2";
    sha256 = "0093hkkvxmbwfaa7905s6185jymynvg42kq6sxv7fili11l5mxwz";
  };

  buildInputs = [ zlib bzip2 lzma perl ];

  makeFlags = [
    "HSTDIR=${htslib}"
    "prefix=$(out)"
    "CC=cc"
  ];

  meta = with stdenv.lib; {
    description = "Tools for manipulating BCF2/VCF/gVCF format, SNP and short indel sequence variants";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}
