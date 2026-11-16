{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nmap-formatter";
  version = "3.1.5";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = "nmap-formatter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xsHlvafdgrWaMbINhcmo+mHFhO7iFlAG7ovBWlrOy9Q=";
  };

  vendorHash = "sha256-J43xWjQ7vXsj9qyI/6EJI0/70NDnjpnVauN/nt3IXVQ=";

  meta = {
    description = "Tool that allows you to convert nmap output";
    mainProgram = "nmap-formatter";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    changelog = "https://github.com/vdjagilev/nmap-formatter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
