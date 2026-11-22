{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "brave-search-cli";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "brave";
    repo = "brave-search-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9be8CdS92src2f56sIfYe8UaN3LWxtMGbrTvqzFw08U=";
  };

  cargoHash = "sha256-GA9qKuFh1YOaUPuAQ//VJqScLJaqxHIyLl/TDnOTsdY=";

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
