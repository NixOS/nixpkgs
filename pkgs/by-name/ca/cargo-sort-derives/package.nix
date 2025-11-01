{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-sort-derives";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "cargo-sort-derives";
    tag = "v${version}";
    hash = "sha256-6AaRtj3Q23bXLBAbQQBwa//P6DFIbgDYFhCth/gkAUk=";
  };

  cargoHash = "sha256-PaM34tEsukTAj6SBM5Nzh/KgrOBaurMLimkAWac6yRI=";

  meta = {
    description = "Cargo subcommand to sort derive attributes";
    mainProgram = "cargo-sort-derives";
    homepage = "https://lusingander.github.io/cargo-sort-derives/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sebimarkgraf ];
  };
}
