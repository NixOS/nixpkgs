{
  lib,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,
  perl,
  stdenv,
  CoreServices,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "kakoune-lsp";
  version = "18.1.2";

  src = fetchFromGitHub {
    owner = "kakoune-lsp";
    repo = "kakoune-lsp";
    rev = "v${version}";
    hash = "sha256-wIKAChmD6gVfrRguywiAnpT3kbCbRk2k2u4ckd1CNOw=";
  };

  patches = [ (replaceVars ./Hardcode-perl.patch { inherit perl; }) ];

  cargoHash = "sha256-6qXdZ1EtYdne0zs5usLXkZm2qYl1gwpTki0cvip+FkE=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    CoreServices
    Security
    SystemConfiguration
  ];

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
