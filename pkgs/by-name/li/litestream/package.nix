{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "litestream";
  version = "0.5.16";

  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = "litestream";
    rev = "v${finalAttrs.version}";
    hash = "sha256-06ZQbOol87HZVaBFOyYbSasl3eHFcdwrYTnmProg9uY=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-xoJwxmQzWSQ055+W1I+hNyEcB3bfShCoAfdMU4Pckjc=";

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
