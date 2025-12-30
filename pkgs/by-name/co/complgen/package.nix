{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "complgen";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "v${version}";
    hash = "sha256-d5D2Vq8B3MDQEYRcoYDJ1yx1CH9PX/ipwPJD8QNBTOQ=";
  };

  cargoHash = "sha256-8JiyVypioVM0tKl2P6QSKM/HMpJjt+tzpmSBZAucQxM=";

  meta = {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    mainProgram = "complgen";
    homepage = "https://github.com/adaszko/complgen";
    changelog = "https://github.com/adaszko/complgen/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
