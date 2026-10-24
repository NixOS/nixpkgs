{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fontc";
  version = "1.0.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-lM6PgEcO+4pOhU+KNDmw8lilhTrT2di7FcRkMwkvCfo=";
  };

  cargoHash = "sha256-do9oFs55bwwEA+cJyNlELJE8/k+xamE5xMtli+xy3/k=";

  # skip `cargo test` because source code from crates.io doesn't include necessary resources for testing
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wherein we pursue oxidizing fontmake";
    homepage = "https://github.com/googlefonts/fontc";
    changelog = "https://github.com/googlefonts/fontc/releases/tag/fontc-v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shiphan ];
    mainProgram = "fontc";
  };
})
