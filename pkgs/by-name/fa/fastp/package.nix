{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  libdeflate,
  isa-l,
}:

stdenv.mkDerivation rec {
  pname = "fastp";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "OpenGene";
    repo = "fastp";
    rev = "v${version}";
    sha256 = "sha256-DrvY2FqTlQU3mJkBp/gM+GHlBlumfYRZItpphaF1xfs=";
  };

  buildInputs = [
    zlib
    libdeflate
    isa-l
  ];

  installPhase = ''
    install -D fastp $out/bin/fastp
  '';

  meta = with lib; {
    description = "Ultra-fast all-in-one FASTQ preprocessor";
    mainProgram = "fastp";
    license = licenses.mit;
    homepage = "https://github.com/OpenGene/fastp";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}
