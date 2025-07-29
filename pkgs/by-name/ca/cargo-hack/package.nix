{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.37";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-OlWSyp3et/48x5lRE14pIny8HHQcgOV2f9mI9hcj8K4=";
  };

  cargoHash = "sha256-1FgFHnNCEGoBUbH+Uk67W9ufsGtr9uGdzJz0xZuPQ9U=";

  # some necessary files are absent in the crate version
  doCheck = false;

  meta = {
    description = "Cargo subcommand to provide various options useful for testing and continuous integration";
    mainProgram = "cargo-hack";
    homepage = "https://github.com/taiki-e/cargo-hack";
    changelog = "https://github.com/taiki-e/cargo-hack/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
