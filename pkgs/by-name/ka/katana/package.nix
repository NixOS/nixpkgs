{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "katana";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Q7ZcbiOo7/HHF/1NYfoOxAQk6zUJsrz6n2HJzw9/Ic=";
  };

  vendorHash = "sha256-rq19948HzGgtc6bRx9PYaPoeUk+3evE0UGpgM08i/ZM=";

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
