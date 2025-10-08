{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.37.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-42Yz6BGmT5EcS3N5x6aHyvnfpnYqicje2rtPx3z+Bu0=";
  };

  cargoHash = "sha256-pSZrLhEZwbnbjiIHmU5bcpHOEcodgD1mVgO6oI7zTG4=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    mainProgram = "svd2rust";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ newam ];
  };
}
