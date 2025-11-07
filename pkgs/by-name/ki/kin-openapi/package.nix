{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "kin-openapi";
  version = "0.133.0";
  vendorHash = "sha256-SFT4mY0TVUa/hMMe7sOVToSX8qA1OimOiNs4kBjRdBU=";

  src = fetchFromGitHub {
    owner = "getkin";
    repo = "kin-openapi";
    tag = "v${version}";
    hash = "sha256-7KC+cHdI3zArJbSMfao8JIb3sUZJK1PQfrIiFI0zHM8=";
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
