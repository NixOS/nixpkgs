{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jsonkdl";
  version = "1.1.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-2oDHEq2VSMmlhyfxp01R1sSyHf7Q5MvFV1Iz8rsF9Hc=";
  };

  cargoHash = "sha256-s0SGqkTAbuAr/SJAHKsR1oowcqYh8RdAHryfIdEzRgU=";

  meta = {
    description = "JSON to KDL converter";
    homepage = "https://github.com/joshprk/jsonkdl";
    changelog = "https://github.com/joshprk/jsonkdl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      joshprk
      kiara
    ];
    mainProgram = "jsonkdl";
  };
})
