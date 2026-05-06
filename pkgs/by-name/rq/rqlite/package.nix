{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rqlite";
  version = "10.0.2";

  src = fetchFromGitHub {
    owner = "rqlite";
    repo = "rqlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PggY2tkodWcdJtLwmfsbfBmK8D6W5tuKo5ZLiE+pZ8g=";
  };

  vendorHash = "sha256-vj1IYHyWcoIBspWxu+jrgI3X4ou200bZ9M990v/mWBA=";

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
