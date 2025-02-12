{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-spellcheck";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-KiulbQhSg5CCZlts8FLsfOrN7nz16u3gRnQrWTFAzdc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iDulfKsw3Ui5b1v7QakIcf7HXNEBlMbhbzqLekuSsUU=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  preCheck = "HOME=$(mktemp -d)";

  checkFlags = [
    "--skip=checker::hunspell::tests::hunspell_binding_is_sane"
    # requires dictionaries
    "--skip=tests::e2e::issue_226"
  ];

  meta = with lib; {
    description = "Checks rust documentation for spelling and grammar mistakes";
    mainProgram = "cargo-spellcheck";
    homepage = "https://github.com/drahnr/cargo-spellcheck";
    changelog = "https://github.com/drahnr/cargo-spellcheck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      newam
      matthiasbeyer
    ];
  };
}
