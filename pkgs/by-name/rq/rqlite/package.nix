{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rqlite";
  version = "8.31.2";

  src = fetchFromGitHub {
    owner = "rqlite";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qxv7HuT7nV0Kr95WH1o02qbtn+oA85b4ZHm/rHGq25A=";
  };

  vendorHash = "sha256-P8v0vqxOfN9JjwsdoM6JmqGujGP5V68OAUc3KB/YU+k=";

  subPackages = [
    "cmd/rqlite"
    "cmd/rqlited"
    "cmd/rqbench"
  ];

  # Leaving other flags from https://github.com/rqlite/rqlite/blob/master/package.sh
  # since automatically retriving those is nontrivial and inessential
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
