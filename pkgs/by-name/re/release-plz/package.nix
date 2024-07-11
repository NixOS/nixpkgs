{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, pkg-config
, perl
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "release-plz";
  version = "0.3.74";

  src = fetchFromGitHub {
    owner = "MarcoIeni";
    repo = "release-plz";
    rev = "release-plz-v${version}";
    hash = "sha256-6Cj23OlIVWnuJC4jpmd7o5L4pUSUkTycZbpu8CzSVM0=";
  };

  cargoHash = "sha256-YAijOHu59BWIsS5cYFYbG4zGG0l+x9cqHfEGu3oL5l0=";

  nativeBuildInputs = [ installShellFiles pkg-config perl ];
  buildInputs = [ openssl ];

  buildAndTestSubdir = "crates/release_plz";

  # Tests depend on additional infrastructure to be running locally
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd ${meta.mainProgram} \
      --bash <($out/bin/${meta.mainProgram} generate-completions bash) \
      --fish <($out/bin/${meta.mainProgram} generate-completions fish) \
      --zsh <($out/bin/${meta.mainProgram} generate-completions zsh)
  '';

  meta = {
    description = "Publish Rust crates from CI with a Release PR";
    homepage = "https://release-plz.ieni.dev";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = with lib.maintainers; [ dannixon ];
    mainProgram = "release-plz";
    broken = stdenv.isDarwin;
  };
}
