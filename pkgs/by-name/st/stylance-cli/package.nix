{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "stylance-cli";
  version = "0.5.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-YN7Y8dxwpZel1SeEgyckh4ZPuRqcAsNvc/fGRgvzeDw=";
  };

  cargoHash = "sha256-VKfQzsTTKIbh+X0suXyUXDsd8sDSRsc5SnO8qxcxGPQ=";

  meta = with lib; {
    description = "Library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ dav-wolff ];
  };
}
