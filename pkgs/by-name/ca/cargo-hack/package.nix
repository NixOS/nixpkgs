{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.33";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/O05q4osyQ30rHKe84oBQJTFuVmPGB5KKy6UM/TzY5Q=";
  };

  cargoHash = "sha256-vkvna8+1+qQh+ZXtQ/HJa8UnstuH1sKlFc4CEUZYc5E=";

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
