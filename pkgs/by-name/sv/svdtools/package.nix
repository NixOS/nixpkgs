{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.19";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-5s4CPV6Tke37QlyMzI6WFDb9EdRfcFDoFrmuWblbp20=";
  };

  cargoHash = "sha256-VrOFu7LNFeH70VPdz9uJxXuRtTvxKiS1dlhCdr++7+g=";

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
