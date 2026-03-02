{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "katana";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hVT1RGS4h3vKcSxIT1nSRN+MC7k1KlGHhotByq+UUY4=";
  };

  vendorHash = "sha256-Cl3aUC4MJC/tUo/yuCdGspMShUMo65fNUHXHy8+/m+o=";

  subPackages = [ "cmd/katana" ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "katana";
  };
})
