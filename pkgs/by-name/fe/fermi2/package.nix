{ config, lib, fetchFromGitHub, zlib, stdenv }:

stdenv.mkDerivation {
  pname = "fermi2";
  version = "0.1-unstable-2021-05-21";

  src = fetchFromGitHub {
    owner = "lh3";
    repo = "fermi2";
    rev = "cb1410972b2bd330883823116931ae67ead8b30f";
    hash = "sha256-jDn1OBuGWDMEHI5A3R9meOykEGM6yjItSnUpx36DxgA=";
  };

  buildInputs = [ zlib ];
  installPhase = ''
      mkdir -p $out/bin
      cp fermi2 $out/bin
    '';

  meta = with lib; {
    homepage = "https://github.com/lh3/fermi2";
    description = "Successor of fermi, a whole genome de novo assembler based on the FMD-index for large genomes ";
    mainProgram = "fermi2";
    license = licenses.mit;
    maintainers = with maintainers; [ apraga ];
    platforms = platforms.unix;
  };
}
