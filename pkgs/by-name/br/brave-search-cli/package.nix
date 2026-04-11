{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "brave-search-cli";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "brave";
    repo = "brave-search-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wcZwgCPqIy+AVxpqcCI8rOyUOWXb7aYSsHJDS2pfpnE=";
  };

  cargoHash = "sha256-qIBepW7I5meLX9V3yEq6zoIRaZWD3CVjyrN8zpTAbR0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for the Brave Search API with support for web, news, images, and AI answer endpoints";
    homepage = "https://github.com/brave/brave-search-cli";
    changelog = "https://github.com/brave/brave-search-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ vitorpavani ];
    mainProgram = "bx";
    platforms = lib.platforms.all;
  };
})
