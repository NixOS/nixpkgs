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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "OpenGene";
    repo = "fastp";
    rev = "v${version}";
    sha256 = "sha256-NR41Hklcz2wOQ39OzQYaYs5+eGjSWxCtcTGDAixZCmg=";
  };

  buildInputs = [
    zlib
    libdeflate
    isa-l
  ];

  installPhase = ''
    install -D fastp $out/bin/fastp
  '';

<<<<<<< HEAD
  meta = {
    description = "Ultra-fast all-in-one FASTQ preprocessor";
    mainProgram = "fastp";
    license = lib.licenses.mit;
    homepage = "https://github.com/OpenGene/fastp";
    maintainers = with lib.maintainers; [ jbedo ];
    platforms = lib.platforms.x86_64;
=======
  meta = with lib; {
    description = "Ultra-fast all-in-one FASTQ preprocessor";
    mainProgram = "fastp";
    license = licenses.mit;
    homepage = "https://github.com/OpenGene/fastp";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
