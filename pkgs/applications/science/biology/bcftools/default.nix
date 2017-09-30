{ stdenv, fetchurl, htslib, zlib, bzip2, lzma, perl, bash }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "bcftools";
  major = "1.6";
  version = "${major}.0";

  src = fetchurl {
    url = "https://github.com/samtools/bcftools/releases/download/${major}/bcftools-${major}.tar.bz2";
    sha256 = "10prgmf09a13mk18840938ijqgfc9y92hfc7sa2gcv07ddri0c19";
  };


  nativeBuildInputs = [ bash ];

  buildInputs = [ zlib bzip2 lzma ];

  propagatedBuildInputs = [ htslib ];

  makeFlags = [
    "HSTDIR=${htslib}"
    "prefix=$(out)"
    "CC=cc"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  preCheck = ''
    sed -ie 's|/usr/bin/\(env[[:space:]]\)\{0,1\}perl|${perl}/bin/perl|' test/test.pl test/csq/{sort-csq,make-csq-test} misc/plot-vcfstats
    sed -ie 's|/bin/bash|${bash}/bin/bash|' test/test.pl
  '';

  meta = with stdenv.lib; {
    description = "Tools for manipulating BCF2/VCF/gVCF format, SNP and short indel sequence variants";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}
