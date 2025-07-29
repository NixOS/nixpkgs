{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.36.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-+wVcUpSlJsd6GAZgBor7eAu6IYnlfJwzZDYKqUKpa9M=";
  };

  cargoHash = "sha256-rZusngSIwdDfNe7tIA2WtIzzje6UBxyz/hfeRLqJHUY=";

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
