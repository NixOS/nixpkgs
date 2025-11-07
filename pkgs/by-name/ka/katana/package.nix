{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "katana";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    tag = "v${version}";
    hash = "sha256-zqcQBRF03TOldfMw/Yw6fdryfW2N5SHOikuliSL0v+A=";
  };

  vendorHash = "sha256-ZcukX+x0csNUxdIERS3ACw728+TsVicsbOqdL6DxgkA=";

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
