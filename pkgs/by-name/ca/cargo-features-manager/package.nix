{
  lib,
  rustPlatform,
  fetchFromTangled,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-features-manager";
  version = "0.12.0";

  src = fetchFromTangled {
    did = "did:plc:ecwggpjedavt2waazmc4nuft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bfBSnC2qk19w6G81NdplPuiZvS1PRUNjCP8ozwuoTac=";
  };

  cargoHash = "sha256-MwfeVPmS4KE1vJ9aEUXZpT+AbPaOP8Rs65vSFarKal0=";

  meta = {
    description = "TUI-like cli tool to manage the features of your rust-projects dependencies";
    homepage = "https://tangled.org/tobinio.dev/cargo-features-manager";
    changelog = "https://tangled.org/tobinio.dev/cargo-features-manager/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tobinio ];
    mainProgram = "cargo-features";
  };
})
