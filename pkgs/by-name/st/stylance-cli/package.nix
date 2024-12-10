{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "stylance-cli";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-YQYYZxLypD5Nz8kllIaBFDoV8L2c9wzJwmszqPpjpmg=";
  };

  cargoHash = "sha256-ZzdLbsHRBgprdzmPVzywJx+wMMqRBsLeT84UIDMJbQM=";

  meta = with lib; {
    description = "A library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ dav-wolff ];
  };
}
