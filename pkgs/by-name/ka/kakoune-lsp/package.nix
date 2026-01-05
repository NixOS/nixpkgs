{
  lib,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "kakoune-lsp";
  version = "19.0.0";

  src = fetchFromGitHub {
    owner = "kakoune-lsp";
    repo = "kakoune-lsp";
    rev = "v${version}";
    hash = "sha256-N1J8HBhOLZmR51y1Z85rl0oxA1UrjBfbPb5hiZ1Q0aY=";
  };

  patches = [ (replaceVars ./Hardcode-perl.patch { inherit perl; }) ];

  cargoHash = "sha256-AaqA+MvpmvPUOLI0usuf9rxr7TcoMSO9mOsg3OCHljw=";

  meta = {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/kakoune-lsp/kakoune-lsp";

    # See https://github.com/kakoune-lsp/kakoune-lsp/commit/55dfc83409b9b7d3556bacda8ef8b71fc33b58cd
    license = with lib.licenses; [
      unlicense
      mit
    ];

    maintainers = with lib.maintainers; [
      philiptaron
      spacekookie
      poweredbypie
    ];

    mainProgram = "kak-lsp";
  };
}
