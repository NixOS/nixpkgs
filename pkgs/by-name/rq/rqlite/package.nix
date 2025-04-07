{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rqlite";
  version = "8.36.16";

  src = fetchFromGitHub {
    owner = "rqlite";
    repo = pname;
    tag = "v${version}";
    sha256 = "sha256-mMsQJETeDyENMkCOmKb6TxDp9lYHSQIjaJtbsYzTJMs=";
  };

  vendorHash = "sha256-6Y15vVvu1KHWTJKDmDKjWt0Kolu6q0mmo94YAHMXs/E=";

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
    "-X github.com/rqlite/rqlite/cmd.Version=${src.rev}"
  ];

  # Tests are in a different subPackage which fails trying to access the network
  doCheck = false;

  meta = with lib; {
    description = "Lightweight, distributed relational database built on SQLite";
    homepage = "https://github.com/rqlite/rqlite";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
