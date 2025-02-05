{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.4.3";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-ftT9EgICfy8vnb6XWEUUtX351+f5aex8xaY11nnWcAY=";
  };

  cargoHash = "sha256-CLb9A7RgENj2HdvqWCdcS0/aqUTezBCBC2c3OGL1aNM=";

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
