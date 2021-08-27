{ lib, stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  pname = "bowtie";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "BenLangmead";
    repo = pname;
    rev = "v${version}";
    sha256 = "0da2kzyfsn6xv8mlqsv2vv7k8g0c9d2vgqzq8yqk888yljdzcrjp";
  };

  buildInputs = [ zlib ];

  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "An ultrafast memory-efficient short read aligner";
    license = licenses.artistic2;
    homepage = "http://bowtie-bio.sourceforge.net";
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.all;
  };
}
