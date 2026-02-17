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
buildGoModule (finalAttrs: {
  pname = "gitlab-elasticsearch-indexer";
  version = "5.12.2";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dfDZIVDtCtph4zMS+3qT7dMlbUXZCIfr8rIBemHFMQ0=";
  };

  vendorHash = "sha256-LwBc/eQ2AQan8SsH+kugAeUv4O31WOx3Qnd1tB580wY=";

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
    maintainers = with lib.maintainers; [
      e1mo
      xanderio
      yayayayaka
    ];
  };
})
