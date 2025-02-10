{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-spellcheck";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NrtPV2bd9BuA1nnniIcth85gJQmFGy9LHdajqmW8j4Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1bOEOZ1byVm9apCqR9zgESsgA9Z9TdFSondwzwOPfWI=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  preCheck = "HOME=$(mktemp -d)";

  checkFlags = [
    "--skip checker::hunspell::tests::hunspell_binding_is_sane"
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
