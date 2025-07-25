{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "obs-cmd";
  version = "0.18.5";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/j+nERCKGBdR+1n3IqRLo77CLbuHz0r5M7m8JttBxak=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XMi3/FEl7OEp2zCWELOjsmfiwCRxS1L95yJPoU1Xlu0=";

  meta = {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    changelog = "https://github.com/grigio/obs-cmd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "obs-cmd";
  };
})
