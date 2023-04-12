{ lib
, stdenv
, fetchFromGitHub
, zlib
, libdeflate
, isa-l
}:

stdenv.mkDerivation rec {
  pname = "fastp";
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "OpenGene";
    repo = "fastp";
    rev = "v${version}";
    sha256 = "sha256-W1mXTfxD7/gHJhao6qqbNcyM3t2cfrUYiBYPJi/O1RI=";
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
