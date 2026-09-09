{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pgread";
  version = "0-unstable-2026-01-18";

  src = fetchFromGitHub {
    owner = "Chocapikk";
    repo = "pgread";
    rev = "48a71943fd1fed407a2bf6c9e0afaefabb7e26fc";
    hash = "sha256-Z9fXFygc7ftP3+6K8JMmaVjoMw1+dgHRvzM2TUhySwM=";
  };

  vendorHash = "sha256-rF9neBKy8HZQBKAaNiA0uAmVLtX93oblkZTowbfnUzs=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/Chocapikk/pgread/pgdump.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Tools to read PostgreSQL data files without credentials";
    homepage = "https://github.com/Chocapikk/pgread";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pgread";
  };
})
