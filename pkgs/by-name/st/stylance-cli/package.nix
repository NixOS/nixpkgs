{ lib
, rustPlatform
, fetchCrate
}:
rustPlatform.buildRustPackage rec {
  pname = "stylance-cli";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-9RrBncFh6gv5QxXOi5IGY8pFsY6T5PB8L0yvWg5WoDU=";
  };

  cargoHash = "sha256-HB+uA/JR1cBWcSzyygzTp8NsCnkhkUMoR5F0HfPPwtQ=";

  meta = with lib; {
    description = "A library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ dav-wolff ];
  };
}
