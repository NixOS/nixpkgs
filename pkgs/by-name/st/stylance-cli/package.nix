{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "stylance-cli";
  version = "0.5.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/aTda9TOwC2spODMWQIaBzJJ17/8EoWIRZ7DjJE/ta4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZMIbNQMZ7uCYFSIX2NTGY/31V6e0QWHjZvVaA8Vv7IQ=";

  meta = with lib; {
    description = "Library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ dav-wolff ];
  };
}
