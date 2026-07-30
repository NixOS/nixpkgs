{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "svd2rust";
  version = "0.37.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-50g5YVmVYTLYJdaWXk91OYdlghDchkyHXS9j2Z7IXSw=";
  };

  cargoHash = "sha256-poP1az7Hv/qPrTUvqHbd7aylJrI9LGBMu88g+pFmXF4=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    mainProgram = "svd2rust";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ newam ];
  };
})
