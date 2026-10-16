{
  lib,
  callPackage,
  buildGoModule,
  fetchFromGitLab,
  pkg-config,
  icu,
  stdenv, # for meta.broken
}:
let
  codeParserBindings = callPackage ./code-parser.nix { };
in
buildGoModule (finalAttrs: {
  pname = "gitlab-elasticsearch-indexer";
  version = "5.14.14";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-elasticsearch-indexer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rN+K/7sCV0S3Wd9ZhC/lG6inZUyqIWHCyD26/uc2XYM=";
  };

  # A dependency rather than an actual package to build.
  # Can be removed once GitLab Elasticsearch Indexer upstreams their changes
  excludedPackages = [
    "third_party/icu"
  ];

  vendorHash = "sha256-0Mt/IRtprLN/7rcY13WnVwlZfFAwl0EC5E0hnJzCBDE=";

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
    # last successful hydra build on darwin was in 2025
    broken = stdenv.hostPlatform.isDarwin;
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
