{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rqlite";
  version = "8.43.2";

  src = fetchFromGitHub {
    owner = "rqlite";
    repo = "rqlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A/PP9jOEelELM3v36/b4YPbd/duzV3C/IXfHgmbjltY=";
  };

  vendorHash = "sha256-3BdRYAc/gbtOtEMfBMOK5scP58r85WNq0In7qNBwY0E=";

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
