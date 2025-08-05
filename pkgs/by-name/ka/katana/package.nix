{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "katana";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    tag = "v${version}";
    hash = "sha256-ldTK8Y6//goFhalF4BaLtbMkwoKJd1NDzUR9pLDRBD8=";
  };

  vendorHash = "sha256-st7gj4hynuY1dDUEhA4xbiOnxH3jV5T2RK+PhB46Lpk=";

  subPackages = [ "cmd/katana" ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "katana";
  };
}
