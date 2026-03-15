{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cloudprober";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "cloudprober";
    repo = "cloudprober";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wZokCv8LnMHJquujk37XiTnp+sUgyOqkl5d2b69xZlc=";
  };

  vendorHash = "sha256-XkDPih82bA+IOev4tB5mbcNp6gFHLvSGSnPNQyygc4A=";

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
