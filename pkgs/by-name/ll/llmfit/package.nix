{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "llmfit";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "AlexsJones";
    repo = "llmfit";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-m3JV7lF/YuxtPMsUvGNQd4VjLw4KFuBM5jQYjnC+2Hs=";
  };

  cargoHash = "sha256-Ue09DBvcqyvQDQ23yAUa6Fo56AWn5pxAl2XYiVLrUYI=";

  meta = {
    description = "Find what runs on your hardware";
    homepage = "https://github.com/AlexsJones/llmfit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "llmfit";
  };
})
