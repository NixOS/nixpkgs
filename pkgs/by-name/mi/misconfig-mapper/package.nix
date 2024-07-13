{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "misconfig-mapper";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    rev = "refs/tags/v${version}";
    hash = "sha256-mla1rjko3hKbxdwUWzky/eFaibfPVXJSXqrVC3Usab4=";
  };

  vendorHash = "sha256-rpDzsUGtYIIUKf8P8Qkd16fuMbwKhKQMATYPVeNhstk=";

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
