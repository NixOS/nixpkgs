{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
}:

stdenv.mkDerivation {
  pname = "oberon-risc-emu";
  version = "2016.1-unstable-2020-08-18";

  src = fetchFromGitHub {
    owner = "pdewacht";
    repo = "oberon-risc-emu";
    rev = "26c8ac5737c71811803c87ad51f1f0d6e62e71fe";
    hash = "sha256-uO82zyOkMw6xWeN+nu+7t4tUoPZkyV6WnOsyx0aPMcc=";
  };

  buildInputs = [ SDL2 ];

  installPhase = ''
    mkdir -p $out/bin
    mv risc $out/bin
  '';

  meta = {
    homepage = "https://github.com/pdewacht/oberon-risc-emu/";
    description = "Emulator for the Oberon RISC machine";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ siraben ];
    mainProgram = "risc";
  };
}
