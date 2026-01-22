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
    runHook preInstall

    install -D fastp $out/bin/fastp

    runHook postInstall
  '';

  meta = {
    description = "Ultra-fast all-in-one FASTQ preprocessor";
    mainProgram = "fastp";
    license = lib.licenses.mit;
    homepage = "https://github.com/OpenGene/fastp";
    maintainers = with lib.maintainers; [ jbedo ];
    platforms = lib.platforms.x86_64;
  };
}
