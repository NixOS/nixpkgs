{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  libz,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bazel";
  version = "0.17.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-KWcxZxzDbiBfBpr37M6HoqHMCYXq6sTVxU9KR3PIiJc=";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libz;

  cargoHash = "sha256-wNsGggyKL6CyldPsNADwGKm3HGfxQwjCCOdgzWcAx4g=";

  # `test_data` is explicitly excluded from the package published to crates.io, so tests cannot be run
  doCheck = false;

  meta = {
    description = "Part of the `crate_universe` collection of tools which use Cargo to generate build targets for Bazel";
    mainProgram = "cargo-bazel";
    homepage = "https://github.com/bazelbuild/rules_rust";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rickvanprim ];
  };
}
