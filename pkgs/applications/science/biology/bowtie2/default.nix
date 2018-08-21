{ stdenv, fetchFromGitHub, zlib, tbb }:

stdenv.mkDerivation rec {
  pname = "bowtie2";
  version = "2.3.4.2";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "BenLangmead";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gsfaf7rjg4nwhs7vc1vf63xd5r5v1yq58w7x3barycplzbvixzz";
  };

  buildInputs = [ zlib tbb ];

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
