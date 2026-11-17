{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
}:

buildGo127Module (finalAttrs: {
  pname = "spiffe-helper";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = "spiffe-helper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MT4VSB9EO8asWvakhGJT5TBQUyn/otVZDQygjFU1bkA=";
  };

  vendorHash = "sha256-qmr/Xm720pUiFsNW8AbYOCeaawR+Ghlyhr1isD2lyGg=";

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
