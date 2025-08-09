{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.4.6";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-AfRFtybGEpArLGKp4AkGlokfNFMK8Ez5VA5Fu5GUhRI=";
  };

  cargoHash = "sha256-0GR9pbrevb0USu8de1oFHePJH1hGTvcVh3Gc9WKP0uA=";

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
