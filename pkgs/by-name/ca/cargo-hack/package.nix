{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.34";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-FAcKzLr835FxgcnWmAe1JirzlRc3fvxGXMKxnSmgCzA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3M+UK0+lvnRH7j1vbqMgpE7mnz8YnPO3MEjQWnPRy8c=";

  # some necessary files are absent in the crate version
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand to provide various options useful for testing and continuous integration";
    mainProgram = "cargo-hack";
    homepage = "https://github.com/taiki-e/cargo-hack";
    changelog = "https://github.com/taiki-e/cargo-hack/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
