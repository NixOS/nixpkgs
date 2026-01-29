{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dasm";
  version = "2.20.14.1";

  src = fetchFromGitHub {
    owner = "dasm-assembler";
    repo = "dasm";
    rev = finalAttrs.version;
    sha256 = "1bna0bj503xyn5inwzzsrsgi9qg8p20by4dfk7azj91ynw56pl41";
  };

  configurePhase = false;
  installPhase = ''
    mkdir -p $out/bin
    install bin/* $out/bin
  '';

  preCheck = ''
    patchShebangs ./test/
  '';

  checkTarget = "test";
  doCheck = true;

  meta = {
    description = "Assembler for 6502 and other 8-bit microprocessors";
    homepage = "https://dasm-assembler.github.io";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.jwatt ];
    platforms = lib.platforms.all;
  };
})
