{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.4.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-cZLLpFYjKIF4bhZJWXFUpTSKSUOWkLZ0DTQ0PpZnPIg=";
  };

  cargoHash = "sha256-Pt810QwfO+b6L5GYtzDAxIIuD/qv9inGMJAGjVIVUtM=";

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
