{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "nostui";
<<<<<<< HEAD
  version = "0.1.1";
=======
  version = "0.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "akiomik";
    repo = "nostui";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7i76JPg6MAk4/sO8/JI4ody4iYFJPeLkD2SWncFhT4o=";
=======
    hash = "sha256-RCD11KdzM66Mkydc51r6fG+q8bmKl5eZma58YoARwPo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  GIT_HASH = "000000000000000000000000000000000000000000000000000";

  checkFlags = [
    # skip failing test due to nix build timestamps
    "--skip=widgets::text_note::tests::test_created_at"
  ];

<<<<<<< HEAD
  cargoHash = "sha256-X5VeL9oWjqoWmXQTCINvvFLdXqCyhO01ckDU7x42Teo=";

  meta = {
    homepage = "https://github.com/akiomik/nostui";
    description = "TUI client for Nostr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ heywoodlh ];
    platforms = lib.platforms.unix;
=======
  cargoHash = "sha256-tway75ZAP2cGdpn79VpuRd0q/h+ovDvkih1LKitM/EU=";

  meta = with lib; {
    homepage = "https://github.com/akiomik/nostui";
    description = "TUI client for Nostr";
    license = licenses.mit;
    maintainers = with maintainers; [ heywoodlh ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "nostui";
  };
}
