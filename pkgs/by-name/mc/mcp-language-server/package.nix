{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-language-server";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "isaacphi";
    repo = "mcp-language-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T0wuPSShJqVW+CcQHQuZnh3JOwqUxAKv1OCHwZMr7KM=";
  };

  vendorHash = "sha256-3NEG9o5AF2ZEFWkA9Gub8vn6DNptN6DwVcn/oR8ujW0=";

  excludedPackages = [ "integrationtests" ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Language server that runs and exposes a language server to LLMs";
    homepage = "https://github.com/isaacphi/mcp-language-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ imalison ];
    mainProgram = "mcp-language-server";
  };
})
