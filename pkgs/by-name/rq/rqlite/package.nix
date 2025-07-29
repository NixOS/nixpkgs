{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rqlite";
  version = "8.41.0";

  src = fetchFromGitHub {
    owner = "rqlite";
    repo = "rqlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3jzQ6Kby/v/cBxc1+ejm5PdmhZVVWvBrDEeuf7hqVKw=";
  };

  vendorHash = "sha256-8Oejfec9QAYRkFGyEB9R/msiwzV+pgDFS+UNfvvTie4=";

  subPackages = [
    "cmd/rqlite"
    "cmd/rqlited"
    "cmd/rqbench"
  ];

  # Leaving other flags from https://github.com/rqlite/rqlite/blob/master/package.sh
  # since automatically retrieving those is nontrivial and inessential
  ldflags = [
    "-s"
    "-w"
    "-X github.com/rqlite/rqlite/cmd.Version=${finalAttrs.version}"
  ];

  # Tests are in a different subPackage which fails trying to access the network
  doCheck = false;

  meta = {
    description = "Lightweight, distributed relational database built on SQLite";
    homepage = "https://github.com/rqlite/rqlite";
    changelog = "https://github.com/rqlite/rqlite/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
