{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "mcp-language-server";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "isaacphi";
    repo = "mcp-language-server";
    rev = "v${version}";
    hash = "sha256-T0wuPSShJqVW+CcQHQuZnh3JOwqUxAKv1OCHwZMr7KM=";
  };

  subPackages = [ "." ];

  proxyVendor = true;

  vendorHash = "sha256-niDJB3QhZjz9qIGSjUEcghRpEbPUgsSuK52ncZ21DS8=";

  meta = {
    description = "Model Context Protocol server to interact with language servers";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/isaacphi/mcp-language-server";
    mainProgram = "mcp-language-server";
    maintainers = with lib.maintainers; [
      fayash
    ];
  };
}
