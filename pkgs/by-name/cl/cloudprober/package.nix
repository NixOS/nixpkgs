{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

# go 1.27 speeded up the compression so the
# test TestCompressBytes fail because the output changed
buildGo126Module (finalAttrs: {
  pname = "cloudprober";
  version = "0.14.7";

  src = fetchFromGitHub {
    owner = "cloudprober";
    repo = "cloudprober";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qvHrHBAsQkCkWy5DOrMKO+qPlwr9lwFWBqlpj+YyLJQ=";
  };

  vendorHash = "sha256-Cgb+/dKfX9yhAhGIMb7piC1/nrQIOX+7suobPMuFWTQ=";

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestSaveProbesConfig"
        "TestRunProbeRealICMP"
        "TestMultipleTargetsMultipleRequests"
        "TestCommandNotifierReapsChild"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "Monitor availability and performance of various components of your system";
    homepage = "https://cloudprober.org/";
    changelog = "https://github.com/cloudprober/cloudprober/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xgwq ];
    mainProgram = "cloudprober";
  };
})
