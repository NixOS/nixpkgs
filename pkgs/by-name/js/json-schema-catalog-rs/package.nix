{
  callPackage,
  fetchFromGitHub,
  jsonSchemaCatalogs,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "json-schema-catalog-rs";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "roberth";
    repo = "json-schema-catalog-rs";
    tag = finalAttrs.version;
    hash = "sha256-KmUpnpVBfVhdHLQVqcVoNCM6KODfIeTUNagOR69ntQY=";
  };

  cargoHash = "sha256-ydygZWAcKNMRw2v6ci2x8b7ca3T5dEGYukEwHnJb7jo=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/json-schema-catalog";

  passthru = {
    tests = {
      run = callPackage ./test-run.nix { json-schema-catalog-rs = finalAttrs.finalPackage; };
      jsonSchemaCatalogs = jsonSchemaCatalogs.tests.override {
        json-schema-catalog-rs = finalAttrs.finalPackage;
      };
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI for working with JSON Schema Catalogs";
    longDescription = ''
      A JSON Schema Catalog file provides a mapping from schema URIs to schema locations.
      By constructing and using a catalog, you can avoid the need to download and parse schemas from the internet.
      This is particularly useful when working with large schemas or when you need to work, test or build offline.
    '';
    homepage = "https://github.com/roberth/json-schema-catalog-rs";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.roberth ];
    mainProgram = "json-schema-catalog";
  };
})
