{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-all-features";
  version = "1.10.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/w3Xd7PXUNtqzRYmUqJtth+GDuXSnsk1NiYCTYsHuAQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-OgVeAuC36mP8rv4+XHsrOe7KKnpQ/u0M3g91NE0u98A=";

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
