{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fontc";
  version = "2.0.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-3iOuzQ3zzWYlsliyQmS6C3wD2lSaedzBbFRybvVC91M=";
  };

  cargoHash = "sha256-6MIz4W+o0EU2ZMyu7DLQPB09+2g/brN1pmij12HKn+E=";

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
