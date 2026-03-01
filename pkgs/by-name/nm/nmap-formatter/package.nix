{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nmap-formatter";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = "nmap-formatter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8RDrLGNVa63tz+3WupDg5Jw+9R+NrclFvO8rsMJ7/1w=";
  };

  vendorHash = "sha256-fHT1FxrUmDv7YG0Kin8jZkolFAvnaEhLhgAvA8tzxkI=";

  meta = {
    description = "Tool that allows you to convert nmap output";
    mainProgram = "nmap-formatter";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    changelog = "https://github.com/vdjagilev/nmap-formatter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
