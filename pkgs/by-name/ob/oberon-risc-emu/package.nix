{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
}:

stdenv.mkDerivation {
  pname = "oberon-risc-emu";
  version = "unstable-2020-08-18";

  src = fetchFromGitHub {
    owner = "pdewacht";
    repo = "oberon-risc-emu";
    rev = "26c8ac5737c71811803c87ad51f1f0d6e62e71fe";
    sha256 = "1iriix3cfcpbkjb5xjb4ysh592xppgprwzp3b6qhwcx44g7kdvxq";
  };

  buildInputs = [ SDL2 ];

  installPhase = ''
    mkdir -p $out/bin
    mv risc $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/pdewacht/oberon-risc-emu/";
    description = "Emulator for the Oberon RISC machine";
    license = licenses.isc;
    maintainers = with maintainers; [ siraben ];
    mainProgram = "risc";
  };
}
