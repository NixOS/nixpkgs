{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nmap-formatter";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = "nmap-formatter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GpJ6zEyGSYEXSPjZ0vTdSodQw4HvytPM0FcYfkvX81M=";
  };

  vendorHash = "sha256-0CTtw3QXnKBeHNFdkSfQhs+TSY5nrpLi36fS3Sz6A08=";

  meta = {
    description = "Tool that allows you to convert nmap output";
    mainProgram = "nmap-formatter";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    changelog = "https://github.com/vdjagilev/nmap-formatter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
