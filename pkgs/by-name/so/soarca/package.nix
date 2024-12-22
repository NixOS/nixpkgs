{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go-swag,
  nixosTests,
  nix-update-script,
}:

buildGoModule {
  pname = "soarca";
  version = "1.1.0-beta-1-unstable-2024-12-19";

  src = fetchFromGitHub {
    owner = "COSSAS";
    repo = "SOARCA";
    rev = "fe560ac6d5c7b372c81cec16937782758a089f26";
    hash = "sha256-4QN6zx2TajUIERH+YqmuNUb/ZbJHUWKrHdrOiyHXsWc=";
  };

  vendorHash = "sha256-pATXKcPbAvh8Hsa3v2TkQq8AqN+RVNirT1OegdShWwQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  preBuild = ''
    mkdir -p api
    ${lib.getExe go-swag} init -g cmd/soarca/main.go -o api
  '';

  checkFlags =
    let
      skippedTests = [
        # require internet access
        "TestHttpConnection"
        "TestHttpOAuth2"
        "TestHttpBasicAuth"
        "TestHttpBearerToken"
        "TestHttpPostWithContentConnection"
        "TestHttpPostWithBase64ContentConnection"
        "TestHttpPostConnection"
        "TestHttpPutConnection"
        "TestHttpDeleteConnection"
        "TestHttpStatus200"
        "TestHttpGetConnection"
        "TestInsecureHTTPConnection"
        "TestSshConnection"
        "TestConnect" # times out
        # integrations
        "TestPowershellConnection"
        "TestTheHiveConnection"
        "TestTheHiveReporting"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru = {
    tests.soarca = nixosTests.soarca;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open Source CACAO-based Security Orchestrator";
    homepage = "https://github.com/COSSAS/SOARCA";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ _13621 ];
    mainProgram = "soarca";
  };
}
