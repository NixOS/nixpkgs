{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "litestream";
  version = "0.5.12";

  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = "litestream";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2Dv+iqWfThJzi5H/2jm6g2OcsjyPpZrJdGJ9KQ7kMl4=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-ZlrORrH53/l276ZSaDncmFozDt/BtvnHTDuvcJXrVEg=";

  passthru.tests = { inherit (nixosTests) litestream; };

  meta = {
    description = "Streaming replication for SQLite";
    mainProgram = "litestream";
    license = lib.licenses.asl20;
    homepage = "https://litestream.io/";
    maintainers = with lib.maintainers; [ fbrs ];
  };
})
