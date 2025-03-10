{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "spirit";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "cashapp";
    repo = "spirit";
    rev = "v${version}-prerelease";
    hash = "sha256-qC27kkUWELRFEVhZT7R6ickpAfDbL/AtYx2gRkDTvrI=";
  };

  vendorHash = "sha256-Dq7UeAH7FvY12rEYkpcKpEUzMMrGfubt0WadnZYt8dk=";

  subPackages = [ "cmd/spirit" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://github.com/cashapp/spirit";
    description = "Online schema change tool for MySQL";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "spirit";
  };
}
