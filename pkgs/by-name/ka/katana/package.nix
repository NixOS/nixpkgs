{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "katana";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XzJav0YGWBHNSrWiVVFOcHcAIIUjBCIUrbnfUzP9Vco=";
  };

  vendorHash = "sha256-xvMmBQ7am5uRbVQlAr42TqRLyfxMDF/Gygiud5LnewY=";

  subPackages = [ "cmd/katana" ];

  ldflags = [
    "-s"
  ];

  meta = {
    description = "Next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "katana";
  };
})
