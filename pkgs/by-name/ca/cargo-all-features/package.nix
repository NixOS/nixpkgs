{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-all-features";
  version = "1.11.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-pHwQq6/KGCIYm3Q63YbUit6yUjwEFnpBJCE6lpGBcZc=";
  };

  cargoHash = "sha256-tAwU7vJLp4KLzYAEbtSpNKbZBz+hBdAiIkUD/A5CpwI=";

  meta = with lib; {
    description = "Cargo subcommand to build and test all feature flag combinations";
    homepage = "https://github.com/frewsxcv/cargo-all-features";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
