{ lib
, rustPlatform
, fetchCrate
}:
rustPlatform.buildRustPackage rec {
  pname = "stylance-cli";
  version = "0.5.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-2RLdO2TxIa/ngji5tzKzSfpq2qErI7gaQqObDTMrd/g=";
  };

  cargoHash = "sha256-26EKLvqc9x7JT6EDkH9KbQJ+xX/CUslLmEF4XxnPbFY=";

  meta = with lib; {
    description = "Library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ dav-wolff ];
  };
}
