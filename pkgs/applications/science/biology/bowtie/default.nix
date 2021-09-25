{ lib, stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  pname = "bowtie";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "BenLangmead";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mWItmrTMPst/NnzSpxxTHcBztDqHPCza9yOsZPwp7G4=";
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
