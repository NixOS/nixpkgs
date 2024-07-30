{ lib
, rustPlatform
, fetchCrate
}:
rustPlatform.buildRustPackage rec {
  pname = "stylance-cli";
  version = "0.5.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-kpii3Jwvqhzp+Kummr0ypI9vyYVOcYKK0xCPwQknuWY=";
  };

  cargoHash = "sha256-tVSMZW2umkSilgPs/J7iFoBxKISrh7D73q3JWh2dJhI=";

  meta = with lib; {
    description = "Library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ dav-wolff ];
  };
}
