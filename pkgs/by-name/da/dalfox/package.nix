{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "dalfox";
    rev = "refs/tags/v${version}";
    hash = "sha256-tg8TXPeGINGDBR3HOWYRXrg7ioBFhX1V7N1wRzHI0/c=";
  };

  vendorHash = "sha256-SXNkMaUZ2jYoSmlmss4lFwpgxvqRF0D27KpANJveaq4=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    changelog = "https://github.com/hahwul/dalfox/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "dalfox";
  };
}
