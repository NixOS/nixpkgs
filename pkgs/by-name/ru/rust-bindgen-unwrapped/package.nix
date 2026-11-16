{
  lib,
  fetchFromGitHub,
  rustPlatform,
  rustc,
  rustfmt,
}:
let
  # bindgen hardcodes rustfmt outputs that use nightly features
  rustfmt-nightly = rustfmt.override { asNightly = true; };
  clang = rustc.llvmPackages.clang;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-bindgen-unwrapped";
  version = "0.72.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rust-bindgen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cswBbshxTAcZtUk3PxH9jD55X1a/fBAyZyYpzVkt27M=";
  };

  cargoHash = "sha256-HKhoLKqk0KeQXdSl8L+w2S6RGXbjfoGAryB5zCCeDZ8=";

  preConfigure = ''
    export LIBCLANG_PATH="${lib.getLib clang.cc}/lib"
  '';

  buildAndTestSubdir = "bindgen-cli";

  # Disable the "runtime" feature, so libclang is linked.
  buildNoDefaultFeatures = true;
  buildFeatures = [ "logging" ];

  doCheck = true;
  nativeCheckInputs = [ clang ];

  env.RUSTFMT = "${rustfmt-nightly}/bin/rustfmt";

  preCheck = ''
    # for the ci folder, notably
    patchShebangs .
  '';

  passthru = { inherit clang; };

  meta = {
    description = "Automatically generates Rust FFI bindings to C (and some C++) libraries";
    longDescription = ''
      Bindgen takes a c or c++ header file and turns them into
      rust ffi declarations.
    '';
    homepage = "https://github.com/rust-lang/rust-bindgen";
    changelog = "https://github.com/rust-lang/rust-bindgen/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ johntitor ];
    mainProgram = "bindgen";
    platforms = lib.platforms.unix;
  };
})
