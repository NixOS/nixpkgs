{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "katana";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    rev = "refs/tags/v${version}";
    hash = "sha256-cRzLJcX7U9jhKMYnpOyo8S8hN6cIeUYFElcmOqbv0GY=";
  };

  vendorHash = "sha256-NaPVrgFbw77kxl2sw1nHhqr1ePn5TYhS2rS0et7qJKs=";

  subPackages = [ "cmd/katana" ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "katana";
  };
}
