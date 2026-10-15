{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-sort-derives";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "cargo-sort-derives";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AOoltabANFWxaI0jeAR+XNk4qn6y2UujGWNFbNakfoo=";
  };

  cargoHash = "sha256-Mwgscv6VrrVBArV05V+xGmaWuWqvr3kG8QZYO5S+vOE=";

  meta = {
    description = "Cargo subcommand to sort derive attributes";
    mainProgram = "cargo-sort-derives";
    homepage = "https://lusingander.github.io/cargo-sort-derives/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sebimarkgraf ];
  };
})
