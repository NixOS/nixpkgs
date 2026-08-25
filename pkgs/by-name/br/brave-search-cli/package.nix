{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "brave-search-cli";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "brave";
    repo = "brave-search-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Fz4cE8gLGoVTOISPBVUlpEAKFqyl0QXyb0nG9csTKUs=";
  };

  cargoHash = "sha256-hsCpMYXPNYkpIC5FKVBRQuHsBrYWRhj/K5a6x+jxj6Y=";

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
