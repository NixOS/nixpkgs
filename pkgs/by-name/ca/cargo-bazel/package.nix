{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  libz,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-bazel";
  version = "0.18.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-yPMos/V7OjAPJWoivLlatqhbsJzbvsxUf0pTDf4JxFg=";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libz;

  cargoHash = "sha256-F55vjMNNPB+d0VdP7HySDCnb3DidhUS9wZwCn8e4J6A=";

  # `test_data` is explicitly excluded from the package published to crates.io, so tests cannot be run
  doCheck = false;

  meta = {
    description = "Part of the `crate_universe` collection of tools which use Cargo to generate build targets for Bazel";
    mainProgram = "cargo-bazel";
    homepage = "https://github.com/bazelbuild/rules_rust";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rickvanprim ];
  };
})
