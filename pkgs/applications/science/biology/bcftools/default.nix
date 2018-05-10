{ stdenv, fetchurl, htslib, zlib, bzip2, lzma, curl, perl, python, bash }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "bcftools";
  version = "1.8";

  src = fetchurl {
    url = "https://github.com/samtools/bcftools/releases/download/${version}/${name}.tar.bz2";
    sha256 = "1vgw2mwngq20c530zim52zvgmw1lci8rzl33pvh44xqk3xlzvjsa";
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
    maintainers = [ maintainers.mimadrid ];
  };
}
