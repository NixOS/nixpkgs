{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.4.4";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-gZK0PdvubxyDD9wqhz3vuXeP33ibsZE5AZin7H2mnNQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gunDbKMGd0f+TDt5tqh5siw0jnTtlpohteA4NNQHj24=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    mainProgram = "svdtools";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ newam ];
  };
}
