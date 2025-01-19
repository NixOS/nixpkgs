{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "rapidloop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-P0IUMYALCy1upd+JLnNqDlNKMAEccfwjc3s8Rn7xI4k=";
  };

  vendorHash = "sha256-GOKgGONoM2q4doMoQwCLnHQjnB2QpPS3cxNnwzzz9ZU=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "pgmetrics";
  };
}
