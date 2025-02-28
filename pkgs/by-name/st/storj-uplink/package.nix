{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.122.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-PO5if8fBbWkLSEFuRues/B4+yWo6I4TNH25SybGU1Rg=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-mISSkuBU0E/ss5hLq5S4luStqJ/r9Vy1VVe5hMLehSc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
