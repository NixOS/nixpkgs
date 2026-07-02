{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "llmfit";
  version = "0.9.33";

  src = fetchFromGitHub {
    owner = "AlexsJones";
    repo = "llmfit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t78LXDadwqPhdD9s4aIq0ZKaynw+/rdC+ZL2Sk0lPTY=";
  };

  cargoHash = "sha256-gn9hhD+ztudHnUiOSXQUk9QbsQtcdfZW9HMRHCWAl0k=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI to find LLM models right sized for the system's RAM, CPU, and GPU";
    homepage = "https://github.com/AlexsJones/llmfit";
    changelog = "https://github.com/AlexsJones/llmfit/blob/v${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "llmfit";
  };
})
