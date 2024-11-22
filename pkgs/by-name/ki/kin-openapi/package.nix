{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "kin-openapi";
  version = "0.128.0";
  vendorHash = "sha256-yNS5Rtmxts4uOhMPTXCFRhe/dLPZZAtGKe/bNkOeIBw=";

  src = fetchFromGitHub {
    owner = "getkin";
    repo = "kin-openapi";
    rev = "refs/tags/v${version}";
    hash = "sha256-4pYrg75dFFdFS2SC1BvFoHcLFNGgBumXd3Vd7jHvUJg=";
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
    changelog = "https://github.com/getkin/kin-openapi/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers._6543 ];
  };
}
