{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-spellcheck";
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = "cargo-spellcheck";
    tag = "v${version}";
    hash = "sha256-saRr1xEBefLoCgCxU/pyQOmmt/di+DOQHMoVc4LgRm0=";
  };

  cargoHash = "sha256-MGjyoHejsUd6HCoZVlw1NDG6TE9Anh05IeObHmcnwg0=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  preCheck = "HOME=$(mktemp -d)";

  checkFlags = [
    "--skip=checker::hunspell::tests::hunspell_binding_is_sane"
    # requires dictionaries
    "--skip=tests::e2e::issue_226"
  ];

  meta = {
    description = "Checks rust documentation for spelling and grammar mistakes";
    mainProgram = "cargo-spellcheck";
    homepage = "https://github.com/drahnr/cargo-spellcheck";
    changelog = "https://github.com/drahnr/cargo-spellcheck/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      newam
      matthiasbeyer
    ];
  };
}
