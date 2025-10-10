{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "stylance-cli";
  version = "0.7.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Cdv+Lz+l0+8Jdk9stHACXDbUPedM/YryDMExdsqVvsU=";
  };

  cargoHash = "sha256-cwgR5AHCeS9YkaJlyFxvEOrBXg7/tXNGXgtSEPHAwm4=";

  meta = {
    description = "Library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
}
