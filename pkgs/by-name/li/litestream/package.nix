{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "litestream";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = "litestream";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LGlcc/FoBiZ7YiZUyqdYmAoV9BgUm4h2/n/KQ3NzFa4=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-Zf7BdL0mljGFrRTx4JJxAUXUm6Uh/sVJP/zOJ4ef/CU=";

  passthru.tests = { inherit (nixosTests) litestream; };

  meta = {
    description = "Streaming replication for SQLite";
    mainProgram = "litestream";
    license = lib.licenses.asl20;
    homepage = "https://litestream.io/";
    maintainers = with lib.maintainers; [ fbrs ];
  };
})
