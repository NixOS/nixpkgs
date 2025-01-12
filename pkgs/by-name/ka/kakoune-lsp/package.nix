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
  version = "18.1.1";

  src = fetchFromGitHub {
    owner = "kakoune-lsp";
    repo = "kakoune-lsp";
    rev = "v${version}";
    hash = "sha256-7ULohcCpIKOb7CtsF2dIkiRt94uBIrGD5pQ2AEfrNrY=";
  };

  patches = [ (replaceVars ./Hardcode-perl.patch { inherit perl; }) ];

  cargoHash = "sha256-eG9VPsZkdNTieUc4ghngLqE2ps6wJFR7W8qcmfMu0fs=";

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
