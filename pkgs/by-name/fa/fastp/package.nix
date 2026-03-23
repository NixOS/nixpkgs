{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  libdeflate,
  isa-l,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastp";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "OpenGene";
    repo = "fastp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-0hLq6r/XcYkF1J9LpiQ+qxh5MN4vDTRr5JibnIsq2J0=";
  };

  buildInputs = [
    zlib
    libdeflate
    isa-l
  ];

  installPhase = ''
    install -D fastp $out/bin/fastp
  '';

  meta = {
    description = "Ultra-fast all-in-one FASTQ preprocessor";
    mainProgram = "fastp";
    license = lib.licenses.mit;
    homepage = "https://github.com/OpenGene/fastp";
    maintainers = with lib.maintainers; [ jbedo ];
    platforms = lib.platforms.x86_64;
  };
})
