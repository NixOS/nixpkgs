{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nmap-formatter";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = "nmap-formatter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sh/OsDdwgKl4l3RZwtGbEGC1DU8qsO550Up0pqUKj5U=";
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
