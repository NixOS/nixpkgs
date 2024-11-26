{
  lib,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "nostui";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "akiomik";
    repo = "nostui";
    rev = "v${version}";
    hash = "sha256-RCD11KdzM66Mkydc51r6fG+q8bmKl5eZma58YoARwPo=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk; [ frameworks.SystemConfiguration ]
  );

  GIT_HASH = "000000000000000000000000000000000000000000000000000";

  checkFlags = [
    # skip failing test due to nix build timestamps
    "--skip=widgets::text_note::tests::test_created_at"
  ];

  cargoHash = "sha256-8ciA1FoGdnU+GWRcYJc8zU2FpUgGwTZSZynvAi1luYo=";

  meta = with lib; {
    homepage = "https://github.com/akiomik/nostui";
    description = "TUI client for Nostr";
    license = licenses.mit;
    maintainers = with maintainers; [ heywoodlh ];
    platforms = platforms.unix;
    mainProgram = "nostui";
  };
}
