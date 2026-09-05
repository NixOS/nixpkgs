{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mandown";
  version = "1.1.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-Gxvtslik93BxGG1L+r6f/L2Vt3MkzMJFWy5wJSEqcCI=";
  };

  cargoHash = "sha256-1NrfQBXOROla74iTA1AQndgfEA6YWPurnC1Odc7pdQU=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Markdown to groff (man page) converter";
    homepage = "https://gitlab.com/kornelski/mandown";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ lib.maintainers.da157 ];
    mainProgram = "mandown";
  };
})
