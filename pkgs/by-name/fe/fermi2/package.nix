{
  config,
  lib,
  fetchFromGitHub,
  zlib,
  stdenv,
}:
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
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  installPhase = ''
    runHook preInstall

    install -Dm755 fermi2 -t $out/bin

    runHook postInstall
  '';
  meta = with lib; {
    homepage = "https://github.com/lh3/fermi2";
    description = "Successor of fermi, a whole genome de novo assembler based on the FMD-index for large genomes";
    mainProgram = "fermi2";
    license = licenses.mit;
    maintainers = with maintainers; [ apraga ];
    platforms = intersectLists platforms.x86_64 platforms.unix;
  };
}
