{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "asmc-linux";
  version = "2.36.25";
  src = fetchFromGitHub {
    owner = "nidud";
    repo = "asmc_linux";
    rev = "4ee70bde4439bdd9c772d08527dba6d50f2e5a88";
    hash = "sha256-/yJC1OQGRgy9T/U2VB0MohSsD1ImLnHYM/8Y8fIWhVE=";
  };

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin ./asmc

    runHook postInstall
  '';

  meta = {
    description = "MASM-compatible assembler";
    homepage = "https://github.com/nidud/asmc_linux";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    platforms = with lib.systems.inspect; patternLogicalAnd patterns.isx86_64 patterns.isLinux;
    mainProgram = "asmc";
  };
}
