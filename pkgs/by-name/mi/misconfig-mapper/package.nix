{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "misconfig-mapper";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    rev = "refs/tags/v${version}";
    hash = "sha256-zg7OBHrveBmsljUJUE0/kz3AkIbUtTHf64BQbROUXsQ=";
  };

  vendorHash = "sha256-aABtsS39yxBBFMN98fjr4gy6QeF3dobrZqeZmmv2ywQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to uncover security misconfigurations on popular third-party services";
    homepage = "https://github.com/intigriti/misconfig-mapper";
    changelog = "https://github.com/intigriti/misconfig-mapper/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "misconfig-mapper";
  };
}
