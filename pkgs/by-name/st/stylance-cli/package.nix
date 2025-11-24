{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "stylance-cli";
  version = "0.7.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ry/F1BbQKBkR06bwrmB/+y2XuUsREZNWhpTt4d9t9OM=";
  };

  cargoHash = "sha256-Xmfkk6sr4lAtD28PhUOMEax7aj4fCCJ90Aubobd2gOM=";

  meta = {
    description = "Library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
}
