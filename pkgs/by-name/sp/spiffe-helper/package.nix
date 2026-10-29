{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
}:

buildGo127Module (finalAttrs: {
  pname = "spiffe-helper";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = "spiffe-helper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wg9Ijtf9iwua/CPKd/iCw638qL30RlAGAbE1FLSiTfY=";
  };

  vendorHash = "sha256-m0leI9dGckceaiFPG7l+oNg3cxRbhk0ZpdD9M3EvxSI=";

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
