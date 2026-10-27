{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pulldown-cmark";
  version = "0.13.5";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-5f+pTBy3cEhBdjiGtGNs81ihlA4hsVFS7NAZ2IWcWJI=";
  };

  cargoHash = "sha256-8FwKg2iJ9Mix4+WiFPdRIbDIbTG/VVIq9bz8XOdMIq4=";

  meta = {
    description = "Pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
})
