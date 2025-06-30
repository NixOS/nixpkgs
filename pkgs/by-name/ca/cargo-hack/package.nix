{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.36";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-AO4bB+aqAzGxFyPhuwaEQDAbL+fCIWY2rv3QFdBAq7s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fWKrHo5WdeEhnPxATbZ9Cjv+aiSxOh0pRDeeHHDk8u4=";

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
