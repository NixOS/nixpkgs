{ stdenv, fetchurl, zlib, ncurses }:

stdenv.mkDerivation rec {
  name = "samtools-${version}";
  version = "1.3";

  src = fetchurl {
    url = "https://github.com/samtools/samtools/releases/download/${version}/${name}.tar.bz2";
    sha256 = "03mnf0mhbfwhqlqfslrhfnw68s3g0fs1as354i9a584mqw1l1smy";
  };

  buildInputs = [ zlib ncurses ];

  meta = with stdenv.lib; {
    description = "Tools (written in C using htslib) for manipulating next-generation sequencing data";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
  };
}
