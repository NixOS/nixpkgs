{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.4.5";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-XwgDjSn19qbmh/yX4h5vG0C4rTRxd9tT1ZzUm1Y1ckg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-h99NTKW1Re680GNsmKTW35OpJVlfYFj05QVZ9rHXgYY=";

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
