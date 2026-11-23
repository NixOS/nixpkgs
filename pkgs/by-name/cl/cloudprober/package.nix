{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

# go 1.27 speeded up the compression so the
# test TestCompressBytes fail because the output changed
buildGo126Module (finalAttrs: {
  pname = "cloudprober";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "cloudprober";
    repo = "cloudprober";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dMogW0NQAMiSBC7//7gGmadvK5vS2H+170aW0RK58fU=";
  };

  vendorHash = "sha256-YEueI/Ms350bNkKPmLNzLljr9FDL0R7zACF4HQwHLdk=";

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestSaveProbesConfig"
        "TestRunProbeRealICMP"
        "TestMultipleTargetsMultipleRequests"
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
