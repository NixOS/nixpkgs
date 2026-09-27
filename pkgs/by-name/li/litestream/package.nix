{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "litestream";
  version = "0.5.17";

  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = "litestream";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NOSyBKmxy+gtLFl4XgmU4xkKT06yRhEEdfcM0mB7ajU=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-IbnLypkKqtm+wceNXakdeML66fHNmuBRi+cWSFmUKWk=";

  # httptest servers in tests
  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit (nixosTests) litestream;
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "litestream version";
    };
  };

  meta = {
    description = "Streaming replication for SQLite";
    mainProgram = "litestream";
    license = lib.licenses.asl20;
    homepage = "https://litestream.io/";
    maintainers = with lib.maintainers; [
      fbrs
      konradmalik
    ];
  };
})
