{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nostui";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "akiomik";
    repo = "nostui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7i76JPg6MAk4/sO8/JI4ody4iYFJPeLkD2SWncFhT4o=";
  };

  GIT_HASH = "000000000000000000000000000000000000000000000000000";

  checkFlags = [
    # skip failing test due to nix build timestamps
    "--skip=widgets::text_note::tests::test_created_at"
  ];

  cargoHash = "sha256-X5VeL9oWjqoWmXQTCINvvFLdXqCyhO01ckDU7x42Teo=";

  meta = {
    homepage = "https://github.com/akiomik/nostui";
    description = "TUI client for Nostr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ heywoodlh ];
    platforms = lib.platforms.unix;
    mainProgram = "nostui";
  };
})
