{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-sort-derives";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "cargo-sort-derives";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YNZmEHjmedLXfKKqJjF24knly+S4Sehfgk8Wqlb/oa0=";
  };

  cargoHash = "sha256-fj5kWJ6BV2WOYpJ3PEq2KGqAMzgHAuuGeK2hBl0mjFY=";

  meta = {
    description = "Cargo subcommand to sort derive attributes";
    mainProgram = "cargo-sort-derives";
    homepage = "https://lusingander.github.io/cargo-sort-derives/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sebimarkgraf ];
  };
})
