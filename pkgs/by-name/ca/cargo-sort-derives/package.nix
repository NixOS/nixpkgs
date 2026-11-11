{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-sort-derives";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "cargo-sort-derives";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BFIsgoAierFgcwtXeeapZLZ/Ujc4xiEBf064qP+MKgc=";
  };

  cargoHash = "sha256-5w5en18/Yyd+ZwB3tLTPZdylSL95MyxvNC3doT2lDB0=";

  meta = {
    description = "Cargo subcommand to sort derive attributes";
    mainProgram = "cargo-sort-derives";
    homepage = "https://lusingander.github.io/cargo-sort-derives/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sebimarkgraf ];
  };
})
