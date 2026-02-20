{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nmap-formatter";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = "nmap-formatter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qai8HbVJJLFH5cNiG24fBjq5++6mvlhpT+4hlvx+gGI=";
  };

  vendorHash = "sha256-q94ET4oMYvF3eCJ358EznwL++vwdCeEAu5UquGChCc0=";

  meta = {
    description = "Tool that allows you to convert nmap output";
    mainProgram = "nmap-formatter";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    changelog = "https://github.com/vdjagilev/nmap-formatter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
