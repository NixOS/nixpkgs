{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "asmc-linux";
  version = "2.40";
  src = fetchFromGitHub {
    owner = "nidud";
    repo = "asmc_linux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5fbfLYQEoeAJJqZJ4Rs8WcHm2hD05OZOirNVxY66SdM=";
  };

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin ./asmc

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "MASM-compatible assembler";
    homepage = "https://github.com/nidud/asmc_linux";
    changelog = "https://github.com/nidud/asmc/blob/v${lib.versions.majorMinor finalAttrs.version}/source/asmc/history.txt";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    platforms = with lib.systems.inspect; patternLogicalAnd patterns.isx86_64 patterns.isLinux;
    mainProgram = "asmc";
  };
})
