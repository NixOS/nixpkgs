{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.35.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-KLwIwJtPBQ8Sa94/IEJhIGTx/n3oYQKINmNV5L5TJV0=";
  };

  cargoHash = "sha256-4a89Do57KFKu/RDTB4BxUxVlO46HL5aEhhHmnzLuZGo=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    mainProgram = "svd2rust";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ newam ];
  };
}
