{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "svdtools";
  version = "0.5.0";

  src = fetchCrate {
    inherit (finalAttrs) version pname;
    hash = "sha256-2GemBVTRvYC5bvlYgJKmDJM78ZoE63B1QwV8cfSHYPg=";
  };

  cargoHash = "sha256-sn+Z3/p4Ek/wxwTj6uwDBFP1hFNGDb2EZ7MO0zvPjPk=";

  meta = {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    mainProgram = "svdtools";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${finalAttrs.version}/CHANGELOG-rust.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ newam ];
  };
})
