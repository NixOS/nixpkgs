{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jsonkdl";
  version = "1.0.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-4k6gwThkS9OfdM412Mi/Scv+4wIKIXuCA5lVuJ7IRiY=";
  };

  cargoHash = "sha256-9dHS41ZyI9vna0w8N6/PXsmObKPHUi25JPFLsEaxG/A=";

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
