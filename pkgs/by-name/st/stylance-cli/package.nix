{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "stylance-cli";
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-uksDnxTBuzwpMDCO3HIg05IK1emba6BjbpN0TcWSOdQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iSE6SmqYXg9IAMJOb4/q80w+J2OEVd7oyxRpWcCps9U=";

  meta = {
    description = "Library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
}
