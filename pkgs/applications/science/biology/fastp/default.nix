{ stdenv
, fetchFromGitHub
, zlib
}:

stdenv.mkDerivation rec {
  pname = "fastp";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "OpenGene";
    repo = "fastp";
    rev = "v${version}";
    sha256 = "sha256-pANwppkO9pfV9vctB7HmNCzYRtf+Xt+5HMKzvFuvyFM=";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    install -D fastp $out/bin/fastp
  '';

  meta = with stdenv.lib; {
    description = "Ultra-fast all-in-one FASTQ preprocessor";
    license = licenses.mit;
    homepage = "https://github.com/OpenGene/fastp";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}
