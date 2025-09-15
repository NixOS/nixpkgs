{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.38";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-gKuc7FTBlWasRb59IvzFT54I7aY3MjNAkl2YCVZzl6Q=";
  };

  cargoHash = "sha256-TRtz6OVYyt/sHVMoR5wDRbAPVvB33d8kSSTlO6JJkdM=";

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
