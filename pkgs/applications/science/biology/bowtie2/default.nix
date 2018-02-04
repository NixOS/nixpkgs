{ stdenv, fetchFromGitHub, zlib, tbb }:

stdenv.mkDerivation rec {
  pname = "bowtie2";
  version = "2.3.4";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "BenLangmead";
    repo = pname;
    rev = "v${version}";
    sha256 = "15k86ln1xgqkyk8ms09cgdhagz49jpvr6ij6mha1f9ga5fxnnp1m";
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
