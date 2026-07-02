{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qst";
  version = "0.10.0";
  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-IgSgozX1HHp3oK8iFUEOxJ0XWiXrKaj9N3i8yrPq/zs=";
  };

  cargoHash = "sha256-FyHO5rA2Wh8ztPOd5qpTKQJEjAjtEdEkVY923kXuYsY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Community Driven CLI Quick Script Tool";
    homepage = "https://github.com/GitanElyon/qst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GitanElyon ];
    mainProgram = "qst";
  };
})
