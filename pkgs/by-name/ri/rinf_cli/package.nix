{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rinf_cli";
  version = "8.7.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-MDiWD2CevkJHRTmnBWpvHra3i2985nO5mJ9uOVK55l8=";
  };

  cargoHash = "sha256-RIccbZFfMcxhmMuN72YQbAbRnDrpz/i4I7Zb8WngXT4=";

  meta = {
    mainProgram = "rinf";
    description = "Rust for native business logic, Flutter for flexible and beautiful GUI";
    homepage = "https://rinf.cunarist.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ noah765 ];
  };
})
