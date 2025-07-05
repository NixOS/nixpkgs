{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.131.4";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-jDZ7Y+3CnuL5vIVns+5PdmMjfqbP0K596HDivu++zyA=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-8g5NZpw2T2NuyizSh/cA2seSChEGWzlZmR82Xg0ClKQ=";

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
