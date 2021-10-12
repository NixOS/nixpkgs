{ lib, stdenv
, fetchFromGitHub
, zlib
}:

stdenv.mkDerivation rec {
  pname = "fastp";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "OpenGene";
    repo = "fastp";
    rev = "v${version}";
    sha256 = "sha256-XR76hNz7iGXQYSBbBandHZ+oU3wyTf1AKlu9Xeq/GyE=";
  };

  buildInputs = [ zlib ];

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
