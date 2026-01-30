{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rqlite";
  version = "9.3.16";

  src = fetchFromGitHub {
    owner = "rqlite";
    repo = "rqlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pWZy8xuKIuJZXjzLwR15Q5CWCexNbqiA8PkvFEjxkYY=";
  };

  vendorHash = "sha256-wOeYMj1jlMCnckDsO/y7vHsi2QnR8va8cVtl79dc9qs=";

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
