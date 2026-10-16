{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-olde";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "nix-olde";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zpKcEUSqfkfBgDaz/2wIajCAzPOrBP6aPnMA6v1wnb8=";
  };

  cargoHash = "sha256-HbcgCrRjQ49Ekwl6MoWk6h6iYqKtNzEx/gtp9ktP1Y8=";

  meta = {
    description = "Show details about outdated packages in your NixOS system";
    homepage = "https://github.com/trofi/nix-olde";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qweered ];
    mainProgram = "nix-olde";
  };
})
