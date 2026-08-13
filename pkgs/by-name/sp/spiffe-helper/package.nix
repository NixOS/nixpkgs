{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "spiffe-helper";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = "spiffe-helper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-akuq5qqL+B4kyZ7EuBYOPYQ15/hUsUPTmewgQWYTXos=";
  };

  vendorHash = "sha256-32ArgWgQFHPyA/wqbcuIZ77HCCsh+V3QFw/8YrPJZww=";

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    patchShebangs pkg/sidecar/sidecar_test.sh
  '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck

    # no version output
    $out/bin/${finalAttrs.meta.mainProgram} -h

    runHook postInstallCheck
  '';

  meta = {
    description = "Retrieve and manage SVIDs on behalf of a workload";
    homepage = "https://github.com/spiffe/spiffe-helper";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jk ];
    mainProgram = "spiffe-helper";
  };
})
