{ stdenv, fetchurl, zlib, ncurses }:

stdenv.mkDerivation rec {
  name = "samtools-${version}";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/samtools/samtools/releases/download/${version}/${name}.tar.bz2";
    sha256 = "0znnnxc467jbf1as2dpskrjhfh8mbll760j6w6rdkwlwbqsp8gbc";
  };

  buildInputs = [ zlib ncurses ];

  meta = with stdenv.lib; {
    description = "Tools (written in C using htslib) for manipulating next-generation sequencing data";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
  };
}
