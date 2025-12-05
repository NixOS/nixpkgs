{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "amber-lsp";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "amber-lang";
    repo = "amber-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rVh79myF1kfYY0P8hq8ZPNXOkhGvyZZzv8SFYfRJKy8=";
  };

  cargoLock = {
    # Upstream does not include lock file
    lockFile = ./Cargo.lock;
    # Git dependencies require manual hashes
    outputHashes = {
      "chumsky-1.0.0-alpha.7" = "sha256-eF48NeuUHdpwNf5+Ura6P7aXfCWHd/rziQTOomaPoic=";
    };
  };
  postPatch = ''ln -s ${./Cargo.lock} Cargo.lock'';

  meta = {
    description = "Official language server for the Amber programming language";
    mainProgram = "amber-lsp";
    homepage = "https://github.com/amber-lang/amber-lsp";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tye-exe ];
  };
})
