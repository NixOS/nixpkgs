{
  lib,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "kakoune-lsp";
  version = "18.1.3";

  src = fetchFromGitHub {
    owner = "kakoune-lsp";
    repo = "kakoune-lsp";
    rev = "v${version}";
    hash = "sha256-2jD0meehUNGvmywOY4D9CwP1qswD7QCPlctLBjngzvE=";
  };

  patches = [ (replaceVars ./Hardcode-perl.patch { inherit perl; }) ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-fb6RDcOLtkrUqw+BX2oa43d84BGF8IA2HxhdGgB94iU=";

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
