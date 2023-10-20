{ lib
, stdenv
, fetchFromGitHub
, cmake
, perl
, python3
, tbb
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bowtie2";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "BenLangmead";
    repo = "bowtie2";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-Bem4SHY/74suZPDbw/rwKMLBn3bRq5ooHbBoVnKuYk0=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ tbb zlib python3 perl ];

  meta = with lib; {
    description = "An ultrafast and memory-efficient tool for aligning sequencing reads to long reference sequences";
    license = licenses.gpl3Plus;
    homepage = "http://bowtie-bio.sf.net/bowtie2";
    changelog = "https://github.com/BenLangmead/bowtie2/releases/tag/${finalAttrs.src.rev}";
    maintainers = with maintainers; [ rybern ];
    platforms = platforms.all;
    broken = stdenv.isAarch64; # only x86 is supported
    mainProgram = "bowtie2";
  };
})
