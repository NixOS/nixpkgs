{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "kin-openapi";
  version = "0.135.0";
  vendorHash = "sha256-Tf/F7L2F3nhyf6WYsc1FFsBEcMwFHfqkNBlRfcnVRO8=";

  src = fetchFromGitHub {
    owner = "getkin";
    repo = "kin-openapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hg8FK11Q3dRcuKGCBsXkoBaHXpSGQLKM6PnKEir0kBI=";
  };

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestExtraSiblingsInRemoteRef"
        "TestIssue495WithDraft04"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  subPackages = [ "cmd/validate" ];

  meta = {
    mainProgram = "validate";
    description = "Command line tool to validation openapi3 documents";
    homepage = "https://github.com/getkin/kin-openapi";
    changelog = "https://github.com/getkin/kin-openapi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers._6543 ];
  };
})
