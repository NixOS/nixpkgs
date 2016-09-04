{ stdenv, fetchurl, zlib, htslib }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "bcftools";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/samtools/${pname}/releases/download/${version}/${name}.tar.bz2";
    sha256 = "095ry68vmz9q5s1scjsa698dhgyvgw5aicz24c19iwfbai07mhqj";
  };

  buildInputs = [ zlib ];

  makeFlags = [
    "HSTDIR=${htslib}"
    "prefix=$out"
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
