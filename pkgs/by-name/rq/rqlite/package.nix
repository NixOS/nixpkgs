{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rqlite";
  version = "8.37.4";

  src = fetchFromGitHub {
    owner = "rqlite";
    repo = "rqlite";
    rev = "v${version}";
    sha256 = "sha256-PMoQg3QjG0hyWKWIf5JIj7X9XbjpHpy1Hwo9DMsutW0=";
  };

  vendorHash = "sha256-3ZoMpmWOf3wIK0R1mY2GRzPA+Xb6YIdk+hLfzsC84/U=";

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
