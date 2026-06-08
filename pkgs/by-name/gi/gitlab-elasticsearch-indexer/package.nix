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
  version = "5.14.7";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1fVBCem23X8u1NQ6ph37EiXRvMpzF/8Yac+VefAe9Yg=";
  };

  vendorHash = "sha256-cUHXrUd+pSMiS6iSwKKA+o1B6ZHbaQYHYPeVk1Y6wYM=";

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
    homepage = "https://gitlab.com/gitlab-org/gitlab-elasticsearch-indexer";
    mainProgram = "gitlab-elasticsearch-indexer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      e1mo
      xanderio
      yayayayaka
    ];
  };
})
