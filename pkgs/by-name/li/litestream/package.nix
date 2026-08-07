{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "litestream";
  version = "0.5.15";

  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = "litestream";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SsHyi7E/1dHEzFQgKr8eSi1fEf61iqTQ6Avr4c/h9j4=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-Ms33rbFjsWzGbLy9v6kFGl6b62QQI4XAZ4wr73g5udw=";

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
