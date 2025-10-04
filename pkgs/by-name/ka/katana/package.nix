{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "katana";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    tag = "v${version}";
    hash = "sha256-q7uOtfxSS6cLZKjnObLAzn+JpC2myEkoTd2TINBhYcU=";
  };

  vendorHash = "sha256-9RoL6gpAJXO2/0UCmpRnh8roZw/txNgb/H0kVTKVxWs=";

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
