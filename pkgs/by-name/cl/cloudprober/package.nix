{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cloudprober";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "cloudprober";
    repo = "cloudprober";
    tag = "v${version}";
    hash = "sha256-XFMjUwsRfWAnrNsegUPqWz8Bcc/naEBhytqq/o21ras=";
  };

  vendorHash = "sha256-+EVcYFnWPSNfxUzxuL3tAHjCCDad/7K11y3dk2CUtrU=";

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
    changelog = "https://github.com/cloudprober/cloudprober/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xgwq ];
    mainProgram = "cloudprober";
  };
}
