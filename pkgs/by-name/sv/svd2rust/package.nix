{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.36.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-HdE4XWAM1e25kRwryMzGqo2sUpzgwk2aiWsi+qXZ7bU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JiGTGdrudmDCNmJOtHgIBwTVCLB3m4RCqxlypa2KdDQ=";

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
