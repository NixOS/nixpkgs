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
    tag = "v${version}";
    hash = "sha256-tg8TXPeGINGDBR3HOWYRXrg7ioBFhX1V7N1wRzHI0/c=";
  };

  vendorHash = "sha256-SXNkMaUZ2jYoSmlmss4lFwpgxvqRF0D27KpANJveaq4=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    changelog = "https://github.com/hahwul/dalfox/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dalfox";
  };
}
