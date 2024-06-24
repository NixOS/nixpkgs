{ lib
, rustPlatform
, fetchCrate
}:
rustPlatform.buildRustPackage rec {
  pname = "stylance-cli";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-nwvlce1a5Qerh1wa/lAtkl60fpjMV6WQuEzNLfmCK7k=";
  };

  cargoHash = "sha256-e8lu839kthncvCVlg13ZWNUwYGgGVgXZWJlHufubNA8=";

  meta = with lib; {
    description = "Library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ dav-wolff ];
  };
}
