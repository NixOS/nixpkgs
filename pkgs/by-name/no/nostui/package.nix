{
  lib,
  fetchFromGitHub,
  rustPlatform,
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

  GIT_HASH = "000000000000000000000000000000000000000000000000000";

  checkFlags = [
    # skip failing test due to nix build timestamps
    "--skip=widgets::text_note::tests::test_created_at"
  ];

  cargoHash = "sha256-tway75ZAP2cGdpn79VpuRd0q/h+ovDvkih1LKitM/EU=";

  meta = {
    homepage = "https://github.com/akiomik/nostui";
    description = "TUI client for Nostr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ heywoodlh ];
    platforms = lib.platforms.unix;
    mainProgram = "nostui";
  };
}
