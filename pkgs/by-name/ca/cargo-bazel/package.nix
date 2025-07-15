{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  libz,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bazel";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-FS1WFlK0YNq1QCi3S3f5tMN+Bdcfx2dxhDKRLXLcios=";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libz;

  cargoHash = "sha256-E/yF42Vx9tv8Ik1j23El3+fI19ZGzq6nikVMATY7m3E=";

  # `test_data` is explicitly excluded from the package published to crates.io, so tests cannot be run
  doCheck = false;

  meta = with lib; {
    description = "Part of the `crate_universe` collection of tools which use Cargo to generate build targets for Bazel";
    mainProgram = "cargo-bazel";
    homepage = "https://github.com/bazelbuild/rules_rust";
    license = licenses.asl20;
    maintainers = with maintainers; [ rickvanprim ];
  };
}
