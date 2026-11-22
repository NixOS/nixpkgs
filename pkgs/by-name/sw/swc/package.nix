{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swc";
  version = "0.129.2";

  src = fetchCrate {
    pname = "swc_cli";
    inherit (finalAttrs) version;
    hash = "sha256-F//H0Vuw1NqP15NLh72f+njgi0FmBLN5ihdjN/B/enE=";
  };

  cargoHash = "sha256-BggbiGvGRjX9u4lvAq4z3ZmWk/hN0fPADAu0R2mK8XE=";

  # swc depends on nightly features
  env.RUSTC_BOOTSTRAP = 1;

  meta = {
    description = "Rust-based platform for the Web";
    mainProgram = "swc";
    homepage = "https://github.com/swc-project/swc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kashw2
    ];
  };
})
