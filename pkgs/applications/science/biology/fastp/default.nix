{ lib
, stdenv
, fetchFromGitHub
, zlib
, libdeflate
, isa-l
}:

stdenv.mkDerivation rec {
  pname = "fastp";
<<<<<<< HEAD
  version = "0.23.4";
=======
  version = "0.23.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "OpenGene";
    repo = "fastp";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-hkCo8CiZNJuVcL9Eg/R7YzM7/FEcGEnovV325oWa7y8=";
=======
    sha256 = "sha256-W1mXTfxD7/gHJhao6qqbNcyM3t2cfrUYiBYPJi/O1RI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
