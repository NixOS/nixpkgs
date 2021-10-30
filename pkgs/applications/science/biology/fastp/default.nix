{ lib
, stdenv
, fetchFromGitHub
, zlib
, libdeflate
, isa-l
}:

stdenv.mkDerivation rec {
  pname = "fastp";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "OpenGene";
    repo = "fastp";
    rev = "v${version}";
    sha256 = "sha256-vRJlNtg2JabBAUaX91Y04z8MdyxEnreBAlIHn7VB+u4=";
  };

  buildInputs = [ zlib libdeflate isa-l ];

  installPhase = ''
    install -D fastp $out/bin/fastp
  '';

  meta = with lib; {
    description = "Ultra-fast all-in-one FASTQ preprocessor";
    license = licenses.mit;
    homepage = "https://github.com/OpenGene/fastp";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}
