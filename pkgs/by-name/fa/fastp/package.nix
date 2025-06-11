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
  version = "0.24.2";

  src = fetchFromGitHub {
    owner = "OpenGene";
    repo = "fastp";
    rev = "v${version}";
    sha256 = "sha256-8AJ6wgqbCqH/f3flgdVYUb5u0C5/CQl6MJe7HmZrp60=";
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
