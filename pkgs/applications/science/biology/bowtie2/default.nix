{ stdenv, fetchFromGitHub, zlib, tbb, python, perl }:

stdenv.mkDerivation rec {
  pname = "bowtie2";
  version = "2.3.5.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "BenLangmead";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l1f0yhjqqvy4lpxfml1xwv7ayimwbpzazvp0281gb4jb5f5mr1a";
  };

  buildInputs = [ zlib tbb python perl ];

  installFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "An ultrafast and memory-efficient tool for aligning sequencing reads to long reference sequences";
    license = licenses.gpl3;
    homepage = http://bowtie-bio.sf.net/bowtie2;
    maintainers = with maintainers; [ rybern ];
    platforms = platforms.all;
    broken = stdenv.isAarch64;
  };
}
