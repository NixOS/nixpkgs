{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cloudprober";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "cloudprober";
    repo = "cloudprober";
    tag = "v${version}";
    hash = "sha256-t32mALyxtapPSzf/pNG0MGS2jjq0Dwm31qQZAlZI5zE=";
  };

  vendorHash = "sha256-u/glcoLlNXDEWFblnuvRHK9mUNCXTsfcWR+FDsJeOOA=";

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
