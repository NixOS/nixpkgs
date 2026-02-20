{
  lib,
  callPackage,
  buildGoModule,
  fetchFromGitLab,
  pkg-config,
  icu,
}:
let
  codeParserBindings = callPackage ./code-parser.nix { };
in
buildGoModule rec {
  pname = "gitlab-elasticsearch-indexer";
  version = "5.13.3";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${version}";
    hash = "sha256-0FLAqjbafYsmr21OwNJceikC5Qdr5BIAuHnl1x8oiXs=";
  };

  vendorHash = "sha256-2RlRCkqxupOvmyBe/zQC3Lyp9x0KHnTa6UnxldK1YZQ=";

  buildInputs = [ icu ];
  nativeBuildInputs = [ pkg-config ];

  env = {
    CGO_LDFLAGS = "-L${codeParserBindings}/lib";
    CGO_CFLAGS = "-I${codeParserBindings}/include";
  };

  checkFlags =
    let
      # Skip tests that require an elasticsearch instance
      skippedTests = [
        "TestBulkSizeTracking"
        "TestProactiveFlushOnSizeLimit"
        "TestRemoveBulkSizeTracking"
        "TestDeleteBulkSizeTracking"
        "TestMixedOperationsBulkSizeTracking"
        "TestConcurrentOperationsThreadSafety"
        "TestConcurrentFlushOperations"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru = {
    inherit codeParserBindings;
  };

  meta = {
    description = "Indexes Git repositories into Elasticsearch for GitLab";
    mainProgram = "gitlab-elasticsearch-indexer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yayayayaka ];
    teams = [ lib.teams.cyberus ];
  };
}
