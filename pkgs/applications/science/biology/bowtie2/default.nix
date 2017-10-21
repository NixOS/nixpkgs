{ stdenv, fetchFromGitHub, zlib, tbb }:

stdenv.mkDerivation rec {
  pname = "bowtie2";
  version = "2.3.3.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "BenLangmead";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pcyks76bnnkq6h0gqjw4fkdddjjnw7k5ibim7ajkbvfw58a99y0";
  };

  buildInputs = [ zlib tbb ];

  installFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "An ultrafast and memory-efficient tool for aligning sequencing reads to long reference sequences";
    license = licenses.gpl3;
    homepage = http://bowtie-bio.sf.net/bowtie2;
    maintainers = with maintainers; [ rybern ];
    platforms = platforms.all;
  };
}
