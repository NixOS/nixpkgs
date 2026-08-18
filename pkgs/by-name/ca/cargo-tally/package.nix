{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-tally";
  version = "1.0.76";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-b9AhyeVcx8Z8apj+P0CEHOTDcAcxwK0I6gNVOjlprBs=";
  };

  cargoHash = "sha256-RTRL56xEj0WxgQAw58DNimk6SWTSMR1lKdT87pxWIvs=";

  meta = {
    description = "Graph the number of crates that depend on your crate over time";
    mainProgram = "cargo-tally";
    homepage = "https://github.com/dtolnay/cargo-tally";
    changelog = "https://github.com/dtolnay/cargo-tally/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
