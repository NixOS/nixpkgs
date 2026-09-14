{
  lib,
  fetchCrate,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fmtron";
  version = "0.6.0";
  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-yXDB/fN4cqGy+LNPOcgovZpyH1Z+B339iHuGywIgU9g=";
  };

  cargoHash = "sha256-/DFE5MqLBBMqsq/fSYGf3Sk4yJaSZRyvDCIuDthDeO8=";

  meta = {
    description = "CLI tool to format RON files";
    homepage = "https://github.com/barafael/fmtron";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ yusufraji ];
    mainProgram = "fmtron";
  };
})
